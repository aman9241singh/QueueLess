
package com.queueless.controller;
import com.queueless.dao.AnnouncementDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin/announcement-action")
public class AdminAnnouncementActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        String action = request.getParameter("action");
        String title = request.getParameter("title");
        String message = request.getParameter("message");
        String status = request.getParameter("status");
        String idValue = request.getParameter("announcementId");
        int adminId = (Integer) session.getAttribute("adminId");
        try {
            AnnouncementDAO dao = new AnnouncementDAO();
            boolean success = false;
            if ("create".equals(action)) {
                if (title != null && message != null && !title.trim().isEmpty() && !message.trim().isEmpty() && isValidStatus(status)) {
                    success = dao.addAnnouncement(adminId, title.trim(), message.trim(), status);
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(idValue);
                if (id > 0 && title != null && message != null && !title.trim().isEmpty() && !message.trim().isEmpty() && isValidStatus(status)) {
                    success = dao.updateAnnouncement(id, title.trim(), message.trim(), status);
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(idValue);
                if (id > 0) success = dao.deleteAnnouncement(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin/announcements?result=" + (success ? "success" : "failed"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/announcements?result=failed");
        } catch (SQLException e) {
            throw new ServletException("Unable to process announcement.", e);
        }
    }
    private boolean isValidStatus(String status) {
        return "Draft".equals(status) || "Published".equals(status);
    }
}
