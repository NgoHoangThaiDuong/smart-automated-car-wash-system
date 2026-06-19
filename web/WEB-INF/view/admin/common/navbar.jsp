<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="bg-surface/80 dark:bg-surface-container-low/80 backdrop-blur-xl text-primary dark:text-inverse-primary fixed top-0 w-full z-50 h-pill-nav-height border-b border-outline-variant/30 dark:border-outline/20 shadow-sm shadow-primary/5 transition-all duration-300 ease-in-out">
    <div class="max-w-[1100px] mx-auto px-6 flex justify-between items-center h-full">
        <div class="flex items-center gap-6">
            <a href="<c:url value='/admin/dashboard'/>" class="font-headline-md text-headline-md font-bold text-primary dark:text-inverse-primary tracking-tight decoration-transparent hover:opacity-90">CleanDash</a>
            <div class="relative hidden lg:flex items-center">
                <span class="material-symbols-outlined absolute left-3 text-outline text-label-sm">search</span>
                <input class="bg-surface-container-low border border-outline-variant/50 rounded-full pl-9 pr-4 py-1.5 font-label-sm text-label-sm focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary w-48 transition-all" placeholder="Search..." type="text">
            </div>
        </div>
        <div class="hidden md:flex items-center gap-2">
            <a class="px-3 py-2 rounded-lg transition-all duration-200 ${activePage eq 'dashboard' ? 'text-primary dark:text-inverse-primary font-bold bg-primary-container/10' : 'text-on-surface-variant dark:text-surface-variant hover:text-primary hover:bg-primary-container/10'}" href="<c:url value='/admin/dashboard'/>">
                <span class="font-label-sm text-label-sm">Dashboard</span>
            </a>
            <a class="px-3 py-2 rounded-lg transition-all duration-200 ${activePage eq 'bookings' ? 'text-primary dark:text-inverse-primary font-bold bg-primary-container/10' : 'text-on-surface-variant dark:text-surface-variant hover:text-primary hover:bg-primary-container/10'}" href="<c:url value='/admin/bookings'/>">
                <span class="font-label-sm text-label-sm">Bookings</span>
            </a>
            <a class="px-3 py-2 rounded-lg transition-all duration-200 ${activePage eq 'customers' ? 'text-primary dark:text-inverse-primary font-bold bg-primary-container/10' : 'text-on-surface-variant dark:text-surface-variant hover:text-primary hover:bg-primary-container/10'}" href="<c:url value='/admin/customers'/>">
                <span class="font-label-sm text-label-sm">Customers</span>
            </a>
            <a class="px-3 py-2 rounded-lg transition-all duration-200 ${activePage eq 'services' ? 'text-primary dark:text-inverse-primary font-bold bg-primary-container/10' : 'text-on-surface-variant dark:text-surface-variant hover:text-primary hover:bg-primary-container/10'}" href="<c:url value='/admin/services'/>">
                <span class="font-label-sm text-label-sm">Services</span>
            </a>
        </div>
        <div class="flex items-center gap-4">
            <span class="font-label-sm text-label-sm hidden sm:block text-on-surface-variant">
                <c:out value="${not empty sessionScope.currentUser.fullname ? sessionScope.currentUser.fullname : sessionScope.currentUser.username}"/>
            </span>
            <button class="p-2 text-on-surface-variant hover:bg-primary-container/10 rounded-full transition-colors" title="Notifications">
                <span class="material-symbols-outlined">notifications</span>
            </button>
            <a href="<c:url value='/auth/logout'/>" class="p-2 text-on-surface-variant hover:bg-primary-container/10 rounded-full transition-colors" title="Logout">
                <span class="material-symbols-outlined">logout</span>
            </a>
        </div>
    </div>
</nav>
