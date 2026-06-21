<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="<c:url value='/css/admin/components/booking-table.css'/>">

<!-- Shared Search and Filter Card -->
<div class="filter-card">
    <form method="GET" action="<c:url value='${paginationBaseUrl}'/>" style="margin: 0;">
        <div class="filter-form-grid">
            <!-- Search -->
            <div class="search-input-wrapper">
                <span class="material-symbols-outlined">search</span>
                <input id="search" name="search" type="text" placeholder="Tìm kiếm (Mã đặt lịch, tên KH, biển số...)" class="search-input-field" value="<c:out value='${search}'/>">
            </div>
            
            <!-- Status -->
            <select id="statusFilter" name="status" class="filter-select-field">
                <option value="">-- Tất cả trạng thái --</option>
                <c:forEach var="entry" items="${bookingStatuses}">
                    <option value="${entry.key}" <c:if test="${selectedStatus eq entry.key}">selected</c:if>>
                        <c:out value="${entry.value}"/>
                    </option>
                </c:forEach>
            </select>

            <!-- Date -->
            <input id="dateFilter" name="date" type="date" class="filter-date-field" value="<c:out value='${date}'/>">

            <!-- Sort By -->
            <select id="sortBy" name="sortBy" class="filter-select-field">
                <option value="created_desc" <c:if test="${empty sortBy or sortBy eq 'created_desc'}">selected</c:if>>Mới tạo gần nhất</option>
                <option value="created_asc" <c:if test="${sortBy eq 'created_asc'}">selected</c:if>>Mới tạo xa nhất</option>
                <option value="date_desc" <c:if test="${sortBy eq 'date_desc'}">selected</c:if>>Ngày đặt (Mới -> Cũ)</option>
                <option value="date_asc" <c:if test="${sortBy eq 'date_asc'}">selected</c:if>>Ngày đặt (Cũ -> Mới)</option>
                <option value="amount_desc" <c:if test="${sortBy eq 'amount_desc'}">selected</c:if>>Tổng tiền (Cao -> Thấp)</option>
                <option value="amount_asc" <c:if test="${sortBy eq 'amount_asc'}">selected</c:if>>Tổng tiền (Thấp -> Cao)</option>
            </select>

            <!-- Submit Button -->
            <button type="submit" class="btn-submit-filter">
                <span class="material-symbols-outlined" style="font-size: 1.15rem;">tune</span> Filter
            </button>
        </div>
    </form>
</div>

<!-- Booking Table Card -->
<div class="mgmt-card">

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
                    <c:when test="${not empty bookings}">
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
                                    <div><c:out value="${b.formattedBookingDate}"/></div>
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
                                            <button type="button" 
                                                    class="payment-collect-btn js-collect-payment-btn" 
                                                    onclick="openCheckoutModal(this)"
                                                    data-id="${b.id}"
                                                    data-customer-name="<c:out value='${not empty b.user.fullname ? b.user.fullname : b.user.username}'/>"
                                                    data-customer-tier="${tierName}"
                                                    data-vehicle-model="<c:out value='${b.vehicle.brand} ${b.vehicle.model}'/>"
                                                    data-vehicle-plate="<c:out value='${b.vehicle.licensePlate}'/>"
                                                    data-service-name="<c:out value='${b.service.name}'/>"
                                                    data-service-duration="${b.service.durationMinutes}"
                                                    data-total-amount="<fmt:formatNumber value='${b.totalAmount}' type='number' groupingUsed='true'/>">
                                                <span class="material-symbols-outlined">credit_card</span>
                                                Collect <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> ₫
                                            </button>
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
                                No bookings found.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Pagination Section matching UI layout spec -->
    <div class="pagination-container">
        <div class="pagination-wrapper">
            <ul class="pagination-list">
                <li>
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <c:url value="${paginationBaseUrl}" var="prevUrl">
                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
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
                                            <c:url value="${paginationBaseUrl}" var="pageUrl">
                                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
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
                                                    <c:url value="${paginationBaseUrl}" var="pageUrl">
                                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                        <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                        <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                        <c:param name="page" value="${i}"/>
                                                    </c:url>
                                                    <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </c:forEach>
                                    <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                    <li>
                                        <c:url value="${paginationBaseUrl}" var="pageUrl">
                                            <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                            <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                            <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                            <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                            <c:param name="page" value="${totalPages}"/>
                                        </c:url>
                                        <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${totalPages}</a>
                                    </li>
                                </c:when>
                                
                                <%-- Case 2: Near the end --%>
                                <c:when test="${currentPage >= totalPages - 2}">
                                    <li>
                                        <c:url value="${paginationBaseUrl}" var="pageUrl">
                                            <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                            <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                            <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                            <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
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
                                                    <c:url value="${paginationBaseUrl}" var="pageUrl">
                                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                        <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                        <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
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
                                        <c:url value="${paginationBaseUrl}" var="pageUrl">
                                            <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                            <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                            <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                            <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
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
                                                    <c:url value="${paginationBaseUrl}" var="pageUrl">
                                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                                        <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                                        <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                        <c:param name="page" value="${i}"/>
                                                    </c:url>
                                                    <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </c:forEach>
                                    <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                    <li>
                                        <c:url value="${paginationBaseUrl}" var="pageUrl">
                                            <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                            <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                            <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                            <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
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
                                    <c:url value="${paginationBaseUrl}" var="nextUrl">
                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                        <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                                        <c:if test="${not empty date}"><c:param name="date" value="${date}"/></c:if>
                                        <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
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

