
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,com.queueless.model.Service" %>
<%!
    public String escapeHtml(Object value) {
        if (value == null) return "";
        return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    public String getServiceIcon(String serviceName) {
        String name = serviceName.toLowerCase();
        if (name.contains("bank")) return "🏦";
        if (name.contains("health")) return "🏥";
        if (name.contains("customer")) return "🎧";
        if (name.contains("government")) return "🏛️";
        if (name.contains("education")) return "🎓";
        if (name.contains("salon")) return "💇";
        if (name.contains("restaurant")) return "🍽️";
        if (name.contains("vehicle")) return "🚗";
        if (name.contains("shopping")) return "🛍️";
        if (name.contains("dental")) return "🦷";
        if (name.contains("pharmacy")) return "💊";
        return "🏢";
    }
%>
<%
    List<Service> activeServices = (List<Service>) request.getAttribute("activeServices");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/services.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-login">Dashboard</a>
            <a href="${pageContext.request.contextPath}/services" class="active">Services</a>
            <a href="${pageContext.request.contextPath}/booking">Book Token</a>
          
        </nav>
       <div class="nav-actions">
    <% if (session.getAttribute("userId") != null) { %>
        
        <a href="${pageContext.request.contextPath}/profile" class="btn-login">My Profile</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-primary">Logout</a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/client/login.jsp" class="btn-login">Login</a>
        <a href="${pageContext.request.contextPath}/client/signup.jsp" class="btn-primary">Get Started</a>
    <% } %>
</div>
    </header>
    <main>
        <section class="services-hero">
            <p class="eyebrow">WHAT WE OFFER</p>
            <h1>Our Services</h1>
            <p class="hero-text">Smart solutions for a faster and hassle-free queue experience.</p>
        </section>
        <section class="services-container">
            <div class="services-grid">
                <article class="service-card">
                    <div class="service-icon">🎫</div>
                    <h2>Online Token Booking</h2>
                    <p>Book your token online before visiting a service center and avoid unnecessary waiting.</p>
                    <a href="${pageContext.request.contextPath}/booking">Book a Token <span>→</span></a>
                </article>
                <article class="service-card">
                    <div class="service-icon">⏱️</div>
                    <h2>Live Queue Tracking</h2>
                    <p>Track your current queue position and estimated waiting time from anywhere.</p>
                    <a href="${pageContext.request.contextPath}/queue-status">Track Queue <span>→</span></a>
                </article>
                <article class="service-card">
                    <div class="service-icon">🔔</div>
                    <h2>Instant Notifications</h2>
                    <p>Stay informed with helpful updates and reminders when your turn is approaching.</p>
                    <a href="${pageContext.request.contextPath}/notifications">View Notifications <span>→</span></a>
                </article>
                <article class="service-card">
                    <div class="service-icon">🏢</div>
                    <h2>Multiple Services</h2>
                    <p>Explore different service categories and choose the one that meets your needs.</p>
                    <a href="#service-categories">Explore Categories <span>→</span></a>
                </article>
                <article class="service-card">
                    <div class="service-icon">📊</div>
                    <h2>Queue Information</h2>
                    <p>View queue status and make informed decisions about when to arrive.</p>
                    <a href="${pageContext.request.contextPath}/queue-status">Check Status <span>→</span></a>
                </article>
                <article class="service-card">
                    <div class="service-icon">👤</div>
                    <h2>Personal Account</h2>
                    <p>Create your account to access booking features and manage your queue activity.</p>
                    <a href="${pageContext.request.contextPath}/client/signup.jsp">Create Account <span>→</span></a>
                </article>
            </div>
        </section>
        <section class="services-container" id="service-categories">
            <div class="services-hero">
                <p class="eyebrow">CHOOSE YOUR CATEGORY</p>
                <h2>Available Service Categories</h2>
                <p class="hero-text">Select a category to start your token booking.</p>
            </div>
            <div class="services-grid">
                <% if (activeServices != null && !activeServices.isEmpty()) {
                    for (Service service : activeServices) {
                %>
                <article class="service-card">
                    <div class="service-icon"><%= getServiceIcon(service.getServiceName()) %></div>
                    <h2><%= escapeHtml(service.getServiceName()) %></h2>
                    <p><%= escapeHtml(service.getDescription()) %></p>
                    <a href="${pageContext.request.contextPath}/booking?serviceId=<%= service.getServiceId() %>">Book a Token <span>→</span></a>
                </article>
                <% }
                } else { %>
                <p>No active services are currently available.</p>
                <% } %>
            </div>
        </section>
        <section class="services-cta">
            <h2>Ready to save your time?</h2>
            <p>Start your smarter queue experience with QueueLess today.</p>
            <a href="${pageContext.request.contextPath}/booking" class="btn-primary">Book Your Token</a>
        </section>
    </main>
    <footer class="footer">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <p>Making waiting simpler, smarter, and faster.</p>
        <p class="copyright">© 2026 QueueLess. All rights reserved.</p>
    </footer>
</body>
</html>
