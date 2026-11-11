
package com.queueless.dao;
import com.queueless.model.Service;
import com.queueless.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
public class ServiceDAO {
    public List<Service> getAllServices() throws SQLException {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services ORDER BY service_id";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setCategory(rs.getString("category"));
                service.setLocation(rs.getString("location"));
                service.setDescription(rs.getString("description"));
                service.setAverageWaitTime(rs.getInt("average_wait_time"));
                service.setMaxTokens(rs.getInt("max_tokens"));
                service.setStatus(rs.getString("status"));
                services.add(service);
            }
        }
        return services;
    }
    public List<Service> getActiveServices() throws SQLException {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE status = 'Active' ORDER BY service_id";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setCategory(rs.getString("category"));
                service.setLocation(rs.getString("location"));
                service.setDescription(rs.getString("description"));
                service.setAverageWaitTime(rs.getInt("average_wait_time"));
                service.setMaxTokens(rs.getInt("max_tokens"));
                service.setStatus(rs.getString("status"));
                services.add(service);
            }
        }
        return services;
    }
    public Service getServiceById(int serviceId) throws SQLException {
        String sql = "SELECT * FROM services WHERE service_id = ? AND status = 'Active'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service service = new Service();
                    service.setServiceId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setCategory(rs.getString("category"));
                    service.setLocation(rs.getString("location"));
                    service.setDescription(rs.getString("description"));
                    service.setAverageWaitTime(rs.getInt("average_wait_time"));
                    service.setMaxTokens(rs.getInt("max_tokens"));
                    service.setStatus(rs.getString("status"));
                    return service;
                }
            }
        }
        return null;
    }
    public boolean addService(Service service, int createdBy) throws SQLException {
        String sql = "INSERT INTO services (service_name, category, location, description, average_wait_time, max_tokens, status, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getCategory());
            ps.setString(3, service.getLocation());
            ps.setString(4, service.getDescription());
            ps.setInt(5, service.getAverageWaitTime());
            ps.setInt(6, service.getMaxTokens());
            ps.setString(7, service.getStatus());
            ps.setInt(8, createdBy);
            return ps.executeUpdate() > 0;
        }
    }
    public boolean updateService(Service service) throws SQLException {
        String sql = "UPDATE services SET service_name = ?, category = ?, location = ?, description = ?, average_wait_time = ?, max_tokens = ? WHERE service_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getCategory());
            ps.setString(3, service.getLocation());
            ps.setString(4, service.getDescription());
            ps.setInt(5, service.getAverageWaitTime());
            ps.setInt(6, service.getMaxTokens());
            ps.setInt(7, service.getServiceId());
            return ps.executeUpdate() > 0;
        }
    }
    public boolean deleteService(int serviceId) throws SQLException {
        String sql = "DELETE FROM services WHERE service_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            return ps.executeUpdate() > 0;
        }
    }
    public boolean updateServiceStatus(int serviceId, String status) throws SQLException {
        String sql = "UPDATE services SET status = ? WHERE service_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        }
    }
}
