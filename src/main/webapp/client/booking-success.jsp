
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/client/login.jsp");
        return;
    }
    String tokenNumber = (String) request.getAttribute("tokenNumber");
    String serviceName = (String) request.getAttribute("serviceName");
    String visitDate = (String) request.getAttribute("visitDate");
    String preferredTime = (String) request.getAttribute("preferredTime");
    String queuePosition = String.valueOf(request.getAttribute("queuePosition"));
    String estimatedWait = String.valueOf(request.getAttribute("estimatedWait"));
    if (tokenNumber == null) {
        response.sendRedirect(request.getContextPath() + "/booking");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Successful | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/booking-success.css">
</head>
<body>
    <main class="success-container">
        <div class="success-icon">✓</div>
        <h1>Booking Successful!</h1>
        <p>Your queue token has been generated successfully.</p>
        <div class="token-card">
            <h2>Your Token Number</h2>
            <div class="token-number"><%= tokenNumber %></div>
            <div class="booking-details">
                <div><span>Service</span><strong><%= serviceName %></strong></div>
                <div><span>Visit Date</span><strong><%= visitDate %></strong></div>
                <div><span>Preferred Time</span><strong><%= preferredTime %></strong></div>
                <div><span>Queue Position</span><strong><%= queuePosition %></strong></div>
                <div><span>Estimated Wait</span><strong><%= estimatedWait %> minutes</strong></div>
            </div>
        </div>
        <p class="notice">Please arrive at the selected service counter on your scheduled date and time.</p>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/dashboard">Go to Dashboard</a>
            <a href="${pageContext.request.contextPath}/booking">Book Another Token</a>
        </div>
    </main>
</body>
</html>
