
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QueueLess | Smart Queue Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/client/about.jsp">About</a>
            <a href="${pageContext.request.contextPath}/client/contact.jsp">Contact</a>
        </nav>
        <div class="nav-actions">
            <button type="button" class="btn-login" id="loginChoiceBtn">Login</button>
            <a href="${pageContext.request.contextPath}/client/signup.jsp" class="btn-primary">Get Started</a>
        </div>
    </header>
    <div class="login-modal" id="loginModal" aria-hidden="true">
        <div class="login-modal-backdrop" id="loginBackdrop"></div>
        <div class="login-modal-box" role="dialog" aria-modal="true" aria-labelledby="loginModalTitle">
            <button type="button" class="login-modal-close" id="closeLoginModal" aria-label="Close">&times;</button>
            <div class="login-modal-icon">🔐</div>
            <h2 id="loginModalTitle">Welcome to QueueLess</h2>
            <p>Choose how you want to log in.</p>
            <a href="${pageContext.request.contextPath}/client/login.jsp" class="login-option">
                <span class="login-option-icon">👤</span>
                <span><strong>Login as User</strong><small>Book tokens and track your queue</small></span>
                <span class="login-option-arrow">→</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/login.jsp" class="login-option">
                <span class="login-option-icon">🛡️</span>
                <span><strong>Login as Admin</strong><small>Manage services and queues</small></span>
                <span class="login-option-arrow">→</span>
            </a>
        </div>
    </div>
    <main>
        <section class="hero">
            <div class="hero-content">
                <p class="hero-tag">SMARTER QUEUES, BETTER EXPERIENCES</p>
                <h1>Skip the Line.<br><span>Save Your Time.</span></h1>
                <p class="hero-description">Book your token online, track your queue in real time, and enjoy a hassle-free service experience with QueueLess.</p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/client/book-token.jsp" class="btn-primary">Book a Token</a>
                    <a href="${pageContext.request.contextPath}/queue-status" class="btn-secondary">Track my Queue</a>
                </div>
                <div class="hero-stats">
                    <div><h3>24/7</h3><p>Easy Access</p></div>
                    <div><h3>Real-Time</h3><p>Queue Updates</p></div>
                    <div><h3>Less Wait</h3><p>More Convenience</p></div>
                </div>
            </div>
            <div class="hero-visual">
                <div class="queue-card">
                    <p class="card-label">YOUR QUEUE STATUS</p>
                    <h2>Token #024</h2>
                    <div class="queue-status"><span class="status-dot"></span>You're in the queue</div>
                    <div class="queue-divider"></div>
                    <div class="queue-info">
                        <div><p>People Ahead</p><h3>03</h3></div>
                        <div><p>Estimated Wait</p><h3>12 min</h3></div>
                    </div>
               <a href="${pageContext.request.contextPath}/queue-status" class="card-link">View Queue Status →</a>
                </div>
            </div>
        </section>
        <section class="services-preview">
            <div class="section-heading">
                <p>OUR SERVICES</p>
                <h2>Queue management made simple</h2>
                <span>A smarter way to manage waiting lines and save valuable time.</span>
            </div>
            <div class="service-grid">
                <article class="service-card"><div class="service-icon">🎫</div><h3>Online Token Booking</h3><p>Book your token before reaching the service location.</p></article>
                <article class="service-card"><div class="service-icon">⏱️</div><h3>Live Queue Tracking</h3><p>Check your queue position and estimated waiting time.</p></article>
                <article class="service-card"><div class="service-icon">🔔</div><h3>Instant Notifications</h3><p>Stay updated when your turn is getting closer.</p></article>
            </div>
            <div class="services-action">            <a href="${pageContext.request.contextPath}/services" class="btn-primary">Explore Our Services</a></div>
        </section>
        <section class="cta-section">
            <h2>Your time matters. Make every minute count.</h2>
            <p>Start using QueueLess for a smoother queue experience.</p>
            <a href="${pageContext.request.contextPath}/client/signup.jsp" class="btn-primary">Join QueueLess</a>
        </section>
    </main>
    <footer class="footer">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
        <p>Making waiting simpler, smarter, and faster.</p>
        <p class="copyright">© 2026 QueueLess. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
