<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Booking Management - CleanDash</title>
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
                        "primary-fixed-dim": "#b7c4ff"
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "2xl": "1rem",
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
<c:import url="/WEB-INF/view/admin/common/navbar.jsp">
    <c:param name="activePage" value="bookings"/>
</c:import>

<!-- Main Content Area -->
<main class="flex-1 w-full bg-surface-container-lowest overflow-y-auto">
    <div class="max-w-[1280px] mx-auto p-margin-mobile md:p-margin-desktop space-y-8">
        
        <!-- Breadcrumbs & Page Header -->
        <div class="flex flex-col gap-1">
            <nav class="flex items-center gap-2 text-label-sm text-on-surface-variant mb-1">
                <a class="hover:text-primary decoration-transparent" href="<c:url value='/admin/dashboard'/>">Dashboard</a>
                <span class="material-symbols-outlined text-xs">chevron_right</span>
                <span class="text-on-surface">Bookings</span>
            </nav>
            <div>
                <h2 class="text-display-lg font-display-lg text-on-surface">Booking Management</h2>
                <p class="text-body-lg font-body-lg text-on-surface-variant mt-1">Track and manage car wash appointments, wash schedules, and payment collections.</p>
            </div>
        </div>

        <!-- Search and Filter Section -->
        <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(0,0,0,0.02)]">
            <form method="GET" action="<c:url value='/admin/bookings'/>" class="space-y-6 m-0">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <!-- Search Input -->
                    <div class="space-y-1">
                        <label for="search" class="block font-label-md text-label-md text-on-surface">Tìm kiếm</label>
                        <div class="relative">
                            <span class="material-symbols-outlined text-on-surface-variant absolute left-3.5 top-1/2 -translate-y-1/2 text-[20px]">search</span>
                            <input id="search" name="search" type="text" placeholder="Mã đặt lịch, tên KH, biển số..." class="w-full bg-surface-container-low border border-outline-variant/60 rounded-xl pl-11 pr-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all text-body-md" value="<c:out value='${search}'/>">
                        </div>
                    </div>

                    <!-- Status Filter -->
                    <div class="space-y-1">
                        <label for="statusFilter" class="block font-label-md text-label-md text-on-surface">Trạng thái Booking</label>
                        <select id="statusFilter" name="status" class="w-full bg-surface-container-low border border-outline-variant/60 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all text-body-md">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="CONFIRMED" <c:if test="${selectedStatus eq 'CONFIRMED'}">selected</c:if>>Confirmed (Đã xác nhận)</option>
                            <option value="IN_PROGRESS" <c:if test="${selectedStatus eq 'IN_PROGRESS'}">selected</c:if>>In Progress (Đang rửa)</option>
                            <option value="COMPLETED" <c:if test="${selectedStatus eq 'COMPLETED'}">selected</c:if>>Completed (Hoàn thành)</option>
                            <option value="CANCELLED" <c:if test="${selectedStatus eq 'CANCELLED'}">selected</c:if>>Cancelled (Đã hủy)</option>
                            <option value="NO_SHOW" <c:if test="${selectedStatus eq 'NO_SHOW'}">selected</c:if>>No Show (Không đến)</option>
                        </select>
                    </div>

                    <!-- Date Filter -->
                    <div class="space-y-1">
                        <label for="dateFilter" class="block font-label-md text-label-md text-on-surface">Ngày hẹn</label>
                        <input id="dateFilter" name="date" type="date" class="w-full bg-surface-container-low border border-outline-variant/60 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all text-body-md" value="<c:out value='${date}'/>">
                    </div>
                </div>

                <!-- Action buttons -->
                <div class="flex justify-end items-center gap-3 pt-4 border-t border-outline-variant/30">
                    <a href="<c:url value='/admin/bookings'/>" class="px-4 py-2 border border-outline-variant hover:bg-surface-container rounded-xl text-on-surface font-label-md text-label-md transition-colors decoration-transparent">Xóa bộ lọc</a>
                    <button type="submit" class="px-5 py-2 bg-primary hover:bg-primary/95 text-on-primary font-label-md text-label-md rounded-xl flex items-center gap-2 transition-colors shadow-sm">
                        <span class="material-symbols-outlined text-[18px]">filter_alt</span>
                        Áp dụng bộ lọc
                    </button>
                </div>
            </form>
        </div>

        <!-- Metadata Section -->
        <div class="flex justify-between items-center bg-surface-container-low px-6 py-4 rounded-xl border border-outline-variant/50">
            <div class="text-body-md text-on-surface-variant">
                Tìm thấy <strong class="text-on-surface font-bold"><c:out value="${bookings != null ? bookings.size() : 0}"/></strong> lịch đặt xe phù hợp.
            </div>
        </div>

        <!-- Booking Table Card -->
        <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl shadow-[0px_4px_12px_rgba(0,0,0,0.03)] overflow-hidden">
            <div class="overflow-x-auto w-full custom-scrollbar">
                <table class="w-full text-left whitespace-nowrap min-w-[1000px] border-collapse">
                    <thead class="bg-surface-dim/40 font-label-sm text-label-sm text-on-surface-variant uppercase tracking-wider">
                        <tr>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Mã Đơn</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Khách hàng</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Phương tiện</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Gói Dịch vụ</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Lịch hẹn</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Trạng thái</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant">Thanh toán</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant text-right">Thành tiền</th>
                            <th class="px-6 py-4 font-semibold border-b border-outline-variant text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-outline-variant/10 font-body-md text-body-md text-on-surface">
                        <c:choose>
                            <c:when test="${empty bookings}">
                                <tr>
                                    <td colspan="9" class="p-12 text-center text-on-surface-variant italic">
                                        <div class="flex flex-col items-center justify-center gap-2">
                                            <span class="material-symbols-outlined text-4xl text-outline-variant">assignment_late</span>
                                            <span>Không tìm thấy lịch đặt nào phù hợp với bộ lọc.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="b" items="${bookings}">
                                    <tr class="hover:bg-surface-container-low transition-colors group">
                                        <td class="px-6 py-4 font-semibold text-primary">
                                            #BK-<c:out value="${b.id}"/>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="font-semibold text-on-surface leading-tight">
                                                <c:out value="${not empty b.user.fullname ? b.user.fullname : b.user.username}"/>
                                            </div>
                                            <div class="text-xs text-on-surface-variant mt-0.5">
                                                <c:out value="${b.user.phone != null ? b.user.phone : 'Không có SĐT'}"/>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="font-mono font-semibold tracking-wide text-on-surface">
                                                <c:out value="${b.vehicle.licensePlate}"/>
                                            </div>
                                            <div class="text-xs text-on-surface-variant">
                                                <c:out value="${b.vehicle.brand} ${b.vehicle.color}"/>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 font-semibold text-on-surface">
                                            <c:out value="${b.service.name}"/>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="font-semibold text-on-surface"><c:out value="${b.bookingDate}"/></div>
                                            <div class="text-xs text-primary font-semibold flex items-center gap-1 mt-0.5">
                                                <span class="material-symbols-outlined text-[14px]">schedule</span>
                                                <c:out value="${b.timeSlot}"/>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${b.bookingStatus eq 'CONFIRMED'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#e0f2fe] text-[#0369a1] border border-blue-200">Confirmed</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'IN_PROGRESS'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#fef3c7] text-[#92400e] border border-amber-200">In Progress</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'COMPLETED'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#dcfce7] text-[#166534] border border-emerald-200">Completed</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'CANCELLED'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-error-container text-on-error-container border border-red-200">Cancelled</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'NO_SHOW'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#e2e2e9] text-[#45464f] border border-slate-200">No Show</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="flex flex-col gap-1 items-start">
                                                <c:choose>
                                                    <c:when test="${b.paymentStatus eq 'PAID'}">
                                                        <span class="inline-flex items-center gap-1 text-[#15803d] font-bold text-xs bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded-full">
                                                            <span class="material-symbols-outlined text-[12px] fill">check_circle</span>
                                                            PAID
                                                        </span>
                                                        <div class="text-[10px] font-semibold text-on-surface-variant">
                                                            <c:choose>
                                                                <c:when test="${b.paymentMethod eq 'CASH'}">💵 Tiền mặt</c:when>
                                                                <c:when test="${b.paymentMethod eq 'BANK_TRANSFER'}">💳 Chuyển khoản</c:when>
                                                                <c:otherwise><c:out value="${b.paymentMethod}"/></c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1 text-[#c62828] font-bold text-xs bg-red-50 border border-red-200 px-2 py-0.5 rounded-full">
                                                            <span class="material-symbols-outlined text-[12px]">pending</span>
                                                            UNPAID
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 text-right font-bold text-on-surface">
                                            <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="px-6 py-4 text-center">
                                            <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="inline-flex items-center gap-1 px-3 py-1.5 bg-surface-container hover:bg-surface-container-high text-primary font-semibold text-sm rounded-lg transition-colors decoration-transparent">
                                                Chi tiết
                                                <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
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
