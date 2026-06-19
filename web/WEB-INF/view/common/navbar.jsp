<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="bg-white/80 dark:bg-slate-900/80 backdrop-blur-xl text-slate-900 dark:text-white fixed top-0 left-0 w-full z-50 h-16 border-b border-slate-200/50 dark:border-slate-800/50 shadow-sm transition-all duration-300">
    <div class="max-w-[1280px] mx-auto px-6 flex justify-between items-center h-full">
        <!-- Brand / Logo -->
        <div class="flex items-center gap-8">
            <a href="<c:url value='${sessionScope.currentUser.role eq "ADMIN" ? "/admin/dashboard" : "/dashboard"}'/>" class="flex items-center gap-2 font-display-lg text-xl font-bold tracking-tight text-primary hover:opacity-90 transition-opacity decoration-transparent">
                <!-- SmartWash Pro Car Icon -->
                <span class="w-8 h-8 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                    <svg class="w-5 h-5 fill-current" viewBox="0 0 24 24">
                        <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/>
                    </svg>
                </span>
                <span class="font-bold text-slate-900 dark:text-white">SmartWash <span class="text-primary">Pro</span></span>
            </a>
            
            <!-- Desktop Links -->
            <div class="hidden md:flex items-center gap-1">
                <c:choose>
                    <c:when test="${sessionScope.currentUser.role eq 'ADMIN'}">
                        <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'dashboard' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/admin/dashboard'/>">Dashboard</a>
                        <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'bookings' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/admin/bookings'/>">Bookings</a>
                        <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'services' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/admin/services'/>">Services</a>
                        <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'customers' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/admin/customers'/>">Customers</a>
                    </c:when>
                    <c:otherwise>
                        <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'dashboard' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/dashboard'/>">Dashboard</a>
                        <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'booking' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/booking'/>">Bookings</a>
                        <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'wash-history' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/wash-history'/>">Wash History</a>
                        <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'vehicles' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/vehicles'/>">Vehicles</a>
                    </c:otherwise>
                </c:choose>
                <a class="px-3.5 py-1.5 rounded-xl font-label-md text-sm font-semibold transition-all duration-200 ${param.activePage eq 'profile' ? 'text-primary bg-primary/5' : 'text-slate-600 hover:text-primary hover:bg-slate-50'}" href="<c:url value='/profile'/>">Profile</a>
            </div>
        </div>

        <!-- Right Side: User Profile & Actions -->
        <div class="flex items-center gap-4">
            <div class="hidden sm:flex flex-col text-right">
                <span class="font-semibold text-sm text-slate-800 dark:text-slate-100">
                    <c:out value="${not empty sessionScope.currentUser.fullname ? sessionScope.currentUser.fullname : sessionScope.currentUser.username}"/>
                </span>
                <span class="text-[10px] font-bold text-primary tracking-wider uppercase">
                    <c:choose>
                        <c:when test="${sessionScope.currentUser.role eq 'ADMIN'}">Admin Manager</c:when>
                        <c:otherwise>
                            <c:out value="${not empty sessionScope.currentUser.loyaltyTier ? sessionScope.currentUser.loyaltyTier.name : 'Member'}"/> Member
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>

            <!-- Profile / Info Icon -->
            <a href="<c:url value='/profile'/>" class="w-9 h-9 rounded-full bg-slate-100 hover:bg-primary/10 flex items-center justify-center text-slate-600 hover:text-primary transition-colors duration-200" title="Profile">
                <span class="material-symbols-outlined text-[22px]">account_circle</span>
            </a>

            <!-- Notifications Icon -->
            <button class="w-9 h-9 rounded-full bg-slate-100 hover:bg-primary/10 flex items-center justify-center text-slate-600 hover:text-primary transition-colors duration-200" title="Notifications">
                <span class="material-symbols-outlined text-[22px]">notifications</span>
            </button>

            <!-- Logout Button -->
            <a href="<c:url value='/auth/logout'/>" class="w-9 h-9 rounded-full bg-slate-100 hover:bg-red-50 flex items-center justify-center text-slate-600 hover:text-red-600 transition-colors duration-200" title="Logout">
                <span class="material-symbols-outlined text-[22px]">logout</span>
            </a>

            <!-- Mobile Menu Toggle Button -->
            <button type="button" onclick="toggleNavbar()" class="md:hidden w-9 h-9 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-600 transition-colors" aria-label="Toggle navigation">
                <span class="material-symbols-outlined" id="menuIcon">menu</span>
            </button>
        </div>
    </div>

    <!-- Mobile Dropdown Menu -->
    <div id="mobileMenu" class="hidden md:hidden border-b border-slate-200/50 bg-white/95 backdrop-blur-xl absolute top-16 left-0 w-full flex flex-col px-6 py-4 gap-2 shadow-lg transition-all duration-300">
        <c:choose>
            <c:when test="${sessionScope.currentUser.role eq 'ADMIN'}">
                <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'dashboard' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/admin/dashboard'/>">Dashboard</a>
                <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'bookings' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/admin/bookings'/>">Bookings</a>
                <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'services' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/admin/services'/>">Services</a>
                <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'customers' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/admin/customers'/>">Customers</a>
            </c:when>
            <c:otherwise>
                <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'dashboard' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/dashboard'/>">Dashboard</a>
                <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'booking' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/booking'/>">Bookings</a>
                <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'wash-history' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/wash-history'/>">Wash History</a>
                <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'vehicles' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/vehicles'/>">Vehicles</a>
            </c:otherwise>
        </c:choose>
        <a class="px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${param.activePage eq 'profile' ? 'text-primary bg-primary/5' : 'text-slate-600'}" href="<c:url value='/profile'/>">Profile</a>
    </div>
</nav>

<script>
    function toggleNavbar() {
        const mobileMenu = document.getElementById('mobileMenu');
        const menuIcon = document.getElementById('menuIcon');
        if (mobileMenu.classList.contains('hidden')) {
            mobileMenu.classList.remove('hidden');
            menuIcon.textContent = 'close';
        } else {
            mobileMenu.classList.add('hidden');
            menuIcon.textContent = 'menu';
        }
    }
</script>
