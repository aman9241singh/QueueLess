
package com.queueless.model;
public class Admin {
    private int adminId;
    private String fullName;
    private String email;
    private String password;
    private java.sql.Timestamp createdAt;
    public int getAdminId() {
        return adminId;
    }
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public java.sql.Timestamp getCreatedAt() {
    return createdAt;
}
public void setCreatedAt(java.sql.Timestamp createdAt) {
    this.createdAt = createdAt;
}
}
