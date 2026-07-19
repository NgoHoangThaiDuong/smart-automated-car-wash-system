<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Overview - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/dashboard.css'/>">

</head>
<body>

<c:set var="activePage" value="dashboard" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">
    
    <!-- Stats Row 1: Large Cards -->
    <div class="stats-row-large">
        <!-- Revenue Card -->
        <div class="card-large blue-card">
            <div class="card-label">Revenue Today</div>
            <div class="card-value">
                <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫
            </div>
            <!-- Decorative circle and icon -->
            <div class="card-decor-circle">
                <span class="material-symbols-outlined">payments</span>
            </div>
        </div>

        <!-- Total Bookings Card -->
        <div class="card-large">
            <div class="card-label">Total Bookings</div>
            <div class="card-value">${todayCount}</div>
            <div class="card-icon-wrapper">
                <span class="material-symbols-outlined" style="font-size: 1.3rem;">book_online</span>
            </div>
        </div>

        <!-- Total Customers Card -->
        <div class="card-large">
            <div class="card-label">Total Customers</div>
            <!-- Total Customers -->
            <div class="card-value">${totalCustomers}</div>
            <div class="card-icon-wrapper">
                <span class="material-symbols-outlined" style="font-size: 1.3rem;">group</span>
            </div>
        </div>
    </div>

    <!-- Stats Row 2: Small Cards -->
    <div class="stats-row-small">
        <div class="card-small">
            <div class="card-label">Pending</div>
            <div class="card-value">${confirmedCount}</div>
        </div>
        <div class="card-small">
            <div class="card-label">In Progress</div>
            <div class="card-value">${inProgressCount}</div>
        </div>
        <div class="card-small">
            <div class="card-label">Completed</div>
            <div class="card-value">${completedCount}</div>
        </div>
        <div class="card-small">
            <div class="card-label">Unpaid</div>
            <div class="card-value">${unpaidCount}</div>
        </div>
    </div>

    <!-- Reusable Unified Booking Panel Component -->
    <c:set var="paginationBaseUrl" value="/admin/dashboard" scope="request"/>
    <jsp:include page="/WEB-INF/view/admin/components/booking-table.jsp"/>
</div>
</body>
</html>
