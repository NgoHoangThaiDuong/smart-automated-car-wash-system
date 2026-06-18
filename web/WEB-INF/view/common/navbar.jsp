<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="app-navbar">
    <div class="app-navbar-container">
        <a class="app-brand" href="<c:url value='${sessionScope.currentUser.role eq "ADMIN" ? "/admin/dashboard" : "/dashboard"}'/>">
            <span class="app-brand-icon">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M5.5 7 7 3.5h10L18.5 7A3 3 0 0 1 21 10v8h-3v-2H6v2H3v-8a3 3 0 0 1 2.5-3Zm2.8-1.5L7.7 7h8.6l-.6-1.5H8.3ZM7 10a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Zm10 0a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3ZM6 14h12v-1H6v1Z"/>
                </svg>
            </span>
            <span class="app-brand-text">
                <strong>Smart Car Wash</strong>
                <small>AUTOMATED EXCELLENCE</small>
            </span>
        </a>

        <button class="app-menu-button" type="button" onclick="toggleNavbar()" aria-label="Toggle navigation">☰</button>

        <nav class="app-menu" id="appMenu">
            <c:choose>
                <c:when test="${sessionScope.currentUser.role eq 'ADMIN'}">
                    <a class="${activePage eq 'dashboard' ? 'active' : ''}" href="<c:url value='/admin/dashboard'/>">Dashboard</a>
                    <a class="${activePage eq 'bookings' ? 'active' : ''}" href="<c:url value='/admin/bookings'/>">Bookings</a>
                    <a class="${activePage eq 'services' ? 'active' : ''}" href="<c:url value='/admin/services'/>">Services</a>
                    <a class="${activePage eq 'customers' ? 'active' : ''}" href="<c:url value='/admin/customers'/>">Customers</a>
                    <a class="${activePage eq 'profile' ? 'active' : ''}" href="<c:url value='/profile'/>">Profile</a>
                </c:when>
                <c:otherwise>
                    <a class="${activePage eq 'dashboard' ? 'active' : ''}" href="<c:url value='/dashboard'/>">Dashboard</a>
                    <a class="${activePage eq 'booking' ? 'active' : ''}" href="<c:url value='/booking'/>">Bookings</a>
                    <a class="${activePage eq 'wash-history' ? 'active' : ''}" href="<c:url value='/wash-history'/>">Wash History</a>
                    <a class="${activePage eq 'vehicles' ? 'active' : ''}" href="<c:url value='/vehicles'/>">Vehicles</a>
                    <a class="${activePage eq 'profile' ? 'active' : ''}" href="<c:url value='/profile'/>">Profile</a>
                </c:otherwise>
            </c:choose>
        </nav>

        <div class="app-user">
            <div class="app-user-info">
                <strong>
                    <c:out value="${not empty sessionScope.currentUser.fullname
                            ? sessionScope.currentUser.fullname
                            : sessionScope.currentUser.username}"/>
                </strong>
                <small>
                    <c:choose>
                        <c:when test="${sessionScope.currentUser.role eq 'ADMIN'}">ADMIN MANAGER</c:when>
                        <c:otherwise>
                            <c:out value="${not empty sessionScope.currentUser.loyaltyTier
                                    ? sessionScope.currentUser.loyaltyTier.name
                                    : 'Member'}"/> Member
                        </c:otherwise>
                    </c:choose>
                </small>
            </div>
            <a class="app-profile-icon" href="<c:url value='/profile'/>" title="Profile">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm0 2c-4 0-7 2.2-7 5v1h14v-1c0-2.8-3-5-7-5Z"/>
                </svg>
            </a>
            <a class="app-logout" href="<c:url value='/auth/logout'/>">Logout</a>
        </div>
    </div>
</header>

<script>
    function toggleNavbar() {
        document.getElementById('appMenu').classList.toggle('show');
    }
</script>
