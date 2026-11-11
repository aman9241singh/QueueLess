
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Admin Profile | QueueLess</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/profile.css">
</head>
<body>
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-brand"><img src="${pageContext.request.contextPath}/assets/images/QueueLess%20Clock%20Logo%20(1).png" alt="QueueLess Logo"><span>QueueLess</span></a>
            <nav class="admin-nav">
                <a href="${pageContext.request.contextPath}/admin/dashboard">▦ Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/services">▤ Manage Services</a>
                <a href="${pageContext.request.contextPath}/admin/live-queue">☷ Live Queue</a>
                <a href="${pageContext.request.contextPath}/admin/users">♙ Users</a>
                <a href="${pageContext.request.contextPath}/admin/analytics">▥ Analytics & Reports</a>
                <a href="${pageContext.request.contextPath}/admin/announcements">◉ Announcements</a>
                <a href="${pageContext.request.contextPath}/admin/settings">Settings</a>
                <a href="${pageContext.request.contextPath}/admin/profile" class = "active">♙ Admin Profile</a>
            </nav>
            <a href="${pageContext.request.contextPath}/index.jsp" class="back-link">← Back to Website</a>
        </aside>
        <main class="profile-main">
            <header class="page-header">
                <div>
                    <p class="eyebrow">ACCOUNT MANAGEMENT</p>
                    <h1>Admin Profile</h1>
                    <p>Manage your personal information and account security.</p>
                </div>
                <div class="top-avatar">${empty admin.fullName ? 'A' : admin.fullName.substring(0,1)}</div>
            </header>
            <section class="profile-hero">
                <div class="profile-avatar" id="profileAvatar">${empty admin.fullName ? 'A' : admin.fullName.substring(0,1)}</div>
                <div class="profile-identity">
                    <h2 id="displayName"><c:out value="${admin.fullName}"/></h2>
                    <p id="displayEmail"><c:out value="${admin.email}"/></p>
                    <span class="role-badge">Administrator</span>
                </div>
                <div class="account-status"><span class="status-dot"></span> Active Account</div>
            </section>
            <c:if test="${param.success == 'profile'}">
                <div class="success-message">Profile updated successfully.</div>
            </c:if>
            <c:if test="${param.success == 'password'}">
                <div class="success-message">Password changed successfully.</div>
            </c:if>
            <c:if test="${param.error == 'invalid'}">
                <div class="error-message">Please enter valid profile information.</div>
            </c:if>
            <c:if test="${param.error == 'profile'}">
                <div class="error-message">Profile could not be updated.</div>
            </c:if>
            <c:if test="${param.error == 'password'}">
                <div class="error-message">New password must contain at least 8 characters and both passwords must match.</div>
            </c:if>
            <c:if test="${param.error == 'current'}">
                <div class="error-message">Your current password is incorrect.</div>
            </c:if>
            <c:if test="${param.error == 'duplicate'}">
                <div class="error-message">This email address is already registered.</div>
            </c:if>
            <div class="profile-grid">
                <section class="profile-card">
                    <div class="card-heading">
                        <div>
                            <h2>Personal Information</h2>
                            <p>Update your admin profile details.</p>
                        </div>
                        <span class="card-icon">♙</span>
                    </div>
                   
                    <form id="profileForm" method="post" action="${pageContext.request.contextPath}/admin/profile">
                        <input type="hidden" name="action" value="updateProfile">
                        <div class="field-group">
                            <label for="fullName">Full Name</label>
                            <input id="fullName" name="fullName" type="text" value="<c:out value='${admin.fullName}'/>" required minlength="2" maxlength="100">
                        </div>
                        <div class="field-group">
                            <label for="email">Email Address</label>
                            <input id="email" name="email" type="email" value="<c:out value='${admin.email}'/>" required maxlength="100">
                        </div>
                        <div class="button-row">
                            <button type="reset" class="secondary-button">Reset</button>
                            <button type="submit" class="primary-button">Save Profile</button>
                        </div>
                    </form>
                </section>
                <section class="profile-card security-card">
                    <div class="card-heading">
                        <div>
                            <h2>Account Security</h2>
                            <p>Update your password.</p>
                        </div>
                        <span class="card-icon">♢</span>
                    </div>
                    <form id="passwordForm" method="post" action="${pageContext.request.contextPath}/admin/profile">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="field-group">
                            <label for="currentPassword">Current Password</label>
                            <input id="currentPassword" name="currentPassword" type="password" placeholder="Enter current password" required minlength="6" autocomplete="current-password">
                        </div>
                        <div class="field-group">
                            <label for="newPassword">New Password</label>
                            <input id="newPassword" name="newPassword" type="password" placeholder="Enter new password" required minlength="8" autocomplete="new-password">
                        </div>
                        <div class="field-group">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input id="confirmPassword" name="confirmPassword" type="password" placeholder="Re-enter new password" required minlength="8" autocomplete="new-password">
                        </div>
                        <p class="password-hint">Use at least 8 characters for your new password.</p>
                        <button type="submit" class="primary-button full-button">Update Password</button>
                    </form>
                    <div class="security-note">
                        <strong>Security tip</strong>
                        <p>Never share your password. Use a unique password for your administrator account.</p>
                    </div>
                </section>
                <section class="profile-card account-card">
                    <div class="card-heading">
                        <div>
                            <h2>Account Information</h2>
                            <p>Overview of your administrator account.</p>
                        </div>
                        <span class="card-icon">▤</span>
                    </div>
                    <div class="info-row"><span>Admin ID</span><strong>${admin.adminId}</strong></div>
                    <div class="info-row"><span>Account Role</span><strong>Administrator</strong></div>
                    <div class="info-row"><span>Account Status</span><strong class="active-text">Active</strong></div>
                    <div class="info-row"><span>Member Since</span><strong><c:out value="${admin.createdAt}"/></strong></div>
                    <div class="info-row"><span>Authentication</span><strong>BCrypt Password</strong></div>
                    <div class="info-row"><span>Platform</span><strong>QueueLess Admin</strong></div>
                </section>
            </div>
            <div id="profileToast" class="toast" role="status" aria-live="polite"></div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/admin/profile.js"></script>
</body>
</html>
