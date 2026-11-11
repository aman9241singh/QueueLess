
package com.queueless.controller;
import com.queueless.dao.ServiceDAO;
import com.queueless.model.Service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/booking")
public class BookingPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/client/login.jsp");
            return;
        }
        try {
            ServiceDAO serviceDAO = new ServiceDAO();
            List<Service> services = serviceDAO.getActiveServices();
            request.setAttribute("activeServices", services);
            String serviceIdParam = request.getParameter("serviceId");
            if (serviceIdParam != null) {
                try {
                    int serviceId = Integer.parseInt(serviceIdParam);
                    Service selectedService = serviceDAO.getServiceById(serviceId);
                    if (selectedService != null) {
                        request.setAttribute("selectedServiceId", serviceId);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("selectedServiceId", null);
                }
            }
            request.getRequestDispatcher("/client/book-token.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load services.");
        }
    }
}
