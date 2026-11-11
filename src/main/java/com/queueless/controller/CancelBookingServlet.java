
package com.queueless.controller;
import com.queueless.dao.MyBookingsDAO;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/cancel-booking")
public class CancelBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        try {
            int userId = (Integer) session.getAttribute("userId");
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            MyBookingsDAO dao = new MyBookingsDAO();
            boolean cancelled = dao.cancelBooking(bookingId, userId);
            if (cancelled) {
                session.setAttribute("bookingMessage", "Your booking has been cancelled successfully.");
            } else {
                session.setAttribute("bookingMessage", "This booking cannot be cancelled.");
            }
            response.sendRedirect(request.getContextPath() + "/my-bookings");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-bookings");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to cancel booking.");
        }
    }
}
