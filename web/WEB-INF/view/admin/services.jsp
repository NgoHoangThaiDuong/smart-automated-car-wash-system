<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Service Management - CleanDash</title>
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
    <c:param name="activePage" value="services"/>
</c:import>

<!-- Main Content Area -->
<main class="flex-1 w-full bg-surface-container-lowest overflow-y-auto">
    <div class="max-w-[1280px] mx-auto p-margin-mobile md:p-margin-desktop space-y-8">
        
        <!-- Breadcrumbs & Page Header -->
        <div class="flex flex-col gap-1">
            <nav class="flex items-center gap-2 text-label-sm text-on-surface-variant mb-1">
                <a class="hover:text-primary decoration-transparent" href="<c:url value='/admin/dashboard'/>">Dashboard</a>
                <span class="material-symbols-outlined text-xs">chevron_right</span>
                <span class="text-on-surface">Service Management</span>
            </nav>
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-end gap-4">
                <div>
                    <h2 class="text-display-lg font-display-lg text-on-surface">Service Packages</h2>
                    <p class="text-body-lg font-body-lg text-on-surface-variant mt-1">Manage wash options, standard pricing, and wash durations.</p>
                </div>
                <button onclick="openCreateModal()" class="px-4 py-2.5 bg-primary hover:bg-primary/95 text-on-primary font-label-md text-label-md rounded-lg flex items-center gap-2 transition-colors shadow-sm decoration-transparent shrink-0">
                    <span class="material-symbols-outlined text-[18px]">add</span>
                    Thêm dịch vụ mới
                </button>
            </div>
        </div>

        <!-- Alert Notifications -->
        <c:if test="${not empty adminMsg}">
            <div class="p-4 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-emerald-600 fill">check_circle</span>
                    <span class="font-semibold text-sm"><c:out value="${adminMsg}"/></span>
                </div>
                <button class="text-emerald-800/60 hover:text-emerald-800 transition-colors" onclick="this.parentElement.remove()">
                    <span class="material-symbols-outlined text-[18px]">close</span>
                </button>
            </div>
        </c:if>
        <c:if test="${not empty adminError}">
            <div class="p-4 rounded-xl bg-red-50 text-on-error-container border border-red-200 flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-error fill">error</span>
                    <span class="font-semibold text-sm"><c:out value="${adminError}"/></span>
                </div>
                <button class="text-on-error-container/60 hover:text-on-error-container transition-colors" onclick="this.parentElement.remove()">
                    <span class="material-symbols-outlined text-[18px]">close</span>
                </button>
            </div>
        </c:if>

        <!-- Services Bento Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <c:choose>
                <c:when test="${not empty services}">
                    <c:forEach var="ws" items="${services}">
                        <!-- Service Card -->
                        <div class="bg-surface-container-lowest border rounded-2xl p-card-padding shadow-[0px_4px_12px_rgba(0,0,0,0.02)] flex flex-col justify-between relative transition-all duration-300 hover:shadow-[0px_8px_24px_rgba(0,55,176,0.06)] hover:-translate-y-0.5 ${ws.active ? 'border-outline-variant/80' : 'border-dashed border-outline-variant opacity-75'}">
                            <!-- Status Badge -->
                            <div class="absolute top-6 right-6">
                                <c:choose>
                                    <c:when test="${ws.active}">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-surface-container-high text-on-surface-variant border border-outline-variant">Tạm ngưng</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Header Content -->
                            <div class="space-y-3 pr-24">
                                <h3 class="text-headline-md font-headline-md text-on-surface line-clamp-1"><c:out value="${ws.name}"/></h3>
                                <p class="text-body-md text-on-surface-variant line-clamp-3 min-h-[72px]"><c:out value="${ws.description}"/></p>
                            </div>

                            <!-- Metadata & Stats -->
                            <div class="mt-6 pt-4 border-t border-outline-variant/30 space-y-4">
                                <div class="flex justify-between items-center">
                                    <span class="text-headline-md font-headline-md text-primary font-bold">
                                        <fmt:formatNumber value="${ws.price}" type="number" groupingUsed="true"/> ₫
                                    </span>
                                    <span class="flex items-center gap-1 text-on-surface-variant font-label-md text-label-md bg-surface-container-low px-2.5 py-1 rounded-lg">
                                        <span class="material-symbols-outlined text-[16px] text-primary">schedule</span>
                                        <c:out value="${ws.durationMinutes}"/> phút
                                    </span>
                                </div>

                                <div class="flex justify-between items-center text-xs text-on-surface-variant bg-surface-container-lowest border border-outline-variant/40 rounded-xl p-3">
                                    <span class="flex items-center gap-1 font-semibold">
                                        <span class="material-symbols-outlined text-[16px] text-secondary">book_online</span>
                                        Tổng lượt đặt
                                    </span>
                                    <span class="font-bold text-on-surface text-sm"><c:out value="${ws.bookingCount}"/></span>
                                </div>

                                <!-- Actions Grid -->
                                <div class="grid grid-cols-3 gap-2 pt-2">
                                    <!-- Edit Button -->
                                    <button onclick="openEditModal(${ws.id}, '${ws.name}', '${ws.description}', ${ws.price}, ${ws.durationMinutes}, ${ws.active})" class="px-2 py-2 border border-outline-variant hover:border-primary hover:bg-primary/5 text-on-surface hover:text-primary rounded-lg transition-colors flex items-center justify-center gap-1 text-xs font-bold">
                                        <span class="material-symbols-outlined text-[16px]">edit</span>
                                        Sửa
                                    </button>

                                    <!-- Status Toggle Form -->
                                    <form action="<c:url value='/admin/services/toggle-status'/>" method="POST" onsubmit="return confirm('Bạn có chắc muốn thay đổi trạng thái dịch vụ này?')" class="m-0">
                                        <input type="hidden" name="id" value="${ws.id}">
                                        <button type="submit" class="w-full px-2 py-2 border border-outline-variant hover:border-amber-600 hover:bg-amber-50 text-on-surface hover:text-amber-800 rounded-lg transition-colors flex items-center justify-center gap-1 text-xs font-bold">
                                            <span class="material-symbols-outlined text-[16px]">${ws.active ? 'pause' : 'play_arrow'}</span>
                                            <c:out value="${ws.active ? 'Ngưng' : 'Bật'}"/>
                                        </button>
                                    </form>

                                    <!-- Delete Form -->
                                    <form action="<c:url value='/admin/services/delete'/>" method="POST" onsubmit="return confirm('Bạn có thực sự muốn xóa dịch vụ này? Hành động này không thể hoàn tác!')" class="m-0">
                                        <input type="hidden" name="id" value="${ws.id}">
                                        <button type="submit" class="w-full px-2 py-2 border border-error/30 hover:border-error hover:bg-red-50 text-error/80 hover:text-error rounded-lg transition-colors flex items-center justify-center gap-1 text-xs font-bold">
                                            <span class="material-symbols-outlined text-[16px]">delete</span>
                                            Xóa
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-span-1 md:col-span-3 bg-surface border border-outline-variant border-dashed rounded-2xl p-12 text-center text-on-surface-variant flex flex-col items-center justify-center gap-3">
                        <span class="material-symbols-outlined text-5xl text-outline-variant">assignment_late</span>
                        <span class="font-semibold text-lg">Không có dịch vụ nào trong hệ thống.</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- Create/Edit Service Modal -->
