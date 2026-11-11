
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
public class NotificationDAO {
    public List<Map<String, Object>> getUserNotifications(int userId) throws SQLException {
        List<Map<String, Object>> notifications = new ArrayList<>();
        String sql = "SELECT notification_id, title, message, is_read, created_at FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> notification = new HashMap<>();
                    notification.put("notificationId", rs.getInt("notification_id"));
                    notification.put("title", rs.getString("title"));
                    notification.put("message", rs.getString("message"));
                    notification.put("isRead", rs.getBoolean("is_read"));
                    notification.put("createdAt", rs.getTimestamp("created_at"));
                    notifications.add(notification);
                }
            }
        }
        return notifications;
    }
    public boolean addNotification(int userId, String title, String message) throws SQLException {
    String sql = "INSERT INTO notifications (user_id, title, message, is_read) VALUES (?, ?, ?, 0)";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ps.setString(2, title);
        ps.setString(3, message);
        return ps.executeUpdate() > 0;
    }
}
    public boolean markAsRead(int notificationId, int userId) throws SQLException {
        String sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = ? AND user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }
    public int markAllAsRead(int userId) throws SQLException {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate();
        }
    }
}
