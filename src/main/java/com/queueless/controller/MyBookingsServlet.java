
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
@WebServlet("/my-bookings")
public class MyBookingsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        try {
            int userId = (Integer) session.getAttribute("userId");
            MyBookingsDAO dao = new MyBookingsDAO();
            request.setAttribute("bookings", dao.getUserBookings(userId));
            request.setAttribute("totalBookings", dao.getTotalBookings(userId));
            request.setAttribute("confirmedBookings", dao.getConfirmedBookings(userId));
            request.setAttribute("cancelledBookings", dao.getCancelledBookings(userId));
            request.getRequestDispatcher("/client/my-bookings.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load your bookings.");
        }
    }
}
