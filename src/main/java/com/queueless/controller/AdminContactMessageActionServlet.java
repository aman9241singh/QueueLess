
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
@WebServlet("/admin/contact-message-action")
public class AdminContactMessageActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        String action = request.getParameter("action");
        String idValue = request.getParameter("messageId");
        try {
            int messageId = Integer.parseInt(idValue);
            ContactMessageDAO dao = new ContactMessageDAO();
            boolean success = false;
            if ("read".equals(action)) {
                success = dao.updateMessageStatus(messageId, "Read");
            } else if ("resolve".equals(action)) {
                success = dao.updateMessageStatus(messageId, "Resolved");
            } else if ("delete".equals(action)) {
                success = dao.deleteMessage(messageId);
            }
            response.sendRedirect(request.getContextPath() + "/admin/contact-messages?result=" + (success ? "success" : "failed"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/contact-messages?result=failed");
        } catch (SQLException e) {
            throw new ServletException("Unable to update contact message.", e);
        }
    }
}
