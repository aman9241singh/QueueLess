
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/about.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <nav class="nav-links">
                   
           <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="about.jsp" class="active">About</a>
            <a href="contact.jsp">Contact</a>
        </nav>
        <div class="nav-actions">
            <a href="login.jsp" class="btn-login">Login</a>
            <a href="signup.jsp" class="btn-primary">Get Started</a>
        </div>
    </header>
    <main>
        <section class="about-hero">
            <p class="about-eyebrow">GET TO KNOW US</p>
            <h1>Making Waiting <span>Worth Less.</span></h1>
            <p>QueueLess helps people manage their time better with a smarter and simpler way to join and track queues.</p>
            <a href="${pageContext.request.contextPath}/services" class="btn-primary">Explore Our Services</a>
        </section>
        <section class="about-intro">
            <div class="about-symbol">Q</div>
            <div class="about-intro-content">
                <p class="about-eyebrow">WHO WE ARE</p>
                <h2>A smarter approach to queue management</h2>
                <p>QueueLess is a queue management platform concept designed to make service experiences more convenient. Instead of spending unnecessary time waiting in physical lines, users can explore services, book tokens and check queue information through a single platform.</p>
                <p>Our goal is to make everyday service interactions easier for users and more organized for service providers.</p>
            </div>
        </section>
        <section class="mission-section">
            <article class="mission-card">
                <div class="mission-icon">🎯</div>
                <h2>Our Mission</h2>
                <p>To reduce unnecessary waiting and make queue management simple, accessible and convenient for everyone.</p>
            </article>
            <article class="mission-card">
                <div class="mission-icon">🔭</div>
                <h2>Our Vision</h2>
                <p>To build a smarter service experience where people can manage their time with greater confidence and less stress.</p>
            </article>
        </section>
        <section class="values-section">
            <div class="values-heading">
                <p class="about-eyebrow">WHAT MATTERS TO US</p>
                <h2>Built around your time</h2>
            </div>
            <div class="values-grid">
                <article class="value-card">
                    <span>01</span>
                    <h3>Convenience</h3>
                    <p>Access queue information without unnecessary steps.</p>
                </article>
                <article class="value-card">
                    <span>02</span>
                    <h3>Transparency</h3>
                    <p>Understand your queue position and expected wait.</p>
                </article>
                <article class="value-card">
                    <span>03</span>
                    <h3>Efficiency</h3>
                    <p>Plan your visit and make better use of your time.</p>
                </article>
            </div>
        </section>
        <section class="about-cta">
            <h2>Your time deserves a smarter experience.</h2>
            <p>Take the first step toward easier queue management.</p>
            <a href="signup.jsp" class="btn-primary">Get Started</a>
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
