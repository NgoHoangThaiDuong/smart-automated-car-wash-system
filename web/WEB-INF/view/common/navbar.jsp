<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Load Material Icons inside navbar for global usage -->
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<c:url value='/css/common/navbar.css'/>">

<header class="app-navbar">
    <div class="app-navbar-container">
        <!-- Brand Logo and Name -->
        <a class="app-brand" href="<c:url value='${sessionScope.currentUser.role eq "ADMIN" ? "/admin/dashboard" : "/dashboard"}'/>">
            <span class="app-brand-icon">
                <span class="material-symbols-outlined">directions_car</span>
            </span>
            <span class="app-brand-text">SmartWash<span>Pro</span></span>
        </a>

        <!-- Mobile Navigation Menu Toggle Button -->
        <button class="app-menu-button" type="button" onclick="toggleNavbar()" aria-label="Toggle navigation">☰</button>

        <!-- Navigation Menu -->
        <nav class="app-menu" id="appMenu">
            <c:choose>
                <c:when test="${sessionScope.currentUser.role eq 'ADMIN'}">
                    <a class="${activePage eq 'dashboard' ? 'active' : ''}" href="<c:url value='/admin/dashboard'/>">
                        <span class="material-symbols-outlined">grid_view</span> Dashboard
                    </a>
                    <a class="${activePage eq 'bookings' ? 'active' : ''}" href="<c:url value='/admin/bookings'/>">
                        <span class="material-symbols-outlined">calendar_month</span> Bookings
                    </a>
                    <a class="${activePage eq 'services' ? 'active' : ''}" href="<c:url value='/admin/services'/>">
                        <span class="material-symbols-outlined">settings</span> Services
                    </a>
                    <a class="${activePage eq 'customers' ? 'active' : ''}" href="<c:url value='/admin/customers'/>">
                        <span class="material-symbols-outlined">group</span> Customers
                    </a>
                    <a class="${activePage eq 'profile' ? 'active' : ''}" href="<c:url value='/profile'/>">
                        <span class="material-symbols-outlined">person</span> Profile
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="${activePage eq 'dashboard' ? 'active' : ''}" href="<c:url value='/dashboard'/>">
                        <span class="material-symbols-outlined">grid_view</span> Dashboard
                    </a>
                    <a class="${activePage eq 'booking' ? 'active' : ''}" href="<c:url value='/booking'/>">
                        <span class="material-symbols-outlined">calendar_month</span> Bookings
                    </a>
                    <a class="${activePage eq 'wash-history' ? 'active' : ''}" href="<c:url value='/wash-history'/>">
                        <span class="material-symbols-outlined">history</span> Wash History
                    </a>
                    <a class="${activePage eq 'vehicles' ? 'active' : ''}" href="<c:url value='/vehicles'/>">
                        <span class="material-symbols-outlined">directions_car</span> Vehicles
                    </a>
                    <a class="${activePage eq 'profile' ? 'active' : ''}" href="<c:url value='/profile'/>">
                        <span class="material-symbols-outlined">person</span> Profile
                    </a>
                </c:otherwise>
            </c:choose>
        </nav>

        <!-- User Controls / Account -->
        <div class="app-user">
            <div class="app-user-info">
                <span class="role-label">Admin</span>
                <span class="username-label">
                    <c:out value="${sessionScope.currentUser.role eq 'ADMIN' ? 'MANAGER' : (not empty sessionScope.currentUser.fullname ? sessionScope.currentUser.fullname : sessionScope.currentUser.username)}"/>
                </span>
            </div>
            <a class="app-profile-icon" href="<c:url value='/profile'/>" title="Profile">
                <span class="material-symbols-outlined">person</span>
            </a>
            <a class="app-logout" href="<c:url value='/auth/logout'/>">
                <span class="material-symbols-outlined">logout</span> Logout
            </a>
        </div>
    </div>
</header>

<script>
    function toggleNavbar() {
        document.getElementById('appMenu').classList.toggle('show');
    }
</script>
