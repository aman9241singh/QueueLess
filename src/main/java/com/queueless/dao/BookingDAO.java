package com.queueless.dao;
import com.queueless.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDateTime;
public class BookingDAO {
    public String createBooking(int userId, int serviceId, Date visitDate, Time preferredTime) throws SQLException {
        String bookingSql = "INSERT INTO bookings (user_id, service_id, visit_date, preferred_time, booking_status) VALUES (?, ?, ?, ?, 'Waiting')";
        String serviceSql = "SELECT status FROM services WHERE service_id = ?";
        String queueSql = "SELECT COUNT(*) FROM queue_tokens qt JOIN bookings b ON qt.booking_id = b.booking_id WHERE b.service_id = ? AND b.visit_date = ? AND qt.queue_status IN ('Waiting', 'Serving')";
        String settingsSql = "SELECT setting_key, setting_value FROM system_settings WHERE setting_key IN ('tokenPrefix', 'waitTime', 'maxTokens', 'tokenExpiry')";
        String tokenSql = "INSERT INTO queue_tokens (booking_id, token_number, queue_position, queue_status, estimated_wait, expires_at) VALUES (?, ?, ?, 'Waiting', ?, ?)";
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                String tokenPrefix = "QL-";
                int averageWaitTime = 20;
                int maxTokens = 100;
                int tokenExpiry = 60;
                try (PreparedStatement ps = con.prepareStatement(settingsSql); ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String key = rs.getString("setting_key");
                        String value = rs.getString("setting_value");
                        if ("tokenPrefix".equals(key)) tokenPrefix = value;
                        if ("waitTime".equals(key)) averageWaitTime = Integer.parseInt(value);
                        if ("maxTokens".equals(key)) maxTokens = Integer.parseInt(value);
                        if ("tokenExpiry".equals(key)) tokenExpiry = Integer.parseInt(value);
                    }
                }
                try (PreparedStatement ps = con.prepareStatement(serviceSql)) {
                    ps.setInt(1, serviceId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next() || !"Active".equalsIgnoreCase(rs.getString("status"))) {
                            throw new SQLException("Selected service is unavailable.");
                        }
                    }
                }
                int queuePosition;
                try (PreparedStatement ps = con.prepareStatement(queueSql)) {
                    ps.setInt(1, serviceId);
                    ps.setDate(2, visitDate);
                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        queuePosition = rs.getInt(1) + 1;
                    }
                }
                if (queuePosition > maxTokens) {
                    throw new SQLException("Maximum tokens reached for this service and date.");
                }
                int bookingId;
                try (PreparedStatement ps = con.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, serviceId);
                    ps.setDate(3, visitDate);
                    ps.setTime(4, preferredTime);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) throw new SQLException("Unable to generate booking ID.");
                        bookingId = rs.getInt(1);
                    }
                }
                String tokenNumber = tokenPrefix + String.format("%04d", bookingId);
                int estimatedWait = (queuePosition - 1) * averageWaitTime;
                LocalDateTime expiryDateTime = LocalDateTime.of(visitDate.toLocalDate(), preferredTime.toLocalTime()).plusMinutes(tokenExpiry);
                try (PreparedStatement ps = con.prepareStatement(tokenSql)) {
                    ps.setInt(1, bookingId);
                    ps.setString(2, tokenNumber);
                    ps.setInt(3, queuePosition);
                    ps.setInt(4, estimatedWait);
                    ps.setTimestamp(5, Timestamp.valueOf(expiryDateTime));
                    ps.executeUpdate();
                }
                con.commit();
                return tokenNumber;
            } catch (SQLException | NumberFormatException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
    public int[] getQueueDetails(String tokenNumber) throws SQLException {
        String sql = "SELECT queue_position, estimated_wait FROM queue_tokens WHERE token_number = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tokenNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new int[]{rs.getInt("queue_position"), rs.getInt("estimated_wait")};
            }
        }
        throw new SQLException("Booking queue details not found.");
    }
}