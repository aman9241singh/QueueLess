
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
@WebServlet("/admin/services")
public class AdminServicesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        try {
            ServiceDAO dao = new ServiceDAO();
            List<Service> services = dao.getAllServices();
            int active = 0;
            for (Service service : services) {
                if ("Active".equals(service.getStatus())) {
                    active++;
                }
            }
            request.setAttribute("services", services);
            request.setAttribute("totalServices", services.size());
            request.setAttribute("activeServices", active);
            request.setAttribute("inactiveServices", services.size() - active);
            request.getRequestDispatcher("/admin/services.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load services.", e);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        String action = request.getParameter("action");
        try {
            ServiceDAO dao = new ServiceDAO();
            boolean success = false;
            if ("add".equals(action)) {
                Service service = readService(request);
               Object adminId = session.getAttribute("adminId");
System.out.println("Admin ID from session: " + adminId);
int createdBy = ((Number) adminId).intValue();
System.out.println("Created By: " + createdBy);
success = dao.addService(service, createdBy);
System.out.println("Service Insert Result: " + success);
            } else if ("update".equals(action)) {
                Service service = readService(request);
                service.setServiceId(Integer.parseInt(request.getParameter("serviceId")));
                success = dao.updateService(service);
            } else if ("delete".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                success = dao.deleteService(serviceId);
            } else if ("toggle".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                String status = request.getParameter("status");
                if ("Active".equals(status) || "Inactive".equals(status)) {
                    success = dao.updateServiceStatus(serviceId, status);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/services?result=" + (success ? "success" : "failed"));
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Unable to update service.", e);
        }
    }
    private Service readService(HttpServletRequest request) {
        Service service = new Service();
        service.setServiceName(request.getParameter("serviceName").trim());
        service.setCategory(request.getParameter("category"));
        service.setLocation(request.getParameter("location").trim());
        service.setAverageWaitTime(Integer.parseInt(request.getParameter("averageWaitTime")));
        service.setDescription(request.getParameter("description").trim());
        service.setMaxTokens(100);
        service.setStatus("Active");
        return service;
    }
}