<div id="serviceModal" class="fixed inset-0 bg-on-background/40 backdrop-blur-sm z-[100] hidden items-center justify-center p-4">
    <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant shadow-2xl w-full max-w-lg overflow-hidden flex flex-col animate-in fade-in zoom-in-95 duration-200">
        <!-- Modal Header -->
        <div class="px-6 py-4 border-b border-outline-variant/60 bg-surface flex justify-between items-center">
            <h3 class="text-headline-md font-headline-md text-on-surface" id="modalTitle">Thêm dịch vụ mới</h3>
            <button class="text-on-surface-variant hover:text-on-surface transition-colors" onclick="closeModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <!-- Modal Form -->
        <form id="serviceForm" action="<c:url value='/admin/services/create'/>" method="POST" class="m-0">
            <div class="p-6 space-y-4">
                <input type="hidden" name="id" id="serviceId">

                <!-- Service Name -->
                <div class="space-y-1">
                    <label class="block font-label-md text-label-md text-on-surface" for="name">
                        Tên dịch vụ <span class="text-error">*</span>
                    </label>
                    <input type="text" class="w-full bg-surface-container-low border border-outline-variant/60 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all text-body-md" name="name" id="name" required placeholder="Ví dụ: Rửa xe tiêu chuẩn">
                </div>

                <!-- Description -->
                <div class="space-y-1">
                    <label class="block font-label-md text-label-md text-on-surface" for="description">Mô tả dịch vụ</label>
                    <textarea class="w-full bg-surface-container-low border border-outline-variant/60 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all text-body-md resize-none" name="description" id="description" rows="3" placeholder="Mô tả các bước thực hiện..."></textarea>
                </div>

                <!-- Price and Duration Row -->
                <div class="grid grid-cols-2 gap-4">
                    <div class="space-y-1">
                        <label class="block font-label-md text-label-md text-on-surface" for="price">
                            Giá dịch vụ (₫) <span class="text-error">*</span>
                        </label>
                        <input type="number" class="w-full bg-surface-container-low border border-outline-variant/60 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all text-body-md" name="price" id="price" min="0" required placeholder="Ví dụ: 150000">
                    </div>
                    <div class="space-y-1">
                        <label class="block font-label-md text-label-md text-on-surface" for="durationMinutes">
                            Thời lượng rửa (phút) <span class="text-error">*</span>
                        </label>
                        <input type="number" class="w-full bg-surface-container-low border border-outline-variant/60 rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all text-body-md" name="durationMinutes" id="durationMinutes" min="1" required placeholder="Ví dụ: 30">
                    </div>
                </div>

                <!-- Active Toggle Box -->
                <div class="flex items-center gap-3 p-3 bg-surface-container-low rounded-xl border border-outline-variant/30" id="activeGroup">
                    <input type="checkbox" class="w-4 h-4 rounded text-primary focus:ring-primary border-outline-variant/80" name="isActive" id="isActive" checked>
                    <label class="font-label-md text-label-md text-on-surface select-none cursor-pointer" for="isActive">Trạng thái hoạt động ngay</label>
                </div>
            </div>
            <!-- Modal Footer -->
            <div class="px-6 py-4 border-t border-outline-variant/60 flex justify-end gap-3 bg-surface">
                <button type="button" class="px-4 py-2 border border-outline-variant hover:bg-surface-container-high rounded-xl text-on-surface font-label-md text-label-md transition-colors" onclick="closeModal()">Hủy</button>
                <button type="submit" class="px-4 py-2 bg-primary hover:bg-primary/95 text-on-primary hover:shadow font-label-md text-label-md rounded-xl flex items-center gap-2 transition-all" id="btnSubmit">
                    <span class="material-symbols-outlined text-[18px]">save</span>
                    Lưu lại
                </button>
            </div>
        </form>
    </div>
