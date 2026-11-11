
package com.queueless.controller;
import com.queueless.dao.UserDAO;
import com.queueless.model.User;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/client/login.jsp");
                return;
            }
            request.setAttribute("profileUser", user);
            request.getRequestDispatcher("/client/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load profile details.", e);
        }
    }
}
