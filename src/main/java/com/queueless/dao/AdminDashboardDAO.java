
package com.queueless.dao;
import com.queueless.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class AdminDashboardDAO {
    public int getTotalTokensToday() throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE visit_date = CURDATE()";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    public int getActiveQueues() throws SQLException {
        String sql = "SELECT COUNT(DISTINCT b.service_id) FROM queue_tokens qt JOIN bookings b ON qt.booking_id = b.booking_id WHERE b.visit_date = CURDATE() AND qt.queue_status IN ('Waiting', 'Serving')";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    public int getRegisteredUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    public int getWaitingCustomers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM queue_tokens qt JOIN bookings b ON qt.booking_id = b.booking_id WHERE b.visit_date = CURDATE() AND qt.queue_status = 'Waiting'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