</div>

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

<script>
    const modal = document.getElementById('serviceModal');
    const form = document.getElementById('serviceForm');
    const modalTitle = document.getElementById('modalTitle');
    const btnSubmit = document.getElementById('btnSubmit');

    function openCreateModal() {
        modalTitle.innerText = "Thêm dịch vụ mới";
        btnSubmit.innerHTML = `<span class="material-symbols-outlined text-[18px]">save</span>Thêm mới`;
        form.action = "<c:url value='/admin/services/create'/>";
        
        document.getElementById('serviceId').value = "";
        document.getElementById('name').value = "";
        document.getElementById('description').value = "";
        document.getElementById('price').value = "";
        document.getElementById('durationMinutes').value = "";
        document.getElementById('isActive').checked = true;

        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }

    function openEditModal(id, name, description, price, duration, isActive) {
        modalTitle.innerText = "Chỉnh sửa dịch vụ";
        btnSubmit.innerHTML = `<span class="material-symbols-outlined text-[18px]">save</span>Lưu thay đổi`;
        form.action = "<c:url value='/admin/services/update'/>";

        document.getElementById('serviceId').value = id;
        document.getElementById('name').value = name;
        document.getElementById('description').value = description;
        document.getElementById('price').value = price;
        document.getElementById('durationMinutes').value = duration;
        document.getElementById('isActive').checked = isActive;

        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }

    function closeModal() {
        modal.classList.remove('flex');
        modal.classList.add('hidden');
    }

    // Đóng modal khi bấm ra ngoài
    window.onclick = function(event) {
        if (event.target === modal) {
            closeModal();
        }
    }
</script>
</body>
</html>
