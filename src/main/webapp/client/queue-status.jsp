
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.sql.Date,java.sql.Time,java.text.SimpleDateFormat" %>
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
    List<Map<String,Object>> queueList = (List<Map<String,Object>>) request.getAttribute("queueList");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    String searchToken = request.getParameter("token");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Queue Status | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/queue-status.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
        <nav class="nav-links">
        <a href="${pageContext.request.contextPath}/dashboard" class="btn-login">Dashboard</a>
       <a href="${pageContext.request.contextPath}/services">Services</a>
            <a href="${pageContext.request.contextPath}/booking">Book Token</a>
            <a href="${pageContext.request.contextPath}/queue-status" class = "active">Queue Status</a>
        
        </nav>
        <div class="nav-actions">
                    <a href="${pageContext.request.contextPath}/profile" class="btn-login">My Profile</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn-login">Logout</a>
        </div>
    </header>
    <main class="queue-section">
        <div class="queue-heading">
            <span class="eyebrow">LIVE QUEUE OVERVIEW</span>
            <h1>Check Your Queue Status</h1>
            <p>View your saved tokens and their current status.</p>
        </div>
        <div class="queue-search">
            <label for="tokenSearch">Search by token number</label>
            <div class="search-row">
                <input type="text" id="tokenSearch" placeholder="Enter token number, e.g. QL0003" value="<%= escapeHtml(searchToken) %>">
                <button type="button" id="searchButton" class="btn-primary">Search Token</button>
                <button type="button" id="showAllButton" class="btn-secondary">Show All</button>
            </div>
            <p id="queueMessage" role="status" aria-live="polite"></p>
        </div>
        <div id="bookingList" class="booking-list" data-endpoint="${pageContext.request.contextPath}/queue-status-data">
            <% if (queueList != null && !queueList.isEmpty()) {
                for (Map<String,Object> item : queueList) {
                    Object visitDate = item.get("visitDate");
                    Object preferredTime = item.get("preferredTime");
                    String token = item.get("tokenNumber") == null ? "Not assigned" : item.get("tokenNumber").toString();
                    String bookingStatus = item.get("bookingStatus") == null ? "Waiting" : item.get("bookingStatus").toString();
                    String queueStatus = item.get("queueStatus") == null ? bookingStatus : item.get("queueStatus").toString();
                    String currentServing = item.get("currentServing") == null ? "Not started" : item.get("currentServing").toString();
                    Object position = item.get("queuePosition");
                    Object wait = item.get("estimatedWait");
                    String dateText = visitDate instanceof Date ? dateFormat.format(visitDate) : "Not specified";
                    String timeText = preferredTime instanceof Time ? timeFormat.format(preferredTime) : "Not specified";
                    String positionText = position == null ? "N/A" : position.toString();
                    String waitText = wait == null ? "N/A" : wait.toString() + " minutes";
            %>
            <article class="booking-card" data-token="<%= escapeHtml(token.toLowerCase()) %>" data-status="<%= escapeHtml(queueStatus.toLowerCase()) %>">
                <div class="booking-card-top">
                    <div><span class="booking-label">TOKEN NUMBER</span><h2><%= escapeHtml(token) %></h2></div>
                    <span class="booking-status <%= escapeHtml(queueStatus.toLowerCase()) %>"><%= escapeHtml(queueStatus) %></span>
                </div>
                <div class="booking-details">
                    <div><span>Service</span><strong><%= escapeHtml(item.get("serviceName")) %></strong></div>
                    <div><span>Visit Date</span><strong><%= dateText %></strong></div>
                    <div><span>Preferred Time</span><strong><%= timeText %></strong></div>
                    <div><span>Queue Position</span><strong><%= escapeHtml(positionText) %></strong></div>
                    <div><span>Estimated Waiting Time</span><strong><%= escapeHtml(waitText) %></strong></div>
                    <div><span>Currently Serving</span><strong><%= escapeHtml(currentServing) %></strong></div>
                </div>
            </article>
            <% } } %>
        </div>
        <div class="queue-empty" id="emptyMessage" <%= queueList != null && !queueList.isEmpty() ? "hidden" : "" %>>
            <h2>No bookings found</h2>
            <p>Book a token first, then return here to check its status.</p>
            <a href="${pageContext.request.contextPath}/booking" class="btn-primary">Book a Token</a>
        </div>
    </main>
    <footer class="footer">
        <div class="footer-content">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
            <p>Smarter queues, better experiences.</p>
        </div>
        <p class="footer-bottom">© 2026 QueueLess. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/client/queue-status.js"></script>
</body>
</html>
