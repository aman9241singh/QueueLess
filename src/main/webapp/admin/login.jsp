
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Admin Login | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/login.css">
</head>
<body class="admin-login-page">
    <a href="${pageContext.request.contextPath}/index.jsp" class="back-home">← Back to Home</a>
    <main class="login-container">
        <div class="login-logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </div>
        <div class="login-card">
            <div class="login-icon">🛡️</div>
            <p class="eyebrow">ADMINISTRATOR PORTAL</p>
            <h1>Welcome Back</h1>
            <p class="subtitle">Sign in to manage your QueueLess system.</p>
            <form id="adminLoginForm" action="${pageContext.request.contextPath}/admin-login" method="POST">
                <div class="form-group">
                    <label for="adminEmail">Admin Email</label>
                    <input type="email" id="adminEmail" name="email" placeholder="Enter admin email" autocomplete="username" required>
                </div>
                <div class="form-group">
                    <label for="adminPassword">Password</label>
                    <div class="password-wrap">
                        <input type="password" id="adminPassword" name="password" placeholder="Enter password" autocomplete="current-password" required>
                        <button type="button" id="togglePassword" aria-label="Show password">Show</button>
                    </div>
                </div>
                <% if ("invalid".equals(request.getParameter("error"))) { %>
                    <p class="form-error" role="alert">Invalid admin email or password.</p>
                <% } else if ("failed".equals(request.getParameter("error"))) { %>
                    <p class="form-error" role="alert">Something went wrong. Please try again.</p>
                <% } %>
                <button type="submit" class="login-submit">Login as Admin</button>
            </form>
        </div>
        <p class="footer-text">© 2026 QueueLess. All rights reserved.</p>
    </main>
    <script src="${pageContext.request.contextPath}/js/admin/login.js"></script>
</body>
</html>
