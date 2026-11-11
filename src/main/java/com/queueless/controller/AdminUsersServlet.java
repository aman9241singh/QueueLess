package com.queueless.controller;
import com.queueless.dao.UserDAO;
import com.queueless.model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return false;
        }
        return true;
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request, response)) return;
        try {
            List<User> users = new UserDAO().getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load users.", e);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status");
            if (userId <= 0 || (!"Active".equals(status) && !"Inactive".equals(status))) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID or account status.");
                return;
            }
            boolean updated = new UserDAO().updateAccountStatus(userId, status);
            if (!updated) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found.");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/users?updated=true");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID.");
        } catch (SQLException e) {
            throw new ServletException("Unable to update account status.", e);
        }
    }
}