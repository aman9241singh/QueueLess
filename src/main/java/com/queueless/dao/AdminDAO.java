package com.queueless.dao;
import com.queueless.model.Admin;
import com.queueless.util.DBConnection;
import com.queueless.util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class AdminDAO {
    public Admin getAdminByEmail(String email) throws SQLException {
        String sql = "SELECT admin_id, full_name, email, password FROM admins WHERE email = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    return admin;
                }
            }
        }
        return null;
    }
    public Admin getAdminById(int adminId) throws SQLException {
        String sql = "SELECT admin_id, full_name, email, created_at FROM admins WHERE admin_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                    return admin;
                }
            }
        }
        return null;
    }
    public boolean updateAdminProfile(int adminId, String fullName, String email) throws SQLException {
        String sql = "UPDATE admins SET full_name = ?, email = ? WHERE admin_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setInt(3, adminId);
            return ps.executeUpdate() > 0;
        }
    }
    public boolean updateAdminPassword(int adminId, String currentPassword, String newPassword) throws SQLException {
        String selectSql = "SELECT password FROM admins WHERE admin_id = ?";
        String updateSql = "UPDATE admins SET password = ? WHERE admin_id = ?";
        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setInt(1, adminId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || !PasswordUtil.checkPassword(currentPassword, rs.getString("password"))) {
                        return false;
                    }
                }
            }
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setString(1, PasswordUtil.hashPassword(newPassword));
                ps.setInt(2, adminId);
                return ps.executeUpdate() > 0;
            }
        }
    }
}