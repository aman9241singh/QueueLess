
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
java.util.Map<String, String> settings = (java.util.Map<String, String>) request.getAttribute("settings");
if (settings == null) settings = new java.util.HashMap<>();
String systemName = settings.getOrDefault("systemName", "QueueLess");
String adminEmail = settings.getOrDefault("adminEmail", "admin@queueless.com");
String timezone = settings.getOrDefault("timezone", "Asia/Kolkata");
String language = settings.getOrDefault("language", "English");
String tokenPrefix = settings.getOrDefault("tokenPrefix", "QL-");
String waitTime = settings.getOrDefault("waitTime", "15");
String maxTokens = settings.getOrDefault("maxTokens", "100");
String tokenExpiry = settings.getOrDefault("tokenExpiry", "60");
boolean emailNotifications = !"false".equalsIgnoreCase(settings.getOrDefault("emailNotifications", "true"));
boolean queueAlerts = !"false".equalsIgnoreCase(settings.getOrDefault("queueAlerts", "true"));
boolean userAlerts = "true".equalsIgnoreCase(settings.getOrDefault("userAlerts", "false"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Settings | QueueLess Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/settings.css">
</head>
<body>
<div class="admin-layout">
<aside class="admin-sidebar">
<a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="admin-brand"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"><span>QueueLess</span></a>
<nav class="admin-nav">
<a href="dashboard.jsp">Dashboard</a>
   <a href="${pageContext.request.contextPath}/admin/services">▤ Manage Services</a>
<a href="${pageContext.request.contextPath}/admin/live-queue">☷ Live Queue</a>
<a href="users.jsp">♙ Users</a>
<a href="analytics.jsp">▥ Analytics & Reports</a>
<a href="${pageContext.request.contextPath}/admin/announcements">◉ Announcements</a>
<a href="${pageContext.request.contextPath}/admin/settings" class="active">Settings</a>
<a href="${pageContext.request.contextPath}/admin/profile">♙ Admin Profile</a>
</nav>
<a href="${pageContext.request.contextPath}/index.jsp" class="back-link">← Back to Website</a>
</aside>
<main class="settings-main">
<header class="settings-header">
<div>
<p class="eyebrow">ADMINISTRATION</p>
<h1>System Settings</h1>
<p>Configure your QueueLess experience.</p>
</div>
<div class="admin-avatar">A</div>
</header>
<% if ("1".equals(request.getParameter("success"))) { %>
<div class="success-message">Settings saved successfully!</div>
<% } %>
<form id="settingsForm" method="post" action="${pageContext.request.contextPath}/admin/settings">
<section class="settings-card">
<div class="section-heading">
<div>
<h2>General Preferences</h2>
<p>Configure basic system information.</p>
</div><span class="section-icon">⚙</span>
</div>
<div class="settings-grid">
<div class="form-group"><label for="systemName">System Name</label><input id="systemName" name="systemName" type="text" value="<%= systemName %>" required></div>
<div class="form-group"><label for="adminEmail">Admin Email</label><input id="adminEmail" name="adminEmail" type="email" value="<%= adminEmail %>" required></div>
<div class="form-group"><label for="timezone">Time Zone</label><select id="timezone" name="timezone">
<option value="Asia/Kolkata" <%= "Asia/Kolkata".equals(timezone) ? "selected" : "" %>>India Standard Time (IST)</option>
<option value="UTC" <%= "UTC".equals(timezone) ? "selected" : "" %>>UTC</option>
<option value="Europe/London" <%= "Europe/London".equals(timezone) ? "selected" : "" %>>London</option>
<option value="America/New_York" <%= "America/New_York".equals(timezone) ? "selected" : "" %>>New York</option>
</select></div>
<div class="form-group"><label for="language">Language</label><select id="language" name="language">
<option value="English" <%= "English".equals(language) ? "selected" : "" %>>English</option>
<option value="Hindi" <%= "Hindi".equals(language) ? "selected" : "" %>>Hindi</option>
</select></div>
</div>
</section>
<section class="settings-card">
<div class="section-heading">
<div>
<h2>Queue Configuration</h2>
<p>Set default token and waiting-time preferences.</p>
</div><span class="section-icon">▤</span>
</div>
<div class="settings-grid">
<div class="form-group"><label for="tokenPrefix">Token Prefix</label><input id="tokenPrefix" name="tokenPrefix" type="text" value="<%= tokenPrefix %>" maxlength="5" required></div>
<div class="form-group"><label for="waitTime">Default Waiting Time (minutes)</label><input id="waitTime" name="waitTime" type="number" value="<%= waitTime %>" min="1" max="240" required></div>
<div class="form-group"><label for="maxTokens">Maximum Tokens per Service</label><input id="maxTokens" name="maxTokens" type="number" value="<%= maxTokens %>" min="1" max="1000" required></div>
<div class="form-group"><label for="tokenExpiry">Token Expiry</label><select id="tokenExpiry" name="tokenExpiry">
<option value="30" <%= "30".equals(tokenExpiry) ? "selected" : "" %>>30 minutes</option>
<option value="60" <%= "60".equals(tokenExpiry) ? "selected" : "" %>>1 hour</option>
<option value="120" <%= "120".equals(tokenExpiry) ? "selected" : "" %>>2 hours</option>
<option value="240" <%= "240".equals(tokenExpiry) ? "selected" : "" %>>4 hours</option>
</select></div>
</div>
</section>
<section class="settings-card">
<div class="section-heading">
<div>
<h2>Notifications</h2>
<p>Choose which alerts administrators receive.</p>
</div><span class="section-icon">♧</span>
</div>
<div class="setting-row">
<div><h3>Email Notifications</h3><p>Receive important updates by email.</p></div>
<label class="switch"><input id="emailNotifications" name="emailNotifications" type="checkbox" <%= emailNotifications ? "checked" : "" %>><span></span></label>
</div>
<div class="setting-row">
<div><h3>Queue Alerts</h3><p>Get notified when the queue becomes busy.</p></div>
<label class="switch"><input id="queueAlerts" name="queueAlerts" type="checkbox" <%= queueAlerts ? "checked" : "" %>><span></span></label>
</div>
<div class="setting-row">
<div><h3>New User Alerts</h3><p>Receive alerts when a new user registers.</p></div>
<label class="switch"><input id="userAlerts" name="userAlerts" type="checkbox" <%= userAlerts ? "checked" : "" %>><span></span></label>
</div>
</section>
<div class="form-actions"><button type="button" id="resetSettings" class="btn-secondary">Reset Changes</button><button type="submit" class="btn-primary">Save Settings</button></div>
</form>
<div id="settingsToast" class="toast" role="status" aria-live="polite"></div>
</main>
</div>
<script src="${pageContext.request.contextPath}/js/admin/settings.js"></script>
</body>
</html>
