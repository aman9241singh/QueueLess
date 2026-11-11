package com.queueless.controller;
import com.queueless.dao.NotificationDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/mark-all-notifications-read")
public class MarkAllNotificationsReadServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        try {
            int userId = (Integer) session.getAttribute("userId");
            new NotificationDAO().markAllAsRead(userId);
            response.sendRedirect(request.getContextPath() + "/notifications");
        } catch (Exception e) {
            throw new ServletException("Unable to update notifications.", e);
        }
    }
}