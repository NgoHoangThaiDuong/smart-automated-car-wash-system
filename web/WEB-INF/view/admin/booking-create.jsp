<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Create Booking - Smart Car Wash</title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap"
                        rel="stylesheet">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
                    <link rel="stylesheet" href="<c:url value='/css/admin/components/booking-table.css'/>">
                    <link rel="stylesheet" href="<c:url value='/css/admin/customers.css'/>">
                    <link rel="stylesheet" href="<c:url value='/css/customer/booking.css'/>">

                    <style>
                        /* Tinh chỉnh cho giao diện admin đẹp mắt */
                        .admin-booking-card {
                            background: #ffffff;
                            border: 1px solid var(--border-slate);
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 1.5rem;
                            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                        }

                        .customer-info-box {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            background: #F8FAFC;
                            border: 1px dashed var(--border-slate);
                            border-radius: 10px;
                            padding: 1rem;
                            margin-bottom: 1.5rem;
                        }

                        .customer-info-box .customer-details {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                        }

                        .customer-info-box .customer-avatar {
                            width: 42px;
                            height: 42px;
                            border-radius: 50%;
                            background: #2563EB;
                            color: #ffffff;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: 700;
                            font-size: 0.95rem;
                        }

                        .customer-info-box .customer-meta h3 {
                            margin: 0;
                            font-size: 1rem;
                            font-weight: 600;
                            color: #1E293B;
                        }

                        .customer-info-box .customer-meta p {
                            margin: 0;
                            font-size: 0.85rem;
                            color: #64748B;
                        }

                        /* Cần đảm bảo booking-page và container hài hòa */
                        .booking-page {
                            max-width: 100% !important;
                            padding: 0 !important;
                            margin: 0 !important;
                        }

                        .page-heading {
                            margin-bottom: 1.5rem !important;
                        }

                        /* Form action styles */
                        .admin-action-btn-sm {
                            padding: 0.35rem 0.85rem;
                            background: #2563EB;
                            color: #ffffff;
                            border-radius: 6px;
                            text-decoration: none;
                            font-size: 0.85rem;
                            font-weight: 600;
                            display: inline-flex;
                            align-items: center;
                            gap: 4px;
                            transition: all 0.2s;
                        }

                        .admin-action-btn-sm:hover {
                            background: #1D4ED8;
                        }
                    </style>
                </head>

                <body>

                    <!-- Sticky Top Navbar -->
                    <c:set var="activePage" value="bookings" scope="request" />
                    <jsp:include page="/WEB-INF/view/common/navbar.jsp" />

                    <div class="admin-container">

                        <!-- Page Header & Breadcrumbs -->
                        <div class="page-header-container">
                            <div class="breadcrumb-trail">
                                <a href="<c:url value='/admin/dashboard'/>">Dashboard</a>
                                <span class="material-symbols-outlined">chevron_right</span>
                                <a href="<c:url value='/admin/bookings'/>">Bookings</a>
                                <span class="material-symbols-outlined">chevron_right</span>
                                <span style="font-weight: 700;">New Booking</span>
                            </div>
                            <div class="header-action-row">
                                <div>
                                    <h1 class="page-title">Create New Booking</h1>
                                </div>
                                <div>
                                    <a href="<c:url value='/admin/bookings'/>" class="btn-admin-secondary"
                                        style="text-decoration: none;">
                                        <span class="material-symbols-outlined">arrow_back</span>
                                        Back to Bookings
                                    </a>
                                </div>
                            </div>
                        </div>

                        <c:choose>
                            <%-- TRẠNG THÁI 1: CHƯA CHỌN CUSTOMER --%>
                                <c:when test="${hasNoCustomer}">
                                    <div class="mgmt-card" style="padding: 1.5rem;">
                                        <h2
                                            style="font-size: 1.2rem; font-weight: 700; color: #1E293B; margin-top: 0; margin-bottom: 1rem; display: flex; align-items: center; gap: 8px;">
                                            <span class="material-symbols-outlined"
                                                style="color: #2563EB;">person_search</span>
                                            Select a Customer to Proceed
                                        </h2>
                                        <p style="color: #64748B; font-size: 0.9rem; margin-bottom: 1.5rem;">Please find
                                            and choose the customer for whom you are creating this booking.</p>

                                        <!-- Search and Filter -->
                                        <div class="filter-card" style="margin-bottom: 1.5rem; background: #F8FAFC;">
                                            <form action="<c:url value='/admin/bookings/new'/>" method="GET"
                                                style="margin: 0;">
                                                <div class="filter-form-grid">
                                                    <!-- Search Field -->
                                                    <div class="search-input-wrapper">
                                                        <span class="material-symbols-outlined">search</span>
                                                        <input name="search" class="search-input-field"
                                                            placeholder="Search by name, phone number, or username..."
                                                            type="text" value="<c:out value='${search}'/>">
                                                    </div>

                                                    <!-- Tier Filter Select -->
                                                    <select name="tierId" class="filter-select-field">
                                                        <option value="">Tiers</option>
                                                        <c:forEach var="t" items="${tiers}">
                                                            <option value="${t.id}" ${selectedTierId==t.id ? 'selected'
                                                                : '' }>
                                                                <c:out value="${t.name}" />
                                                            </option>
                                                        </c:forEach>
                                                    </select>

                                                    <!-- Filter Submit -->
                                                    <button type="submit" class="btn-submit-filter">
                                                        <span class="material-symbols-outlined"
                                                            style="font-size: 1.15rem;">tune</span> Filter
                                                    </button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- Customers Table -->
                                        <div
                                            style="overflow-x: auto; border: 1px solid var(--border-slate); border-radius: 8px;">
                                            <table class="booking-table">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 25%;">Customer</th>
                                                        <th style="width: 15%;">Membership Tier</th>
                                                        <th style="width: 15%; text-align: right;">Loyalty Points</th>
                                                        <th style="width: 15%; text-align: right;">Lifetime Spent</th>
                                                        <th style="width: 12%; text-align: center;">Wash Count</th>
                                                        <th style="width: 8%; text-align: center;">Vehicles</th>
                                                        <th style="width: 10%; text-align: center;">Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${not empty customers}">
                                                            <c:forEach var="u" items="${customers}">
                                                                <tr>
                                                                    <!-- Customer Profile -->
                                                                    <td>
                                                                        <div class="customer-cell">
                                                                            <div class="customer-avatar">
                                                                                <c:out
                                                                                    value="${fn:substring(u.username, 0, 2).toUpperCase()}" />
                                                                            </div>
                                                                            <div>
                                                                                <div class="customer-name">
                                                                                    <c:out value="${u.fullname}" />
                                                                                </div>
                                                                                <div class="customer-sub">
                                                                                    @
                                                                                    <c:out value="${u.username}" /> •
                                                                                    <c:out
                                                                                        value="${not empty u.phone ? u.phone : 'No Phone'}" />
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </td>

                                                                    <!-- Tier Badge -->
                                                                    <td>
                                                                        <c:set var="tierName"
                                                                            value="${not empty u.loyaltyTier ? u.loyaltyTier.name : 'Member'}" />
                                                                        <span class="tier-badge tier-${tierName}">
                                                                            <c:out value="${tierName}" />
                                                                        </span>
                                                                    </td>

                                                                    <!-- Points -->
                                                                    <td class="td-points" style="text-align: right;">
                                                                        <fmt:formatNumber value="${u.pointsBalance}"
                                                                            type="number" groupingUsed="true" /> pts
                                                                    </td>

                                                                    <!-- Spent -->
                                                                    <td class="td-spent" style="text-align: right;">
                                                                        <fmt:formatNumber value="${u.lifetimeSpent}"
                                                                            type="number" groupingUsed="true" /> ₫
                                                                    </td>

                                                                    <!-- Total Washes -->
                                                                    <td class="td-washes" style="text-align: center;">
                                                                        ${u.totalWashes}</td>

                                                                    <!-- Total Vehicles -->
                                                                    <td class="td-vehicle-count"
                                                                        style="text-align: center;">
                                                                        <span
                                                                            class="vehicle-count-tag">${u.vehicleCount}</span>
                                                                    </td>

                                                                    <!-- Action: Select -->
                                                                    <td style="text-align: center;">
                                                                        <a href="<c:url value='/admin/bookings/new'><c:param name='customerId' value='${u.id}'/></c:url>"
                                                                            class="admin-action-btn-sm">
                                                                            Select
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <tr>
                                                                <td colspan="7"
                                                                    style="text-align: center; color: #94A3B8; padding: 4rem 2rem; font-style: italic;">
                                                                    <div
                                                                        style="display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.5rem;">
                                                                        <span class="material-symbols-outlined"
                                                                            style="font-size: 3rem; color: #94A3B8;">person_search</span>
                                                                        <span>No loyalty accounts match filter
                                                                            constraints.</span>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination Section -->
                                        <c:if test="${totalPages > 0}">
                                            <div class="pagination-container"
                                                style="border-top: 1px solid var(--border-slate); margin-top: 1rem; padding-top: 1rem;">
                                                <div class="pagination-wrapper">
                                                    <ul class="pagination-list">
                                                        <li>
                                                            <c:choose>
                                                                <c:when test="${currentPage > 1}">
                                                                    <c:url value="/admin/bookings/new" var="prevUrl">
                                                                        <c:if test="${not empty search}">
                                                                            <c:param name="search" value="${search}" />
                                                                        </c:if>
                                                                        <c:if test="${not empty selectedTierId}">
                                                                            <c:param name="tierId"
                                                                                value="${selectedTierId}" />
                                                                        </c:if>
                                                                        <c:param name="page"
                                                                            value="${currentPage - 1}" />
                                                                    </c:url>
                                                                    <a href="${prevUrl}" class="page-item-btn"
                                                                        style="text-decoration: none; display: flex; align-items: center; justify-content: center;">
                                                                        <span class="material-symbols-outlined"
                                                                            style="font-size: 1.1rem;">chevron_left</span>
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button class="page-item-btn disabled">
                                                                        <span class="material-symbols-outlined"
                                                                            style="font-size: 1.1rem;">chevron_left</span>
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </li>
                                                        <c:choose>
                                                            <c:when test="${totalPages <= 5}">
                                                                <c:forEach var="i" begin="1" end="${totalPages}">
                                                                    <li>
                                                                        <c:url value="/admin/bookings/new"
                                                                            var="pageUrl">
                                                                            <c:if test="${not empty search}">
                                                                                <c:param name="search"
                                                                                    value="${search}" />
                                                                            </c:if>
                                                                            <c:if test="${not empty selectedTierId}">
                                                                                <c:param name="tierId"
                                                                                    value="${selectedTierId}" />
                                                                            </c:if>
                                                                            <c:param name="page" value="${i}" />
                                                                        </c:url>
                                                                        <a href="${pageUrl}"
                                                                            class="page-item-btn ${currentPage == i ? 'active' : ''}"
                                                                            style="text-decoration: none;">${i}</a>
                                                                    </li>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="i" begin="1" end="${totalPages}">
                                                                    <li>
                                                                        <c:url value="/admin/bookings/new"
                                                                            var="pageUrl">
                                                                            <c:if test="${not empty search}">
                                                                                <c:param name="search"
                                                                                    value="${search}" />
                                                                            </c:if>
                                                                            <c:if test="${not empty selectedTierId}">
                                                                                <c:param name="tierId"
                                                                                    value="${selectedTierId}" />
                                                                            </c:if>
                                                                            <c:param name="page" value="${i}" />
                                                                        </c:url>
                                                                        <a href="${pageUrl}"
                                                                            class="page-item-btn ${currentPage == i ? 'active' : ''}"
                                                                            style="text-decoration: none;">${i}</a>
                                                                    </li>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <li>
                                                            <c:choose>
                                                                <c:when test="${currentPage < totalPages}">
                                                                    <c:url value="/admin/bookings/new" var="nextUrl">
                                                                        <c:if test="${not empty search}">
                                                                            <c:param name="search" value="${search}" />
                                                                        </c:if>
                                                                        <c:if test="${not empty selectedTierId}">
                                                                            <c:param name="tierId"
                                                                                value="${selectedTierId}" />
                                                                        </c:if>
                                                                        <c:param name="page"
                                                                            value="${currentPage + 1}" />
                                                                    </c:url>
                                                                    <a href="${nextUrl}" class="page-item-btn"
                                                                        style="text-decoration: none; display: flex; align-items: center; justify-content: center;">
                                                                        <span class="material-symbols-outlined"
                                                                            style="font-size: 1.1rem;">chevron_right</span>
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button class="page-item-btn disabled">
                                                                        <span class="material-symbols-outlined"
                                                                            style="font-size: 1.1rem;">chevron_right</span>
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:when>

                                <%-- TRẠNG THÁI 2: ĐÃ CHỌN CUSTOMER -> HIỂN THỊ FORM ĐẶT LỊCH --%>
                                    <c:otherwise>
                                        <div class="admin-booking-card">
                                            <!-- Customer Details Panel -->
                                            <div class="customer-info-box">
                                                <div class="customer-details">
                                                    <div class="customer-avatar">
                                                        <c:out
                                                            value="${fn:substring(customer.username, 0, 2).toUpperCase()}" />
                                                    </div>
                                                    <div class="customer-meta">
                                                        <h3>
                                                            <c:out value="${customer.fullname}" />
                                                        </h3>
                                                        <p>@
                                                            <c:out value="${customer.username}" /> •
                                                            <c:out
                                                                value="${not empty customer.phone ? customer.phone : 'No Phone'}" />
                                                            • <span
                                                                class="tier-badge tier-${not empty customer.loyaltyTier ? customer.loyaltyTier.name : 'Member'}"
                                                                style="transform: scale(0.85); display: inline-block;">
                                                                <c:out
                                                                    value="${not empty customer.loyaltyTier ? customer.loyaltyTier.name : 'Member'}" />
                                                            </span>
                                                        </p>
                                                    </div>
                                                </div>
                                                <div>
                                                    <a href="<c:url value='/admin/bookings/new'/>"
                                                        class="btn-admin-secondary"
                                                        style="font-size: 0.85rem; padding: 0.4rem 0.8rem; text-decoration: none;">
                                                        <span class="material-symbols-outlined"
                                                            style="font-size: 1rem;">compare_arrows</span>
                                                        Change Customer
                                                    </a>
                                                </div>
                                            </div>

                                            <c:if test="${not empty bookingError}">
                                                <div class="alert alert-error"
                                                    style="background-color: #FEF2F2; color: #DC2626; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid #FEE2E2;">
                                                    <c:out value="${bookingError}" />
                                                </div>
                                            </c:if>

                                            <!-- Custom Integration of booking-form -->
                                            <main class="booking-page">
                                                <form id="bookingForm" method="POST"
                                                    action="<c:url value='/admin/bookings/create'/>">
                                                    <!-- Hidden customerId -->
                                                    <input type="hidden" name="customerId" value="${customer.id}">

                                                    <div class="booking-layout">
                                                        <div class="booking-selections">
                                                            <section class="selection-card">
                                                                <div class="section-title">
                                                                    <h2>1. Select Vehicle</h2>
                                                                    <span
                                                                        style="color: #64748B; font-size: 0.85rem;">Customer
                                                                        vehicles list</span>
                                                                </div>

                                                                <c:choose>
                                                                    <c:when test="${empty vehicles}">
                                                                        <div class="empty-state compact"
                                                                            style="text-align: center; padding: 2rem;">
                                                                            <h3
                                                                                style="font-size: 1rem; color: #64748B;">
                                                                                No vehicle registered for this customer
                                                                            </h3>
                                                                            <p
                                                                                style="font-size: 0.85rem; color: #94A3B8;">
                                                                                Customer must add a vehicle first.</p>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="option-grid">
                                                                            <c:forEach var="vehicle"
                                                                                items="${vehicles}">
                                                                                <label
                                                                                    class="choice-card ${selectedVehicleId eq vehicle.id ? 'selected' : ''}"
                                                                                    data-choice="vehicle">
                                                                                    <input type="radio" name="vehicleId"
                                                                                        value="${vehicle.id}"
                                                                                        data-name="<c:out value='${vehicle.brand} ${vehicle.model}'/>"
                                                                                        data-detail="<c:out value='${vehicle.licensePlate}'/>"
                                                                                        ${selectedVehicleId eq
                                                                                        vehicle.id ? 'checked' : '' }>
                                                                                    <span class="choice-title">
                                                                                        🚗
                                                                                        <c:out
                                                                                            value="${vehicle.brand}" />
                                                                                        <c:out
                                                                                            value="${vehicle.model}" />
                                                                                    </span>
                                                                                    <span>
                                                                                        <c:out
                                                                                            value="${vehicle.color}" />
                                                                                    </span>
                                                                                    <b>
                                                                                        <c:out
                                                                                            value="${vehicle.licensePlate}" />
                                                                                    </b>
                                                                                </label>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </section>

                                                            <section class="selection-card">
                                                                <h2>2. Select Service</h2>
                                                                <c:choose>
                                                                    <c:when test="${empty services}">
                                                                        <div class="empty-state compact"
                                                                            style="text-align: center; padding: 2rem;">
                                                                            <h3
                                                                                style="font-size: 1rem; color: #64748B;">
                                                                                No service available</h3>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="service-options">
                                                                            <c:forEach var="service"
                                                                                items="${services}">
                                                                                <label
                                                                                    class="service-card ${selectedServiceId eq service.id ? 'selected' : ''}"
                                                                                    data-choice="service">
                                                                                    <input type="radio" name="serviceId"
                                                                                        value="${service.id}"
                                                                                        data-name="<c:out value='${service.name}'/>"
                                                                                        data-duration="${service.durationMinutes}"
                                                                                        data-price="${service.price}"
                                                                                        ${selectedServiceId eq
                                                                                        service.id ? 'checked' : '' }>
                                                                                    <span>
                                                                                        <strong>
                                                                                            <c:out
                                                                                                value="${service.name}" />
                                                                                        </strong>
                                                                                        <small>
                                                                                            <c:out
                                                                                                value="${service.description}" />
                                                                                        </small>
                                                                                    </span>
                                                                                    <span class="service-price">
                                                                                        <b>
                                                                                            <fmt:formatNumber
                                                                                                value="${service.price}"
                                                                                                type="number" /> VND
                                                                                        </b>
                                                                                        <small>${service.durationMinutes}
                                                                                            mins</small>
                                                                                    </span>
                                                                                </label>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </section>

                                                            <div class="date-time-grid">
                                                                <section class="selection-card">
                                                                    <h2>3. Select Date</h2>
                                                                    <div class="membership-note">
                                                                        <c:out
                                                                            value="${empty customer.loyaltyTier ? 'Member' : customer.loyaltyTier.name}" />
                                                                        Member:
                                                                        ${bookingWindowDays}-day booking window
                                                                    </div>
                                                                    <input id="bookingDate" class="date-input"
                                                                        type="date" name="bookingDate"
                                                                        value="<c:out value='${selectedDate}'/>"
                                                                        min="${minBookingDate}" max="${maxBookingDate}">
                                                                </section>

                                                                <section class="selection-card">
                                                                    <h2>4. Select Time</h2>
                                                                    <div id="timeMessage" class="helper-text">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${empty selectedService || empty selectedDate}">
                                                                                Select a service and booking date.
                                                                            </c:when>
                                                                            <c:when test="${empty availableSlots}">
                                                                                No available time slots.
                                                                            </c:when>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div id="timeGrid" class="time-grid">
                                                                        <c:forEach var="slot" items="${availableSlots}">
                                                                            <button type="button"
                                                                                class="time-button ${selectedTime eq slot ? 'selected' : ''}"
                                                                                data-time="${slot}">
                                                                                <c:out value="${slot}" />
                                                                                <small>${selectedTime eq slot ?
                                                                                    'Selected' : 'Available'}</small>
                                                                            </button>
                                                                        </c:forEach>
                                                                    </div>
                                                                    <input id="selectedTime" type="hidden" name="time"
                                                                        value="<c:out value='${selectedTime}'/>">
                                                                </section>
                                                            </div>
                                                        </div>

                                                        <aside class="booking-summary">
                                                            <h2>Booking Summary</h2>
                                                            <div class="summary-row">
                                                                <span>Vehicle</span>
                                                                <b>
                                                                    <span id="summaryVehicle">
                                                                        <c:choose>
                                                                            <c:when test="${not empty selectedVehicle}">
                                                                                <c:out
                                                                                    value="${selectedVehicle.brand}" />
                                                                                <c:out
                                                                                    value="${selectedVehicle.model}" />
                                                                            </c:when>
                                                                            <c:otherwise>Not selected</c:otherwise>
                                                                        </c:choose>
                                                                    </span>
                                                                    <small id="summaryVehicleDetail">
                                                                        <c:out
                                                                            value="${empty selectedVehicle ? '' : selectedVehicle.licensePlate}" />
                                                                    </small>
                                                                </b>
                                                            </div>
                                                            <div class="summary-row">
                                                                <span>Service</span>
                                                                <b>
                                                                    <span id="summaryService">
                                                                        <c:out
                                                                            value="${empty selectedService ? 'Not selected' : selectedService.name}" />
                                                                    </span>
                                                                    <small id="summaryServiceDetail">
                                                                        <c:if test="${not empty selectedService}">
                                                                            ${selectedService.durationMinutes} mins
                                                                        </c:if>
                                                                    </small>
                                                                </b>
                                                            </div>
                                                            <div class="summary-row">
                                                                <span>Date &amp; Time</span>
                                                                <b>
                                                                    <span id="summaryDate">
                                                                        <c:out
                                                                            value="${empty selectedDate ? 'Not selected' : selectedDate}" />
                                                                    </span>
                                                                    <small id="summaryTime">
                                                                        <c:out value="${selectedTime}" />
                                                                    </small>
                                                                </b>
                                                            </div>
                                                            <div class="summary-total">
                                                                <span>Estimated Total</span>
                                                                <strong id="summaryTotal">
                                                                    <c:choose>
                                                                        <c:when test="${not empty selectedService}">
                                                                            <fmt:formatNumber
                                                                                value="${selectedService.price}"
                                                                                type="number" /> VND
                                                                        </c:when>
                                                                        <c:otherwise>0 VND</c:otherwise>
                                                                    </c:choose>
                                                                </strong>
                                                            </div>
                                                            <div class="summary-status">
                                                                <span>Booking Status <b>CONFIRMED</b></span>
                                                                <span>Payment Status <b>UNPAID</b></span>
                                                            </div>
                                                            <button id="confirmBooking" class="confirm-button"
                                                                type="submit" disabled>
                                                                Confirm Booking →
                                                            </button>
                                                        </aside>
                                                    </div>
                                                </form>
                                            </main>
                                        </div>

                                        <script>
                                            (function () {
                                                var form = document.getElementById('bookingForm');
                                                var bookingDate = document.getElementById('bookingDate');
                                                var selectedTime = document.getElementById('selectedTime');
                                                var timeGrid = document.getElementById('timeGrid');
                                                var confirmButton = document.getElementById('confirmBooking');

                                                function selectedInput(name) {
                                                    return form.querySelector('input[name="' + name + '"]:checked');
                                                }

                                                function updateCardSelection(name) {
                                                    form.querySelectorAll('input[name="' + name + '"]').forEach(function (input) {
                                                        input.closest('label').classList.toggle('selected', input.checked);
                                                    });
                                                }

                                                function updateSummary() {
                                                    var vehicle = selectedInput('vehicleId');
                                                    var service = selectedInput('serviceId');

                                                    document.getElementById('summaryVehicle').textContent =
                                                        vehicle ? vehicle.dataset.name : 'Not selected';
                                                    document.getElementById('summaryVehicleDetail').textContent =
                                                        vehicle ? vehicle.dataset.detail : '';
                                                    document.getElementById('summaryService').textContent =
                                                        service ? service.dataset.name : 'Not selected';
                                                    document.getElementById('summaryServiceDetail').textContent =
                                                        service ? service.dataset.duration + ' mins' : '';
                                                    document.getElementById('summaryDate').textContent =
                                                        bookingDate.value || 'Not selected';
                                                    document.getElementById('summaryTime').textContent = selectedTime.value || 'Not selected';
                                                    document.getElementById('summaryTotal').textContent = service
                                                        ? Number(service.dataset.price).toLocaleString('en-US') + ' VND'
                                                        : '0 VND';

                                                    confirmButton.disabled = !vehicle || !service
                                                        || !bookingDate.value || !selectedTime.value;
                                                }

                                                function chooseTime(button) {
                                                    timeGrid.querySelectorAll('.time-button').forEach(function (item) {
                                                        item.classList.remove('selected');
                                                        var small = item.querySelector('small');
                                                        if (small) small.textContent = 'Available';
                                                    });
                                                    button.classList.add('selected');
                                                    var small = button.querySelector('small');
                                                    if (small) small.textContent = 'Selected';
                                                    selectedTime.value = button.dataset.time;
                                                    updateSummary();
                                                }

                                                function reloadWithParams() {
                                                    var vehicle = selectedInput('vehicleId');
                                                    var service = selectedInput('serviceId');
                                                    var vehicleId = vehicle ? vehicle.value : '';
                                                    var serviceId = service ? service.value : '';
                                                    var dateVal = bookingDate.value || '';

                                                    var url = '?customerId=${customer.id}'
                                                        + '&vehicleId=' + encodeURIComponent(vehicleId)
                                                        + '&serviceId=' + encodeURIComponent(serviceId)
                                                        + '&bookingDate=' + encodeURIComponent(dateVal);
                                                    window.location.href = url;
                                                }

                                                form.querySelectorAll('input[name="vehicleId"]').forEach(function (input) {
                                                    input.addEventListener('change', function () {
                                                        updateCardSelection('vehicleId');
                                                        updateSummary();
                                                    });
                                                });

                                                form.querySelectorAll('input[name="serviceId"]').forEach(function (input) {
                                                    input.addEventListener('change', function () {
                                                        updateCardSelection('serviceId');
                                                        reloadWithParams();
                                                    });
                                                });

                                                bookingDate.addEventListener('change', reloadWithParams);

                                                timeGrid.querySelectorAll('.time-button').forEach(function (button) {
                                                    button.addEventListener('click', function () {
                                                        chooseTime(button);
                                                    });
                                                });

                                                form.addEventListener('submit', function (event) {
                                                    if (confirmButton.disabled) {
                                                        event.preventDefault();
                                                    }
                                                });

                                                updateCardSelection('vehicleId');
                                                updateCardSelection('serviceId');
                                                updateSummary();
                                            })();
                                        </script>
                                    </c:otherwise>
                        </c:choose>
                    </div>

                </body>

                </html>