package com.queueless.controller;
import com.queueless.dao.UserDAO;
import com.queueless.dao.MyBookingsDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        try {
            int userId = (Integer) session.getAttribute("userId");
            UserDAO userDAO = new UserDAO();
            MyBookingsDAO bookingsDAO = new MyBookingsDAO();
            int[] stats = userDAO.getBookingStatistics(userId);
            int unreadNotifications = userDAO.getUnreadNotificationCount(userId);
            request.setAttribute("totalBookings", stats[0]);
            request.setAttribute("activeTokens", stats[1]);
            request.setAttribute("completedVisits", stats[2]);
            request.setAttribute("notificationCount", unreadNotifications);
            request.setAttribute("upcomingBookings", bookingsDAO.getUpcomingBookings(userId));
            request.setAttribute("recentActivities", bookingsDAO.getRecentActivity(userId));
            request.getRequestDispatcher("/client/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load dashboard.", e);
        }
    }
}