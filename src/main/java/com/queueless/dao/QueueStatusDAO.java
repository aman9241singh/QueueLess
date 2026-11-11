package com.queueless.dao;
import com.queueless.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
public class QueueStatusDAO {
    public List<Map<String, Object>> getUserQueueStatus(int userId) throws SQLException {
        List<Map<String, Object>> queueList = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.visit_date, b.preferred_time, b.booking_status, s.service_name, s.average_wait_time, qt.token_number, qt.queue_position, qt.queue_status, qt.estimated_wait, (SELECT serving_qt.token_number FROM queue_tokens serving_qt JOIN bookings serving_b ON serving_qt.booking_id = serving_b.booking_id WHERE serving_b.service_id = b.service_id AND serving_b.visit_date = b.visit_date AND serving_qt.queue_status = 'Serving' ORDER BY serving_qt.queue_position LIMIT 1) AS current_serving FROM bookings b JOIN services s ON b.service_id = s.service_id JOIN queue_tokens qt ON b.booking_id = qt.booking_id WHERE b.user_id = ? AND b.booking_status IN ('Waiting', 'Serving') AND qt.queue_status IN ('Waiting', 'Serving') ORDER BY b.created_at DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("bookingId", rs.getInt("booking_id"));
                    item.put("serviceName", rs.getString("service_name"));
                    item.put("visitDate", rs.getDate("visit_date"));
                    item.put("preferredTime", rs.getTime("preferred_time"));
                    item.put("bookingStatus", rs.getString("booking_status"));
                    item.put("tokenNumber", rs.getString("token_number"));
                    item.put("queuePosition", rs.getObject("queue_position"));
                    item.put("queueStatus", rs.getString("queue_status"));
                    item.put("estimatedWait", rs.getObject("estimated_wait"));
                    item.put("currentServing", rs.getString("current_serving"));
                    queueList.add(item);
                }
            }
        }
        return queueList;
    }
}