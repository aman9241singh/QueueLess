package com.queueless.controller;
import com.queueless.dao.AdminQueueDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin/update-queue-status")
public class UpdateQueueStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        try {
            int queueId = Integer.parseInt(request.getParameter("queueId"));
            String status = request.getParameter("status");
            boolean updated = new AdminQueueDAO().updateQueueStatus(queueId, status);
            if (updated) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Queue status updated successfully.");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to update queue status.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid queue ID.");
        } catch (Exception e) {
            throw new ServletException("Unable to update queue status.", e);
        }
    }
}