<!-- Payment Checkout Modal (Khớp 100% hình 2) -->
<div id="paymentCheckoutModal" class="checkout-modal">
    <div class="checkout-modal-content">
        <div class="checkout-modal-header">
            <h2>Payment Checkout</h2>
            <button type="button" class="checkout-modal-close" onclick="closeCheckoutModal()">&times;</button>
        </div>
        
        <form id="checkoutPaymentForm" method="POST" action="<c:url value='/admin/bookings/collect-payment'/>">
            <input type="hidden" name="bookingId" id="checkoutBookingId">
            <input type="hidden" name="redirect" value="list">
            
            <div class="checkout-card">
                <div class="checkout-booking-title">
                    Booking <span id="checkoutBookingRef">#SW-8942</span>
                </div>
                
                <div class="checkout-info-grid">
                    <div class="checkout-info-col">
                        <div class="checkout-info-label">CUSTOMER</div>
                        <div class="checkout-info-value" id="checkoutCustomerName">Michael Chen</div>
                        <div>
                            <span class="tier-badge-small" id="checkoutCustomerTier">GOLD TIER</span>
                        </div>
                    </div>
                    <div class="checkout-info-col">
                        <div class="checkout-info-label">VEHICLE</div>
                        <div class="checkout-info-value" id="checkoutVehicleModel">Tesla Model 3</div>
                        <div class="checkout-info-sub" id="checkoutVehiclePlate">CA-XYZ789</div>
                    </div>
                </div>
                
                <div class="checkout-divider"></div>
                
                <div class="checkout-service-row">
                    <div class="checkout-service-left">
                        <div class="checkout-service-name" id="checkoutServiceName">Premium Detail Wash</div>
                        <div class="checkout-service-duration">
                            <span class="material-symbols-outlined" style="font-size: 0.9rem; margin-right: 2px;">schedule</span>
                            <span id="checkoutServiceDuration">90 mins</span>
                        </div>
                    </div>
                    <div class="checkout-service-price">
                        <span id="checkoutTotalAmount">1,200,000</span> ₫
                    </div>
                </div>
                
                <div class="checkout-payment-section">
                    <div class="checkout-payment-title">Payment Method</div>
                    
                    <div class="payment-options">
                        <label class="payment-option-card active" id="paymentCardCASH">
                            <input type="radio" name="paymentMethod" value="CASH" checked onclick="selectPaymentMethod(this)">
                            <div class="payment-option-content">
                                <span class="custom-radio"></span>
                                <span class="material-symbols-outlined payment-icon">payments</span>
                                <span class="payment-text">Cash</span>
                            </div>
                        </label>
                        
                        <label class="payment-option-card" id="paymentCardBANK">
                            <input type="radio" name="paymentMethod" value="BANK_TRANSFER" onclick="selectPaymentMethod(this)">
                            <div class="payment-option-content">
                                <span class="custom-radio"></span>
                                <span class="material-symbols-outlined payment-icon">account_balance</span>
                                <span class="payment-text">Banking</span>
                            </div>
                        </label>
                    </div>
                </div>
                
                <button type="submit" class="btn-confirm-payment">Confirm Payment</button>
            </div>
        </form>
    </div>
</div>

<script>
function openCheckoutModal(btn) {
    var id = btn.getAttribute('data-id');
    var customerName = btn.getAttribute('data-customer-name');
    var customerTier = btn.getAttribute('data-customer-tier');
    var vehicleModel = btn.getAttribute('data-vehicle-model');
    var vehiclePlate = btn.getAttribute('data-vehicle-plate');
    var serviceName = btn.getAttribute('data-service-name');
    var serviceDuration = btn.getAttribute('data-service-duration');
    var totalAmount = btn.getAttribute('data-total-amount');

    document.getElementById('checkoutBookingId').value = id;
    document.getElementById('checkoutBookingRef').innerText = '#BK-' + id;
    document.getElementById('checkoutCustomerName').innerText = customerName;
    
    var tierBadge = document.getElementById('checkoutCustomerTier');
    tierBadge.innerText = customerTier.toUpperCase() + ' TIER';
    tierBadge.className = 'tier-badge-small tier-badge-' + customerTier.toUpperCase();

    document.getElementById('checkoutVehicleModel').innerText = vehicleModel;
    document.getElementById('checkoutVehiclePlate').innerText = vehiclePlate;
    document.getElementById('checkoutServiceName').innerText = serviceName;
    document.getElementById('checkoutServiceDuration').innerText = serviceDuration + ' mins';
    document.getElementById('checkoutTotalAmount').innerText = totalAmount;

    // Reset payment option
    var radioCash = document.querySelector('input[name="paymentMethod"][value="CASH"]');
    radioCash.checked = true;
    
    // Reset active class
    document.getElementById('paymentCardCASH').classList.add('active');
    document.getElementById('paymentCardBANK').classList.remove('active');

    var modal = document.getElementById('paymentCheckoutModal');
    modal.style.display = 'flex';
    setTimeout(function() {
        modal.classList.add('show');
    }, 10);
}

function closeCheckoutModal() {
    var modal = document.getElementById('paymentCheckoutModal');
    modal.classList.remove('show');
    setTimeout(function() {
        modal.style.display = 'none';
    }, 250);
}

function selectPaymentMethod(radio) {
    document.getElementById('paymentCardCASH').classList.remove('active');
    document.getElementById('paymentCardBANK').classList.remove('active');
    
    if (radio.value === 'CASH') {
        document.getElementById('paymentCardCASH').classList.add('active');
    } else {
        document.getElementById('paymentCardBANK').classList.add('active');
    }
}

// Close modal when clicking outside content
window.addEventListener('click', function(event) {
    var modal = document.getElementById('paymentCheckoutModal');
    if (event.target == modal) {
        closeCheckoutModal();
    }
});
</script>

