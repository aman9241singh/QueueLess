
package com.queueless.controller;
import com.queueless.dao.AdminDAO;
import com.queueless.model.Admin;
import com.queueless.util.PasswordUtil;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        if (email == null || password == null || email.trim().isEmpty() || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=invalid");
            return;
        }
        try {
            AdminDAO adminDAO = new AdminDAO();
            Admin admin = adminDAO.getAdminByEmail(email.trim());
            if (admin != null && PasswordUtil.checkPassword(password, admin.getPassword())) {
                HttpSession session = request.getSession();
                session.setAttribute("adminId", admin.getAdminId());
                session.setAttribute("adminName", admin.getFullName());
                session.setAttribute("adminEmail", admin.getEmail());
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=invalid");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=failed");
        }
    }
}
