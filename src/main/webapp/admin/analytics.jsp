
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Analytics &amp; Reports | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/analytics.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logo">
                <img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo">
            </a>
            <div class="admin-info">
                <div class="admin-avatar">A</div>
                <div>
                    <h3>Administrator</h3>
                    <p>System Admin</p>
                </div>
            </div>
            <nav class="admin-nav">
                <a href="dashboard.jsp">▦ Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/services">▤ Manage Services</a>
                <a href="${pageContext.request.contextPath}/admin/live-queue">☷ Live Queue</a>
                <a href="users.jsp">♙ Users</a>
                <a href="${pageContext.request.contextPath}/admin/analytics" class="active">▥ Analytics &amp; Reports</a>
                <a href="${pageContext.request.contextPath}/admin/announcements">◉ Announcements</a>
                <a href="settings.jsp">⚙ Settings</a>
                <a href="${pageContext.request.contextPath}/admin/profile">♙ Admin Profile</a>
            </nav>
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logout">← Back to Website</a>
        </aside>
        <main class="admin-main">
            <header class="admin-header">
                <div>
                    <p class="eyebrow">PERFORMANCE OVERVIEW</p>
                    <h1>Analytics &amp; Reports</h1>
                    <p class="header-subtitle">Understand queue performance and service usage.</p>
                </div>
                <div class="system-status"><span></span> System Online</div>
            </header>
            <section class="analytics-toolbar">
                <div>
                    <label for="reportPeriod">Report Period</label>
                    <select id="reportPeriod">
                        <option value="7" ${days == 7 ? 'selected' : ''}>Last 7 Days</option>
                        <option value="14" ${days == 14 ? 'selected' : ''}>Last 14 Days</option>
                        <option value="30" ${days == 30 ? 'selected' : ''}>Last 30 Days</option>
                    </select>
                </div>
                <button type="button" id="downloadReport" class="report-btn">Download Report ↓</button>
            </section>
            <section class="analytics-stats">
                <div class="analytics-stat">
                    <span>Total Tokens</span>
                    <h2 id="totalTokens">${summary.totalTokens}</h2>
                    <p>Bookings in selected period</p>
                </div>
                <div class="analytics-stat">
                    <span>Completion Rate</span>
                    <h2 id="completionRate">${summary.completionRate}%</h2>
                    <p>Bookings completed</p>
                </div>
                <div class="analytics-stat">
                    <span>Average Wait</span>
                    <h2 id="averageWait">${summary.averageWait} min</h2>
                    <p>Estimated waiting time</p>
                </div>
                <div class="analytics-stat">
                    <span>Active Services</span>
                    <h2 id="activeServices">${summary.activeServices}</h2>
                    <p>Currently available</p>
                </div>
            </section>
            <section class="charts-grid">
                <div class="chart-panel">
                    <div class="chart-heading">
                        <div>
                            <h2>Token Activity</h2>
                            <p>Bookings and completions over time</p>
                        </div>
                    </div>
                    <div class="chart-container"><canvas id="tokenChart"></canvas></div>
                </div>
                <div class="chart-panel">
                    <div class="chart-heading">
                        <div>
                            <h2>Token Status</h2>
                            <p>Distribution of booking statuses</p>
                        </div>
                    </div>
                    <div class="chart-container doughnut-container"><canvas id="statusChart"></canvas></div>
                </div>
                <div class="chart-panel">
                    <div class="chart-heading">
                        <div>
                            <h2>Service Usage</h2>
                            <p>Bookings by service category</p>
                        </div>
                    </div>
                    <div class="chart-container"><canvas id="serviceChart"></canvas></div>
                </div>
                <div class="chart-panel">
                    <div class="chart-heading">
                        <div>
                            <h2>Weekly Traffic</h2>
                            <p>Customer activity by day of the week</p>
                        </div>
                    </div>
                    <div class="chart-container"><canvas id="trafficChart"></canvas></div>
                </div>
            </section>
            <section class="report-panel">
                <div class="chart-heading">
                    <div>
                        <h2>Service Performance</h2>
                        <p>Service metrics for the selected period</p>
                    </div>
                </div>
                <div class="table-scroll">
                    <table>
                        <thead>
                            <tr>
                                <th>Service</th>
                                <th>Total Tokens</th>
                                <th>Completed</th>
                                <th>Avg. Wait</th>
                                <th>Completion</th>
                            </tr>
                        </thead>
                        <tbody id="performanceTable"></tbody>
                    </table>
                </div>
            </section>
            <p class="report-disclaimer">Analytics are calculated from actual QueueLess booking and service records.</p>
            <footer class="admin-footer">© 2026 QueueLess. Smart queues, better experiences.</footer>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/admin/analytics.js"></script>
</body>
</html>
