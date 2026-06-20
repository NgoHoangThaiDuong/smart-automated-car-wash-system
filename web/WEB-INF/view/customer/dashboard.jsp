<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/customer/dashboard.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

    <main class="dashboard-page">
        <section class="dashboard-heading">
            <h1>Hello, <c:out value="${not empty dashboard.fullname ? dashboard.fullname : dashboard.username}"/>!</h1>
            <p>Here is an overview of your automated car care operations and loyalty status today.</p>
        </section>

        <section class="dashboard-overview">
            <article class="loyalty-card">
                <div class="loyalty-card-top">
                    <div>
                        <span class="tier-label">CURRENT TIER</span>
                        <h2><c:out value="${dashboard.tierName}"/> Member</h2>
                    </div>
                    <div class="points-box">
                        <span>Points Balance</span>
                        <strong>☆ <fmt:formatNumber value="${dashboard.pointsBalance}" type="number"/></strong>
                    </div>
                </div>

                <div class="tier-progress">
                    <c:choose>
                        <c:when test="${not empty dashboard.nextTierName}">
                            <div class="progress-text">
                                <span>Progress to <c:out value="${dashboard.nextTierName}"/> Tier</span>
                                <span>
                                    <fmt:formatNumber value="${dashboard.remainingSpend}" type="number"/> VND
                                    or ${dashboard.remainingWashes} washes needed
                                </span>
                            </div>
                            <div class="progress-bar">
                                <div style="width: ${dashboard.progressPercent}%;"></div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="progress-text">
                                <span>Highest tier achieved</span>
                                <span>Platinum Member</span>
                            </div>
                            <div class="progress-bar">
                                <div style="width: 100%;"></div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="loyalty-card-bottom">
                    <div>
                        <span>Lifetime Spent</span>
                        <strong><fmt:formatNumber value="${dashboard.lifetimeSpent}" type="number"/> VND</strong>
                    </div>
                    <div>
                        <span>Total Washes</span>
                        <strong>${dashboard.totalWashes}</strong>
                    </div>
                </div>
            </article>

            <div class="dashboard-side">
                <article class="small-card vehicle-summary">
                    <div class="small-card-icon">▣</div>
                    <div>
                        <span>Registered Vehicles</span>
                        <strong>${dashboard.vehicleCount}</strong>
                        <a href="<c:url value='/profile'/>">Manage Garage →</a>
                    </div>
                </article>

                <article class="small-card upcoming-booking">
                    <c:choose>
                        <c:when test="${not empty upcomingBooking}">
                            <div class="card-row">
                                <span>Upcoming Booking</span>
                                <b><c:out value="${upcomingBooking.bookingStatus}"/></b>
                            </div>
                            <h3>
                                <c:out value="${upcomingBooking.bookingDate}"/>,
                                <c:out value="${upcomingBooking.timeSlot}"/>
                            </h3>
                            <p>
                                <c:out value="${upcomingBooking.service.name}"/> -
                                <c:out value="${upcomingBooking.vehicle.brand}"/>
                                <c:out value="${upcomingBooking.vehicle.model}"/>
                            </p>
                            <span class="payment-status">
                                Payment:
                                <c:out value="${empty upcomingBooking.payment ? 'NOT CREATED' : upcomingBooking.payment.paymentStatus}"/>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span>Upcoming Booking</span>
                            <h3>No upcoming booking</h3>
                            <p>Your next booking will appear here.</p>
                        </c:otherwise>
                    </c:choose>
                </article>
            </div>
        </section>

        <section class="history-card">
            <div class="history-header">
                <h2>Recent Wash History</h2>
                <a href="<c:url value='/wash-history'/>">View All History</a>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Service</th>
                            <th>Vehicle</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty recentWashHistory}">
                                <tr>
                                    <td colspan="5" class="empty-row">No completed wash history yet.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="booking" items="${recentWashHistory}">
                                    <tr>
                                        <td><fmt:formatDate value="${booking.completedAt}" pattern="dd/MM/yyyy"/></td>
                                        <td><c:out value="${booking.service.name}"/></td>
                                        <td>
                                            <c:out value="${booking.vehicle.brand}"/>
                                            <c:out value="${booking.vehicle.model}"/>
                                            (<c:out value="${booking.vehicle.licensePlate}"/>)
                                        </td>
                                        <td><fmt:formatNumber value="${booking.payment.amount}" type="number"/> VND</td>
                                        <td><span class="completed-badge">Completed</span></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>
