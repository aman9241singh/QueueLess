
package com.queueless.controller;
import com.queueless.dao.SettingsDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin/settings")
public class AdminSettingsServlet extends HttpServlet {
    private final SettingsDAO settingsDAO = new SettingsDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        try {
            request.setAttribute("settings", settingsDAO.getAllSettings());
            request.getRequestDispatcher("/admin/settings.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load system settings.", e);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        request.setCharacterEncoding("UTF-8");
        Map<String, String> settings = new LinkedHashMap<>();
        settings.put("systemName", request.getParameter("systemName"));
        settings.put("adminEmail", request.getParameter("adminEmail"));
        settings.put("timezone", request.getParameter("timezone"));
        settings.put("language", request.getParameter("language"));
        settings.put("tokenPrefix", request.getParameter("tokenPrefix"));
        settings.put("waitTime", request.getParameter("waitTime"));
        settings.put("maxTokens", request.getParameter("maxTokens"));
        settings.put("tokenExpiry", request.getParameter("tokenExpiry"));
        settings.put("emailNotifications", String.valueOf(request.getParameter("emailNotifications") != null));
        settings.put("queueAlerts", String.valueOf(request.getParameter("queueAlerts") != null));
        settings.put("userAlerts", String.valueOf(request.getParameter("userAlerts") != null));
  
        try {
            if (settings.values().stream().anyMatch(value -> value == null || value.trim().isEmpty())) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Please complete all required settings.");
                return;
            }
            int waitTime = Integer.parseInt(settings.get("waitTime"));
            int maxTokens = Integer.parseInt(settings.get("maxTokens"));
            int tokenExpiry = Integer.parseInt(settings.get("tokenExpiry"));
            if (waitTime < 1 || waitTime > 240 || maxTokens < 1 || maxTokens > 1000 || !new int[]{30, 60, 120, 240}.equals(new int[]{tokenExpiry})) {
                if (waitTime < 1 || waitTime > 240 || maxTokens < 1 || maxTokens > 1000 || (tokenExpiry != 30 && tokenExpiry != 60 && tokenExpiry != 120 && tokenExpiry != 240)) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid numeric settings.");
                    return;
                }
            }
            settingsDAO.saveSettings(settings);
            response.sendRedirect(request.getContextPath() + "/admin/settings?success=1");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Numeric settings must contain valid numbers.");
        } catch (SQLException e) {
            throw new ServletException("Unable to save system settings.", e);
        }
    }
}
