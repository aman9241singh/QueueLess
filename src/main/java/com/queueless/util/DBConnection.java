
package com.queueless.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class DBConnection {
    private static final String URL = System.getenv("QUEUELESS_DB_URL");
    private static final String USERNAME = System.getenv("QUEUELESS_DB_USERNAME");
    private static final String PASSWORD = System.getenv("QUEUELESS_DB_PASSWORD");
    public static Connection getConnection() throws SQLException {
        if (URL == null || USERNAME == null || PASSWORD == null) {
            throw new SQLException("Database environment variables are not configured.");
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found.", e);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
