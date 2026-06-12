<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body>
<nav class="navbar">
    <div class="nav-container" style="max-width:1100px;">
        <a href="<c:url value='/admin/dashboard'/>" class="nav-logo">⚙️ Smart CarWash Admin</a>
        <div class="nav-user">
            <a href="<c:url value='/admin/bookings'/>" class="admin-nav-link">Booking</a>
            <span class="user-greeting"><c:out value="${sessionScope.currentUser.username}"/></span>
            <a href="<c:url value='/auth/logout'/>" class="btn-logout" style="text-decoration:none;display:inline-block;">Đăng xuất</a>
        </div>
    </div>
</nav>

<div class="admin-container">
    <h2 class="admin-page-title">Dashboard</h2>

    <div class="stats-grid">
        <div class="stat-card stat-confirmed">
            <div class="stat-value"><c:out value="${confirmedCount}"/></div>
            <div class="stat-label">Chờ xử lý</div>
        </div>
        <div class="stat-card stat-inprogress">
            <div class="stat-value"><c:out value="${inProgressCount}"/></div>
            <div class="stat-label">Đang rửa</div>
        </div>
        <div class="stat-card stat-completed">
            <div class="stat-value"><c:out value="${completedCount}"/></div>
            <div class="stat-label">Hoàn thành</div>
        </div>
        <div class="stat-card stat-today">
            <div class="stat-value"><c:out value="${todayCount}"/></div>
            <div class="stat-label">Hôm nay</div>
        </div>
        <div class="stat-card stat-revenue">
            <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/>₫</div>
            <div class="stat-label">Doanh thu (PAID)</div>
        </div>
    </div>

    <div style="margin-top:2rem;">
        <a href="<c:url value='/admin/bookings'/>" class="btn-admin-primary">Xem danh sách Booking →</a>
    </div>
</div>
</body>
</html>
