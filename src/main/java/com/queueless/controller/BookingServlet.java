
package com.queueless.controller;
import com.queueless.dao.BookingDAO;
import com.queueless.dao.ServiceDAO;
import com.queueless.dao.NotificationDAO;
import com.queueless.model.Service;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/book-token")
public class BookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        try {
            int userId = (Integer) session.getAttribute("userId");
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String dateValue = request.getParameter("date");
            String timeValue = request.getParameter("time");
           

if (dateValue == null || timeValue == null ||
    dateValue.trim().isEmpty() || timeValue.trim().isEmpty()) {

    response.sendRedirect(request.getContextPath() + "/booking?error=invalid");
    return;
}


            LocalDate visitDate = LocalDate.parse(dateValue);
            LocalTime preferredTime = LocalTime.parse(timeValue);
            if (visitDate.isBefore(LocalDate.now()) || preferredTime.isBefore(LocalTime.of(9, 0)) || preferredTime.isAfter(LocalTime.of(17, 0))) {
                response.sendRedirect(request.getContextPath() + "/booking?error=invalid");
                return;
            }
            BookingDAO bookingDAO = new BookingDAO();
            String tokenNumber = bookingDAO.createBooking(userId, serviceId, Date.valueOf(visitDate), Time.valueOf(preferredTime));
            Service service = new ServiceDAO().getServiceById(serviceId);
            if (service == null) {
                throw new SQLException("Selected service is unavailable.");
            }
            int[] queueDetails = bookingDAO.getQueueDetails(tokenNumber);
            String notificationTitle = "Token Booking Confirmed";
            String notificationMessage = "Your booking for " + service.getServiceName() + " is confirmed. Your token number is " + tokenNumber + ".";
            new NotificationDAO().addNotification(userId, notificationTitle, notificationMessage);
            request.setAttribute("tokenNumber", tokenNumber);
            request.setAttribute("serviceName", service.getServiceName());
            request.setAttribute("visitDate", visitDate.toString());
            request.setAttribute("preferredTime", preferredTime.toString());
            request.setAttribute("queuePosition", queueDetails[0]);
            request.setAttribute("estimatedWait", queueDetails[1]);
            request.getRequestDispatcher("/client/booking-success.jsp").forward(request, response);
        } catch (NumberFormatException | java.time.DateTimeException e) {
            response.sendRedirect(request.getContextPath() + "/booking?error=invalid");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?error=failed");
        }
    }
}
