
package com.queueless.controller;
import com.queueless.dao.AdminQueueDAO;
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
@WebServlet(name = "AdminLiveQueueServlet", urlPatterns = {"/admin/live-queue"})
public class AdminLiveQueueServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("LIVE QUEUE SERVLET WORKING");
        System.out.println("DEBUG 1: AdminLiveQueueServlet executed");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            System.out.println("DEBUG: Admin session missing");
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        try {
            AdminQueueDAO dao = new AdminQueueDAO();
            System.out.println("DEBUG 2: DAO created");
            List<Map<String,Object>> queueTokens = dao.getAllQueueTokens();
            System.out.println("DEBUG 3: Records loaded = " + queueTokens.size());
            request.setAttribute("queueTokens", queueTokens);
            System.out.println("DEBUG 4: Request attribute set successfully");
            request.getRequestDispatcher("/admin/live-queue.jsp").forward(request, response);
            System.out.println("DEBUG 5: Request forwarded to JSP");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Unable to load admin queue.", e);
        }
    }
}
