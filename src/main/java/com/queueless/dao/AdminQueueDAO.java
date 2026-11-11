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
public class AdminQueueDAO {
  private void expireWaitingTokens(Connection con) throws SQLException {
    String tokenSql = "UPDATE queue_tokens SET queue_status = 'Expired' WHERE queue_status = 'Waiting' AND expires_at IS NOT NULL AND expires_at <= NOW()";
    try (PreparedStatement ps = con.prepareStatement(tokenSql)) {
        ps.executeUpdate();
    }
    String bookingSql = "UPDATE bookings b JOIN queue_tokens qt ON b.booking_id = qt.booking_id SET b.booking_status = 'Expired' WHERE qt.queue_status = 'Expired' AND b.booking_status = 'Waiting'";
    try (PreparedStatement ps = con.prepareStatement(bookingSql)) {
        ps.executeUpdate();
    }

}
    public List<Map<String,Object>> getAllQueueTokens() throws SQLException {
        List<Map<String,Object>> tokens = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            expireWaitingTokens(con);
            String sql = "SELECT qt.queue_id, qt.token_number, qt.queue_position, qt.queue_status, qt.estimated_wait, qt.created_at, b.booking_id, b.visit_date, b.preferred_time, b.booking_status, u.full_name, s.service_name FROM queue_tokens qt JOIN bookings b ON qt.booking_id = b.booking_id JOIN users u ON b.user_id = u.user_id JOIN services s ON b.service_id = s.service_id WHERE b.visit_date >= CURDATE() AND qt.queue_status IN ('Waiting','Serving','Completed','Expired') ORDER BY b.visit_date, s.service_name, qt.queue_position";
            try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> token = new HashMap<>();
                    token.put("queueId", rs.getInt("queue_id"));
                    token.put("bookingId", rs.getInt("booking_id"));
                    token.put("tokenNumber", rs.getString("token_number"));
                    token.put("customerName", rs.getString("full_name"));
                    token.put("serviceName", rs.getString("service_name"));
                    token.put("queuePosition", rs.getInt("queue_position"));
                    token.put("queueStatus", rs.getString("queue_status"));
                    token.put("estimatedWait", rs.getInt("estimated_wait"));
                    token.put("createdAt", rs.getTimestamp("created_at"));
                    token.put("visitDate", rs.getDate("visit_date"));
                    token.put("preferredTime", rs.getTime("preferred_time"));
                    tokens.add(token);
                }
            }
        }
        return tokens;
    }
    public boolean updateQueueStatus(int queueId, String newStatus) throws SQLException {
        if (!"Serving".equals(newStatus) && !"Completed".equals(newStatus)) {
            return false;
        }
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                expireWaitingTokens(con);
                int userId;
                String tokenNumber;
                String serviceName;
                String currentStatus;
                String selectSql = "SELECT b.user_id, qt.token_number, s.service_name, qt.queue_status FROM queue_tokens qt JOIN bookings b ON qt.booking_id = b.booking_id JOIN services s ON b.service_id = s.service_id WHERE qt.queue_id = ? FOR UPDATE";
                try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                    ps.setInt(1, queueId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            return false;
                        }
                        userId = rs.getInt("user_id");
                        tokenNumber = rs.getString("token_number");
                        serviceName = rs.getString("service_name");
                        currentStatus = rs.getString("queue_status");
                    }
                }
                if ("Expired".equals(currentStatus)) {
                    con.commit();
                    return false;
                }
                if ("Serving".equals(newStatus) && !"Waiting".equals(currentStatus)) {
                    con.rollback();
                    return false;
                }
                if ("Completed".equals(newStatus) && !"Serving".equals(currentStatus)) {
                    con.rollback();
                    return false;
                }
                String updateSql = "UPDATE queue_tokens SET queue_status = ? WHERE queue_id = ?";
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setString(1, newStatus);
                    ps.setInt(2, queueId);
                    ps.executeUpdate();
                }
                String bookingSql = "UPDATE bookings SET booking_status = ? WHERE booking_id = (SELECT booking_id FROM queue_tokens WHERE queue_id = ?)";
                try (PreparedStatement ps = con.prepareStatement(bookingSql)) {
                    ps.setString(1, newStatus);
                    ps.setInt(2, queueId);
                    ps.executeUpdate();
                }
                String title;
                String message;
                if ("Serving".equals(newStatus)) {
                    title = "Your Turn Has Arrived!";
                    message = "Your token " + tokenNumber + " for " + serviceName + " is now being served.";
                } else {
                    title = "Service Completed";
                    message = "Your service for token " + tokenNumber + " at " + serviceName + " has been completed.";
                }
                String notificationSql = "INSERT INTO notifications (user_id, title, message, is_read) VALUES (?, ?, ?, 0)";
                try (PreparedStatement ps = con.prepareStatement(notificationSql)) {
                    ps.setInt(1, userId);
                    ps.setString(2, title);
                    ps.setString(3, message);
                    ps.executeUpdate();
                }
                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
}