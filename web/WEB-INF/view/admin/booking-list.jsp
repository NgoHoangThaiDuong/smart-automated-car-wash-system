<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">

</head>
<body>

<!-- Sticky Top Navbar -->
<c:set var="activePage" value="bookings" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">

    <!-- Page Header & Breadcrumbs -->
    <div class="page-header-container">
        <div class="breadcrumb-trail">
            <a href="<c:url value='/admin/dashboard'/>">Dashboard</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <span style="font-weight: 700;">Bookings</span>
        </div>
        <div class="header-action-row">
            <div>
                <h1 class="page-title">Bookings</h1>
            </div>
            <div>
                <a href="#" class="btn-admin-primary" style="text-decoration: none;">
                    <span class="material-symbols-outlined">add</span>
                    New Booking
                </a>
            </div>
        </div>
    </div>
    
    <!-- Reusable Unified Booking Panel Component -->
    <c:set var="paginationBaseUrl" value="/admin/bookings" scope="request"/>
    <jsp:include page="/WEB-INF/view/admin/components/booking-table.jsp"/>
</div>

</body>
</html>
