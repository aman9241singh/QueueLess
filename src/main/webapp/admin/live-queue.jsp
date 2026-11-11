
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map,java.util.HashSet,java.util.Set,java.text.SimpleDateFormat" %>
<%!
public String escapeHtml(Object value) {
    if (value == null) return "";
    return value.toString().replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
}
%>
<%
if (session.getAttribute("adminId") == null) {
    response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
    return;
}
List<Map<String,Object>> queueTokens = (List<Map<String,Object>>) request.getAttribute("queueTokens");
if (queueTokens == null) queueTokens = new java.util.ArrayList<>();
int waiting = 0;
int serving = 0;
int completed = 0;
Set<String> services = new HashSet<>();
SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
for (Map<String,Object> token : queueTokens) {
    String status = String.valueOf(token.get("queueStatus"));
    if (status.equalsIgnoreCase("Waiting")) waiting++;
    else if (status.equalsIgnoreCase("Serving")) serving++;
    else if (status.equalsIgnoreCase("Completed")) completed++;
    services.add(String.valueOf(token.get("serviceName")));
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Live Queue | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/live-queue.css">
</head>
<body data-context-path="${pageContext.request.contextPath}">
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logo">
                <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
            </a>
            <div class="admin-info">
                <div class="admin-avatar">A</div>
                <div>
                    <h3><%= escapeHtml(session.getAttribute("adminName") == null ? "Administrator" : session.getAttribute("adminName")) %></h3>
                    <p>System Admin</p>
                </div>
            </div>
            <nav class="admin-nav">
                <a href="${pageContext.request.contextPath}/admin/dashboard">▦ Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/services">▤ Manage Services</a>
                <a href="${pageContext.request.contextPath}/admin/live-queue" class="active">☷ Live Queue</a>
                <a href="${pageContext.request.contextPath}/admin/users.jsp">♙ Users</a>
                <a href="${pageContext.request.contextPath}/admin/analytics.jsp">▥ Analytics &amp; Reports</a>
                 <a href="${pageContext.request.contextPath}/admin/announcements">◉ Announcements</a>
                <a href="${pageContext.request.contextPath}/admin/settings.jsp">⚙ Settings</a>
               <a href="${pageContext.request.contextPath}/admin/profile">♙ Admin Profile</a>
            </nav>
            <a href="${pageContext.request.contextPath}/admin-logout" class="admin-logout">← Logout</a>
        </aside>
        <main class="admin-main">
            <header class="admin-header">
                <div>
                    <p class="eyebrow">QUEUE MANAGEMENT</p>
                    <h1>Live Queue</h1>
                    <p class="header-subtitle">Monitor waiting tokens and manage service counters.</p>
                </div>
                <div class="system-status"><span></span> System Online</div>
            </header>
            <section class="queue-summary">
                <div class="queue-stat">
                    <span>Waiting Tokens</span>
                    <h2 id="waitingCount"><%= waiting %></h2>
                    <p>Customers waiting</p>
                </div>
                <div class="queue-stat">
                    <span>Currently Serving</span>
                    <h2 id="servingCount"><%= serving %></h2>
                    <p>Tokens being served</p>
                </div>
                <div class="queue-stat">
                    <span>Completed Today</span>
                    <h2 id="completedCount"><%= completed %></h2>
                    <p>Completed tokens shown</p>
                </div>
                <div class="queue-stat">
                    <span>Paused Services</span>
                    <h2 id="pausedCount">0</h2>
                    <p>Services on hold</p>
                </div>
            </section>
            <section class="queue-panel">
                <div class="queue-heading">
                    <div>
                        <h2>Queue Tokens</h2>
                        <p>View and update the status of each token.</p>
                    </div>
                    <button type="button" id="refreshQueueBtn" class="secondary-btn">Refresh Queue</button>
                </div>
                <div class="queue-toolbar">
                    <input type="search" id="queueSearch" placeholder="Search token or customer...">
                    <select id="serviceFilter">
                        <option value="all">All Services</option>
                        <% for (String service : services) { %>
                            <option value="<%= escapeHtml(service) %>"><%= escapeHtml(service) %></option>
                        <% } %>
                    </select>
                    <select id="queueStatusFilter">
                        <option value="all">All Statuses</option>
                        <option value="Waiting">Waiting</option>
                        <option value="Serving">Serving</option>
                        <option value="Completed">Completed</option>
                    </select>
                </div>
                <div class="table-scroll">
                    <table>
                        <thead>
                            <tr>
                                <th>Token</th>
                                <th>Customer</th>
                                <th>Service</th>
                                <th>Visit Date &amp; Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="queueTable">
                            <% for (Map<String,Object> token : queueTokens) {
                                String status = String.valueOf(token.get("queueStatus"));
                                Object visitDate = token.get("visitDate");
                                Object preferredTime = token.get("preferredTime");
                            %>
                                <tr data-queue-id="<%= token.get("queueId") %>" data-token="<%= escapeHtml(token.get("tokenNumber")) %>" data-customer="<%= escapeHtml(token.get("customerName")) %>" data-service="<%= escapeHtml(token.get("serviceName")) %>" data-status="<%= escapeHtml(status) %>">
                                    <td><%= escapeHtml(token.get("tokenNumber")) %></td>
                                    <td><%= escapeHtml(token.get("customerName")) %></td>
                                    <td><%= escapeHtml(token.get("serviceName")) %></td>
                                    <td><%= visitDate == null ? "" : dateFormat.format((java.util.Date)visitDate) %> <%= preferredTime == null ? "" : timeFormat.format((java.util.Date)preferredTime) %></td>
                                    <td class="status-cell"><%= escapeHtml(status) %></td>
                                    <td class="action-cell">
                                        <% if (status.equals("Waiting")) { %>
                                            <button type="button" class="serve-btn">Serve</button>
                                        <% } else if (status.equals("Serving")) { %>
                                            <button type="button" class="complete-btn">Complete</button>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <p id="emptyQueue" class="empty-state" <%= queueTokens.isEmpty() ? "" : "hidden" %>>No queue tokens found.</p>
                <p id="queueMessage" role="status"></p>
            </section>
            <section class="queue-help">
                <div>
                    <span>●</span>
                    <div>
                        <h3>Waiting</h3>
                        <p>Customer is waiting for their turn.</p>
                    </div>
                </div>
                <div>
                    <span>●</span>
                    <div>
                        <h3>Serving</h3>
                        <p>Customer is currently being served.</p>
                    </div>
                </div>
                <div>
                    <span>●</span>
                    <div>
                        <h3>Completed</h3>
                        <p>Service has been completed.</p>
                    </div>
                </div>
            </section>
            <footer class="admin-footer">© 2026 QueueLess. Smart queues, better experiences.</footer>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/admin/live-queue.js"></script>
</body>
</html>
