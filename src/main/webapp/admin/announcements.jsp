
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.text.SimpleDateFormat" %>
<%!
private String escapeHtml(Object value) {
    if (value == null) return "";
    return String.valueOf(value).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
}
%>
<%
List<Map<String,Object>> announcements = (List<Map<String,Object>>) request.getAttribute("announcements");
int total = announcements == null ? 0 : announcements.size();
int published = 0;
int drafts = 0;
if (announcements != null) {
    for (Map<String,Object> item : announcements) {
        if ("Published".equals(item.get("status"))) published++;
        else if ("Draft".equals(item.get("status"))) drafts++;
    }
}
SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Announcements | QueueLess</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/announcements.css">
</head>
<body>
<div class="admin-layout">
<aside class="admin-sidebar">
<a href="${pageContext.request.contextPath}/index.jsp" class="admin-logo">
<img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
</a>
<div class="admin-info">
<div class="admin-avatar">A</div>
<div><h3>Administrator</h3><p>System Admin</p></div>
</div>
<nav class="admin-nav">
<a href="dashboard.jsp">▦ Dashboard</a>
<a href="${pageContext.request.contextPath}/admin/services">▤ Manage Services</a>
<a href="${pageContext.request.contextPath}/admin/live-queue">☷ Live Queue</a>
<a href="users.jsp">♙ Users</a>
<a href="analytics.jsp">▥ Analytics &amp; Reports</a>
<a href="${pageContext.request.contextPath}/admin/announcements" class = "active">◉ Announcements</a>
<a href="settings.jsp">⚙ Settings</a>
<a href="${pageContext.request.contextPath}/admin/profile">♙ Admin Profile</a>
<a href="${pageContext.request.contextPath}/admin/contact-messages">✉ Contact Messages</a>
</nav>
<a href="${pageContext.request.contextPath}/index.jsp" class="admin-logout">← Back to Website</a>
</aside>
<main class="admin-main">
<header class="admin-header">
<div>
<p class="eyebrow">COMMUNICATION CENTER</p>
<h1>Announcements</h1>
<p class="header-subtitle">Create and manage updates for QueueLess customers.</p>
</div>
<div class="system-status"><span></span> System Online</div>
</header>
<section class="announcement-stats">
<div class="announcement-stat"><span>Total Announcements</span><h2><%= total %></h2></div>
<div class="announcement-stat"><span>Published</span><h2><%= published %></h2></div>
<div class="announcement-stat"><span>Drafts</span><h2><%= drafts %></h2></div>
</section>
<section class="announcement-editor" id="editorPanel">
<div class="editor-heading">
<div><h2 id="editorTitle">Create Announcement</h2><p>Share an important update with your customers.</p></div>
<button type="button" class="secondary-btn" id="toggleEditorBtn">Hide Form</button>
</div>
<form id="announcementForm" method="post" action="${pageContext.request.contextPath}/admin/announcement-action">
<input type="hidden" name="action" value="create" id="formAction">
<input type="hidden" name="announcementId" id="announcementId">
<div class="editor-grid">
<div class="form-group">
<label for="announcementTitle">Announcement Title</label>
<input id="announcementTitle" name="title" type="text" maxlength="150" placeholder="Enter a clear title" required>
</div>
<div class="form-group">
<label for="announcementStatus">Status</label>
<select id="announcementStatus" name="status" required>
<option value="Published">Publish Now</option>
<option value="Draft">Save as Draft</option>
</select>
</div>
<div class="form-group editor-full">
<label for="announcementMessage">Message</label>
<textarea id="announcementMessage" name="message" rows="4" maxlength="1000" placeholder="Write your announcement..." required></textarea>
<small id="messageCount">0 / 1000 characters</small>
</div>
</div>
<div class="editor-actions">
<button type="submit" class="primary-btn" id="publishBtn">Save Announcement</button>
<button type="button" class="secondary-btn" id="clearFormBtn">Clear</button>
</div>
</form>
</section>
<section class="announcements-panel">
<div class="editor-heading">
<div><h2>All Announcements</h2><p>Review, edit and update announcement status.</p></div>
<span class="announcement-count"><%= total %> announcements</span>
</div>
<div class="announcement-toolbar">
<input type="search" id="announcementSearch" placeholder="Search announcements...">
<select id="announcementStatusFilter">
<option value="all">All Statuses</option>
<option value="Published">Published</option>
<option value="Draft">Draft</option>
</select>
</div>
<div class="announcement-list" id="announcementList">
<% if (announcements != null && !announcements.isEmpty()) {
for (Map<String,Object> item : announcements) { %>
<div class="announcement-card" data-status="<%= escapeHtml(item.get("status")) %>">
<div class="announcement-card-content">
<h3><%= escapeHtml(item.get("title")) %></h3>
<p><%= escapeHtml(item.get("message")) %></p>
<span class="announcement-status"><%= escapeHtml(item.get("status")) %></span>
<small><%= item.get("createdAt") == null ? "" : dateFormat.format(item.get("createdAt")) %></small>
</div>
<div class="announcement-actions">
<button type="button" class="secondary-btn edit-announcement"
data-id="<%= item.get("announcementId") %>"
data-title="<%= escapeHtml(item.get("title")) %>"
data-message="<%= escapeHtml(item.get("message")) %>"
data-status="<%= escapeHtml(item.get("status")) %>">Edit</button>
<form method="post" action="${pageContext.request.contextPath}/admin/announcement-action">
<input type="hidden" name="announcementId" value="<%= item.get("announcementId") %>">
<input type="hidden" name="action" value="delete">
<button type="submit" class="secondary-btn" onclick="return confirm('Delete this announcement permanently?')">Delete</button>
</form>
</div>
</div>
<% } } else { %>
<p class="empty-announcements">No announcements found.</p>
<% } %>
</div>
<p id="emptyAnnouncements" class="empty-announcements" hidden>No announcements found.</p>
</section>
<footer class="admin-footer">© 2026 QueueLess. Smart queues, better experiences.</footer>
</main>
</div>
<script src="${pageContext.request.contextPath}/js/admin/announcements.js"></script>
</body>
</html>
