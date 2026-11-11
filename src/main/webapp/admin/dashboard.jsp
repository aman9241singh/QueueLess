<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Admin Dashboard | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
</head>
<body>
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logo"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"></a>
            <div class="admin-info">
                <div class="admin-avatar">A</div>
                <div>
                    <h3><%= session.getAttribute("adminName") %></h3>
                    <p>System Admin</p>
                </div>
            </div>
            <nav class="admin-nav">
               <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">▦ Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/services">▤ Manage Services</a>
                <a href="${pageContext.request.contextPath}/admin/live-queue">☷ Live Queue</a>
                <a href="users.jsp">♙ Users</a>
                <a href="analytics.jsp">▥ Analytics & Reports</a>
                <a href="${pageContext.request.contextPath}/admin/announcements">◉ Announcements</a>  <a href="${pageContext.request.contextPath}/admin/contact-messages">✉ Contact Messages</a>
                <a href="settings.jsp">⚙ Settings</a>
                <a href="${pageContext.request.contextPath}/admin/profile">♙Admin Profile</a>
            </nav>
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logout">← Back to Website</a>
        </aside>
        <main class="admin-main">
            <header class="admin-header">
                <div>
                    <p class="eyebrow">ADMINISTRATION</p>
                    <h1>Dashboard</h1>
                    <p class="header-subtitle">Welcome back! Here's what's happening today.</p>
                </div>
                <div class="system-status"><span></span> System Online</div>
            </header>
            <section class="welcome-banner">
                <div>
                    <p class="banner-label">QUEUELESS CONTROL CENTER</p>
                    <h2>Manage your queues efficiently.</h2>
                    <p>Monitor tokens, services and customer activity from one place.</p>
                </div>
                <div class="banner-icon">⌁</div>
            </section>
            <section class="stats-grid">
                <article class="stat-card">
                    <div><span>Total Tokens Today</span><b>▣</b></div>
                    <h2 id="totalTokens">${totalTokens}</h2>
                    <p>Today's token bookings</p>
                </article>
                <article class="stat-card">
                    <div><span>Active Queues</span><b>☷</b></div>
                    <h2 id="activeQueues">${activeQueues}</h2>
                    <p>Across all services</p>
                </article>
                <article class="stat-card">
                    <div><span>Registered Users</span><b>♙</b></div>
                   <h2 id="registeredUsers">${registeredUsers}</h2>
                    <p>Total registered customers</p>
                </article>
                <article class="stat-card">
                    <div><span>Waiting Customers</span><b>◷</b></div>
                    <h2 id="waitingCustomers">${waitingCustomers}</h2>
                    <p>Across active queues</p>
                </article>
            </section>
            <section class="dashboard-grid">
                <div class="dashboard-panel">
                    <div class="panel-heading">
                        <div>
                            <h2>Live Queue Overview</h2>
                            <p>Current status of service queues</p>
                        </div>
                    <a href="${pageContext.request.contextPath}/admin/live-queue">View All →</a>
                    </div>
                    <div class="table-scroll">
                        <table>
                            <thead>
                                <tr>
                                    <th>Service</th>
                                    <th>Waiting</th>
                                    <th>Avg. Wait</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody id="serviceQueueTable"></tbody>
                        </table>
                    </div>
                </div>
                <div class="dashboard-panel">
                    <div class="panel-heading">
                        <div>
                            <h2>Recent Activity</h2>
                            <p>Latest system updates</p>
                        </div>
                    </div>
                    <div class="activity-list">
                        <div class="activity-item">
                            <span class="activity-icon blue">＋</span>
                            <div>
                                <h3>New token booked</h3>
                                <p>Token QL1284 was created.</p>
                                <small>5 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <span class="activity-icon green">✓</span>
                            <div>
                                <h3>Service completed</h3>
                                <p>Banking token QL1279 completed.</p>
                                <small>18 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <span class="activity-icon purple">♙</span>
                            <div>
                                <h3>New user registered</h3>
                                <p>A new customer joined QueueLess.</p>
                                <small>35 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <span class="activity-icon orange">◉</span>
                            <div>
                                <h3>Announcement published</h3>
                                <p>A service update was published.</p>
                                <small>1 hour ago</small>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <section class="quick-section">
                <div class="panel-heading">
                    <div>
                        <h2>Quick Actions</h2>
                        <p>Frequently used administration tools</p>
                    </div>
                </div>
                <div class="quick-grid">
                  <a href="${pageContext.request.contextPath}/admin/services">
                        <span>＋</span>
                        <div>
                            <h3>Manage Services</h3>
                            <p>Add or update services</p>
                        </div>
                        <b>→</b>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/live-queue">
                        <span>☷</span>
                        <div>
                            <h3>Monitor Queue</h3>
                            <p>Review active tokens</p>
                        </div>
                        <b>→</b>
                    </a>
                   <a href="${pageContext.request.contextPath}/admin/announcements">
                        <span>◉</span>
                        <div>
                            <h3>Announcements</h3>
                            <p>Share updates with users</p>
                        </div>
                        <b>→</b>
                    </a>
                </div>
            </section>
            <footer class="admin-footer">© 2026 QueueLess. Smart queues, better experiences.</footer>
        </main>
    </div>
    
</body>
</html>
