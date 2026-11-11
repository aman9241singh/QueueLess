
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Manage Services | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/services.css">
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
                <a href="${pageContext.request.contextPath}/admin/dashboard">▦ Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/services" class="active">▤ Manage Services</a>
                <a href="${pageContext.request.contextPath}/admin/live-queue">☷ Live Queue</a>
                <a href="${pageContext.request.contextPath}/admin/users">♙ Users</a>
                <a href="${pageContext.request.contextPath}/admin/analytics">▥ Analytics &amp; Reports</a>
                <a href="${pageContext.request.contextPath}/admin/announcements">◉ Announcements</a>
                <a href="${pageContext.request.contextPath}/admin/settings">⚙ Settings</a>
                <a href="${pageContext.request.contextPath}/admin/profile">♙ Admin Profile</a>
            </nav>
            <a href="${pageContext.request.contextPath}/index.jsp" class="admin-logout">← Back to Website</a>
        </aside>
        <main class="admin-main">
            <header class="admin-header">
                <div>
                    <p class="eyebrow">SERVICE MANAGEMENT</p>
                    <h1>Manage Services</h1>
                    <p class="header-subtitle">Create, update and manage services available to customers.</p>
                </div>
                <div class="system-status"><span></span> System Online</div>
            </header>
            <section class="service-stats">
                <div class="service-stat">
                    <span>Total Services</span>
                    <h3 id="totalServices">${totalServices}</h3>
                </div>
                <div class="service-stat">
                    <span>Active Services</span>
                    <h3 id="activeServices">${activeServices}</h3>
                </div>
                <div class="service-stat">
                    <span>Inactive Services</span>
                    <h3 id="inactiveServices">${inactiveServices}</h3>
                </div>
            </section>
            <section class="service-form-panel" id="serviceFormPanel">
                <div class="service-panel-heading">
                    <div>
                        <h2 id="formTitle">Add New Service</h2>
                        <p>Enter the service details below.</p>
                    </div>
                    <button type="button" class="secondary-btn" id="toggleFormBtn">Hide Form</button>
                </div>
                <form id="serviceForm" method="post" action="${pageContext.request.contextPath}/admin/services">
                    <input type="hidden" id="serviceId" name="serviceId">
                    <input type="hidden" id="action" name="action" value="add">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="serviceName">Service Name</label>
                            <input id="serviceName" name="serviceName" type="text" placeholder="e.g. Salon Services" required>
                        </div>
                        <div class="form-group">
                            <label for="serviceCategory">Category</label>
                            <select id="serviceCategory" name="category" required>
                                <option value="">Select category</option>
                                <option value="Banking">Banking</option>
                                <option value="Healthcare">Healthcare</option>
                                <option value="Customer Support">Customer Support</option>
                                <option value="Government Office">Government Office</option>
                                <option value="Education">Education</option>
                                <option value="Salon & Beauty">Salon &amp; Beauty</option>
                                <option value="Restaurant">Restaurant</option>
                                <option value="Vehicle Service">Vehicle Service</option>
                                <option value="Shopping Store">Shopping Store</option>
                                <option value="Dental Clinic">Dental Clinic</option>
                                <option value="Pharmacy">Pharmacy</option>
                                <option value="Documents">Documents</option>
                                <option value="Billing">Billing</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="serviceLocation">Location / Counter</label>
                            <input id="serviceLocation" name="location" type="text" placeholder="e.g. Counter 01" required>
                        </div>
                        <div class="form-group">
                            <label for="serviceWait">Estimated Wait (minutes)</label>
                            <input id="serviceWait" name="averageWaitTime" type="number" min="1" max="240" placeholder="e.g. 15" required>
                        </div>
                        <div class="form-group full-width">
                            <label for="serviceDescription">Description</label>
                            <textarea id="serviceDescription" name="description" rows="3" placeholder="Describe the service..." required></textarea>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="primary-btn" id="saveServiceBtn">Add Service</button>
                        <button type="button" class="secondary-btn" id="cancelEditBtn">Clear</button>
                    </div>
                </form>
            </section>
            <section class="services-panel">
                <div class="service-panel-heading">
                    <div>
                        <h2>All Services</h2>
                        <p>Review and manage the services in your system.</p>
                    </div>
                    <div class="service-count" id="serviceCount">${totalServices} services</div>
                </div>
                <div class="service-toolbar">
                    <input type="search" id="serviceSearch" placeholder="Search services...">
                    <select id="statusFilter">
                        <option value="all">All Statuses</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>
                <div class="table-scroll">
                    <table>
                        <thead>
                            <tr>
                                <th>Service</th>
                                <th>Category</th>
                                <th>Location</th>
                                <th>Wait Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="servicesTable">
                            <c:forEach var="service" items="${services}">
                                <tr>
                                    <td><c:out value="${service.serviceName}"/></td>
                                    <td><c:out value="${service.category}"/></td>
                                    <td><c:out value="${service.location}"/></td>
                                    <td>${service.averageWaitTime} min</td>
                                    <td>
                                        <span class="status-badge ${service.status == 'Active' ? 'active' : 'inactive'}"><c:out value="${service.status}"/></span>
                                    </td>
                                    <td>
                                        <button type="button" class="edit-btn"
                                            data-id="${service.serviceId}"
                                            data-name="${service.serviceName}"
                                            data-category="${service.category}"
                                            data-location="${service.location}"
                                            data-wait="${service.averageWaitTime}"
                                            data-description="${service.description}">Edit</button>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/services" style="display:inline">
                                            <input type="hidden" name="action" value="toggle">
                                            <input type="hidden" name="serviceId" value="${service.serviceId}">
                                            <input type="hidden" name="status" value="${service.status == 'Active' ? 'Inactive' : 'Active'}">
                                            <button type="submit">${service.status == 'Active' ? 'Deactivate' : 'Activate'}</button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/services" style="display:inline" onsubmit="return confirm('Are you sure you want to delete this service?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="serviceId" value="${service.serviceId}">
                                            <button type="submit" class="delete-btn">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <p class="empty-state" id="emptyState" hidden>No services match your search.</p>
            </section>
            <footer class="admin-footer">
                © 2026 QueueLess. Smart queues, better experiences.
            </footer>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/admin/services.js"></script>
</body>
</html>
