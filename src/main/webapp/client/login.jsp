
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/login.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="about.jsp">About</a>
            <a href="contact.jsp">Contact</a>
        </nav>
        <div class="nav-actions">
            <a href="login.jsp" class="btn-login active">Login</a>
            <a href="signup.jsp" class="btn-primary">Get Started</a>
        </div>
    </header>
    <main class="auth-page">
        <section class="auth-card">
            <div class="auth-heading">
                <div class="auth-icon">👋</div>
                <h1>Welcome Back</h1>
                <p>Log in to continue your QueueLess experience.</p>
            </div>
            <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
                <label for="loginEmail">Email Address</label>
                <input type="email" id="loginEmail" name="email" placeholder="Enter your email" autocomplete="email" required>
                <label for="loginPassword">Password</label>
                <div class="password-field">
                    <input type="password" id="loginPassword" name="password" placeholder="Enter your password" autocomplete="current-password" required minlength="8">
                    <button type="button" id="togglePassword" aria-label="Show password">Show</button>
                </div>
                <div class="auth-options">
                    <label class="remember-option">
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="#" id="forgotPassword">Forgot password?</a>
                </div>
                <button type="submit" class="btn-primary auth-submit">Login to Account</button>
                <p id="loginFeedback" aria-live="polite">
                    <% if ("invalid".equals(request.getParameter("error"))) { %>
                        Invalid email or password. Please try again.
                    <% } else if ("failed".equals(request.getParameter("error"))) { %>
                        Something went wrong. Please try again later.
                    <% } else if ("registered".equals(request.getParameter("success"))) { %>
                        Account created successfully. Please log in.
                    <% } %>
                </p>
            </form>
            <div class="auth-switch">Don't have an account? <a href="signup.jsp">Create an account</a></div>
            <div class="auth-security">🔒 Your information should always be kept secure.</div>
        </section>
    </main>
    <footer class="footer">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <p>Making waiting simpler, smarter, and faster.</p>
        <p class="copyright">© 2026 QueueLess. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/client/login.js"></script>
</body>
</html>
