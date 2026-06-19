<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Booking Detail #<c:out value="${booking.id}"/> - CleanDash</title>
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
    <div class="max-w-[1280px] mx-auto p-margin-mobile md:p-margin-desktop space-y-6">
        
        <!-- Navigation Back -->
        <div class="flex items-center">
            <a href="<c:url value='/admin/bookings'/>" class="inline-flex items-center gap-1.5 px-3 py-1.5 border border-outline-variant hover:bg-surface-container rounded-xl text-on-surface font-label-md text-label-md transition-colors decoration-transparent">
                <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                Quay lại danh sách
            </a>
        </div>

        <!-- Header Title -->
        <div>
            <h2 class="text-display-lg font-display-lg text-on-surface">Thông tin Booking #<c:out value="${booking.id}"/></h2>
            <p class="text-body-lg font-body-lg text-on-surface-variant mt-1">Chi tiết thông tin khách hàng, xe, gói dịch vụ và các tác vụ nghiệp vụ.</p>
        </div>

        <!-- Alert Feedbacks -->
        <c:if test="${not empty sessionScope.adminMsg}">
            <div class="p-4 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-emerald-600 fill">check_circle</span>
                    <span class="font-semibold text-sm"><c:out value="${sessionScope.adminMsg}"/></span>
                </div>
                <button class="text-emerald-800/60 hover:text-emerald-800 transition-colors" onclick="this.parentElement.remove()">
                    <span class="material-symbols-outlined text-[18px]">close</span>
                </button>
            </div>
            <c:remove var="adminMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.adminError}">
            <div class="p-4 rounded-xl bg-red-50 text-on-error-container border border-red-200 flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-error fill">error</span>
                    <span class="font-semibold text-sm"><c:out value="${sessionScope.adminError}"/></span>
                </div>
                <button class="text-on-error-container/60 hover:text-on-error-container transition-colors" onclick="this.parentElement.remove()">
                    <span class="material-symbols-outlined text-[18px]">close</span>
                </button>
            </div>
            <c:remove var="adminError" scope="session"/>
        </c:if>

        <!-- Bento Grid for Details -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Customer Card -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(0,0,0,0.02)] space-y-4">
                <div class="flex items-center gap-2 border-b border-outline-variant/30 pb-3 text-[#1e3a8a] font-bold text-headline-sm font-headline-md">
                    <span class="material-symbols-outlined text-primary">person</span>
                    Khách hàng
                </div>
                <div class="space-y-3">
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Họ tên</span>
                        <span class="font-semibold text-on-surface"><c:out value="${not empty booking.user.fullname ? booking.user.fullname : booking.user.username}"/></span>
                    </div>
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Tên đăng nhập</span>
                        <span class="text-on-surface-variant font-mono"><c:out value="${booking.user.username}"/></span>
                    </div>
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Số điện thoại</span>
                        <span class="font-semibold text-on-surface"><c:out value="${not empty booking.user.phone ? booking.user.phone : 'Chưa cập nhật'}"/></span>
                    </div>
                    <c:if test="${not empty booking.user.loyaltyTier}">
                        <div class="flex justify-between items-center py-1 border-t border-outline-variant/20 pt-2">
                            <span class="text-on-surface-variant font-label-md text-label-md">Hạng thành viên</span>
                            <span class="font-bold text-primary bg-primary/5 border border-primary/20 px-2.5 py-0.5 rounded-full text-xs uppercase"><c:out value="${booking.user.loyaltyTier.tierName}"/></span>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Vehicle Card -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(0,0,0,0.02)] space-y-4">
                <div class="flex items-center gap-2 border-b border-outline-variant/30 pb-3 text-[#1e3a8a] font-bold text-headline-sm font-headline-md">
                    <span class="material-symbols-outlined text-primary">directions_car</span>
                    Phương tiện
                </div>
                <div class="space-y-3">
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Biển số xe</span>
                        <span class="font-mono font-bold text-on-surface bg-surface-container px-3 py-1 rounded-lg border border-outline-variant/60 tracking-wider"><c:out value="${booking.vehicle.licensePlate}"/></span>
                    </div>
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Thương hiệu</span>
                        <span class="font-semibold text-on-surface"><c:out value="${booking.vehicle.brand}"/></span>
                    </div>
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Màu sắc</span>
                        <span class="font-semibold text-on-surface"><c:out value="${booking.vehicle.color}"/></span>
                    </div>
                </div>
            </div>

            <!-- Service Card -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(0,0,0,0.02)] space-y-4">
                <div class="flex items-center gap-2 border-b border-outline-variant/30 pb-3 text-[#1e3a8a] font-bold text-headline-sm font-headline-md">
                    <span class="material-symbols-outlined text-primary">water_drop</span>
                    Dịch vụ & Lịch hẹn
                </div>
                <div class="space-y-3">
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Gói dịch vụ</span>
                        <span class="font-bold text-primary"><c:out value="${booking.service.name}"/></span>
                    </div>
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Ngày hẹn</span>
                        <span class="font-semibold text-on-surface"><c:out value="${booking.bookingDate}"/></span>
                    </div>
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Khung giờ</span>
                        <span class="font-bold text-on-surface flex items-center gap-1">
                            <span class="material-symbols-outlined text-[16px] text-primary">schedule</span>
                            <c:out value="${booking.timeSlot}"/>
                        </span>
                    </div>
                    <div class="flex justify-between items-center py-2 border-t border-dashed border-outline-variant/80 mt-2">
                        <span class="text-on-surface font-semibold text-body-lg">Tổng chi phí</span>
                        <span class="font-display-lg text-headline-md text-on-surface font-bold">
                            <fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/> ₫
                        </span>
                    </div>
                </div>
            </div>

            <!-- Status Card -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(0,0,0,0.02)] space-y-4">
                <div class="flex items-center gap-2 border-b border-outline-variant/30 pb-3 text-[#1e3a8a] font-bold text-headline-sm font-headline-md">
                    <span class="material-symbols-outlined text-primary">info</span>
                    Trạng thái đơn
                </div>
                <div class="space-y-3">
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Booking</span>
                        <c:choose>
                            <c:when test="${booking.bookingStatus eq 'CONFIRMED'}">
                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#e0f2fe] text-[#0369a1] border border-blue-200">Confirmed</span>
                            </c:when>
                            <c:when test="${booking.bookingStatus eq 'IN_PROGRESS'}">
                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#fef3c7] text-[#92400e] border border-amber-200">In Progress</span>
                            </c:when>
                            <c:when test="${booking.bookingStatus eq 'COMPLETED'}">
                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#dcfce7] text-[#166534] border border-emerald-200">Completed</span>
                            </c:when>
                            <c:when test="${booking.bookingStatus eq 'CANCELLED'}">
                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-error-container text-on-error-container border border-red-200">Cancelled</span>
                            </c:when>
                            <c:when test="${booking.bookingStatus eq 'NO_SHOW'}">
                                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-[#e2e2e9] text-[#45464f] border border-slate-200">No Show</span>
                            </c:when>
                        </c:choose>
                    </div>
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Thanh toán</span>
                        <c:choose>
                            <c:when test="${booking.paymentStatus eq 'PAID'}">
                                <span class="inline-flex items-center gap-1 text-[#15803d] font-bold text-xs bg-emerald-50 border border-emerald-200 px-2.5 py-0.5 rounded-full">
                                    <span class="material-symbols-outlined text-[12px] fill">check_circle</span>
                                    PAID
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="inline-flex items-center gap-1 text-[#c62828] font-bold text-xs bg-red-50 border border-red-200 px-2.5 py-0.5 rounded-full">
                                    <span class="material-symbols-outlined text-[12px]">pending</span>
                                    UNPAID
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="flex justify-between items-center py-1">
                        <span class="text-on-surface-variant font-label-md text-label-md">Ngày đặt</span>
                        <span class="font-semibold text-on-surface text-sm"><fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                    </div>
                    <c:if test="${not empty booking.completedAt}">
                        <div class="flex justify-between items-center py-1">
                            <span class="text-on-surface-variant font-label-md text-label-md">Hoàn thành lúc</span>
                            <span class="font-semibold text-emerald-700 text-sm"><fmt:formatDate value="${booking.completedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                    </c:if>
                    <c:if test="${booking.pointsEarned > 0}">
                        <div class="flex justify-between items-center py-1 border-t border-outline-variant/20 pt-2">
                            <span class="text-on-surface-variant font-label-md text-label-md">Điểm tích lũy</span>
                            <span class="font-bold text-[#7c3aed] flex items-center gap-0.5">
                                <span class="material-symbols-outlined text-[18px]">stars</span>
                                +<c:out value="${booking.pointsEarned}"/> điểm
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Notes Card -->
        <c:if test="${not empty booking.notes}">
            <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(0,0,0,0.02)] space-y-3">
                <div class="flex items-center gap-2 border-b border-outline-variant/30 pb-2 text-[#1e3a8a] font-bold text-headline-sm font-headline-md">
                    <span class="material-symbols-outlined text-primary">notes</span>
                    Ghi chú từ khách hàng
                </div>
                <div class="text-body-md text-on-surface-variant leading-relaxed whitespace-pre-line bg-surface-container-low/50 p-4 rounded-xl border border-outline-variant/20">
                    <c:out value="${booking.notes}"/>
                </div>
            </div>
        </c:if>

        <!-- Actions Panel Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4">
            <!-- Payment Processing Block -->
            <c:if test="${booking.paymentStatus ne 'PAID' and booking.bookingStatus ne 'CANCELLED'}">
                <div class="bg-blue-50 border border-blue-200 rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(29,78,216,0.02)] space-y-4">
                    <div class="flex items-center gap-2 border-b border-blue-200/60 pb-3 text-blue-900 font-bold text-headline-sm font-headline-md">
                        <span class="material-symbols-outlined text-blue-800">payments</span>
                        Thu tiền & Xác nhận thanh toán
                    </div>
                    <p class="text-xs text-blue-800 leading-relaxed font-label-md">
                        Vui lòng chọn phương thức thanh toán thực tế của khách hàng để cập nhật trạng thái thanh toán cho hóa đơn này.
                    </p>
                    <form method="POST" action="<c:url value='/admin/bookings/collect-payment'/>" class="m-0 space-y-4">
                        <input type="hidden" name="bookingId" value="<c:out value='${booking.id}'/>">
                        <div class="space-y-1">
                            <label for="paymentMethod" class="block font-label-md text-label-md text-blue-900">Phương thức thanh toán</label>
                            <select id="paymentMethod" name="paymentMethod" class="w-full bg-white border border-blue-300 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all text-body-md text-on-surface">
                                <option value="CASH">💵 Tiền mặt (Cash)</option>
                                <option value="BANK_TRANSFER">💳 Chuyển khoản (Bank Transfer)</option>
                            </select>
                        </div>
                        <button type="submit" class="w-full py-3 bg-blue-600 hover:bg-blue-700 text-white font-semibold text-sm rounded-xl transition-colors shadow-sm flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined text-[20px] fill">credit_score</span>
                            Xác nhận đã thanh toán thành công
                        </button>
                    </form>
                </div>
            </c:if>

            <!-- Status Management Block -->
            <c:if test="${booking.bookingStatus ne 'COMPLETED' and booking.bookingStatus ne 'CANCELLED' and booking.bookingStatus ne 'NO_SHOW'}">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(0,0,0,0.02)] space-y-4">
                    <div class="flex items-center gap-2 border-b border-outline-variant/30 pb-3 text-[#1e3a8a] font-bold text-headline-sm font-headline-md">
                        <span class="material-symbols-outlined text-primary">settings_applications</span>
                        Quản lý trạng thái Booking
                    </div>
                    <p class="text-xs text-on-surface-variant leading-relaxed">
                        Cập nhật tiến độ của đơn rửa xe. Lưu ý: Lịch hẹn chỉ có thể hoàn thành sau khi khách hàng đã thanh toán xong.
                    </p>
                    <form method="POST" action="<c:url value='/admin/bookings/update-status'/>" class="m-0 pt-2">
                        <input type="hidden" name="bookingId" value="<c:out value='${booking.id}'/>">
                        <div class="flex flex-wrap gap-3">
                            <c:if test="${booking.bookingStatus eq 'CONFIRMED'}">
                                <button type="submit" name="newStatus" value="IN_PROGRESS" class="flex-1 py-3 bg-amber-600 hover:bg-amber-700 text-white font-semibold text-sm rounded-xl transition-colors flex items-center justify-center gap-1.5">
                                    <span class="material-symbols-outlined text-[18px]">play_circle</span>
                                    Tiến hành rửa
                                </button>
                                <button type="submit" name="newStatus" value="NO_SHOW" class="px-4 py-3 border border-outline hover:bg-surface-container text-on-surface font-semibold text-sm rounded-xl transition-colors flex items-center justify-center gap-1.5" onclick="return confirm('Xác nhận khách hàng không đến?')">
                                    <span class="material-symbols-outlined text-[18px]">person_off</span>
                                    Vắng mặt
                                </button>
                                <button type="submit" name="newStatus" value="CANCELLED" class="px-4 py-3 border border-error hover:bg-red-50 text-error font-semibold text-sm rounded-xl transition-colors flex items-center justify-center gap-1.5" onclick="return confirm('Xác nhận hủy lịch đặt này?')">
                                    <span class="material-symbols-outlined text-[18px]">cancel</span>
                                    Hủy đơn
                                </button>
                            </c:if>
                            <c:if test="${booking.bookingStatus eq 'IN_PROGRESS'}">
                                <button type="submit" name="newStatus" value="COMPLETED" class="w-full py-3 bg-emerald-600 hover:bg-emerald-700 text-white font-semibold text-sm rounded-xl transition-colors flex items-center justify-center gap-1.5" onclick="return confirm('Xác nhận hoàn thành rửa xe? (Đơn hàng bắt buộc phải ở trạng thái ĐÃ THANH TOÁN)')">
                                    <span class="material-symbols-outlined text-[18px] fill">check_circle</span>
                                    Hoàn thành dịch vụ
                                </button>
                                <div class="flex w-full gap-3 mt-1">
                                    <button type="submit" name="newStatus" value="NO_SHOW" class="flex-1 py-2.5 border border-outline hover:bg-surface-container text-on-surface font-semibold text-sm rounded-xl transition-colors flex items-center justify-center gap-1.5" onclick="return confirm('Xác nhận khách hàng không đến?')">
                                        <span class="material-symbols-outlined text-[18px]">person_off</span>
                                        Vắng mặt
                                    </button>
                                    <button type="submit" name="newStatus" value="CANCELLED" class="flex-1 py-2.5 border border-error hover:bg-red-50 text-error font-semibold text-sm rounded-xl transition-colors flex items-center justify-center gap-1.5" onclick="return confirm('Xác nhận hủy lịch đặt này?')">
                                        <span class="material-symbols-outlined text-[18px]">cancel</span>
                                        Hủy đơn
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </form>
                </div>
            </c:if>
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
