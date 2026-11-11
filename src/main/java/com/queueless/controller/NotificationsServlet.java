
package com.queueless.controller;
import com.queueless.dao.NotificationDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/notifications")
public class NotificationsServlet extends HttpServlet {
    private final NotificationDAO notificationDAO = new NotificationDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        try {
            List<Map<String, Object>> notifications = notificationDAO.getUserNotifications(userId);
            request.setAttribute("notifications", notifications);
            request.setAttribute("totalCount", notifications.size());
            int unreadCount = 0;
            for (Map<String, Object> notification : notifications) {
                if (!Boolean.TRUE.equals(notification.get("isRead"))) unreadCount++;
            }
            request.setAttribute("unreadCount", unreadCount);
            request.getRequestDispatcher("/client/notifications.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load notifications.", e);
        }
    }
}
