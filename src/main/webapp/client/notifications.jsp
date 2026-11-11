
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.text.SimpleDateFormat" %>
<%!
    public String escapeHtml(Object value) {
        if (value == null) return "";
        return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    public String formatNotificationDate(Object value) {
        if (value == null) return "";
        if (value instanceof java.util.Date) return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format((java.util.Date)value);
        return value.toString();
    }
%>
<%
    List<Map<String,Object>> notifications = (List<Map<String,Object>>) request.getAttribute("notifications");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    if (notifications == null) notifications = new java.util.ArrayList<>();
    if (totalCount == null) totalCount = 0;
    if (unreadCount == null) unreadCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Notifications | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/notifications.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
        <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn-login">Dashboard</a>
            <a href="${pageContext.request.contextPath}/services">Services</a>
            <a href="${pageContext.request.contextPath}/booking">Book Token</a>
            <a href="${pageContext.request.contextPath}/queue-status">Queue Status</a>
             <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
           
        </nav>
        <div class="nav-actions">
       
            <a href="${pageContext.request.contextPath}/logout" class="btn-primary">Logout</a>
        </div>
    </header>
    <main class="notifications-section">
        <div class="notifications-heading">
            <div>
                <span class="eyebrow">STAY UPDATED</span>
                <h1>Notifications</h1>
                <p>View your booking updates and important announcements.</p>
            </div>
            <form action="${pageContext.request.contextPath}/mark-all-notifications-read" method="post">
                <button type="submit" id="markAllRead" class="mark-read-btn" <%= unreadCount == 0 ? "disabled" : "" %>>Mark all as read</button>
            </form>
        </div>
        <div class="notification-summary">
            <div class="summary-card">
                <span class="summary-icon blue">✉</span>
                <div>
                    <p>Total Notifications</p>
                    <h2 id="totalCount"><%= totalCount %></h2>
                </div>
            </div>
            <div class="summary-card">
                <span class="summary-icon orange">●</span>
                <div>
                    <p>Unread Notifications</p>
                    <h2 id="unreadCount"><%= unreadCount %></h2>
                </div>
            </div>
        </div>
        <div class="notification-toolbar">
            <div class="notification-tabs">
                <button type="button" class="filter-btn active" data-filter="all">All</button>
                <button type="button" class="filter-btn" data-filter="unread">Unread</button>
                <button type="button" class="filter-btn" data-filter="booking">Bookings</button>
                <button type="button" class="filter-btn" data-filter="announcement">Announcements</button>
            </div>
        </div>
        <div id="notificationList" class="notification-list">
            <% for (Map<String,Object> notification : notifications) {
                boolean isRead = Boolean.TRUE.equals(notification.get("isRead"));
                String title = notification.get("title") == null ? "" : notification.get("title").toString();
                String lowerTitle = title.toLowerCase();
                boolean isAnnouncement = lowerTitle.contains("announcement");
                String type = isAnnouncement ? "announcement" : "booking";
                String iconClass = isAnnouncement ? "orange" : "green";
                String icon = isAnnouncement ? "!" : "✓";
            %>
            <article class="notification-item <%= isRead ? "" : "unread" %>" data-type="<%= type %>" data-unread="<%= !isRead %>">
                <div class="notification-icon <%= iconClass %>"><%= icon %></div>
                <div class="notification-content">
                    <div class="notification-title-row">
                        <h3><%= escapeHtml(notification.get("title")) %></h3>
                        <% if (!isRead) { %>
                            <span class="new-label">NEW</span>
                        <% } %>
                    </div>
                    <p><%= escapeHtml(notification.get("message")) %></p>
                    <span class="notification-time"><%= escapeHtml(formatNotificationDate(notification.get("createdAt"))) %></span>
                </div>
                <% if (!isRead) { %>
                    <form action="${pageContext.request.contextPath}/mark-notification-read" method="post">
                        <input type="hidden" name="notificationId" value="<%= notification.get("notificationId") %>">
                        <button type="submit" class="read-btn">Mark read</button>
                    </form>
                <% } %>
            </article>
            <% } %>
        </div>
        <p id="emptyNotifications" class="empty-notifications" <%= notifications.isEmpty() ? "" : "hidden" %>>No notifications found in this category.</p>
    </main>
    <footer class="footer">
        <div class="footer-content">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
            <p>Smarter queues, better experiences.</p>
        </div>
        <p class="footer-bottom">© 2026 QueueLess. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/client/notifications.js"></script>
</body>
</html>
