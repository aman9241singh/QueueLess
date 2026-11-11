
package com.queueless.controller;
import com.queueless.dao.AdminDashboardDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        try {
            AdminDashboardDAO dao = new AdminDashboardDAO();
            request.setAttribute("totalTokens", dao.getTotalTokensToday());
            request.setAttribute("activeQueues", dao.getActiveQueues());
            request.setAttribute("registeredUsers", dao.getRegisteredUsers());
            request.setAttribute("waitingCustomers", dao.getWaitingCustomers());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=failed");
        }
    }
}
