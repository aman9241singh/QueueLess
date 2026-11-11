
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
@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        if (fullName == null || email == null || phone == null || fullName.trim().isEmpty() || email.trim().isEmpty() || phone.trim().isEmpty() || !phone.matches("[0-9]{10}") || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            session.setAttribute("profileMessage", "Please enter valid profile details.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        fullName = fullName.trim();
        email = email.trim().toLowerCase();
        phone = phone.trim();
        try {
            if (userDAO.emailExistsForAnotherUser(email, userId)) {
                session.setAttribute("profileMessage", "This email address is already registered.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
            boolean updated = userDAO.updateProfile(userId, fullName, email, phone);
            if (updated) {
                session.setAttribute("userName", fullName);
                session.setAttribute("userEmail", email);
                session.setAttribute("userPhone", phone);
                session.setAttribute("profileMessage", "Profile updated successfully.");
            } else {
                session.setAttribute("profileMessage", "No profile changes were saved.");
            }
            response.sendRedirect(request.getContextPath() + "/profile");
        } catch (SQLException e) {
            throw new ServletException("Unable to update profile.", e);
        }
    }
}
