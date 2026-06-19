<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Operational Dashboard - CleanDash</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@600;700&amp;family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface": "#f9f9ff",
                        "error": "#ba1a1a",
                        "on-error-container": "#93000a",
                        "tertiary-fixed-dim": "#c4c7c9",
                        "surface-variant": "#d8e3fb",
                        "on-primary-fixed-variant": "#0039b5",
                        "on-tertiary": "#ffffff",
                        "on-primary-container": "#cad3ff",
                        "secondary": "#505f76",
                        "primary": "#0037b0",
                        "surface-dim": "#cfdaf2",
                        "tertiary-fixed": "#e0e3e5",
                        "outline": "#747686",
                        "inverse-on-surface": "#ecf1ff",
                        "surface-container": "#e7eeff",
                        "secondary-fixed-dim": "#b7c8e1",
                        "on-primary-fixed": "#001551",
                        "on-secondary": "#ffffff",
                        "outline-variant": "#c4c5d7",
                        "tertiary-container": "#595c5e",
                        "surface-container-highest": "#d8e3fb",
                        "on-error": "#ffffff",
                        "on-secondary-fixed": "#0b1c30",
                        "on-tertiary-fixed-variant": "#444749",
                        "surface-bright": "#f9f9ff",
                        "primary-container": "#1d4ed8",
                        "background": "#f8f9ff",
                        "surface-container-high": "#dee8ff",
                        "on-secondary-fixed-variant": "#38485d",
                        "surface-tint": "#2151da",
                        "on-primary": "#ffffff",
                        "secondary-fixed": "#d3e4fe",
                        "on-background": "#111c2d",
                        "primary-fixed": "#dce1ff",
                        "on-tertiary-container": "#d2d4d6",
                        "secondary-container": "#d0e1fb",
                        "error-container": "#ffdad6",
                        "surface-container-low": "#f0f3ff",
                        "inverse-surface": "#263143",
                        "inverse-primary": "#b7c4ff",
                        "surface-container-lowest": "#ffffff",
                        "on-surface-variant": "#434655",
                        "on-tertiary-fixed": "#191c1e",
                        "on-surface": "#111c2d",
                        "on-secondary-container": "#54647a",
                        "tertiary": "#414546",
                        "primary-fixed-dim": "#b7c4ff",
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
                        "container-max-width": "1280px",
                        "margin-mobile": "16px",
                        "margin-desktop": "32px",
                        "card-padding": "24px",
                        "gutter": "24px",
                        "unit": "4px"
                    },
                    fontFamily: {
                        "label-sm": ["Inter"],
                        "headline-md": ["Hanken Grotesk"],
                        "body-lg": ["Inter"],
                        "headline-lg-mobile": ["Hanken Grotesk"],
                        "label-md": ["Inter"],
                        "headline-lg": ["Hanken Grotesk"],
                        "display-lg": ["Hanken Grotesk"],
                        "body-md": ["Inter"]
                    },
                    fontSize: {
                        "label-sm": ["12px", { "lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600" }],
                        "headline-md": ["24px", { "lineHeight": "32px", "fontWeight": "600" }],
                        "body-lg": ["18px", { "lineHeight": "28px", "fontWeight": "400" }],
                        "headline-lg-mobile": ["24px", { "lineHeight": "32px", "fontWeight": "700" }],
                        "label-md": ["14px", { "lineHeight": "20px", "letterSpacing": "0.01em", "fontWeight": "500" }],
                        "headline-lg": ["32px", { "lineHeight": "40px", "fontWeight": "700" }],
                        "display-lg": ["48px", { "lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700" }],
                        "body-md": ["16px", { "lineHeight": "24px", "fontWeight": "400" }]
                    },
                    boxShadow: {
                        'glass-card': '0 20px 40px rgba(0, 55, 176, 0.03)',
                    }
                }
            }
        }
    </script>
    <style>
        .custom-scrollbar::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: transparent;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #d8e3fb;
            border-radius: 4px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
            background: #b7c8e1;
        }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .material-symbols-outlined.fill {
            font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-md antialiased min-h-screen flex flex-col pt-20">

<!-- Sticky Top Navbar -->
<c:import url="/WEB-INF/view/common/navbar.jsp">
    <c:param name="activePage" value="dashboard"/>
</c:import>

<!-- Main Content Area -->
<main class="flex-1 w-full bg-surface-container-lowest overflow-y-auto">
    <div class="max-w-[1280px] mx-auto p-margin-mobile md:p-margin-desktop space-y-8">
        
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h2 class="text-display-lg font-display-lg text-on-surface">Overview</h2>
                <p class="text-body-lg font-body-lg text-on-surface-variant mt-1">Operational status and quick stats for today.</p>
            </div>
            <div class="flex gap-3">
                <a href="<c:url value='/admin/dashboard'/>" class="px-4 py-2.5 rounded-lg border border-outline text-on-surface font-label-md text-label-md flex items-center gap-2 hover:bg-surface-container transition-colors decoration-transparent">
                    <span class="material-symbols-outlined text-[18px]">calendar_today</span>
                    Today
                </a>
            </div>
        </div>

        <!-- KPI Cards Grid -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 md:gap-gutter">
            <!-- Revenue Card (col-span-2) -->
            <div class="md:col-span-2 bg-gradient-to-br from-primary-container to-primary p-card-padding rounded-2xl shadow-sm relative overflow-hidden flex flex-col justify-between min-h-[140px] text-white">
                <div class="absolute -right-8 -top-8 w-32 h-32 rounded-full bg-white opacity-10"></div>
                <div class="flex justify-between items-start relative z-10">
                    <h3 class="font-label-sm text-label-sm text-on-primary-container uppercase tracking-wider">Total Revenue (PAID)</h3>
                    <span class="material-symbols-outlined text-on-primary-container" style="font-variation-settings: 'FILL' 1">payments</span>
                </div>
                <div class="relative z-10 mt-4 flex items-baseline gap-2">
                    <span class="text-display-lg font-display-lg text-on-primary">
                        <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫
                    </span>
                </div>
            </div>

            <!-- Total Bookings (col-span-1) -->
            <div class="bg-surface-container-lowest border border-outline-variant p-card-padding rounded-2xl shadow-[0px_4px_12px_rgba(0,0,0,0.03)] flex flex-col justify-between min-h-[140px]">
                <div class="flex justify-between items-start">
                    <h3 class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider">Today's Bookings</h3>
                    <span class="material-symbols-outlined text-primary">book_online</span>
                </div>
                <div class="mt-4 flex items-baseline gap-2">
                    <span class="text-headline-lg font-headline-lg text-on-surface">${todayCount}</span>
                </div>
            </div>

            <!-- Completed Bookings (col-span-1) -->
            <div class="bg-surface-container-lowest border border-outline-variant p-card-padding rounded-2xl shadow-[0px_4px_12px_rgba(0,0,0,0.03)] flex flex-col justify-between min-h-[140px]">
                <div class="flex justify-between items-start">
                    <h3 class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider">Completed Bookings</h3>
                    <span class="material-symbols-outlined text-emerald-600">check_circle</span>
                </div>
                <div class="mt-4 flex items-baseline gap-2">
                    <span class="text-headline-lg font-headline-lg text-on-surface">${completedCount}</span>
                </div>
            </div>

            <!-- Status Counters Row -->
            <div class="col-span-1 md:col-span-4 grid grid-cols-2 md:grid-cols-4 gap-4">
                <!-- Pending Card -->
                <div class="bg-surface-container-lowest border-t-4 border-outline p-4 rounded-b-2xl rounded-t border-x border-b border-outline-variant shadow-sm flex flex-col">
                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase mb-1">Pending</span>
                    <span class="text-headline-md font-headline-md text-on-surface">${confirmedCount}</span>
                </div>
                
                <!-- In Progress Card -->
                <div class="bg-surface-container-lowest border-t-4 border-[#b45309] p-4 rounded-b-2xl rounded-t border-x border-b border-outline-variant shadow-sm flex flex-col">
                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase mb-1">In Progress</span>
                    <span class="text-headline-md font-headline-md text-on-surface">${inProgressCount}</span>
                </div>
                
                <!-- Completed Card -->
                <div class="bg-surface-container-lowest border-t-4 border-[#15803d] p-4 rounded-b-2xl rounded-t border-x border-b border-outline-variant shadow-sm flex flex-col">
                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase mb-1">Completed</span>
                    <span class="text-headline-md font-headline-md text-on-surface">${completedCount}</span>
                </div>
                
                <!-- Today Card -->
                <div class="bg-surface-container-lowest border-t-4 border-primary p-4 rounded-b-2xl rounded-t border-x border-b border-outline-variant shadow-sm flex flex-col">
                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase mb-1">Today's Total</span>
                    <span class="text-headline-md font-headline-md text-on-surface">${todayCount}</span>
                </div>
            </div>
        </div>

        <!-- Booking Management Section -->
        <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl shadow-[0px_4px_12px_rgba(0,0,0,0.03)] overflow-hidden flex flex-col">
            <!-- Table Header & Controls -->
            <div class="p-card-padding border-b border-outline-variant bg-surface-bright flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h3 class="text-headline-md font-headline-md text-on-surface">Recent Wash Orders</h3>
                    <p class="font-body-md text-body-md text-on-surface-variant">Manage and monitor daily operational flow.</p>
                </div>
                <div class="flex flex-wrap items-center gap-3">
                    <a href="<c:url value='/admin/bookings'/>" class="px-4 py-2 bg-primary hover:bg-primary/95 text-on-primary font-label-md text-label-md rounded-lg flex items-center gap-2 transition-colors shadow-sm decoration-transparent">
                        <span class="material-symbols-outlined text-[18px]">list</span>
                        All Bookings
                    </a>
                </div>
            </div>

            <!-- Table Container -->
            <div class="overflow-x-auto w-full custom-scrollbar">
                <table class="w-full text-left whitespace-nowrap min-w-[1000px] border-collapse">
                    <thead class="bg-surface-dim/40 font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider">
                        <tr>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Mã đơn</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Khách hàng</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Thông tin xe</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Dịch vụ rửa</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Thời gian</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant text-right">Thành tiền</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Trạng thái</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Thanh toán</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant text-right">Hành động</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-outline-variant/10 font-body-md text-body-md text-on-surface">
                        <c:choose>
                            <c:when test="${not empty recentBookings}">
                                <c:forEach var="b" items="${recentBookings}">
                                    <tr class="hover:bg-surface-container-low transition-colors group">
                                        <td class="px-6 py-4 font-semibold text-primary">
                                            #BK-<c:out value="${b.id}"/>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="flex items-center gap-3">
                                                <div class="w-8 h-8 rounded-full bg-secondary-container text-on-secondary-container flex items-center justify-center font-label-md font-bold shrink-0">
                                                    <c:out value="${b.user.username.substring(0, 2).toUpperCase()}"/>
                                                </div>
                                                <div>
                                                    <p class="font-semibold text-on-surface leading-tight"><c:out value="${b.user.fullname}"/></p>
                                                    <c:set var="userTier" value="${not empty b.user.loyaltyTier ? b.user.loyaltyTier.name : 'Member'}"/>
                                                    <c:choose>
                                                        <c:when test="${userTier eq 'Platinum'}">
                                                            <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[9px] font-bold tracking-wide bg-tier-platinum/20 text-blue-800 border border-tier-platinum/30 uppercase mt-0.5">Platinum</span>
                                                        </c:when>
                                                        <c:when test="${userTier eq 'Gold'}">
                                                            <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[9px] font-bold tracking-wide bg-tier-gold/20 text-yellow-800 border border-tier-gold/30 uppercase mt-0.5">Gold</span>
                                                        </c:when>
                                                        <c:when test="${userTier eq 'Silver'}">
                                                            <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[9px] font-bold tracking-wide bg-tier-silver/20 text-slate-800 border border-tier-silver/30 uppercase mt-0.5">Silver</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center px-2 py-0.5 rounded-full text-[9px] font-bold tracking-wide bg-surface-container-high text-on-surface border border-outline/20 uppercase mt-0.5">Member</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="font-mono font-semibold tracking-wide text-on-surface"><c:out value="${b.vehicle.licensePlate}"/></div>
                                            <div class="text-xs text-on-surface-variant"><c:out value="${b.vehicle.brand}"/> <c:out value="${b.vehicle.model}"/></div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="font-semibold text-on-surface"><c:out value="${b.service.name}"/></div>
                                            <div class="text-xs text-on-surface-variant"><fmt:formatNumber value="${b.service.price}" type="number" groupingUsed="true"/> ₫</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="font-semibold text-on-surface"><c:out value="${b.bookingDate}"/></div>
                                            <div class="text-xs text-on-surface-variant flex items-center gap-1">
                                                <span class="material-symbols-outlined text-[14px]">schedule</span>
                                                <c:out value="${b.timeSlot}"/>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 text-right font-bold text-on-surface">
                                            <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${b.bookingStatus eq 'CONFIRMED'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#e0f2fe] text-[#0369a1] border border-blue-200">Chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'IN_PROGRESS'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#fef3c7] text-[#92400e] border border-amber-200">Đang rửa</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'COMPLETED'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#dcfce7] text-[#166534] border border-emerald-200">Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'CANCELLED'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-error-container text-on-error-container border border-red-200">Đã hủy</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'NO_SHOW'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#e2e2e9] text-[#45464f] border border-slate-200">No Show</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${b.paymentStatus eq 'PAID'}">
                                                    <span class="inline-flex items-center gap-1 text-[#15803d] font-semibold text-sm">
                                                        <span class="material-symbols-outlined text-[16px] fill">check_circle</span>
                                                        Đã thanh toán
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center gap-1 text-[#c62828] font-semibold text-sm">
                                                        <span class="material-symbols-outlined text-[16px]">pending</span>
                                                        Chưa thanh toán
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 text-right">
                                            <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="inline-flex items-center gap-1 px-3 py-1.5 bg-surface-container hover:bg-surface-container-high text-primary font-semibold text-sm rounded-lg transition-colors decoration-transparent">
                                                Chi tiết
                                                <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="p-8 text-center text-on-surface-variant italic">
                                        <div class="flex flex-col items-center justify-center gap-2">
                                            <span class="material-symbols-outlined text-4xl text-outline-variant">assignment_late</span>
                                            <span>Không có lịch đặt gần đây.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-surface dark:bg-surface-container-lowest text-primary dark:text-inverse-primary w-full py-12 border-t border-outline-variant/20 shadow-none mt-12">
    <div class="max-w-[1280px] mx-auto flex flex-col md:flex-row justify-between items-center gap-stack-gap-sm px-6">
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
