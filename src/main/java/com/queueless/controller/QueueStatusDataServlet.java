
package com.queueless.controller;
import com.queueless.dao.QueueStatusDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/queue-status-data")
public class QueueStatusDataServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\":\"Session expired\"}");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        try {
            List<Map<String,Object>> queueList = new QueueStatusDAO().getUserQueueStatus(userId);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < queueList.size(); i++) {
                Map<String,Object> item = queueList.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                append(json, "bookingId", item.get("bookingId"));
                append(json, "serviceName", item.get("serviceName"));
                append(json, "visitDate", item.get("visitDate"));
                append(json, "preferredTime", item.get("preferredTime"));
                append(json, "bookingStatus", item.get("bookingStatus"));
                append(json, "tokenNumber", item.get("tokenNumber"));
                append(json, "queuePosition", item.get("queuePosition"));
                append(json, "queueStatus", item.get("queueStatus"));
                append(json, "estimatedWait", item.get("estimatedWait"));
                append(json, "currentServing", item.get("currentServing"));
                if (json.charAt(json.length() - 1) == ',') json.deleteCharAt(json.length() - 1);
                json.append("}");
            }
            json.append("]");
            response.getWriter().write(json.toString());
        } catch (SQLException e) {
            throw new ServletException("Unable to retrieve live queue data.", e);
        }
    }
    private void append(StringBuilder json, String key, Object value) {
        json.append("\"").append(key).append("\":");
        if (value == null) {
            json.append("null");
        } else if (value instanceof Number) {
            json.append(value);
        } else {
            json.append("\"").append(escapeJson(value.toString())).append("\"");
        }
        json.append(",");
    }
    private String escapeJson(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"").replace("\b", "\\b").replace("\f", "\\f").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
