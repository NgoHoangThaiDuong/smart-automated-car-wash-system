<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings - SmartWash Pro</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/booking-list.css'/>">

</head>
<body>

<!-- Sticky Top Navbar -->
<c:set var="activePage" value="bookings" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">
    
    <!-- Overview Header -->
    <div class="overview-header">
        <div>
            <h1 class="overview-title">Bookings</h1>
            <div class="overview-subtitle">Manage and monitor daily operational flow.</div>
        </div>
    </div>

    <!-- Search and Filter Card -->
    <div class="filter-card">
        <form method="GET" action="<c:url value='/admin/bookings'/>" style="margin: 0;">
            <div class="filter-form-grid">
                <!-- Search -->
                <div class="search-input-wrapper">
                    <span class="material-symbols-outlined">search</span>
                    <input id="search" name="search" type="text" placeholder="Tìm kiếm (Mã đặt lịch, tên KH, biển số...)" class="search-input-field" value="<c:out value='${search}'/>">
                </div>
                
                <!-- Status -->
                <select id="statusFilter" name="status" class="filter-select-field">
                    <option value="">-- Tất cả trạng thái --</option>
                    <option value="CONFIRMED" <c:if test="${selectedStatus eq 'CONFIRMED'}">selected</c:if>>Confirmed (Đã xác nhận)</option>
                    <option value="IN_PROGRESS" <c:if test="${selectedStatus eq 'IN_PROGRESS'}">selected</c:if>>In Progress (Đang rửa)</option>
                    <option value="COMPLETED" <c:if test="${selectedStatus eq 'COMPLETED'}">selected</c:if>>Completed (Hoàn thành)</option>
                    <option value="CANCELLED" <c:if test="${selectedStatus eq 'CANCELLED'}">selected</c:if>>Cancelled (Đã hủy)</option>
                    <option value="NO_SHOW" <c:if test="${selectedStatus eq 'NO_SHOW'}">selected</c:if>>No Show (Không đến)</option>
                </select>

                <!-- Date -->
                <input id="dateFilter" name="date" type="date" class="filter-date-field" value="<c:out value='${date}'/>">

                <!-- Submit and Clear Buttons -->
                <button type="submit" class="btn-submit-filter">
                    <span class="material-symbols-outlined" style="font-size: 1.15rem;">tune</span> Filter
                </button>
                <a href="<c:url value='/admin/bookings'/>" class="btn-clear-filter">
                    <span class="material-symbols-outlined" style="font-size: 1.15rem;">restart_alt</span> Reset
                </a>
            </div>
        </form>
    </div>

    <!-- Booking Table Card -->
    <div class="mgmt-card">
        <div class="mgmt-header">
            <h2 class="mgmt-title">Booking List</h2>
            <div style="font-size: 0.85rem; color: #64748B; font-weight: 500;">
                Found <strong style="color: #0F172A;"><c:out value="${totalEntries != null ? totalEntries : 0}"/></strong> bookings matching filters.
            </div>
        </div>

        <div style="overflow-x: auto;">
            <table class="booking-table">
                <thead>
                    <tr>
                        <th style="width: 10%;">ID</th>
                        <th style="width: 22%;">Customer</th>
                        <th style="width: 15%;">Vehicle</th>
                        <th style="width: 15%;">Service</th>
                        <th style="width: 15%;">Schedule</th>
                        <th style="width: 13%;">Payment</th>
                        <th style="width: 10%;">Status</th>
                        <th style="width: 2%; text-align: center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty bookings}">
                            <tr>
                                <td colspan="8" style="text-align: center; color: #94A3B8; padding: 4rem; font-style: italic;">
                                    No bookings matching filter constraints.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${bookings}">
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
                                                <div class="vehicle-sub" style="font-size: 0.75rem;">
                                                    <c:out value="${b.user.phone != null ? b.user.phone : 'No Phone'}"/>
                                                </div>
                                                <c:set var="tierName" value="${not empty b.user.loyaltyTier ? b.user.loyaltyTier.name : 'Member'}"/>
                                                <span class="tier-badge-small tier-badge-${tierName.toUpperCase()}">
                                                    ${tierName.toUpperCase()} TIER
                                                </span>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Vehicle License Plate + Brand + Color -->
                                    <td>
                                        <div class="td-vehicle"><c:out value="${b.vehicle.licensePlate}"/></div>
                                        <div class="vehicle-sub"><c:out value="${b.vehicle.brand}"/> (<c:out value="${b.vehicle.color}"/>)</div>
                                    </td>

                                    <!-- Service Name + Price -->
                                    <td>
                                        <div class="td-service"><c:out value="${b.service.name}"/></div>
                                        <div class="service-price">
                                            <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> ₫
                                        </div>
                                    </td>

                                    <!-- Schedule (Date + Time) -->
                                    <td class="td-schedule">
                                        <div><c:out value="${b.bookingDate}"/></div>
                                        <div class="schedule-time ${b.bookingStatus eq 'CANCELLED' ? 'cancelled-time' : ''}">
                                            <c:out value="${b.timeSlot}"/>
                                        </div>
                                    </td>

                                    <!-- Payment Badge or Collect Button -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.paymentStatus eq 'PAID'}">
                                                <span class="payment-paid">
                                                    <span class="material-symbols-outlined">check_circle</span>
                                                    Paid
                                                </span>
                                                <div class="vehicle-sub" style="font-size: 0.72rem; margin-top: 0.15rem; font-weight: 600;">
                                                    <c:choose>
                                                        <c:when test="${b.paymentMethod eq 'CASH'}">💵 Cash</c:when>
                                                        <c:when test="${b.paymentMethod eq 'BANK_TRANSFER'}">💳 Transfer</c:when>
                                                        <c:otherwise><c:out value="${b.paymentMethod}"/></c:otherwise>
                                                    </c:choose>
                                                </div>
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

                                    <!-- Detail Action -->
                                    <td style="text-align: center;">
                                        <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="btn-detail-icon" title="View Details">
                                            <span class="material-symbols-outlined" style="font-size: 1.25rem;">arrow_forward</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

            <!-- Pagination section (dynamically reflects the list) -->
            <div class="pagination-container">
                <div class="pagination-info">
                    Showing <c:out value="${startEntry}"/> to <c:out value="${endEntry}"/> of <c:out value="${totalEntries}"/> entries
                </div>
                <div>
                    <ul class="pagination-list">
                        <li>
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <c:url value="/admin/bookings" var="prevUrl">
                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                        <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                        <c:param name="page" value="${currentPage - 1}"/>
                                    </c:url>
                                    <a href="${prevUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">
                                        <span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_left</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="page-item-btn disabled">
                                        <span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_left</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <c:if test="${totalPages > 0}">
                            <c:choose>
                                <%-- If totalPages <= 5, show all pages without any ellipsis --%>
                                <c:when test="${totalPages <= 5}">
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <li>
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <button class="page-item-btn active">${i}</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url value="/admin/bookings" var="pageUrl">
                                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                        <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                        <c:param name="page" value="${i}"/>
                                                    </c:url>
                                                    <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                
                                <%-- If totalPages > 5, apply ellipsis logic --%>
                                <c:otherwise>
                                    <c:choose>
                                        <%-- Case 1: Near the beginning --%>
                                        <c:when test="${currentPage <= 3}">
                                            <c:forEach var="i" begin="1" end="4">
                                                <li>
                                                    <c:choose>
                                                        <c:when test="${i == currentPage}">
                                                            <button class="page-item-btn active">${i}</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:url value="/admin/bookings" var="pageUrl">
                                                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                                <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                                <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                                <c:param name="page" value="${i}"/>
                                                            </c:url>
                                                            <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>
                                            </c:forEach>
                                            <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                            <li>
                                                <c:url value="/admin/bookings" var="pageUrl">
                                                    <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                    <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                    <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                    <c:param name="page" value="${totalPages}"/>
                                                </c:url>
                                                <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${totalPages}</a>
                                            </li>
                                        </c:when>
                                        
                                        <%-- Case 2: Near the end --%>
                                        <c:when test="${currentPage >= totalPages - 2}">
                                            <li>
                                                <c:url value="/admin/bookings" var="pageUrl">
                                                    <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                    <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                    <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                    <c:param name="page" value="1"/>
                                                </c:url>
                                                <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">1</a>
                                            </li>
                                            <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                            <c:forEach var="i" begin="${totalPages - 3}" end="${totalPages}">
                                                <li>
                                                    <c:choose>
                                                        <c:when test="${i == currentPage}">
                                                            <button class="page-item-btn active">${i}</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:url value="/admin/bookings" var="pageUrl">
                                                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                                <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                                <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                                <c:param name="page" value="${i}"/>
                                                            </c:url>
                                                            <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>
                                            </c:forEach>
                                        </c:when>
                                        
                                        <%-- Case 3: In the middle --%>
                                        <c:otherwise>
                                            <li>
                                                <c:url value="/admin/bookings" var="pageUrl">
                                                    <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                    <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                    <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                    <c:param name="page" value="1"/>
                                                </c:url>
                                                <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">1</a>
                                            </li>
                                            <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                            <c:forEach var="i" begin="${currentPage - 1}" end="${currentPage + 1}">
                                                <li>
                                                    <c:choose>
                                                        <c:when test="${i == currentPage}">
                                                            <button class="page-item-btn active">${i}</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:url value="/admin/bookings" var="pageUrl">
                                                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                                <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                                <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                                <c:param name="page" value="${i}"/>
                                                            </c:url>
                                                            <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>
                                            </c:forEach>
                                            <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                            <li>
                                                <c:url value="/admin/bookings" var="pageUrl">
                                                    <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                    <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                    <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                    <c:param name="page" value="${totalPages}"/>
                                                </c:url>
                                                <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${totalPages}</a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <li>
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <c:url value="/admin/bookings" var="nextUrl">
                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                        <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                        <c:param name="page" value="${currentPage + 1}"/>
                                    </c:url>
                                    <a href="${nextUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">
                                        <span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_right</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="page-item-btn disabled">
                                        <span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_right</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </ul>
                </div>
            </div>
    </div>
</div>

</body>
</html>
