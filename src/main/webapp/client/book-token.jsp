
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,com.queueless.model.Service" %>
<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect(request.getContextPath() + "/client/login.jsp");
    return;
}
List<Service> activeServices = (List<Service>) request.getAttribute("activeServices");
Integer selectedServiceId = (Integer) request.getAttribute("selectedServiceId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Token | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/book-token.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-login">Dashboard</a>
             <a href="${pageContext.request.contextPath}/booking"  class = "active">Book Token</a>
            <a href="${pageContext.request.contextPath}/services">Services</a>
              
            <a href="${pageContext.request.contextPath}/queue-status">Queue Status</a>
            <a href="${pageContext.request.contextPath}/my-bookings">My Bookings</a>
            
        </nav>
        <div class="nav-actions">
    
            <a href="${pageContext.request.contextPath}/logout" class="btn-login">Logout</a>
        </div>
    </header>
    <main class="booking-section">
        <div class="booking-heading">
            <span class="eyebrow">QUICK AND EASY</span>
            <h1>Book Your Token</h1>
            <p>Choose a service, select your preferred time and get your queue token.</p>
        </div>
        <div class="booking-container">
            <div class="booking-info">
                <h2>Skip the long queues</h2>
                <p>Reserve your token online and plan your visit more conveniently.</p>
                <div class="booking-benefit">
                    <span>01</span>
                    <div>
                        <h3>Choose a service</h3>
                        <p>Select the service you need.</p>
                    </div>
                </div>
                <div class="booking-benefit">
                    <span>02</span>
                    <div>
                        <h3>Select your time</h3>
                        <p>Pick your preferred visit date and time.</p>
                    </div>
                </div>
                <div class="booking-benefit">
                    <span>03</span>
                    <div>
                        <h3>Get your token</h3>
                        <p>Keep your generated token number for reference.</p>
                    </div>
                </div>
            </div>
            <div class="booking-form-card">
                <h2>Booking Details</h2>
                <p class="form-subtitle">Your account information is filled automatically.</p>
                <form id="bookingForm" action="${pageContext.request.contextPath}/book-token" method="post">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" value="<%= session.getAttribute("userName") %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" value="<%= session.getAttribute("userEmail") %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" value="<%= session.getAttribute("userPhone") %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="serviceId">Select Service</label>
                        <select id="serviceId" name="serviceId" required>
                            <option value="">Choose a service</option>
                            <% if (activeServices != null) {
                                for (Service service : activeServices) { %>
                                    <option value="<%= service.getServiceId() %>" <%= selectedServiceId != null && selectedServiceId.intValue() == service.getServiceId() ? "selected" : "" %>><%= service.getServiceName() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="date">Visit Date</label>
                            <input type="date" id="date" name="date" required>
                        </div>
                        <div class="form-group">
                            <label for="time">Preferred Time</label>
                            <select id="time" name="time" required>
                                <option value="">Select time</option>
                                <option value="09:00">09:00 AM</option>
                                <option value="10:00">10:00 AM</option>
                                <option value="11:00">11:00 AM</option>
                                <option value="12:00">12:00 PM</option>
                                <option value="14:00">02:00 PM</option>
                                <option value="15:00">03:00 PM</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary booking-submit">Generate Token</button>
                    <p id="bookingMessage" class="booking-message" role="status" aria-live="polite"></p>
                    <div id="tokenResult" class="token-result" hidden></div>
                    <% if ("invalid".equals(request.getParameter("error"))) { %>
                        <p class="booking-message">Please check your booking details and try again.</p>
                    <% } else if ("failed".equals(request.getParameter("error"))) { %>
                        <p class="booking-message">Unable to create your booking. Please try again.</p>
                    <% } %>
                </form>
            </div>
        </div>
    </main>
    <footer class="footer">
        <div class="footer-content">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
            </a>
            <p>Smarter queues, better experiences.</p>
        </div>
        <p class="footer-bottom">© 2026 QueueLess. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/client/book-token.js"></script>
</body>
</html>
