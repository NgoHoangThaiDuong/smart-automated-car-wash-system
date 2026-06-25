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

        <form id="bookingForm" method="POST" action="<c:url value='/booking/create'/>">
            <div class="booking-layout">
                <div class="booking-selections">
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
                                        <label class="choice-card ${selectedVehicleId eq vehicle.id ? 'selected' : ''}"
                                               data-choice="vehicle">
                                            <input type="radio" name="vehicleId" value="${vehicle.id}"
                                                   data-name="<c:out value='${vehicle.brand} ${vehicle.model}'/>"
                                                   data-detail="<c:out value='${vehicle.licensePlate}'/>"
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
                                        <label class="service-card ${selectedServiceId eq service.id ? 'selected' : ''}"
                                               data-choice="service">
                                            <input type="radio" name="serviceId" value="${service.id}"
                                                   data-name="<c:out value='${service.name}'/>"
                                                   data-duration="${service.durationMinutes}"
                                                   data-price="${service.price}"
                                                   ${selectedServiceId eq service.id ? 'checked' : ''}>
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
                            <input id="bookingDate" class="date-input" type="date" name="bookingDate"
                                   value="<c:out value='${selectedDate}'/>"
                                   min="${minBookingDate}" max="${maxBookingDate}">
                        </section>

                        <section class="selection-card">
                            <h2>4. Select Time</h2>
                            <div id="timeMessage" class="helper-text">
                                <c:choose>
                                    <c:when test="${empty selectedServiceId || empty selectedDate}">
                                        Select a service and booking date.
                                    </c:when>
                                    <c:when test="${empty availableSlots}">
                                        No available time slots.
                                    </c:when>
                                </c:choose>
                            </div>
                            <div id="timeGrid" class="time-grid">
                                <c:forEach var="slot" items="${availableSlots}">
                                    <button type="button" class="time-button ${selectedTime eq slot ? 'selected' : ''}" data-time="${slot}">
                                        <c:out value="${slot}"/>
                                        <small>${selectedTime eq slot ? 'Selected' : 'Available'}</small>
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
                                        <c:out value="${selectedVehicle.brand}"/> <c:out value="${selectedVehicle.model}"/>
                                    </c:when>
                                    <c:otherwise>Not selected</c:otherwise>
                                </c:choose>
                            </span>
                            <small id="summaryVehicleDetail">
                                <c:out value="${empty selectedVehicle ? '' : selectedVehicle.licensePlate}"/>
                            </small>
                        </b>
                    </div>
                    <div class="summary-row">
                        <span>Service</span>
                        <b>
                            <span id="summaryService">
                                <c:out value="${empty selectedService ? 'Not selected' : selectedService.name}"/>
                            </span>
                            <small id="summaryServiceDetail">
                                <c:if test="${not empty selectedService}">${selectedService.durationMinutes} mins</c:if>
                            </small>
                        </b>
                    </div>
                    <div class="summary-row">
                        <span>Date &amp; Time</span>
                        <b>
                            <span id="summaryDate">
                                <c:out value="${empty selectedDate ? 'Not selected' : selectedDate}"/>
                            </span>
                            <small id="summaryTime"><c:out value="${selectedTime}"/></small>
                        </b>
                    </div>
                    <div class="summary-total">
                        <span>Estimated Total</span>
                        <strong id="summaryTotal">
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
                    <button id="confirmBooking" class="confirm-button" type="submit" disabled>
                        Confirm Booking →
                    </button>
                </aside>
            </div>
        </form>
    </main>

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
                
                var url = '?vehicleId=' + encodeURIComponent(vehicleId)
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
</body>
</html>
