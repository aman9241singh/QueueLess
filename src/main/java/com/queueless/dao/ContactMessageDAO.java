
package com.queueless.dao;
import com.queueless.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
public class ContactMessageDAO {
    public List<Map<String,Object>> getAllMessages() throws SQLException {
        List<Map<String,Object>> messages = new ArrayList<>();
        String sql = "SELECT message_id, full_name, email, subject, message, message_status, created_at FROM contact_messages ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> item = new HashMap<>();
                item.put("messageId", rs.getInt("message_id"));
                item.put("fullName", rs.getString("full_name"));
                item.put("email", rs.getString("email"));
                item.put("subject", rs.getString("subject"));
                item.put("message", rs.getString("message"));
                item.put("status", rs.getString("message_status"));
                item.put("createdAt", rs.getTimestamp("created_at"));
                messages.add(item);
            }
        }
        return messages;
    }
    public boolean updateMessageStatus(int messageId, String status) throws SQLException {
        if (!"New".equals(status) && !"Read".equals(status) && !"Resolved".equals(status)) {
            return false;
        }
        String sql = "UPDATE contact_messages SET message_status = ? WHERE message_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, messageId);
            return ps.executeUpdate() == 1;
        }
    }
    public boolean deleteMessage(int messageId) throws SQLException {
        String sql = "DELETE FROM contact_messages WHERE message_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            return ps.executeUpdate() == 1;
        }
    }
}
