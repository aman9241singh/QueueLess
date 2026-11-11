
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/signup.css">
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
            <a href="login.jsp" class="btn-login">Login</a>
            <a href="signup.jsp" class="btn-primary">Get Started</a>
        </div>
    </header>
    <main class="auth-page">
        <section class="auth-card">
            <div class="auth-heading">
                <div class="auth-icon">✨</div>
                <h1>Create Account</h1>
                <p>Join QueueLess and make waiting easier.</p>
            </div>
            <form id="signupForm" action="${pageContext.request.contextPath}/signup" method="post">
                <label for="signupName">Full Name</label>
                <input type="text" id="signupName" name="fullName" placeholder="Enter your full name" autocomplete="name" required minlength="2">
                <label for="signupEmail">Email Address</label>
                <input type="email" id="signupEmail" name="email" placeholder="Enter your email" autocomplete="email" required>
                <label for="signupPhone">Phone Number</label>
                <input type="tel" id="signupPhone" name="phone" placeholder="Enter your phone number" autocomplete="tel" pattern="[0-9]{10}" maxlength="10" required>
                <label for="signupPassword">Password</label>
                <input type="password" id="signupPassword" name="password" placeholder="Create a password" autocomplete="new-password" minlength="8" required>
                <p class="field-hint">Use at least 8 characters.</p>
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter your password" autocomplete="new-password" minlength="8" required>
                <label class="terms-option">
                    <input type="checkbox" id="acceptTerms" name="acceptTerms" value="yes" required>
                    I agree to the terms and privacy policy.
                </label>
                <button type="submit" class="btn-primary auth-submit">Create My Account</button>
                <p id="signupFeedback" aria-live="polite">
                    <%
                        String error = request.getParameter("error");
                        String registered = request.getParameter("registered");
                        if ("1".equals(registered)) {
                    %>
                        Account created successfully! Please log in.
                    <% } else if ("invalid".equals(error)) { %>
                        Please check your details and try again.
                    <% } else if ("duplicate".equals(error)) { %>
                        Email or phone number already exists.
                    <% } else if ("failed".equals(error)) { %>
                        Registration failed. Please try again.
                    <% } %>
                </p>
            </form>
            <div class="auth-switch">Already have an account? <a href="login.jsp">Login here</a></div>
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
    <script src="${pageContext.request.contextPath}/js/client/signup.js"></script>
</body>
</html>
