<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wash History - Smart Car Wash</title>
    <link rel="stylesheet" href="<c:url value='/css/typography.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/customer/booking.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

    <main class="booking-page">
        <div class="page-heading">
            <div>
                <h1>Wash History</h1>
                <p>View details of your past completed and paid car wash services.</p>
            </div>
        </div>

        <c:if test="${not empty bookingMessage}">
            <div class="alert alert-success"><c:out value="${bookingMessage}"/></div>
        </c:if>
        <c:if test="${not empty bookingError}">
            <div class="alert alert-error"><c:out value="${bookingError}"/></div>
        </c:if>

        <section class="booking-list">
            <c:choose>
                <c:when test="${empty bookings}">
                    <div class="empty-state">
                        <span class="material-symbols-outlined">history</span>
                        <h2>No wash history yet</h2>
                        <p>You haven't completed any car wash bookings yet.</p>
                        <a class="primary-button" href="<c:url value='/booking/new'/>">Book a Service</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="booking" items="${bookings}">
                        <article class="booking-item">
                            <div>
                                <span class="item-label">Booking ID</span>
                                <strong>#SW-${booking.id}</strong>
                            </div>
                            <div>
                                <span class="item-label">Service</span>
                                <b><c:out value="${booking.service.name}"/></b>
                            </div>
                            <div>
                                <span class="item-label">Vehicle</span>
                                <b>
                                    <c:out value="${booking.vehicle.brand}"/>
                                    <c:out value="${booking.vehicle.model}"/>
                                </b>
                                <span><c:out value="${booking.vehicle.licensePlate}"/></span>
                            </div>
                            <div>
                                <span class="item-label">Date &amp; Time</span>
                                <b><c:out value="${booking.bookingDate}"/></b>
                                <span><c:out value="${booking.timeSlot}"/></span>
                            </div>
                            <div class="booking-status-box">
                                <strong><fmt:formatNumber value="${booking.totalAmount}" type="number"/> VND</strong>
                                <div>
                                    <span class="status payment-${booking.paymentStatus}">
                                        <c:out value="${booking.paymentStatus}"/>
                                    </span>
                                    <span class="status booking-${booking.bookingStatus}">
                                        <c:out value="${booking.bookingStatus}"/>
                                    </span>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
