
package com.queueless.controller;
import com.queueless.dao.AnalyticsDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/admin/analytics")
public class AdminAnalyticsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            if ("json".equals(request.getParameter("format"))) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            }
            return;
        }
        int days = 7;
        try {
            int requestedDays = Integer.parseInt(request.getParameter("days"));
            if (requestedDays == 7 || requestedDays == 14 || requestedDays == 30) days = requestedDays;
        } catch (NumberFormatException | NullPointerException e) {
            days = 7;
        }
        try {
            AnalyticsDAO dao = new AnalyticsDAO();
            Map<String, Object> summary = dao.getSummary(days);
            Map<String, Integer> bookingTrends = dao.getBookingTrends(days);
            Map<String, Integer> completedTrends = dao.getCompletedTrends(days);
            Map<String, Integer> statuses = dao.getStatusDistribution(days);
            List<Map<String, Object>> services = dao.getServicePerformance(days);
            Map<String, Integer> traffic = dao.getWeeklyTraffic(days);
            if ("json".equals(request.getParameter("format"))) {
                response.setContentType("application/json;charset=UTF-8");
                StringBuilder json = new StringBuilder();
                json.append("{\"summary\":").append(toJson(summary));
                json.append(",\"bookingTrends\":").append(toJson(bookingTrends));
                json.append(",\"completedTrends\":").append(toJson(completedTrends));
                json.append(",\"statusDistribution\":").append(toJson(statuses));
                json.append(",\"servicePerformance\":").append(toJson(services));
                json.append(",\"weeklyTraffic\":").append(toJson(traffic)).append("}");
                response.getWriter().write(json.toString());
                return;
            }
            request.setAttribute("days", days);
            request.setAttribute("summary", summary);
            request.getRequestDispatcher("/admin/analytics.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load analytics data.", e);
        }
    }
    private String toJson(Object value) {
        if (value == null) return "null";
        if (value instanceof Number || value instanceof Boolean) return value.toString();
        if (value instanceof String) return "\"" + escapeJson((String) value) + "\"";
        if (value instanceof Map) {
            StringBuilder json = new StringBuilder("{");
            boolean first = true;
            for (Object entryObject : ((Map<?, ?>) value).entrySet()) {
                Map.Entry<?, ?> entry = (Map.Entry<?, ?>) entryObject;
                if (!first) json.append(",");
                json.append(toJson(String.valueOf(entry.getKey()))).append(":").append(toJson(entry.getValue()));
                first = false;
            }
            return json.append("}").toString();
        }
        if (value instanceof Iterable) {
            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Object item : (Iterable<?>) value) {
                if (!first) json.append(",");
                json.append(toJson(item));
                first = false;
            }
            return json.append("]").toString();
        }
        return toJson(value.toString());
    }
    private String escapeJson(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
