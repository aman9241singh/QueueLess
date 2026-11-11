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
public class AnnouncementDAO {
    public List<Map<String,Object>> getAllAnnouncements() throws SQLException {
        List<Map<String,Object>> announcements = new ArrayList<>();
        String sql = "SELECT announcement_id, admin_id, title, message, status, created_at FROM announcements ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> item = new HashMap<>();
                item.put("announcementId", rs.getInt("announcement_id"));
                item.put("adminId", rs.getInt("admin_id"));
                item.put("title", rs.getString("title"));
                item.put("message", rs.getString("message"));
                item.put("status", rs.getString("status"));
                item.put("createdAt", rs.getTimestamp("created_at"));
                announcements.add(item);
            }
        }
        return announcements;
    }
 public boolean addAnnouncement(int adminId, String title, String message, String status) throws SQLException {
    String announcementSql = "INSERT INTO announcements (admin_id, title, message, status) VALUES (?, ?, ?, ?)";
    String notificationSql = "INSERT INTO notifications (user_id, title, message) SELECT user_id, ?, ? FROM users";
    try (Connection con = DBConnection.getConnection()) {
        con.setAutoCommit(false);
        try {
            try (PreparedStatement ps = con.prepareStatement(announcementSql)) {
                ps.setInt(1, adminId);
                ps.setString(2, title);
                ps.setString(3, message);
                ps.setString(4, status);
                ps.executeUpdate();
            }
            if ("Published".equals(status)) {
                try (PreparedStatement ps = con.prepareStatement(notificationSql)) {
                   ps.setString(1, title);
ps.setString(2, message);
int insertedRows = ps.executeUpdate();
System.out.println("DEBUG notifications inserted = " + insertedRows);
                }
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
   
public boolean updateAnnouncement(int id, String title, String message, String status) throws SQLException {
    String selectSql = "SELECT status FROM announcements WHERE announcement_id = ? FOR UPDATE";
    String updateSql = "UPDATE announcements SET title = ?, message = ?, status = ? WHERE announcement_id = ?";
    String notificationSql = "INSERT INTO notifications (user_id, title, message) SELECT user_id, ?, ? FROM users";
    try (Connection con = DBConnection.getConnection()) {
        con.setAutoCommit(false);
        try {
            String oldStatus = null;
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) oldStatus = rs.getString("status");
                }
            }
            if (oldStatus == null) {
                con.rollback();
                return false;
            }
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setString(1, title);
                ps.setString(2, message);
                ps.setString(3, status);
                ps.setInt(4, id);
                if (ps.executeUpdate() != 1) {
                    con.rollback();
                    return false;
                }
            }
            System.out.println("DEBUG oldStatus = [" + oldStatus + "]");
System.out.println("DEBUG newStatus = [" + status + "]");
            if ("Draft".equals(oldStatus) && "Published".equals(status)) {
              try (PreparedStatement ps = con.prepareStatement(notificationSql)) {
    ps.setString(1, title);
    ps.setString(2, message);
    int insertedRows = ps.executeUpdate();
    System.out.println("DEBUG notifications inserted = " + insertedRows);
}
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

    public boolean deleteAnnouncement(int id) throws SQLException {
        String sql = "DELETE FROM announcements WHERE announcement_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        }
    }
}