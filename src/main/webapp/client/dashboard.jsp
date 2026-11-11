<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.text.SimpleDateFormat" %>
<%!
public String escapeHtml(Object value) {
    if (value == null) return "";
    return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
}
%>
<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect(request.getContextPath() + "/client/login.jsp");
    return;
}
List<Map<String,Object>> upcomingBookings = (List<Map<String,Object>>) request.getAttribute("upcomingBookings");
List<Map<String,Object>> recentActivities = (List<Map<String,Object>>) request.getAttribute("recentActivities");
if (upcomingBookings == null) upcomingBookings = new java.util.ArrayList<>();
if (recentActivities == null) recentActivities = new java.util.ArrayList<>();
SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
SimpleDateFormat activityDateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Client Dashboard | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/dashboard.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/client/dashboard.jsp" class="btn-login active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/services">Services</a>
            <a href="${pageContext.request.contextPath}/queue-status">Queue Status</a>
            <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
        </nav>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/profile" class="btn-login">My Profile</a>
            <a href="${pageContext.request.contextPath}/booking" class="btn-primary">Book Token</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn-login">Logout</a>
        </div>
    </header>
    <main class="dashboard-section">
        <section class="welcome-banner">
            <div>
                <span class="welcome-label">CLIENT DASHBOARD</span>
                <h1>Welcome back, <span id="welcomeName"><%= escapeHtml(session.getAttribute("userName")) %></span>!</h1>
                <p>Manage your tokens and keep track of your visits from one place.</p>
                <a href="${pageContext.request.contextPath}/booking" class="dashboard-cta">+ Book a New Token</a>
            </div>
            <div class="welcome-art">
                <div class="clock-circle">
                    <span>QL</span>
                    <strong>QueueLess</strong>
                    <small>YOUR TIME MATTERS</small>
                </div>
            </div>
        </section>
        <section class="dashboard-stats">
            <article class="stat-card">
                <div class="stat-top"><span>Total Bookings</span><span class="stat-icon blue">▣</span></div>
                <h2 id="totalBookings">${totalBookings}</h2>
                <p>All your token bookings</p>
            </article>
            <article class="stat-card">
                <div class="stat-top"><span>Active Tokens</span><span class="stat-icon green">✓</span></div>
                <h2 id="activeTokens">${activeTokens}</h2>
                <p>Bookings awaiting service</p>
            </article>
            <article class="stat-card">
                <div class="stat-top"><span>Completed Visits</span><span class="stat-icon purple">★</span></div>
                <h2 id="completedVisits">${completedVisits}</h2>
                <p>Successfully completed</p>
            </article>
            <article class="stat-card">
                <div class="stat-top"><span>Notifications</span><span class="stat-icon orange">✉</span></div>
                <h2 id="notificationCount">${notificationCount}</h2>
                <p>Unread notifications</p>
            </article>
        </section>
        <section class="dashboard-main-grid">
            <div class="dashboard-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Upcoming Tokens</h2>
                        <p>Check your next scheduled visits.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/my-bookings">View all</a>
                </div>
                <% if (upcomingBookings.isEmpty()) { %>
                    <div class="empty-state">
                        <p>You don't have any upcoming tokens.</p>
                        <a href="${pageContext.request.contextPath}/booking">Book a Token</a>
                    </div>
                <% } else {
                    for (Map<String,Object> booking : upcomingBookings) {
                        String serviceName = String.valueOf(booking.get("serviceName"));
                        String serviceIcon = serviceName.equalsIgnoreCase("Healthcare") ? "🏥" : serviceName.equalsIgnoreCase("Banking") ? "🏦" : "🎫";
                %>
                    <div class="upcoming-token">
                        <div class="token-icon"><%= serviceIcon %></div>
                        <div class="token-info">
                            <h3><%= escapeHtml(serviceName) %></h3>
                            <p>Token <%= escapeHtml(booking.get("tokenNumber")) %> · <%= booking.get("visitDate") == null ? "" : dateFormat.format((java.util.Date)booking.get("visitDate")) %></p>
                            <span><%= booking.get("preferredTime") == null ? "" : timeFormat.format((java.util.Date)booking.get("preferredTime")) %></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/queue-status" class="token-action">Track</a>
                    </div>
                <%  }
                   } %>
            </div>
            <div class="dashboard-panel quick-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Quick Actions</h2>
                        <p>What would you like to do?</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/booking" class="quick-action"><span class="quick-icon blue">＋</span><span><strong>Book a Token</strong><small>Reserve your place in a queue</small></span><b>›</b></a>
                <a href="${pageContext.request.contextPath}/queue-status" class="quick-action"><span class="quick-icon green">◷</span><span><strong>Check Queue Status</strong><small>View your current position</small></span><b>›</b></a>
                <a href="${pageContext.request.contextPath}/my-bookings" class="quick-action"><span class="quick-icon purple">▤</span><span><strong>My Bookings</strong><small>View your booking history</small></span><b>›</b></a>
                <a href="${pageContext.request.contextPath}/notifications" class="quick-action"><span class="quick-icon orange">✉</span><span><strong>Notifications</strong><small>Read your latest updates</small></span><b>›</b></a>
            </div>
        </section>
        <section class="dashboard-panel activity-panel">
            <div class="panel-heading">
                <div>
                    <h2>Recent Activity</h2>
                    <p>A quick look at your recent account activity.</p>
                </div>
            </div>
            <% if (recentActivities.isEmpty()) { %>
                <div class="empty-state">
                    <p>No recent booking activity yet.</p>
                </div>
            <% } else {
                for (Map<String,Object> activity : recentActivities) {
                    String status = String.valueOf(activity.get("bookingStatus"));
                    String activityColor = status.equalsIgnoreCase("Completed") ? "purple" : status.equalsIgnoreCase("Cancelled") ? "orange" : "green";
            %>
                <div class="activity-row">
                    <span class="activity-dot <%= activityColor %>"></span>
                    <div>
                        <h3>Token <%= escapeHtml(activity.get("tokenNumber")) %> – <%= escapeHtml(activity.get("serviceName")) %></h3>
                        <p>Booking <%= escapeHtml(status) %></p>
                    </div>
                    <time><%= activity.get("createdAt") == null ? "" : activityDateFormat.format((java.util.Date)activity.get("createdAt")) %></time>
                </div>
            <%  }
               } %>
        </section>
    </main>
    <footer class="footer">
        <div class="footer-content">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
            <p>Smarter queues, better experiences.</p>
        </div>
        <p class="footer-bottom">© 2026 QueueLess. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/client/dashboard.js"></script>
</body>
</html>