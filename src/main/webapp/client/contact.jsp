
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/client/contact.css">
</head>
<body>
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="about.jsp">About</a>
            <a href="contact.jsp" class="active">Contact</a>
        </nav>
        <div class="nav-actions">
            <a href="login.jsp" class="btn-login">Login</a>
            <a href="signup.jsp" class="btn-primary">Get Started</a>
        </div>
    </header>
    <main>
        <section class="contact-hero">
            <p class="contact-eyebrow">WE ARE HERE TO HELP</p>
            <h1>Let's Talk</h1>
            <p>Have a question or need help? Send us a message and let us know how we can help.</p>
        </section>
        <section class="contact-layout">
            <div class="contact-details">
                <h2>Get in touch</h2>
                <p class="contact-description">We would love to hear from you. Fill out the form and our team will get back to you.</p>
                <div class="contact-item">
                    <div class="contact-icon">✉</div>
                    <div>
                        <h3>Email Us</h3>
                        <p>support@queueless.example</p>
                    </div>
                </div>
                <div class="contact-item">
                    <div class="contact-icon">⏰</div>
                    <div>
                        <h3>Support Hours</h3>
                        <p>Monday – Friday</p>
                        <p>9:00 AM – 5:00 PM</p>
                    </div>
                </div>
                <div class="contact-item">
                    <div class="contact-icon">💬</div>
                    <div>
                        <h3>Quick Support</h3>
                        <p>Use the contact form to describe your question or issue.</p>
                    </div>
                </div>
                <div class="contact-note">
                    <strong>We're listening.</strong>
                    <p>Your feedback helps us improve the QueueLess experience.</p>
                </div>
            </div>
            <div class="contact-form-card">
                <h2>Send us a message</h2>
                <form id="contactForm" action="${pageContext.request.contextPath}/contact-submit" method="post">
                    <label for="contactName">Full Name</label>
                    <input type="text" id="contactName" name="name" placeholder="Enter your full name" required>
                    <label for="contactEmail">Email Address</label>
                    <input type="email" id="contactEmail" name="email" placeholder="Enter your email address" required>
                    <label for="contactSubject">Subject</label>
                    <select id="contactSubject" name="subject" required>
                        <option value="">Select a subject</option>
                        <option value="General Inquiry">General Inquiry</option>
                        <option value="Booking Support">Booking Support</option>
                        <option value="Queue Status">Queue Status</option>
                        <option value="Feedback">Feedback</option>
                        <option value="Other">Other</option>
                    </select>
                    <label for="contactMessage">Your Message</label>
                    <textarea id="contactMessage" name="message" rows="5" placeholder="How can we help you?" required></textarea>
                    <button type="submit" class="btn-primary contact-submit">Send Message</button>
              <p id="contactFeedback" aria-live="polite">${contactFeedback != null ? contactFeedback : ""}</p>
                </form>
            </div>
        </section>
    </main>
    <footer class="footer">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
        </a>
        <p>Making waiting simpler, smarter, and faster.</p>
        <p class="copyright">© 2026 QueueLess. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/client/contact.js"></script>
</body>
</html>
