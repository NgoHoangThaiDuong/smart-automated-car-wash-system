<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Detail - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/components/booking-table.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/customers.css'/>">
</head>
<body>

<!-- Sticky Top Navbar -->
<c:set var="activePage" value="customers" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">
    
    <!-- Page Header & Breadcrumbs -->
    <div class="page-header-container">
        <div class="breadcrumb-trail">
            <a href="<c:url value='/admin/dashboard'/>">Dashboard</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <a href="<c:url value='/admin/customers'/>">Customers</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <span style="font-weight: 700;"><c:out value="${customer.fullname}"/></span>
        </div>
        <div class="header-action-row">
            <div>
                <h1 class="page-title">Customer Profile</h1>
            </div>
            <div>
                <a href="<c:url value='/admin/customers'/>" class="btn-admin-secondary" style="text-decoration: none;">
                    <span class="material-symbols-outlined">arrow_back</span>
                    Back to List
                </a>
            </div>
        </div>
    </div>

    <!-- Alert Notifications Session Feedbacks -->
    <c:if test="${not empty sessionScope.adminMsg}">
        <div class="alert-box alert-success" style="margin-bottom: 1.5rem;">
            <span><c:out value="${sessionScope.adminMsg}"/></span>
            <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
        </div>
        <c:remove var="adminMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.adminError}">
        <div class="alert-box alert-error" style="margin-bottom: 1.5rem;">
            <span><c:out value="${sessionScope.adminError}"/></span>
            <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
        </div>
        <c:remove var="adminError" scope="session"/>
    </c:if>

    <!-- Main Detail Grid layout -->
    <div class="detail-grid">
        
        <!-- Left Column: Profile Card & Actions & Vehicles -->
        <div>
            <div class="profile-card">
                <!-- Large Avatar using first letter of fullname -->
                <div class="large-avatar">
                    <c:out value="${fn:substring(customer.fullname, 0, 1).toUpperCase()}"/>
                </div>
                
                <div class="profile-name"><c:out value="${customer.fullname}"/></div>
                <div class="profile-username">@<c:out value="${customer.username}"/></div>
                
                <!-- Status Badge -->
                <span class="tier-badge tier-${not empty customer.loyaltyTier ? customer.loyaltyTier.name : 'Member'}">
                    <c:out value="${not empty customer.loyaltyTier ? customer.loyaltyTier.name : 'Member'}"/>
                </span>

                <!-- Profile Info Details -->
                <div class="profile-info-list">
                    <div class="info-item">
                        <span class="material-symbols-outlined info-item-icon">phone</span>
                        <div class="info-item-content">
                            <span class="info-label">Phone Number</span>
                            <span class="info-value"><c:out value="${not empty customer.phone ? customer.phone : 'Not updated'}"/></span>
                        </div>
                    </div>
                    <div class="info-item">
                        <span class="material-symbols-outlined info-item-icon">calendar_month</span>
                        <div class="info-item-content">
                            <span class="info-label">Joined Date</span>
                            <span class="info-value">
                                <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy"/>
                            </span>
                        </div>
                    </div>
                    <div class="info-item">
                        <span class="material-symbols-outlined info-item-icon">shield</span>
                        <div class="info-item-content">
                            <span class="info-label">Account Status</span>
                            <span class="info-value" style="color: ${customer.deleted ? '#EF4444' : '#10B981'};">
                                <c:choose>
                                    <c:when test="${customer.deleted}">Banned</c:when>
                                    <c:otherwise>Active</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Vehicles List -->
                <div class="vehicles-section">
                    <h3 class="vehicles-title">
                        <span class="material-symbols-outlined" style="font-size: 1.25rem;">directions_car</span>
                        Registered Vehicles (${fn:length(vehicles)})
                    </h3>
                    <c:choose>
                        <c:when test="${not empty vehicles}">
                            <c:forEach var="v" items="${vehicles}">
                                <div class="vehicle-pill">
                                    <div class="vehicle-details">
                                        <span class="vehicle-plate"><c:out value="${v.licensePlate}"/></span>
                                        <span class="vehicle-model"><c:out value="${v.brand}"/> - <c:out value="${v.model}"/> (${v.color})</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="font-size: 0.875rem; color: var(--text-slate-muted); font-style: italic; margin: 0.5rem 0;">No vehicles registered.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Ban / Unban actions button block -->
                <div class="profile-actions">
                    <c:choose>
                        <c:when test="${customer.deleted}">
                            <!-- Banned account, click to Unban -->
                            <form action="<c:url value='/admin/customers/ban'/>" method="POST" onsubmit="return confirm('Are you sure you want to unban this customer account?')">
                                <input type="hidden" name="customerId" value="${customer.id}">
                                <input type="hidden" name="ban" value="false">
                                <button type="submit" class="btn-ban-action state-banned" title="Click to unban account">
                                    <span class="material-symbols-outlined" style="font-size: 1.15rem;">lock_open</span>
                                    <span class="btn-text-normal">Banned</span>
                                    <span class="btn-text-hover">Unban</span>
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <!-- Active account, click to Ban -->
                            <form action="<c:url value='/admin/customers/ban'/>" method="POST" onsubmit="return confirm('Are you sure you want to ban this customer account? The user will not be able to log in or book appointments!')">
                                <input type="hidden" name="customerId" value="${customer.id}">
                                <input type="hidden" name="ban" value="true">
                                <button type="submit" class="btn-ban-action state-unbanned" title="Click to ban account">
                                    <span class="material-symbols-outlined" style="font-size: 1.15rem;">block</span>
                                    <span>Ban</span>
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Reset Password form block -->
                <div class="vehicles-section" style="margin-top: 1.5rem; border-top: 1px solid #f1f5f9; padding-top: 1.5rem;">
                    <h3 class="vehicles-title" style="margin-bottom: 0.75rem;">
                        <span class="material-symbols-outlined" style="font-size: 1.25rem; color: #EF4444;">lock_open</span>
                        Customer Password
                    </h3>
                    <form action="<c:url value='/admin/customers/reset-password'/>" method="POST" onsubmit="return confirm('Are you sure you want to reset this customer password to default (123456)?')">
                        <input type="hidden" name="customerId" value="${customer.id}">
                        <button type="submit" class="btn-admin-secondary" 
                                style="width: 100%; justify-content: center; background-color: #EF4444; color: #ffffff; border: none; padding: 0.6rem; border-radius: 8px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 0.25rem; text-decoration: none;">
                            <span class="material-symbols-outlined" style="font-size: 1.15rem;">lock_reset</span>
                            Reset Password (123456)
                        </button>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Right Column: Bento Stats Cards & Lists of Bookings -->
        <div>
            <!-- Stats Bento Cards Row -->
            <div class="stats-cards-row">
                <!-- Lifetime Spent -->
                <div class="detail-stats-card">
                    <span class="detail-stats-label">Total Spent</span>
                    <div class="detail-stats-value" style="color: #10B981;">
                        <fmt:formatNumber value="${stats.lifetimeSpent}" type="number" groupingUsed="true"/> ₫
                    </div>
                </div>
                <!-- Wash Count -->
                <div class="detail-stats-card">
                    <span class="detail-stats-label">Wash Count</span>
                    <div class="detail-stats-value"><c:out value="${stats.totalWashes}"/></div>
                </div>
                <!-- Loyalty Points -->
                <div class="detail-stats-card">
                    <span class="detail-stats-label">Loyalty Points</span>
                    <div class="detail-stats-value" style="color: var(--primary);">
                        <fmt:formatNumber value="${stats.pointsBalance}" type="number" groupingUsed="true"/> pts
                    </div>
                </div>
            </div>

            <!-- Section: Upcoming Bookings -->
            <div class="detail-section-card">
                <h3 class="detail-section-title">
                    <span class="material-symbols-outlined" style="color: var(--primary);">schedule</span>
                    Upcoming Bookings
                </h3>
                <div style="overflow-x: auto;">
                    <table class="booking-table" style="font-size: 0.875rem;">
                        <thead>
                            <tr>
                                <th>Service</th>
                                <th>License Plate</th>
                                <th>Schedule</th>
                                <th style="text-align: right;">Amount</th>
                                <th style="text-align: center;">Status</th>
                                <th style="text-align: center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasUpcoming" value="false"/>
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.bookingStatus eq 'PENDING' || b.bookingStatus eq 'CONFIRMED'}">
                                    <c:set var="hasUpcoming" value="true"/>
                                    <tr>
                                        <td style="font-weight: 600;"><c:out value="${b.service.name}"/></td>
                                        <td style="font-family: monospace; font-weight: 700; color: #475569;"><c:out value="${b.vehicle.licensePlate}"/></td>
                                        <td>
                                            <c:out value="${b.bookingDate}"/>
                                            <span style="color: #64748B; font-size: 0.75rem; display: block;"><c:out value="${b.timeSlot}"/></span>
                                        </td>
                                        <td style="text-align: right; font-weight: 700; color: #1E293B;">
                                            <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td style="text-align: center;">
                                            <span class="status-badge status-${b.bookingStatus}">
                                                <c:out value="${b.bookingStatus}"/>
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="btn-detail-icon" title="View booking details">
                                                <span class="material-symbols-outlined" style="font-size: 1.15rem;">arrow_forward</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasUpcoming}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #94A3B8; padding: 2rem; font-style: italic;">No upcoming bookings.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Section: Wash History -->
            <div class="detail-section-card">
                <h3 class="detail-section-title">
                    <span class="material-symbols-outlined" style="color: #10B981;">history</span>
                    Wash History
                </h3>
                <div style="overflow-x: auto;">
                    <table class="booking-table" style="font-size: 0.875rem;">
                        <thead>
                            <tr>
                                <th>Service</th>
                                <th>License Plate</th>
                                <th>Schedule</th>
                                <th style="text-align: right;">Amount</th>
                                <th style="text-align: center;">Status</th>
                                <th style="text-align: center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasHistory" value="false"/>
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.bookingStatus ne 'PENDING' && b.bookingStatus ne 'CONFIRMED'}">
                                    <c:set var="hasHistory" value="true"/>
                                    <tr>
                                        <td style="font-weight: 600;"><c:out value="${b.service.name}"/></td>
                                        <td style="font-family: monospace; font-weight: 700; color: #475569;"><c:out value="${b.vehicle.licensePlate}"/></td>
                                        <td>
                                            <c:out value="${b.bookingDate}"/>
                                            <span style="color: #64748B; font-size: 0.75rem; display: block;"><c:out value="${b.timeSlot}"/></span>
                                        </td>
                                        <td style="text-align: right; font-weight: 700; color: #1E293B;">
                                            <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td style="text-align: center;">
                                            <span class="status-badge status-${b.bookingStatus}">
                                                <c:out value="${b.bookingStatus}"/>
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="btn-detail-icon" title="View booking details">
                                                <span class="material-symbols-outlined" style="font-size: 1.15rem;">arrow_forward</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasHistory}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #94A3B8; padding: 2rem; font-style: italic;">No wash history.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            
        </div>
    </div>
</div>

</body>
</html>
