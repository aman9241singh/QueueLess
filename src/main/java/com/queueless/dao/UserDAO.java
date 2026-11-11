
package com.queueless.dao;
import java.util.List;
import java.util.ArrayList;
import com.queueless.model.User;
import com.queueless.util.DBConnection;
import com.queueless.util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
public class UserDAO {
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT user_id, full_name, email, phone, password FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setPassword(rs.getString("password"));
                    return user;
                }
            }
        }
        return null;
    }
    public boolean registerUser(User user) throws SQLException {
        String sql = "INSERT INTO users (full_name, email, phone, password) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            return ps.executeUpdate() > 0;
        }
    }
    public int[] getBookingStatistics(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) AS total, SUM(CASE WHEN booking_status IN ('Waiting', 'Serving') THEN 1 ELSE 0 END) AS active, SUM(CASE WHEN booking_status = 'Completed' THEN 1 ELSE 0 END) AS completed FROM bookings WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new int[]{rs.getInt("total"), rs.getInt("active"), rs.getInt("completed")};
                }
            }
        }
        return new int[]{0, 0, 0};
    }
    public int getUnreadNotificationCount(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
    public boolean updateProfile(int userId, String fullName, String email, String phone) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        }
    }
    public boolean changePassword(int userId, String currentPassword, String newPassword) throws SQLException {
        String selectSql = "SELECT password FROM users WHERE user_id = ?";
        String updateSql = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || !PasswordUtil.checkPassword(currentPassword, rs.getString("password"))) return false;
                }
            }
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setString(1, PasswordUtil.hashPassword(newPassword));
                ps.setInt(2, userId);
                return ps.executeUpdate() > 0;
            }
        }
    }
    
public User getUserById(int userId) throws SQLException {
    String sql = "SELECT user_id, full_name, email, phone FROM users WHERE user_id = ?";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                return user;
            }
        }
    }
    return null;
}

public boolean emailExistsForAnotherUser(String email, int userId) throws SQLException {
    String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND user_id <> ?";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setInt(2, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1) > 0;
        }
    }
    return false;
}
public List<User> getAllUsers() throws SQLException {
    List<User> users = new ArrayList<>();
    String sql = "SELECT u.user_id, u.full_name, u.email, u.phone, u.created_at, u.account_status, COUNT(b.booking_id) AS total_tokens FROM users u LEFT JOIN bookings b ON u.user_id = b.user_id GROUP BY u.user_id, u.full_name, u.email, u.phone, u.created_at, u.account_status ORDER BY u.created_at DESC";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setFullName(rs.getString("full_name"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setAccountStatus(rs.getString("account_status"));
            user.setTotalTokens(rs.getInt("total_tokens"));
            users.add(user);
        }
    }
    return users;
}
public boolean updateAccountStatus(int userId, String status) throws SQLException {
    String sql = "UPDATE users SET account_status = ? WHERE user_id = ?";
    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, status);
        ps.setInt(2, userId);
        return ps.executeUpdate() > 0;
    }
}
}
