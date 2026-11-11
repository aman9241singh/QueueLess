
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.text.SimpleDateFormat" %>
<%!
    private String escapeHtml(Object value) {
        if (value == null) return "";
        return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
    List<Map<String,Object>> messages = (List<Map<String,Object>>) request.getAttribute("contactMessages");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Contact Messages | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
    <style>
        .messages-panel{background:#fff;padding:25px;border-radius:14px;box-shadow:0 4px 18px rgba(0,0,0,.05);margin-top:25px}
        .messages-panel h2{margin-bottom:8px}
        .messages-table{width:100%;border-collapse:collapse;min-width:850px}
        .messages-table th,.messages-table td{padding:15px;text-align:left;border-bottom:1px solid #e8eaf0;font-size:14px}
        .messages-table th{background:#f7f8fc;color:#555;font-weight:600}
        .message-text{max-width:260px;white-space:normal;overflow-wrap:anywhere}
        .message-status{display:inline-block;padding:6px 12px;border-radius:20px;background:#fff3cd;color:#856404;font-size:12px;font-weight:600}
        .message-empty{text-align:center;padding:35px;color:#777}
        @media(max-width:700px){.messages-panel{padding:15px}.messages-table th,.messages-table td{padding:10px}}
    </style>
</head>
<body>
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
            <div class="admin-info">
                <div class="admin-avatar">A</div>
                <div>
                    <h3><%= escapeHtml(session.getAttribute("adminName")) %></h3>
                    <p>System Admin</p>
                </div>
            </div>
            <nav class="admin-nav">
                <a href="dashboard.jsp">▦ Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/services">▤ Manage Services</a>
                <a href="${pageContext.request.contextPath}/admin/live-queue">☷ Live Queue</a>
                <a href="users.jsp">♙ Users</a>
                <a href="analytics.jsp">▥ Analytics & Reports</a>
                <a href="${pageContext.request.contextPath}/admin/announcements">◉ Announcements</a>
                <a href="${pageContext.request.contextPath}/admin/contact-messages" class="active">✉ Contact Messages</a>
                <a href="settings.jsp">⚙ Settings</a>
                <a href="${pageContext.request.contextPath}/admin/profile">♙ Admin Profile</a>
            </nav>
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logout">← Back to Website</a>
        </aside>
        <main class="admin-main">
            <header class="admin-header">
                <div>
                    <p class="eyebrow">ADMINISTRATION</p>
                    <h1>Contact Messages</h1>
                    <p class="header-subtitle">View and manage messages submitted by customers.</p>
                </div>
                <div class="system-status"><span></span> System Online</div>
            </header>
            <section class="messages-panel">
                <h2>Customer Messages</h2>
                <p>All messages submitted through the QueueLess contact form.</p>
                <div class="table-scroll">
                    <table class="messages-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Customer</th>
                                <th>Email</th>
                                <th>Subject</th>
                                <th>Message</th>
                                <th>Status</th>
                                <th>Submitted At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (messages != null && !messages.isEmpty()) {
                                for (Map<String,Object> item : messages) { %>
                                <tr>
                                    <td><%= item.get("messageId") %></td>
                                    <td><%= escapeHtml(item.get("fullName")) %></td>
                                    <td><%= escapeHtml(item.get("email")) %></td>
                                    <td><%= escapeHtml(item.get("subject")) %></td>
                                    <td class="message-text"><%= escapeHtml(item.get("message")) %></td>
                                    <td><span class="message-status"><%= escapeHtml(item.get("status")) %></span></td>
                                    <td><%= item.get("createdAt") == null ? "" : dateFormat.format(item.get("createdAt")) %></td>
                                    <td>
                                        <% if ("New".equals(item.get("status"))) { %>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/contact-message-action">
                                            <input type="hidden" name="messageId" value="<%= item.get("messageId") %>">
                                            <input type="hidden" name="action" value="read">
                                            <button type="submit">Mark Read</button>
                                        </form>
                                        <% } %>
                                        <% if (!"Resolved".equals(item.get("status"))) { %>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/contact-message-action">
                                            <input type="hidden" name="messageId" value="<%= item.get("messageId") %>">
                                            <input type="hidden" name="action" value="resolve">
                                            <button type="submit">Resolve</button>
                                        </form>
                                        <% } %>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/contact-message-action" onsubmit="return confirm('Are you sure you want to delete this message?')">
                                            <input type="hidden" name="messageId" value="<%= item.get("messageId") %>">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="8" class="message-empty">No contact messages found.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </section>
            <footer class="admin-footer">© 2026 QueueLess. Smart queues, better experiences.</footer>
        </main>
    </div>
</body>
</html>
