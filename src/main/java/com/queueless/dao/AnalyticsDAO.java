package com.queueless.dao;
import java.util.ArrayList;
import java.util.List;
import com.queueless.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
public class AnalyticsDAO {
    public Map<String, Object> getSummary(int days) throws SQLException {
        Map<String, Object> summary = new LinkedHashMap<>();
        String sql = "SELECT COUNT(*) AS total, COALESCE(SUM(CASE WHEN b.booking_status = 'Completed' THEN 1 ELSE 0 END), 0) AS completed, COALESCE(AVG(CASE WHEN b.booking_status IN ('Waiting','Serving') THEN q.estimated_wait END), 0) AS average_wait FROM bookings b LEFT JOIN queue_tokens q ON b.booking_id = q.booking_id WHERE b.created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, days);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total");
                    int completed = rs.getInt("completed");
                    summary.put("totalTokens", total);
                    summary.put("completed", completed);
                    summary.put("completionRate", total == 0 ? 0 : Math.round(completed * 100.0 / total));
                    summary.put("averageWait", Math.round(rs.getDouble("average_wait")));
                }
            }
        }
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM services WHERE status = 'Active'"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) summary.put("activeServices", rs.getInt(1));
        }
        return summary;
    }
    public Map<String, Integer> getBookingTrends(int days) throws SQLException {
    Map<String, Integer> trends = new LinkedHashMap<>();
    String sql = "SELECT DATE(created_at) AS booking_date, COUNT(*) AS total, SUM(CASE WHEN booking_status = 'Completed' THEN 1 ELSE 0 END) AS completed FROM bookings WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) GROUP BY DATE(created_at) ORDER BY booking_date";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, days);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                trends.put(rs.getDate("booking_date").toString(), rs.getInt("total"));
            }
        }
    }
    return trends;
}
public Map<String, Integer> getStatusDistribution(int days) throws SQLException {
    Map<String, Integer> statuses = new LinkedHashMap<>();
    String sql = "SELECT booking_status, COUNT(*) AS total FROM bookings WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) GROUP BY booking_status";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, days);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                statuses.put(rs.getString("booking_status"), rs.getInt("total"));
            }
        }
    }
    return statuses;
}
public List<Map<String, Object>> getServicePerformance(int days) throws SQLException {
    List<Map<String, Object>> performance = new ArrayList<>();
    String sql = "SELECT s.service_name, COUNT(b.booking_id) AS total, SUM(CASE WHEN b.booking_status = 'Completed' THEN 1 ELSE 0 END) AS completed, COALESCE(AVG(q.estimated_wait), 0) AS average_wait FROM services s LEFT JOIN bookings b ON s.service_id = b.service_id AND b.created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) LEFT JOIN queue_tokens q ON b.booking_id = q.booking_id GROUP BY s.service_id, s.service_name ORDER BY total DESC";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, days);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("serviceName", rs.getString("service_name"));
                item.put("total", rs.getInt("total"));
                item.put("completed", rs.getInt("completed"));
                item.put("averageWait", Math.round(rs.getDouble("average_wait")));
                performance.add(item);
            }
        }
    }
    return performance;
}
public Map<String, Integer> getWeeklyTraffic(int days) throws SQLException {
    Map<String, Integer> traffic = new LinkedHashMap<>();
    String sql = "SELECT DAYOFWEEK(created_at) AS day_number, DAYNAME(created_at) AS day_name, COUNT(*) AS total FROM bookings WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) GROUP BY DAYOFWEEK(created_at), DAYNAME(created_at) ORDER BY day_number";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, days);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                traffic.put(rs.getString("day_name"), rs.getInt("total"));
            }
        }
    }
    return traffic;
}
public Map<String, Integer> getCompletedTrends(int days) throws SQLException {
    Map<String, Integer> trends = new LinkedHashMap<>();
    String sql = "SELECT DATE(created_at) AS booking_date, COUNT(*) AS total FROM bookings WHERE booking_status = 'Completed' AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) GROUP BY DATE(created_at) ORDER BY booking_date";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, days);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                trends.put(rs.getDate("booking_date").toString(), rs.getInt("total"));
            }
        }
    }
    return trends;
}
}