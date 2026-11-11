
package com.queueless.controller;

import com.queueless.dao.UserDAO;
import com.queueless.model.User;
import com.queueless.util.PasswordUtil;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String acceptTerms = request.getParameter("acceptTerms");

        if (fullName == null || email == null || phone == null || password == null || confirmPassword == null ||
            fullName.trim().length() < 2 || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$") ||
            !phone.matches("[0-9]{10}") || password.length() < 8 ||
            !password.equals(confirmPassword) || !"yes".equals(acceptTerms)) {
            response.sendRedirect(request.getContextPath() + "/client/signup.jsp?error=invalid");
            return;
        }

        try {
            String hashedPassword = PasswordUtil.hashPassword(password);
            User user = new User(fullName.trim(), email.trim(), phone.trim(), hashedPassword);
            UserDAO userDAO = new UserDAO();

            if (userDAO.registerUser(user)) {
                response.sendRedirect(request.getContextPath() + "/client/login.jsp?registered=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/client/signup.jsp?error=failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/client/signup.jsp?error=failed");
        }
    }
}
