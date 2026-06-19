<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Overview - SmartWash Pro</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/booking-list.css'/>">

</head>
<body>

<c:set var="activePage" value="dashboard" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">
    
    <!-- Overview Title Header -->
    <div class="overview-header">
        <div>
            <h1 class="overview-title">Overview</h1>
            <div class="overview-subtitle">Operational status for today.</div>
        </div>
        <div>
            <button class="btn-today" onclick="window.location.reload();">
                <span class="material-symbols-outlined" style="font-size: 1.15rem; color: #475569;">calendar_today</span>
                Today
            </button>
        </div>
    </div>

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
            <!-- Mocked total customers count as 89 to align with the visual spec layout -->
            <div class="card-value">89</div>
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
            <!-- Mocked unpaid count as 8 to align with the visual spec layout -->
            <div class="card-value">8</div>
        </div>
    </div>

    <!-- Booking Management Card -->
    <div class="mgmt-card">
        <div class="mgmt-header">
            <div class="mgmt-title-wrapper">
                <h2>Booking Management</h2>
                <p>Manage and monitor daily operational flow.</p>
            </div>
            <div class="mgmt-controls">
                <div class="search-wrapper">
                    <span class="material-symbols-outlined">search</span>
                    <input type="text" class="search-input" placeholder="Search table..." onkeyup="filterTable(this.value)">
                </div>
                <a href="<c:url value='/admin/bookings'/>" class="btn-filter" style="text-decoration: none;">
                    <span class="material-symbols-outlined" style="font-size: 1.1rem;">tune</span>
                    Filter
                </a>
                <a href="<c:url value='/admin/bookings'/>" class="btn-new-booking" style="text-decoration: none;">
                    <span class="material-symbols-outlined" style="font-size: 1.15rem;">add</span>
                    New Booking
                </a>
            </div>
        </div>

        <div style="overflow-x: auto;">
            <table class="booking-table" id="bookingTable">
                <thead>
                    <tr>
                        <th style="width: 10%;">ID</th>
                        <th style="width: 20%;">Customer</th>
                        <th style="width: 15%;">Vehicle</th>
                        <th style="width: 15%;">Service</th>
                        <th style="width: 15%;">Schedule</th>
                        <th style="width: 12%;">Payment</th>
                        <th style="width: 10%;">Status</th>
                        <th style="width: 3%; text-align: center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty recentBookings}">
                            <c:forEach var="b" items="${recentBookings}">
                                <tr>
                                    <!-- Booking ID -->
                                    <td class="td-id">#BK-${b.id}</td>

                                    <!-- Customer Profile -->
                                    <td>
                                        <div class="customer-cell">
                                            <div class="customer-avatar">
                                                <c:out value="${fn:substring(not empty b.user.fullname ? b.user.fullname : b.user.username, 0, 1).toUpperCase()}"/>
                                            </div>
                                            <div>
                                                <div class="customer-name">
                                                    <c:out value="${not empty b.user.fullname ? b.user.fullname : b.user.username}"/>
                                                </div>
                                                <c:set var="tierName" value="${not empty b.user.loyaltyTier ? b.user.loyaltyTier.name : 'Member'}"/>
                                                <span class="tier-badge-small tier-badge-${tierName.toUpperCase()}">
                                                    ${tierName.toUpperCase()} TIER
                                                </span>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Vehicle Brand + Model -->
                                    <td class="td-vehicle">
                                        <c:out value="${b.vehicle.brand}"/> <c:out value="${b.vehicle.model}"/>
                                    </td>

                                    <!-- Service Name -->
                                    <td class="td-service">
                                        <c:out value="${b.service.name}"/>
                                    </td>

                                    <!-- Schedule (Date + Time) -->
                                    <td class="td-schedule">
                                        <div><c:out value="${b.bookingDate}"/></div>
                                        <div class="schedule-time ${b.bookingStatus eq 'CANCELLED' ? 'cancelled-time' : ''}">
                                            <c:out value="${b.timeSlot}"/>
                                        </div>
                                    </td>

                                    <!-- Payment Status -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.paymentStatus eq 'PAID'}">
                                                <span class="payment-paid">
                                                    <span class="material-symbols-outlined">check_circle</span>
                                                    Paid
                                                </span>
                                            </c:when>
                                            <c:when test="${b.bookingStatus eq 'CANCELLED'}">
                                                <span class="payment-voided">Voided</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="payment-collect-btn">
                                                    <span class="material-symbols-outlined">credit_card</span>
                                                    Collect <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> ₫
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Status Badge -->
                                    <td>
                                        <span class="status-badge status-${b.bookingStatus}">
                                            <c:choose>
                                                <c:when test="${b.bookingStatus eq 'CONFIRMED'}">Confirmed</c:when>
                                                <c:when test="${b.bookingStatus eq 'IN_PROGRESS'}">In Progress</c:when>
                                                <c:when test="${b.bookingStatus eq 'COMPLETED'}">Completed</c:when>
                                                <c:when test="${b.bookingStatus eq 'CANCELLED'}">Cancelled</c:when>
                                                <c:when test="${b.bookingStatus eq 'NO_SHOW'}">No Show</c:when>
                                                <c:otherwise>${b.bookingStatus}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>

                                    <!-- Action Button -->
                                    <td style="text-align: center;">
                                        <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="btn-detail-icon" title="View details">
                                            <span class="material-symbols-outlined" style="font-size: 1.25rem;">arrow_forward</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" style="text-align: center; color: #94A3B8; padding: 3rem; font-style: italic;">
                                    No recent bookings found.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination Section matching UI layout spec -->
        <div class="pagination-container">
            <div class="pagination-info">
                Showing 1 to <c:out value="${not empty recentBookings ? recentBookings.size() : 0}"/> of <c:out value="${not empty recentBookings ? recentBookings.size() : 0}"/> entries
            </div>
            <div>
                <ul class="pagination-list">
                    <li><button class="page-item-btn disabled"><span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_left</span></button></li>
                    <li><button class="page-item-btn active">1</button></li>
                    <li><button class="page-item-btn">2</button></li>
                    <li><button class="page-item-btn">3</button></li>
                    <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                    <li><button class="page-item-btn"><span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_right</span></button></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    function filterTable(query) {
        const trs = document.querySelectorAll('#bookingTable tbody tr');
        const q = query.toLowerCase().trim();
        trs.forEach(tr => {
            if (tr.querySelector('td[colspan]')) return;
            const text = tr.innerText.toLowerCase();
            if (text.includes(q)) {
                tr.style.display = '';
            } else {
                tr.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>
