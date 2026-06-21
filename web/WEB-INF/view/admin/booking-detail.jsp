<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Detail #<c:out value="${booking.id}"/> - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/booking-detail.css'/>">

</head>
<body>

<!-- Sticky Top Navbar -->
<c:set var="activePage" value="bookings" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">
    
    <!-- Navigation Back Link -->
    <div class="back-nav-row">
        <a href="<c:url value='/admin/bookings'/>" class="back-link-btn">
            <span class="material-symbols-outlined">arrow_back</span>
            Back to Bookings
        </a>
    </div>

    <!-- Page Header Title -->
    <div class="overview-header">
        <h1 class="overview-title">Booking Detail #<c:out value="${booking.id}"/></h1>
        <div class="overview-subtitle">Review customer files, vehicle data, service items, and update workflow status.</div>
    </div>

    <!-- Alert Notifications Session Feedbacks -->
    <c:if test="${not empty sessionScope.adminMsg}">
        <div class="alert-box alert-success">
            <span><c:out value="${sessionScope.adminMsg}"/></span>
            <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
        </div>
        <c:remove var="adminMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.adminError}">
        <div class="alert-box alert-error">
            <span><c:out value="${sessionScope.adminError}"/></span>
            <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
        </div>
        <c:remove var="adminError" scope="session"/>
    </c:if>

    <!-- Details Grid -->
    <div class="detail-grid">
        <!-- Customer Details -->
        <div class="detail-card">
            <h3 class="detail-card-title">
                <span class="material-symbols-outlined">person</span>
                Customer Info
            </h3>
            <div class="detail-row">
                <span class="detail-label">Name</span>
                <span class="detail-value"><c:out value="${not empty booking.user.fullname ? booking.user.fullname : booking.user.username}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Username</span>
                <span class="detail-value" style="font-family: monospace; color: #475569;">@<c:out value="${booking.user.username}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Phone</span>
                <span class="detail-value"><c:out value="${not empty booking.user.phone ? booking.user.phone : 'Not Provided'}"/></span>
            </div>
            <c:if test="${not empty booking.user.loyaltyTier}">
                <div class="detail-row" style="border-top: 1px dashed #E2E8F0; padding-top: 0.75rem;">
                    <span class="detail-label">Loyalty Tier</span>
                    <span class="detail-value" style="color: #0B45BD; font-weight: bold;"><c:out value="${booking.user.loyaltyTier.name}"/> TIER</span>
                </div>
            </c:if>
        </div>

        <!-- Vehicle Details -->
        <div class="detail-card">
            <h3 class="detail-card-title">
                <span class="material-symbols-outlined">directions_car</span>
                Vehicle Info
            </h3>
            <div class="detail-row">
                <span class="detail-label">License Plate</span>
                <span class="license-plate-tag"><c:out value="${booking.vehicle.licensePlate}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Brand</span>
                <span class="detail-value"><c:out value="${booking.vehicle.brand}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Color</span>
                <span class="detail-value"><c:out value="${booking.vehicle.color}"/></span>
            </div>
        </div>

        <!-- Service & Appointment Details -->
        <div class="detail-card">
            <h3 class="detail-card-title">
                <span class="material-symbols-outlined">design_services</span>
                Service & Slot
            </h3>
            <div class="detail-row">
                <span class="detail-label">Service Plan</span>
                <span class="detail-value" style="color: #0B45BD;"><c:out value="${booking.service.name}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Wash Date</span>
                <span class="detail-value"><c:out value="${booking.formattedBookingDate}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Time Slot</span>
                <span class="detail-value" style="font-weight: 800; color: #0B45BD;">${booking.timeSlot}</span>
            </div>
            <div class="detail-row" style="border-top: 1px dashed #CBD5E1; padding-top: 0.75rem; margin-top: 0.25rem;">
                <span class="detail-label" style="font-weight: 800; color: #0F172A;">Total Amount</span>
                <span class="detail-value" style="font-size: 1.15rem; font-weight: 800; color: #0B45BD;">
                    <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/> ₫
                </span>
            </div>
        </div>

        <!-- Booking Status Details -->
        <div class="detail-card">
            <h3 class="detail-card-title">
                <span class="material-symbols-outlined">info</span>
                Order Status
            </h3>
            <div class="detail-row">
                <span class="detail-label">Booking Status</span>
                <span class="status-badge status-${booking.bookingStatus}">
                    <c:choose>
                        <c:when test="${booking.bookingStatus eq 'CONFIRMED'}">Confirmed</c:when>
                        <c:when test="${booking.bookingStatus eq 'IN_PROGRESS'}">In Progress</c:when>
                        <c:when test="${booking.bookingStatus eq 'COMPLETED'}">Completed</c:when>
                        <c:when test="${booking.bookingStatus eq 'CANCELLED'}">Cancelled</c:when>
                        <c:when test="${booking.bookingStatus eq 'NO_SHOW'}">No Show</c:when>
                        <c:otherwise>${booking.bookingStatus}</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Payment</span>
                <span class="payment-badge payment-${booking.paymentStatus}">
                    <c:choose>
                        <c:when test="${booking.paymentStatus eq 'PAID'}">Paid</c:when>
                        <c:otherwise>Unpaid</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Created At</span>
                <span class="detail-value" style="font-size: 0.8rem; color: #475569;"><fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
            </div>
            <c:if test="${not empty booking.completedAt}">
                <div class="detail-row">
                    <span class="detail-label">Finished At</span>
                    <span class="detail-value" style="color: #047857; font-size: 0.8rem;"><fmt:formatDate value="${booking.completedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
            </c:if>
            <c:if test="${booking.pointsEarned > 0}">
                <div class="detail-row" style="border-top: 1px dashed #E2E8F0; padding-top: 0.5rem;">
                    <span class="detail-label font-bold">Points Earned</span>
                    <span class="detail-value" style="color: #7C3AED; font-weight: 700;">+<c:out value="${booking.pointsEarned}"/> pts</span>
                </div>
            </c:if>
        </div>
    </div>


    <!-- Actions Control Panel Grid -->
    <div class="actions-panel-grid">
        
        <!-- Payment Collecting Section -->
        <c:choose>
            <c:when test="${booking.paymentStatus ne 'PAID' and booking.bookingStatus ne 'CANCELLED'}">
                <div class="action-box action-box-blue">
                    <h3 class="action-box-title">Collect Payment</h3>
                    <p class="action-box-desc">Choose the physical transaction method selected by the user to confirm billing collection.</p>
                    
                    <form method="POST" action="<c:url value='/admin/bookings/collect-payment'/>" style="margin: 0;">
                        <input type="hidden" name="bookingId" value="<c:out value='${booking.id}'/>">
                        <div>
                            <label for="paymentMethod" class="form-label">Payment Method</label>
                            <select id="paymentMethod" name="paymentMethod" class="select-field">
                                <option value="CASH">💵 Cash Payment</option>
                                <option value="BANK_TRANSFER">💳 Bank Wire Transfer</option>
                            </select>
                        </div>
                        <button type="submit" class="btn-submit-action">
                            <span class="material-symbols-outlined">payments</span>
                            Confirm Payment Collected
                        </button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <div class="action-box" style="display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; background: #F8FAFC; border-style: dashed; padding: 2rem 1.5rem;">
                    <span class="material-symbols-outlined" style="font-size: 3rem; color: #94A3B8; margin-bottom: 0.75rem;">check_circle</span>
                    <h4 style="margin: 0 0 0.25rem 0; font-size: 0.95rem; font-weight: 700; color: #334155;">Payment Settled</h4>
                    <p style="margin: 0; font-size: 0.8rem; color: #64748B;">No further payment transaction actions are needed for this booking.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Status Workflow Controls Section -->
        <c:choose>
            <c:when test="${booking.bookingStatus ne 'COMPLETED' and booking.bookingStatus ne 'CANCELLED' and booking.bookingStatus ne 'NO_SHOW'}">
                <div class="action-box">
                    <h3 class="action-box-title">Workflow State</h3>
                    <p class="action-box-desc">Transit the slot status across operational states. Note: Completion requires paid settlements.</p>
                    
                    <form method="POST" action="<c:url value='/admin/bookings/update-status'/>" style="margin: 0;">
                        <input type="hidden" name="bookingId" value="<c:out value='${booking.id}'/>">
                        <div class="status-buttons-column">
                            <c:if test="${booking.bookingStatus eq 'CONFIRMED'}">
                                <button type="submit" name="newStatus" value="IN_PROGRESS" class="btn-status-action btn-status-inprogress">
                                    <span class="material-symbols-outlined">local_car_wash</span> Start Washing Car
                                </button>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
                                    <button type="submit" name="newStatus" value="NO_SHOW" class="btn-status-action btn-status-noshow" onclick="return confirm('Confirm customer failed to show up?')">
                                        <span class="material-symbols-outlined">person_off</span> No Show
                                    </button>
                                    <button type="submit" name="newStatus" value="CANCELLED" class="btn-status-action btn-status-cancel" onclick="return confirm('Confirm cancellation for this appointment?')">
                                        <span class="material-symbols-outlined">cancel</span> Cancel
                                    </button>
                                </div>
                            </c:if>
                            <c:if test="${booking.bookingStatus eq 'IN_PROGRESS'}">
                                <button type="submit" name="newStatus" value="COMPLETED" class="btn-status-action btn-status-complete" onclick="return confirm('Mark car wash service as fully completed? (Requires Paid status)')">
                                    <span class="material-symbols-outlined">task_alt</span> Complete Wash Service
                                </button>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
                                    <button type="submit" name="newStatus" value="NO_SHOW" class="btn-status-action btn-status-noshow" onclick="return confirm('Confirm customer failed to show up?')">
                                        <span class="material-symbols-outlined">person_off</span> No Show
                                    </button>
                                    <button type="submit" name="newStatus" value="CANCELLED" class="btn-status-action btn-status-cancel" onclick="return confirm('Confirm cancellation for this appointment?')">
                                        <span class="material-symbols-outlined">cancel</span> Cancel
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <div class="action-box" style="display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; background: #F8FAFC; border-style: dashed; padding: 2rem 1.5rem;">
                    <span class="material-symbols-outlined" style="font-size: 3rem; color: #94A3B8; margin-bottom: 0.75rem;">lock</span>
                    <h4 style="margin: 0 0 0.25rem 0; font-size: 0.95rem; font-weight: 700; color: #334155;">Workflow Closed</h4>
                    <p style="margin: 0; font-size: 0.8rem; color: #64748B;">This order is already in a terminal state (Completed/Cancelled/No Show).</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

</body>
</html>
