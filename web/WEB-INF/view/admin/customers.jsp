<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Customer Management - CleanDash</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&amp;display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "inverse-primary": "#b4c5ff",
                        "on-primary-container": "#eeefff",
                        "surface-container-lowest": "#ffffff",
                        "inverse-on-surface": "#eaf1ff",
                        "on-secondary-fixed": "#001e2f",
                        "on-error-container": "#93000a",
                        "on-secondary-fixed-variant": "#004c6e",
                        "on-tertiary-fixed": "#141d21",
                        "on-background": "#0b1c30",
                        "secondary-fixed": "#c9e6ff",
                        "on-secondary-container": "#004666",
                        "on-primary-fixed-variant": "#003ea8",
                        "background": "#f8f9ff",
                        "surface-dim": "#cbdbf5",
                        "outline-variant": "#c3c6d7",
                        "surface-bright": "#f8f9ff",
                        "primary": "#004ac6",
                        "secondary-container": "#39b8fd",
                        "primary-fixed-dim": "#b4c5ff",
                        "on-tertiary": "#ffffff",
                        "surface-container-high": "#dce9ff",
                        "primary-container": "#2563eb",
                        "on-tertiary-fixed-variant": "#3f484d",
                        "surface": "#f8f9ff",
                        "primary-fixed": "#dbe1ff",
                        "on-primary-fixed": "#00174b",
                        "inverse-surface": "#213145",
                        "tertiary": "#4e565b",
                        "on-primary": "#ffffff",
                        "tertiary-fixed-dim": "#bfc8ce",
                        "surface-container-highest": "#d3e4fe",
                        "surface-container": "#e5eeff",
                        "tertiary-fixed": "#dbe4ea",
                        "secondary-fixed-dim": "#89ceff",
                        "outline": "#737686",
                        "tertiary-container": "#666f74",
                        "on-secondary": "#ffffff",
                        "surface-tint": "#0053db",
                        "error-container": "#ffdad6",
                        "on-error": "#ffffff",
                        "on-surface": "#0b1c30",
                        "surface-variant": "#d3e4fe",
                        "surface-container-low": "#eff4ff",
                        "on-surface-variant": "#434655",
                        "error": "#ba1a1a",
                        "secondary": "#006591",
                        "on-tertiary-container": "#e9f2f8",
                        "tier-silver": "#94a3b8",
                        "tier-gold": "#fbbf24",
                        "tier-platinum": "#93c5fd"
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    spacing: {
                        "stack-gap-sm": "0.75rem",
                        "section-gap": "4rem",
                        "card-padding": "2rem",
                        "container-max-width": "1100px",
                        "stack-gap-md": "1.5rem",
                        "pill-nav-height": "64px"
                    },
                    fontFamily: {
                        "headline-md": ["Inter"],
                        "body-lg": ["Inter"],
                        "label-sm": ["Inter"],
                        "display-lg-mobile": ["Inter"],
                        "currency-display": ["Inter"],
                        "display-lg": ["Inter"],
                        "body-md": ["Inter"]
                    },
                    fontSize: {
                        "headline-md": ["24px", { "lineHeight": "1.3", "fontWeight": "600" }],
                        "body-lg": ["18px", { "lineHeight": "1.6", "fontWeight": "400" }],
                        "label-sm": ["14px", { "lineHeight": "1", "letterSpacing": "0.05em", "fontWeight": "600" }],
                        "display-lg-mobile": ["32px", { "lineHeight": "1.2", "letterSpacing": "-0.02em", "fontWeight": "700" }],
                        "currency-display": ["20px", { "lineHeight": "1", "fontWeight": "700" }],
                        "display-lg": ["48px", { "lineHeight": "1.1", "letterSpacing": "-0.02em", "fontWeight": "700" }],
                        "body-md": ["16px", { "lineHeight": "1.5", "fontWeight": "400" }]
                    },
                    boxShadow: {
                        'glass-card': '0 20px 40px rgba(37, 99, 235, 0.05)',
                        'nav-pill': '0 10px 25px -5px rgba(37, 99, 235, 0.1), 0 8px 10px -6px rgba(37, 99, 235, 0.1)',
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .material-symbols-outlined.fill {
            font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="bg-background text-on-background min-h-screen font-body-md text-body-md overflow-x-hidden pt-24">

<!-- TopNavBar -->
<c:import url="/WEB-INF/view/admin/common/navbar.jsp">
    <c:param name="activePage" value="customers"/>
</c:import>

<!-- Main Content Canvas -->
<main class="max-w-[1280px] mx-auto px-6 pb-24">
    <!-- Header Section -->
    <header class="flex flex-col md:flex-row md:items-end justify-between gap-stack-gap-md mb-8">
        <div class="space-y-2">
            <h1 class="font-display-lg text-display-lg text-on-background">Customer Management</h1>
            <p class="font-body-lg text-body-lg text-on-surface-variant max-w-2xl">Track customer accounts, loyalty tiers, points, spending, and wash activity.</p>
        </div>
        <div class="flex flex-wrap items-center gap-3">
            <a href="<c:url value='/admin/customers'/>" class="flex items-center gap-2 px-5 py-2.5 bg-transparent border border-primary text-primary hover:bg-primary/5 rounded-full font-label-sm text-label-sm transition-colors decoration-transparent">
                <span class="material-symbols-outlined">refresh</span>
                Refresh Data
            </a>
        </div>
    </header>

    <!-- Analytics Grid (Bento Style) -->
    <section class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
        <!-- Total Customers -->
        <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-glass-card relative overflow-hidden group hover:shadow-lg transition-shadow border border-outline-variant/20">
            <div class="flex justify-between items-start mb-4 relative z-10">
                <div class="p-3 bg-surface-container-low rounded-xl text-primary">
                    <span class="material-symbols-outlined text-2xl">group</span>
                </div>
            </div>
            <h3 class="font-label-sm text-label-sm text-on-surface-variant mb-1 relative z-10">Total Customers</h3>
            <p class="font-display-lg-mobile text-display-lg-mobile font-bold text-on-background relative z-10">
                <c:out value="${totalCustomers}"/>
            </p>
            <div class="absolute -right-10 -bottom-10 w-32 h-32 bg-primary/5 rounded-full blur-2xl group-hover:bg-primary/10 transition-colors"></div>
        </div>

        <!-- Total Revenue -->
        <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-glass-card relative overflow-hidden group hover:shadow-lg transition-shadow border border-outline-variant/20">
            <div class="flex justify-between items-start mb-4 relative z-10">
                <div class="p-3 bg-surface-container-low rounded-xl text-primary">
                    <span class="material-symbols-outlined text-2xl">payments</span>
                </div>
            </div>
            <h3 class="font-label-sm text-label-sm text-on-surface-variant mb-1 relative z-10">Total Lifetime Revenue</h3>
            <p class="font-currency-display text-currency-display font-bold text-on-background relative z-10">
                <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫
            </p>
            <div class="absolute -right-10 -bottom-10 w-32 h-32 bg-primary/5 rounded-full blur-2xl group-hover:bg-primary/10 transition-colors"></div>
        </div>

        <!-- Registered Vehicles -->
        <div class="bg-surface-container-lowest rounded-2xl p-6 shadow-glass-card relative overflow-hidden group hover:shadow-lg transition-shadow border border-outline-variant/20">
            <div class="flex justify-between items-start mb-4 relative z-10">
                <div class="p-3 bg-surface-container-low rounded-xl text-primary">
                    <span class="material-symbols-outlined text-2xl">directions_car</span>
                </div>
            </div>
            <h3 class="font-label-sm text-label-sm text-on-surface-variant mb-1 relative z-10">Total Registered Vehicles</h3>
            <p class="font-display-lg-mobile text-display-lg-mobile font-bold text-on-background relative z-10">
                <c:out value="${totalVehicles}"/>
            </p>
            <div class="absolute -right-10 -bottom-10 w-32 h-32 bg-primary/5 rounded-full blur-2xl group-hover:bg-primary/10 transition-colors"></div>
        </div>
    </section>

    <!-- Customer List Section -->
    <section class="bg-surface-container-lowest rounded-2xl shadow-glass-card overflow-hidden border border-outline-variant/20">
        <!-- Controls (Search & Filter) -->
        <form class="p-6 border-b border-outline-variant/20 flex flex-col lg:flex-row gap-4 justify-between items-center bg-surface-bright" action="<c:url value='/admin/customers'/>" method="GET">
            <div class="relative w-full lg:max-w-md">
                <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline">search</span>
                <input name="search" class="w-full bg-surface border-none rounded-xl pl-12 pr-4 py-3 font-body-md text-on-surface focus:ring-2 focus:ring-primary/50 transition-shadow" placeholder="Search by customer name, phone number, or username" type="text" value="<c:out value='${search}'/>">
            </div>
            <div class="flex flex-wrap gap-3 w-full lg:w-auto">
                <select name="tierId" class="bg-surface border-none rounded-xl px-4 py-3 font-label-sm text-label-sm text-on-surface-variant focus:ring-2 focus:ring-primary/50 cursor-pointer">
                    <option value="">All Tiers</option>
                    <c:forEach var="t" items="${tiers}">
                        <option value="${t.id}" ${selectedTierId == t.id ? 'selected' : ''}>
                            <c:out value="${t.name}"/>
                        </option>
                    </c:forEach>
                </select>
                <button type="submit" class="flex items-center gap-2 px-6 py-3 bg-primary text-on-primary hover:bg-primary/90 rounded-xl font-label-sm text-label-sm transition-colors">
                    <span class="material-symbols-outlined text-[18px]">filter_list</span>
                    Apply Filters
                </button>
                <a href="<c:url value='/admin/customers'/>" class="flex items-center gap-2 px-6 py-3 bg-surface hover:bg-surface-container-low rounded-xl font-label-sm text-label-sm text-on-surface-variant transition-colors decoration-transparent">
                    Reset
                </a>
            </div>
        </form>

        <!-- Table -->
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-surface-container-low/50 border-b border-outline-variant/20">
                        <th class="p-4 font-label-sm text-label-sm text-on-surface-variant font-semibold">Customer Info</th>
                        <th class="p-4 font-label-sm text-label-sm text-on-surface-variant font-semibold">Tier</th>
                        <th class="p-4 font-label-sm text-label-sm text-on-surface-variant font-semibold text-right">Points</th>
                        <th class="p-4 font-label-sm text-label-sm text-on-surface-variant font-semibold text-right">Lifetime Spend</th>
                        <th class="p-4 font-label-sm text-label-sm text-on-surface-variant font-semibold text-center">Washes</th>
                        <th class="p-4 font-label-sm text-label-sm text-on-surface-variant font-semibold text-center">Vehicles</th>
                        <th class="p-4 font-label-sm text-label-sm text-on-surface-variant font-semibold">Tier Progress</th>
                    </tr>
                </thead>
                <tbody class="font-body-md text-on-background divide-y divide-outline-variant/10">
                    <c:choose>
                        <c:when test="${not empty customers}">
                            <c:forEach var="u" items="${customers}">
                                <tr class="hover:bg-surface/50 transition-colors">
                                    <td class="p-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary font-label-sm font-bold">
                                                <c:out value="${u.username.substring(0, 2).toUpperCase()}"/>
                                            </div>
                                            <div>
                                                <div class="font-semibold text-on-background"><c:out value="${u.fullname}"/></div>
                                                <div class="text-sm text-on-surface-variant">@<c:out value="${u.username}"/> • <c:out value="${not empty u.phone ? u.phone : 'No phone'}"/></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="p-4">
                                        <c:set var="tierName" value="${not empty u.loyaltyTier ? u.loyaltyTier.name : 'Member'}"/>
                                        <c:choose>
                                            <c:when test="${tierName eq 'Platinum'}">
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-tier-platinum/20 text-blue-800 border border-tier-platinum/30">Platinum</span>
                                            </c:when>
                                            <c:when test="${tierName eq 'Gold'}">
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-tier-gold/20 text-yellow-800 border border-tier-gold/30">Gold</span>
                                            </c:when>
                                            <c:when test="${tierName eq 'Silver'}">
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-tier-silver/20 text-slate-800 border border-tier-silver/30">Silver</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold bg-surface-container-high text-on-surface border border-outline/20">Member</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-4 text-right font-medium text-primary">
                                        <fmt:formatNumber value="${u.pointsBalance}" type="number" groupingUsed="true"/>
                                    </td>
                                    <td class="p-4 text-right font-medium text-emerald-600">
                                        <fmt:formatNumber value="${u.lifetimeSpent}" type="number" groupingUsed="true"/> ₫
                                    </td>
                                    <td class="p-4 text-center font-semibold text-on-background">${u.totalWashes}</td>
                                    <td class="p-4 text-center">
                                        <span class="inline-flex items-center justify-center px-2.5 py-1 rounded-lg text-xs font-bold ${u.vehicleCount > 0 ? 'bg-blue-50 text-blue-700 border border-blue-100' : 'bg-slate-50 text-slate-500 border border-slate-100'}">
                                            ${u.vehicleCount}
                                        </span>
                                    </td>
                                    <td class="p-4">
                                        <!-- Tier Progress Logic -->
                                        <c:choose>
                                            <c:when test="${tierName eq 'Platinum'}">
                                                <div class="flex flex-col gap-1 w-full max-w-[150px]">
                                                    <div class="flex justify-between text-xs text-on-surface-variant font-medium">
                                                        <span class="text-blue-700">Max Tier reached</span>
                                                        <span class="material-symbols-outlined text-[14px] text-tier-platinum">stars</span>
                                                    </div>
                                                    <div class="h-1.5 w-full bg-surface-container rounded-full overflow-hidden">
                                                        <div class="h-full bg-tier-platinum rounded-full w-full"></div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when test="${tierName eq 'Gold'}">
                                                <c:set var="targetWashes" value="30"/>
                                                <c:set var="progPercent" value="${u.totalWashes * 100 / targetWashes}"/>
                                                <c:if test="${progPercent > 100}"><c:set var="progPercent" value="100"/></c:if>
                                                <div class="flex flex-col gap-1 w-full max-w-[150px]">
                                                    <div class="flex justify-between text-xs text-on-surface-variant">
                                                        <span>${u.totalWashes} / ${targetWashes} washes</span>
                                                        <span><fmt:formatNumber value="${progPercent}" maxFractionDigits="0"/>%</span>
                                                    </div>
                                                    <div class="h-1.5 w-full bg-surface-container rounded-full overflow-hidden">
                                                        <div class="h-full bg-primary rounded-full" style="width: ${progPercent}%"></div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when test="${tierName eq 'Silver'}">
                                                <c:set var="targetWashes" value="15"/>
                                                <c:set var="progPercent" value="${u.totalWashes * 100 / targetWashes}"/>
                                                <c:if test="${progPercent > 100}"><c:set var="progPercent" value="100"/></c:if>
                                                <div class="flex flex-col gap-1 w-full max-w-[150px]">
                                                    <div class="flex justify-between text-xs text-on-surface-variant">
                                                        <span>${u.totalWashes} / ${targetWashes} washes</span>
                                                        <span><fmt:formatNumber value="${progPercent}" maxFractionDigits="0"/>%</span>
                                                    </div>
                                                    <div class="h-1.5 w-full bg-surface-container rounded-full overflow-hidden">
                                                        <div class="h-full bg-primary rounded-full" style="width: ${progPercent}%"></div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="targetWashes" value="5"/>
                                                <c:set var="progPercent" value="${u.totalWashes * 100 / targetWashes}"/>
                                                <c:if test="${progPercent > 100}"><c:set var="progPercent" value="100"/></c:if>
                                                <div class="flex flex-col gap-1 w-full max-w-[150px]">
                                                    <div class="flex justify-between text-xs text-on-surface-variant">
                                                        <span>${u.totalWashes} / ${targetWashes} washes</span>
                                                        <span><fmt:formatNumber value="${progPercent}" maxFractionDigits="0"/>%</span>
                                                    </div>
                                                    <div class="h-1.5 w-full bg-surface-container rounded-full overflow-hidden">
                                                        <div class="h-full bg-primary rounded-full" style="width: ${progPercent}%"></div>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="p-8 text-center text-on-surface-variant italic">
                                    <div class="flex flex-col items-center justify-center gap-2">
                                        <span class="material-symbols-outlined text-4xl text-outline-variant">person_search</span>
                                        <span>No customers found matching the search criteria.</span>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </section>

    <!-- Business Logic Note Card -->
    <div class="mt-8 p-6 bg-secondary-fixed/30 rounded-2xl border border-secondary-fixed-dim/30">
        <div class="flex items-start gap-4">
            <span class="material-symbols-outlined text-secondary mt-1">info</span>
            <div>
                <h4 class="font-label-sm text-label-sm font-semibold text-on-secondary-container mb-2">Tier Upgrade Logic</h4>
                <p class="text-sm text-on-surface-variant mb-3">Customer tiers are automatically calculated based on either Total Washes OR Lifetime Spend, whichever threshold is met first.</p>
                <div class="flex flex-wrap gap-4">
                    <div class="flex items-center gap-2 bg-surface-container-lowest px-3 py-1.5 rounded-lg border border-outline-variant/30">
                        <div class="w-2 h-2 rounded-full bg-tier-silver"></div>
                        <span class="text-xs font-medium">Silver: 5 washes / 2,000,000 ₫</span>
                    </div>
                    <div class="flex items-center gap-2 bg-surface-container-lowest px-3 py-1.5 rounded-lg border border-outline-variant/30">
                        <div class="w-2 h-2 rounded-full bg-tier-gold"></div>
                        <span class="text-xs font-medium">Gold: 15 washes / 6,000,000 ₫</span>
                    </div>
                    <div class="flex items-center gap-2 bg-surface-container-lowest px-3 py-1.5 rounded-lg border border-outline-variant/30">
                        <div class="w-2 h-2 rounded-full bg-tier-platinum"></div>
                        <span class="text-xs font-medium">Platinum: 30 washes / 15,000,000 ₫</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-surface dark:bg-surface-container-lowest text-primary dark:text-inverse-primary w-full py-12 border-t border-outline-variant/20 shadow-none">
    <div class="max-w-[1100px] mx-auto flex flex-col md:flex-row justify-between items-center gap-stack-gap-sm px-6">
        <div class="font-label-sm text-label-sm font-semibold opacity-80 hover:opacity-100 transition-opacity">
            © 2024 SmartWash Enterprise Systems. All rights reserved.
        </div>
        <div class="flex gap-6 font-body-md text-body-md text-on-surface-variant dark:text-surface-variant">
            <a class="hover:text-primary dark:hover:text-inverse-primary transition-colors opacity-80 hover:opacity-100 transition-opacity decoration-transparent" href="#">Privacy Policy</a>
            <a class="hover:text-primary dark:hover:text-inverse-primary transition-colors opacity-80 hover:opacity-100 transition-opacity decoration-transparent" href="#">Terms of Service</a>
            <a class="hover:text-primary dark:hover:text-inverse-primary transition-colors opacity-80 hover:opacity-100 transition-opacity decoration-transparent" href="#">Support</a>
        </div>
    </div>
</footer>

</body>
</html>
