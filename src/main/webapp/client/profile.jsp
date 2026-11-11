
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.queueless.model.User" %>
<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect(request.getContextPath() + "/client/login.jsp");
    return;
}
User profileUser = (User) request.getAttribute("profileUser");
if (profileUser == null) {
    response.sendRedirect(request.getContextPath() + "/profile");
    return;
}
String message = (String) session.getAttribute("profileMessage");
String messageType = (String) session.getAttribute("profileMessageType");
session.removeAttribute("profileMessage");
session.removeAttribute("profileMessageType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>My Profile | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/profile.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
        <nav class="nav-links">
         <a href="${pageContext.request.contextPath}/dashboard" class="btn-login">Dashboard</a>
            <a href="${pageContext.request.contextPath}/services">Services</a>
            <a href="${pageContext.request.contextPath}/booking">Book Token</a>
          
   <a href="${pageContext.request.contextPath}/profile" class="btn-login active">My Profile</a>
        </nav>
        <div class="nav-actions">
            
            <a href="${pageContext.request.contextPath}/my-bookings" class="btn-login">My Bookings</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn-primary">Logout</a>
        </div>
    </header>
    <main class="profile-section">
        <div class="profile-heading">
            <span class="eyebrow">YOUR ACCOUNT</span>
            <h1>My Profile</h1>
            <p>Manage your personal information and account details.</p>
        </div>
        <div class="profile-layout">
            <aside class="profile-sidebar">
                <div class="profile-avatar" id="profileAvatar"><%= profileUser.getFullName().substring(0,1).toUpperCase() %></div>
                <h2 id="sidebarName"><%= profileUser.getFullName() %></h2>
                <p id="sidebarEmail"><%= profileUser.getEmail() %></p>
                <div class="profile-menu">
                    <a href="${pageContext.request.contextPath}/profile" class="active">Personal Information</a>
           <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
                    <a href="${pageContext.request.contextPath}/my-bookings">My Bookings</a>
                    <a href="${pageContext.request.contextPath}/queue-status">Queue Status</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </div>
            </aside>
            <section class="profile-form-card">
                <div class="card-heading">
                    <div>
                        <h2>Personal Information</h2>
                        <p>Update your profile details below.</p>
                    </div>
                    <span class="account-badge">Client Account</span>
                </div>
                <% if (message != null) { %>
                    <p class="profile-message"><%= message %></p>
                <% } %>
                <form id="profileForm" action="${pageContext.request.contextPath}/update-profile" method="post">
                    <div class="profile-fields">
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" placeholder="Enter your full name" value="<%= profileUser.getFullName() %>" maxlength="100" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" placeholder="Enter your email" value="<%= profileUser.getEmail() %>" maxlength="150" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" placeholder="10-digit mobile number" pattern="[0-9]{10}" maxlength="10" value="<%= profileUser.getPhone() == null ? "" : profileUser.getPhone() %>" required>
                        </div>
                    </div>
                    <div class="profile-actions">
                        <button type="reset" class="cancel-btn">Reset</button>
                        <button type="submit" class="btn-primary">Save Changes</button>
                    </div>
                </form>
                        
<div class="card-heading">
    <div>
        <h2>Change Password</h2>
        <p>Update your account password securely.</p>
    </div>
</div>
<form action="${pageContext.request.contextPath}/change-password" method="post">
    <div class="profile-fields">
        <div class="form-group">
            <label for="currentPassword">Current Password</label>
            <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter current password" required>
        </div>
        <div class="form-group">
            <label for="newPassword">New Password</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" minlength="8" required>
        </div>
        <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password" minlength="8" required>
        </div>
    </div>
    <div class="profile-actions">
        <button type="reset" class="cancel-btn">Reset</button>
        <button type="submit" class="btn-primary">Change Password</button>
    </div>
</form>

            </section>
        </div>
    </main>
    <footer class="footer">
        <div class="footer-content">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
            <p>Smarter queues, better experiences.</p>
        </div>
        <p class="footer-bottom">© 2026 QueueLess. All rights reserved.</p>
    </footer>
</body>
</html>
