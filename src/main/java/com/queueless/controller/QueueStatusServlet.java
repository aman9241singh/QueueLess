package com.queueless.controller;
import com.queueless.dao.QueueStatusDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/queue-status")
public class QueueStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        try {
            QueueStatusDAO dao = new QueueStatusDAO();
            request.setAttribute("queueList", dao.getUserQueueStatus(userId));
            request.getRequestDispatcher("/client/queue-status.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load queue status.", e);
        }
    }
}