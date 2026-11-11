
package com.queueless.controller;
import com.queueless.dao.UserDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (currentPassword == null || newPassword == null || confirmPassword == null || currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            session.setAttribute("profileMessage", "Please fill in all password fields.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        if (newPassword.length() < 8) {
            session.setAttribute("profileMessage", "New password must contain at least 8 characters.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("profileMessage", "New password and confirm password do not match.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        if (currentPassword.equals(newPassword)) {
            session.setAttribute("profileMessage", "New password must be different from the current password.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        try {
            boolean changed = userDAO.changePassword(userId, currentPassword, newPassword);
            if (changed) {
                session.setAttribute("profileMessage", "Password changed successfully.");
            } else {
                session.setAttribute("profileMessage", "Current password is incorrect.");
            }
            response.sendRedirect(request.getContextPath() + "/profile");
        } catch (SQLException e) {
            throw new ServletException("Unable to change password.", e);
        }
    }
}
