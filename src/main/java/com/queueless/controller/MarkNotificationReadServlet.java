package com.queueless.controller;
import com.queueless.dao.NotificationDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/mark-notification-read")
public class MarkNotificationReadServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        try {
            int userId = (Integer) session.getAttribute("userId");
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            new NotificationDAO().markAsRead(notificationId, userId);
            response.sendRedirect(request.getContextPath() + "/notifications");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID.");
        } catch (Exception e) {
            throw new ServletException("Unable to update notification.", e);
        }
    }
}