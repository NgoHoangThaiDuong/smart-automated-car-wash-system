<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book a Service - Smart Car Wash</title>
    <link rel="stylesheet" href="<c:url value='/css/typography.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/customer/booking.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

    <main class="booking-page">
        <div class="page-heading">
            <a class="back-link" href="<c:url value='/booking'/>">← My Bookings</a>
            <h1>Book a Service</h1>
            <p>Select your vehicle, service, and preferred time slot.</p>
        </div>

        <c:if test="${not empty bookingError}">
            <div class="alert alert-error"><c:out value="${bookingError}"/></div>
        </c:if>
        <c:if test="${not empty successBooking}">
            <div class="alert alert-success">
                Booking #SW-${successBooking.id} was created successfully.
                Status: ${successBooking.bookingStatus}, payment: ${successBooking.paymentStatus}.
            </div>
        </c:if>

        <div class="booking-layout">
            <form class="booking-selections" method="GET" action="<c:url value='/booking/new'/>">
                <section class="selection-card">
                    <div class="section-title">
                        <h2>1. Select Vehicle</h2>
                        <a href="<c:url value='/vehicles'/>">Manage Vehicles →</a>
                    </div>

                    <c:choose>
                        <c:when test="${empty vehicles}">
                            <div class="empty-state compact">
                                <h3>No vehicle registered</h3>
                                <p>Add a vehicle before creating a booking.</p>
                                <a class="secondary-button" href="<c:url value='/vehicles'/>">Add Vehicle</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="option-grid">
                                <c:forEach var="vehicle" items="${vehicles}">
                                    <label class="choice-card ${selectedVehicleId eq vehicle.id ? 'selected' : ''}">
                                        <input type="radio" name="vehicleId" value="${vehicle.id}"
                                               ${selectedVehicleId eq vehicle.id ? 'checked' : ''}
                                               onchange="this.form.submit()">
                                        <span class="choice-title">🚗 <c:out value="${vehicle.brand}"/> <c:out value="${vehicle.model}"/></span>
                                        <span><c:out value="${vehicle.color}"/></span>
                                        <b><c:out value="${vehicle.licensePlate}"/></b>
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
                            <div class="empty-state compact">
                                <h3>No service available</h3>
                                <p>Please come back later.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="service-options">
                                <c:forEach var="service" items="${services}">
                                    <label class="service-card ${selectedServiceId eq service.id ? 'selected' : ''}">
                                        <input type="radio" name="serviceId" value="${service.id}"
                                               ${selectedServiceId eq service.id ? 'checked' : ''}
                                               onchange="this.form.submit()">
                                        <span>
                                            <strong><c:out value="${service.name}"/></strong>
                                            <small><c:out value="${service.description}"/></small>
                                        </span>
                                        <span class="service-price">
                                            <b><fmt:formatNumber value="${service.price}" type="number"/> VND</b>
                                            <small>${service.durationMinutes} mins</small>
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
                            <c:out value="${empty sessionScope.currentUser.loyaltyTier ? 'Member' : sessionScope.currentUser.loyaltyTier.name}"/> Member:
                            ${bookingWindowDays}-day booking window
                        </div>
                        <input class="date-input" type="date" name="bookingDate"
                               value="<c:out value='${selectedDate}'/>"
                               min="${minBookingDate}" max="${maxBookingDate}"
                               onchange="this.form.submit()">
                    </section>

                    <section class="selection-card">
                        <h2>4. Select Time</h2>
                        <c:choose>
                            <c:when test="${empty selectedService}">
                                <p class="helper-text">Select a service first.</p>
                            </c:when>
                            <c:when test="${empty selectedDate}">
                                <p class="helper-text">Select a booking date.</p>
                            </c:when>
                            <c:when test="${empty availableSlots}">
                                <p class="helper-text">No available time slot for this date.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="time-grid">
                                    <c:forEach var="slot" items="${availableSlots}">
                                        <button type="submit" name="time" value="${slot}"
                                                class="time-button ${selectedTime eq slot ? 'selected' : ''}">
                                            ${slot}
                                            <small>
                                                <c:out value="${selectedTime eq slot ? 'Selected' : 'Available'}"/>
                                            </small>
                                        </button>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>
                </div>

                <c:if test="${not empty selectedVehicleId}">
                    <input type="hidden" name="vehicleId" value="${selectedVehicleId}">
                </c:if>
                <c:if test="${not empty selectedServiceId}">
                    <input type="hidden" name="serviceId" value="${selectedServiceId}">
                </c:if>
            </form>

            <aside class="booking-summary">
                <h2>Booking Summary</h2>
                <div class="summary-row">
                    <span>Vehicle</span>
                    <b>
                        <c:choose>
                            <c:when test="${not empty selectedVehicle}">
                                <c:out value="${selectedVehicle.brand}"/> <c:out value="${selectedVehicle.model}"/>
                                <small><c:out value="${selectedVehicle.licensePlate}"/></small>
                            </c:when>
                            <c:otherwise>Not selected</c:otherwise>
                        </c:choose>
                    </b>
                </div>
                <div class="summary-row">
                    <span>Service</span>
                    <b>
                        <c:choose>
                            <c:when test="${not empty selectedService}">
                                <c:out value="${selectedService.name}"/>
                                <small>${selectedService.durationMinutes} mins</small>
                            </c:when>
                            <c:otherwise>Not selected</c:otherwise>
                        </c:choose>
                    </b>
                </div>
                <div class="summary-row">
                    <span>Date &amp; Time</span>
                    <b>
                        <c:out value="${empty selectedDate ? 'Not selected' : selectedDate}"/>
                        <small><c:out value="${empty selectedTime ? '' : selectedTime}"/></small>
                    </b>
                </div>
                <div class="summary-total">
                    <span>Estimated Total</span>
                    <strong>
                        <c:choose>
                            <c:when test="${not empty selectedService}">
                                <fmt:formatNumber value="${selectedService.price}" type="number"/> VND
                            </c:when>
                            <c:otherwise>0 VND</c:otherwise>
                        </c:choose>
                    </strong>
                </div>
                <div class="summary-status">
                    <span>Booking Status <b>CONFIRMED</b></span>
                    <span>Payment Status <b>UNPAID</b></span>
                </div>

                <form method="POST" action="<c:url value='/booking/new'/>">
                    <input type="hidden" name="vehicleId" value="${selectedVehicleId}">
                    <input type="hidden" name="serviceId" value="${selectedServiceId}">
                    <input type="hidden" name="bookingDate" value="<c:out value='${selectedDate}'/>">
                    <input type="hidden" name="time" value="<c:out value='${selectedTime}'/>">
                    <button class="confirm-button" type="submit"
                            ${empty selectedVehicle or empty selectedService or empty selectedDate or empty selectedTime ? 'disabled' : ''}>
                        Confirm Booking →
                    </button>
                </form>
            </aside>
        </div>
    </main>
</body>
</html>
