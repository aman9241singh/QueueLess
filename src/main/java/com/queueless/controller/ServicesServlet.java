package com.queueless.controller;
import com.queueless.dao.ServiceDAO;
import com.queueless.model.Service;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/services")
public class ServicesServlet extends HttpServlet {
   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
        ServiceDAO dao = new ServiceDAO();
        List<Service> services = dao.getActiveServices();
        System.out.println("SERVICES FETCHED: " + services.size());
        for (Service service : services) {
            System.out.println(service.getServiceId() + " - " + service.getServiceName());
        }
        request.setAttribute("activeServices", services);
        request.getRequestDispatcher("/client/services.jsp").forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
        throw new ServletException("Unable to load services.", e);
    }
}
}