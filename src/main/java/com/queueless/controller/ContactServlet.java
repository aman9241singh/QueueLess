
package com.queueless.controller;
import com.queueless.dao.ContactDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/contact-submit")
public class ContactServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        if (name == null || email == null || subject == null || message == null || name.trim().isEmpty() || email.trim().isEmpty() || subject.trim().isEmpty() || message.trim().isEmpty()) {
            request.setAttribute("contactFeedback", "Please fill in all fields.");
            request.getRequestDispatcher("/client/contact.jsp").forward(request, response);
            return;
        }
        try {
            boolean saved = new ContactDAO().saveMessage(name.trim(), email.trim(), subject.trim(), message.trim());
            request.setAttribute("contactFeedback", saved ? "Your message has been sent successfully!" : "Unable to send your message. Please try again.");
            request.getRequestDispatcher("/client/contact.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to save contact message.", e);
        }
    }
}
