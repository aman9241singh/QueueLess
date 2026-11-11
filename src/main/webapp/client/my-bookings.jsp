
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.sql.Date,java.sql.Time,java.text.SimpleDateFormat" %>
<%!
    public String escapeHtml(Object value) {
        if (value == null) return "";
        return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    List<Map<String,Object>> bookings = (List<Map<String,Object>>) request.getAttribute("bookings");
    int total = request.getAttribute("totalBookings") == null ? 0 : (Integer) request.getAttribute("totalBookings");
    int confirmed = request.getAttribute("confirmedBookings") == null ? 0 : (Integer) request.getAttribute("confirmedBookings");
    int cancelled = request.getAttribute("cancelledBookings") == null ? 0 : (Integer) request.getAttribute("cancelledBookings");
    String bookingMessage = (String) session.getAttribute("bookingMessage");
    session.removeAttribute("bookingMessage");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>My Bookings | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/my-bookings.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
        <nav class="nav-links">
                 <a href="${pageContext.request.contextPath}/dashboard" class="btn-login">Dashboard</a>
            <a href="${pageContext.request.contextPath}/services">Services</a>
            <a href="${pageContext.request.contextPath}/booking">Book Token</a>
           <a href="${pageContext.request.contextPath}/my-bookings" class="btn-login active">My Bookings</a>
            
            <a href="${pageContext.request.contextPath}/queue-status">Queue Status</a>
            <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
        </nav>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/logout" class="btn-login">Logout</a>
        </div>
    </header>
    <main class="bookings-section">
        <div class="bookings-heading">
            <div>
                <span class="eyebrow">YOUR ACTIVITY</span>
                <h1>My Bookings</h1>
                <p>View and manage your token bookings in one place.</p>
            </div>
            <a href="${pageContext.request.contextPath}/booking" class="btn-primary">+ Book New Token</a>
        </div>
        <% if (bookingMessage != null) { %>
            <p class="booking-message"><%= escapeHtml(bookingMessage) %></p>
        <% } %>
        <div class="booking-summary">
            <div class="summary-card">
                <span class="summary-icon blue">▣</span>
                <div><p>Total Bookings</p><h2 id="totalBookings"><%= total %></h2></div>
            </div>
            <div class="summary-card">
                <span class="summary-icon green">✓</span>
                <div><p>Confirmed</p><h2 id="confirmedBookings"><%= confirmed %></h2></div>
            </div>
            <div class="summary-card">
                <span class="summary-icon orange">◷</span>
                <div><p>Cancelled</p><h2 id="cancelledBookings"><%= cancelled %></h2></div>
            </div>
        </div>
        <div class="bookings-toolbar">
            <div class="booking-tabs">
                <button class="filter-btn active" data-filter="all" type="button">All Bookings</button>
                <button class="filter-btn" data-filter="Confirmed" type="button">Confirmed</button>
                <button class="filter-btn" data-filter="Completed" type="button">Completed</button>
                <button class="filter-btn" data-filter="Cancelled" type="button">Cancelled</button>
            </div>
        </div>
        <div class="booking-list" id="bookingList">
            <% if (bookings != null) { for (Map<String,Object> booking : bookings) {
                Object visitDate = booking.get("visitDate");
                Object preferredTime = booking.get("preferredTime");
                String status = booking.get("bookingStatus") == null ? "Waiting" : booking.get("bookingStatus").toString();
                String token = booking.get("tokenNumber") == null ? "Not assigned" : booking.get("tokenNumber").toString();
                String dateText = visitDate instanceof Date ? dateFormat.format(visitDate) : "Not specified";
                String timeText = preferredTime instanceof Time ? timeFormat.format(preferredTime) : "Not specified";
                String filterStatus = status.equalsIgnoreCase("Waiting") || status.equalsIgnoreCase("Serving") ? "Confirmed" : status;
                int bookingId = (Integer) booking.get("bookingId");
            %>
            <article class="booking-card" data-status="<%= escapeHtml(filterStatus) %>">
                <div class="booking-card-top">
                    <div><span class="booking-label">TOKEN NUMBER</span><h2><%= escapeHtml(token) %></h2></div>
                    <span class="booking-status <%= escapeHtml(status.toLowerCase()) %>"><%= escapeHtml(status) %></span>
                </div>
                <div class="booking-details">
                    <div><span>Service</span><strong><%= escapeHtml(booking.get("serviceName")) %></strong></div>
                    <div><span>Visit Date</span><strong><%= dateText %></strong></div>
                    <div><span>Preferred Time</span><strong><%= timeText %></strong></div>
                </div>
                <div class="booking-card-bottom">
                    <p>Booking reference: <%= bookingId %></p>
                    <div>
                        <a href="<%= request.getContextPath() %>/queue-status" class="view-status">View Queue</a>
                        <% if (status.equalsIgnoreCase("Waiting") || status.equalsIgnoreCase("Serving")) { %>
                            <form action="<%= request.getContextPath() %>/cancel-booking" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                                <button type="submit" class="cancel-booking-btn">Cancel Booking</button>
                            </form>
                        <% } else if (status.equalsIgnoreCase("Cancelled")) { %>
                            <span class="completed-note">Booking cancelled</span>
                        <% } else if (status.equalsIgnoreCase("Completed")) { %>
                            <span class="completed-note">Visit completed</span>
                        <% } %>
                    </div>
                </div>
            </article>
            <% } } %>
        </div>
        <p id="emptyBookings" class="empty-bookings" <%= bookings != null && !bookings.isEmpty() ? "hidden" : "" %>>No bookings found in this category.</p>
    </main>
    <footer class="footer">
        <div class="footer-content">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
            <p>Smarter queues, better experiences.</p>
        </div>
        <p class="footer-bottom">© 2026 QueueLess. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/client/my-bookings.js"></script>
</body>
</html>
