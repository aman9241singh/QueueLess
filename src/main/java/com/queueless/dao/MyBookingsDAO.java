
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
public class MyBookingsDAO {
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
    public List<Map<String, Object>> getUserBookings(int userId) throws SQLException {
        List<Map<String, Object>> bookings = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
    expireWaitingTokens(con);
}
        String sql = "SELECT b.booking_id, s.service_name, b.visit_date, b.preferred_time, b.booking_status, qt.token_number, qt.queue_position, qt.queue_status, qt.estimated_wait FROM bookings b JOIN services s ON b.service_id = s.service_id LEFT JOIN queue_tokens qt ON b.booking_id = qt.booking_id WHERE b.user_id = ? ORDER BY b.created_at DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("bookingId", rs.getInt("booking_id"));
                    booking.put("serviceName", rs.getString("service_name"));
                    booking.put("visitDate", rs.getDate("visit_date"));
                    booking.put("preferredTime", rs.getTime("preferred_time"));
                    booking.put("bookingStatus", rs.getString("booking_status"));
                    booking.put("tokenNumber", rs.getString("token_number"));
                    booking.put("queuePosition", rs.getObject("queue_position"));
                    booking.put("queueStatus", rs.getString("queue_status"));
                    booking.put("estimatedWait", rs.getObject("estimated_wait"));
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }
    public int getTotalBookings(int userId) throws SQLException {
        return getCount(userId, "SELECT COUNT(*) FROM bookings WHERE user_id = ?");
    }
   public int getConfirmedBookings(int userId) throws SQLException {
    try (Connection con = DBConnection.getConnection()) {
        expireWaitingTokens(con);
    }
    return getCount(userId, "SELECT COUNT(*) FROM bookings WHERE user_id = ? AND booking_status IN ('Waiting', 'Serving')");
}
    public int getCancelledBookings(int userId) throws SQLException {
        return getCount(userId, "SELECT COUNT(*) FROM bookings WHERE user_id = ? AND booking_status = 'Cancelled'");
    }
    public boolean cancelBooking(int bookingId, int userId) throws SQLException {
        String bookingSql = "UPDATE bookings SET booking_status = 'Cancelled' WHERE booking_id = ? AND user_id = ? AND booking_status = 'Waiting'";
        String tokenSql = "UPDATE queue_tokens SET queue_status = 'Cancelled' WHERE booking_id = ? AND queue_status = 'Waiting'";
        String detailsSql = "SELECT b.service_id, b.visit_date, s.average_wait_time FROM bookings b JOIN services s ON b.service_id = s.service_id WHERE b.booking_id = ?";
        String queueSql = "SELECT qt.queue_id FROM queue_tokens qt JOIN bookings b ON qt.booking_id = b.booking_id WHERE b.service_id = ? AND b.visit_date = ? AND qt.queue_status IN ('Waiting', 'Serving') ORDER BY qt.queue_position ASC, b.preferred_time ASC, b.booking_id ASC";
        String updateSql = "UPDATE queue_tokens SET queue_position = ?, estimated_wait = ? WHERE queue_id = ?";
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                int serviceId;
                java.sql.Date visitDate;
                int averageWaitTime;
                try (PreparedStatement ps = con.prepareStatement(detailsSql)) {
                    ps.setInt(1, bookingId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            return false;
                        }
                        serviceId = rs.getInt("service_id");
                        visitDate = rs.getDate("visit_date");
                        averageWaitTime = rs.getInt("average_wait_time");
                    }
                }
                try (PreparedStatement ps = con.prepareStatement(bookingSql)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, userId);
                    if (ps.executeUpdate() == 0) {
                        con.rollback();
                        return false;
                    }
                }
                try (PreparedStatement ps = con.prepareStatement(tokenSql)) {
                    ps.setInt(1, bookingId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = con.prepareStatement(queueSql); PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                    ps.setInt(1, serviceId);
                    ps.setDate(2, visitDate);
                    try (ResultSet rs = ps.executeQuery()) {
                        int position = 1;
                        while (rs.next()) {
                            updatePs.setInt(1, position);
                            updatePs.setInt(2, (position - 1) * averageWaitTime);
                            updatePs.setInt(3, rs.getInt("queue_id"));
                            updatePs.addBatch();
                            position++;
                        }
                    }
                    updatePs.executeBatch();
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
    private int getCount(int userId, String sql) throws SQLException {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }
    public List<Map<String, Object>> getUpcomingBookings(int userId) throws SQLException {
    List<Map<String, Object>> bookings = new ArrayList<>();
    try (Connection con = DBConnection.getConnection()) {
    expireWaitingTokens(con);
}
    String sql = "SELECT b.booking_id, s.service_name, b.visit_date, b.preferred_time, b.booking_status, qt.token_number FROM bookings b JOIN services s ON b.service_id = s.service_id LEFT JOIN queue_tokens qt ON b.booking_id = qt.booking_id WHERE b.user_id = ? AND b.visit_date >= CURDATE() AND b.booking_status IN ('Waiting', 'Serving') ORDER BY b.visit_date ASC, b.preferred_time ASC LIMIT 5";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getInt("booking_id"));
                booking.put("serviceName", rs.getString("service_name"));
                booking.put("visitDate", rs.getDate("visit_date"));
                booking.put("preferredTime", rs.getTime("preferred_time"));
                booking.put("bookingStatus", rs.getString("booking_status"));
                booking.put("tokenNumber", rs.getString("token_number"));
                bookings.add(booking);
            }
        }
    }
    return bookings;
}
public List<Map<String, Object>> getRecentActivity(int userId) throws SQLException {
    List<Map<String, Object>> activities = new ArrayList<>();
    try (Connection con = DBConnection.getConnection()) {
    expireWaitingTokens(con);
}
    String sql = "SELECT b.booking_id, s.service_name, b.visit_date, b.booking_status, b.created_at, qt.token_number FROM bookings b JOIN services s ON b.service_id = s.service_id LEFT JOIN queue_tokens qt ON b.booking_id = qt.booking_id WHERE b.user_id = ? ORDER BY b.created_at DESC LIMIT 5";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> activity = new HashMap<>();
                activity.put("bookingId", rs.getInt("booking_id"));
                activity.put("serviceName", rs.getString("service_name"));
                activity.put("visitDate", rs.getDate("visit_date"));
                activity.put("bookingStatus", rs.getString("booking_status"));
                activity.put("createdAt", rs.getTimestamp("created_at"));
                activity.put("tokenNumber", rs.getString("token_number"));
                activities.add(activity);
            }
        }
    }
    return activities;
}
}
