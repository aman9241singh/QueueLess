
package com.queueless.controller;
import com.queueless.dao.ContactMessageDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin/contact-messages")
public class AdminContactMessagesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        try {
            request.setAttribute("contactMessages", new ContactMessageDAO().getAllMessages());
            request.getRequestDispatcher("/admin/contact-messages.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load contact messages.", e);
        }
    }
}
