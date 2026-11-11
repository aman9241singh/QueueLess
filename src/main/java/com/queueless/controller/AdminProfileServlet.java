package com.queueless.controller;
import com.queueless.dao.AdminDAO;
import com.queueless.model.Admin;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin/profile")
public class AdminProfileServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        try {
            int adminId = (Integer) session.getAttribute("adminId");
            System.out.println("DEBUG ADMIN ID: " + adminId);
            Admin admin = adminDAO.getAdminById(adminId);
            if (admin == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
                return;
            }
            request.setAttribute("admin", admin);
            request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
        } catch (SQLException | ClassCastException e) {
            throw new ServletException("Unable to load admin profile.", e);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("ADMIN PROFILE POST METHOD CALLED");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        int adminId = (Integer) session.getAttribute("adminId");
        String action = request.getParameter("action");
        try {
            if ("updateProfile".equals(action)) {
                String fullName = request.getParameter("fullName");
                System.out.println("PROFILE UPDATE: " + fullName + " | " + request.getParameter("email"));
                String email = request.getParameter("email");
                if (fullName == null || fullName.trim().length() < 2 || fullName.trim().length() > 100 || email == null || !email.trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                    response.sendRedirect(request.getContextPath() + "/admin/profile?error=invalid");
                    return;
                }
                if (adminDAO.updateAdminProfile(adminId, fullName.trim(), email.trim())) {
                    session.setAttribute("adminName", fullName.trim());
                    session.setAttribute("adminEmail", email.trim());
                    response.sendRedirect(request.getContextPath() + "/admin/profile?success=profile");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/profile?error=profile");
                }
            } else if ("changePassword".equals(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                if (currentPassword == null || newPassword == null || confirmPassword == null || newPassword.length() < 8 || !newPassword.equals(confirmPassword)) {
                    response.sendRedirect(request.getContextPath() + "/admin/profile?error=password");
                    return;
                }
                if (adminDAO.updateAdminPassword(adminId, currentPassword, newPassword)) {
                    response.sendRedirect(request.getContextPath() + "/admin/profile?success=password");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/profile?error=current");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=invalid");
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                response.sendRedirect(request.getContextPath() + "/admin/profile?error=duplicate");
            } else {
                throw new ServletException("Unable to update admin profile.", e);
            }
        }
    }
}