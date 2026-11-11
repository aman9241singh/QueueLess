<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.queueless.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Users Management | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/users.css">
</head>
<body>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }
    int totalUsers = users.size();
    int activeUsers = 0;
    int inactiveUsers = 0;
    int newUsers = 0;
    java.util.Calendar calendar = java.util.Calendar.getInstance();
    int currentMonth = calendar.get(java.util.Calendar.MONTH);
    int currentYear = calendar.get(java.util.Calendar.YEAR);
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    for (User user : users) {
        if ("Active".equalsIgnoreCase(user.getAccountStatus())) activeUsers++;
        else if ("Inactive".equalsIgnoreCase(user.getAccountStatus())) inactiveUsers++;
        if (user.getCreatedAt() != null) {
            calendar.setTime(user.getCreatedAt());
            if (calendar.get(java.util.Calendar.MONTH) == currentMonth && calendar.get(java.util.Calendar.YEAR) == currentYear) newUsers++;
        }
    }
%>
<div class="admin-layout">
    <aside class="admin-sidebar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <div class="admin-info">
            <div class="admin-avatar">A</div>
            <div>
                <h3>Administrator</h3>
                <p>System Admin</p>
            </div>
        </div>
        <nav class="admin-nav">
            <a href="dashboard.jsp">▦ Dashboard</a>
            <a href=href="${pageContext.request.contextPath}/admin/services">▤ Manage Services</a>
            <a href="${pageContext.request.contextPath}/admin/live-queue">☷ Live Queue</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="active">♙ Users</a>
            <a href="analytics.jsp">▥ Analytics &amp; Reports</a>
            <a href="${pageContext.request.contextPath}/admin/announcements">◉ Announcements</a>
            <a href="settings.jsp">⚙ Settings</a>
            <a href="${pageContext.request.contextPath}/admin/profile">♙ Admin Profile</a>
        </nav>
        <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logout">← Back to Website</a>
    </aside>
    <main class="admin-main">
        <header class="admin-header">
            <div>
                <p class="eyebrow">USER MANAGEMENT</p>
                <h1>Users</h1>
                <p class="header-subtitle">View registered customers and manage their account status.</p>
            </div>
            <div class="system-status"><span></span> System Online</div>
        </header>
        <section class="user-stats">
            <div class="user-stat">
                <span>Total Users</span>
                <h2 id="totalUsers"><%= totalUsers %></h2>
                <p>All registered accounts</p>
            </div>
            <div class="user-stat">
                <span>Active Users</span>
                <h2 id="activeUsers"><%= activeUsers %></h2>
                <p>Accounts currently active</p>
            </div>
            <div class="user-stat">
                <span>Inactive Users</span>
                <h2 id="inactiveUsers"><%= inactiveUsers %></h2>
                <p>Deactivated accounts</p>
            </div>
            <div class="user-stat">
                <span>New This Month</span>
                <h2 id="newUsers"><%= newUsers %></h2>
                <p>Registrations this month</p>
            </div>
        </section>
        <section class="users-panel">
            <div class="users-heading">
                <div>
                    <h2>Registered Users</h2>
                    <p>Search and review customer accounts.</p>
                </div>
                <button type="button" id="exportUsersBtn" class="export-btn">Export CSV ↓</button>
            </div>
            <div class="users-toolbar">
                <input type="search" id="userSearch" placeholder="Search name, email or phone...">
                <select id="userStatusFilter">
                    <option value="all">All Statuses</option>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
                <select id="userSort">
                    <option value="newest">Newest First</option>
                    <option value="oldest">Oldest First</option>
                    <option value="name">Name A–Z</option>
                </select>
            </div>
            <div class="table-scroll">
                <table>
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Phone</th>
                            <th>Joined Date</th>
                            <th>Total Tokens</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="usersTable">
                        <% if (users.isEmpty()) { %>
                        <tr><td colspan="6">No registered users found.</td></tr>
                        <% } else {
                            for (User user : users) {
                                String status = user.getAccountStatus() == null ? "Inactive" : user.getAccountStatus();
                        %>
                        <tr data-id="<%= user.getUserId() %>" data-status="<%= status %>">
                            <td>
                                <div class="user-name"><%= user.getFullName() %></div>
                                <div class="user-email"><%= user.getEmail() %></div>
                            </td>
                            <td><%= user.getPhone() == null || user.getPhone().isEmpty() ? "—" : user.getPhone() %></td>
                            <td><%= user.getCreatedAt() == null ? "—" : dateFormat.format(user.getCreatedAt()) %></td>
                            <td><%= user.getTotalTokens() %></td>
                            <td><span class="status-badge <%= status.toLowerCase() %>"><%= status %></span></td>
                            <td>
                                <button type="button" class="status-btn" data-id="<%= user.getUserId() %>">
                                    <%= "Active".equalsIgnoreCase(status) ? "Deactivate" : "Activate" %>
                                </button>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
            <p id="emptyUsers" class="empty-users" hidden>No users match your search.</p>
        </section>
        <footer class="admin-footer">© 2026 QueueLess. Smart queues, better experiences.</footer>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/admin/users.js"></script>
</body>
</html>