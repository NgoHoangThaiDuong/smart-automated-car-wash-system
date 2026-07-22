<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Rửa Xe - Smart Car Wash</title>
    <link rel="stylesheet" href="<c:url value='/css/typography.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/customer/booking.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

    <main class="booking-page">
        <div class="page-heading">
            <a class="back-link" href="<c:url value='/booking'/>">← Danh Sách Booking</a>
            <h1>Đặt Lịch Rửa Xe</h1>
            <p>Chọn xe, dịch vụ và ngày → nhấn "Xem giờ trống" → chọn giờ → xác nhận.</p>
        </div>
        <c:if test="${not empty bookingError}">
            <div class="alert alert-error"><c:out value="${bookingError}"/></div>
        </c:if>
        <form method="GET" action="<c:url value='/booking/new'/>">
            <div class="booking-selections">

                <section class="selection-card">
                    <div class="section-title">
                        <h2>1. Chọn Xe</h2>
                        <a href="<c:url value='/vehicles'/>">Quản lý xe →</a>
                    </div>

                    <c:choose>
                        <c:when test="${empty vehicles}">
                            <div class="empty-state compact">
                                <h3>Chưa có xe nào</h3>
                                <p>Thêm xe trước khi đặt lịch.</p>
                                <a class="secondary-button" href="<c:url value='/vehicles'/>">Thêm xe</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="option-grid">
                                <c:forEach var="vehicle" items="${vehicles}">
                                    <label class="choice-card">
                                        <input type="radio" name="vehicleId" value="${vehicle.id}"
                                               ${selectedVehicleId eq vehicle.id ? 'checked' : ''}>
                                        <span class="choice-title">
                                            🚗 <c:out value="${vehicle.brand}"/> <c:out value="${vehicle.model}"/>
                                        </span>
                                        <span><c:out value="${vehicle.color}"/></span>
                                        <b><c:out value="${vehicle.licensePlate}"/></b>
                                    </label>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
                <section class="selection-card">
                    <h2>2. Chọn Dịch Vụ</h2>

                    <c:choose>
                        <c:when test="${empty services}">
                            <div class="empty-state compact">
                                <h3>Không có dịch vụ nào</h3>
                                <p>Vui lòng quay lại sau.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="service-options">
                                <c:forEach var="service" items="${services}">
                                    <label class="service-card">
                                        <input type="radio" name="serviceId" value="${service.id}"
                                               ${selectedServiceId eq service.id ? 'checked' : ''}>
                                        <span>
                                            <strong><c:out value="${service.name}"/></strong>
                                            <small><c:out value="${service.description}"/></small>
                                        </span>
                                        <span class="service-price">
                                            <b><fmt:formatNumber value="${service.price}" type="number"/> VND</b>
                                            <small>${service.durationMinutes} phút</small>
                                        </span>
                                    </label>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <%-- Chọn ngày --%>
                <section class="selection-card">
                    <h2>3. Chọn Ngày</h2>
                    <div class="membership-note">
                        Hạng <c:out value="${empty sessionScope.currentUser.loyaltyTier
                                             ? 'Regular' : sessionScope.currentUser.loyaltyTier.name}"/>:
                        Đặt trước tối đa ${bookingWindowDays} ngày
                    </div>
                    <input class="date-input" type="date" name="bookingDate"
                           value="<c:out value='${selectedDate}'/>"
                           min="${minBookingDate}" max="${maxBookingDate}">
                </section>

            </div>
            <div class="booking-submit-row">
                <button class="secondary-button" type="submit">Xem Giờ Trống →</button>
            </div>
        </form>

        <c:if test="${not empty availableSlots}">
            <form method="POST" action="<c:url value='/booking/create'/>">
                <input type="hidden" name="vehicleId"   value="${selectedVehicleId}">
                <input type="hidden" name="serviceId"   value="${selectedServiceId}">
                <input type="hidden" name="bookingDate" value="${selectedDate}">

                <section class="selection-card" style="margin-top: 26px;">
                    <h2>4. Chọn Giờ Rửa Xe</h2>
                    <div class="time-grid">
                        <c:forEach var="slot" items="${availableSlots}">
                            <label class="time-label">
                                <input type="radio" name="time" value="${slot}"
                                       ${selectedTime eq slot ? 'checked' : ''}>
                                <c:out value="${slot}"/>
                            </label>
                        </c:forEach>
                    </div>
                </section>

                <div class="booking-submit-row">
                    <button class="confirm-button" type="submit">Xác Nhận Đặt Lịch →</button>
                </div>
            </form>
        </c:if>
        <c:if test="${not empty selectedServiceId and not empty selectedDate and empty availableSlots}">
            <div class="selection-card" style="margin-top: 26px;">
                <p class="helper-text">Không còn khung giờ trống cho dịch vụ và ngày đã chọn. Vui lòng thử ngày khác.</p>
            </div>
        </c:if>

    </main>
</body>
</html>