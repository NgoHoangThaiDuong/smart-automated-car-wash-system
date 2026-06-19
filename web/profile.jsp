<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - SmartWash Pro</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#004ac6",
                        "background": "#f8f9ff",
                        "surface": "#ffffff",
                        "on-surface": "#0b1c30",
                        "on-surface-variant": "#434655",
                        "outline-variant": "#c3c6d7",
                        "tier-silver": "#94a3b8",
                        "tier-gold": "#fbbf24",
                        "tier-platinum": "#3b82f6"
                    },
                    borderRadius: {
                        "xl": "0.75rem",
                        "2xl": "1rem"
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
        
        /* Premium custom gradient for tiers */
        .premium-silver {
            background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e1 50%, #94a3b8 100%);
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }
        .premium-gold {
            background: linear-gradient(135deg, #fef08a 0%, #facc15 50%, #ca8a04 100%);
            text-shadow: 0 1px 2px rgba(0,0,0,0.15);
        }
        .premium-platinum {
            background: linear-gradient(135deg, #bfdbfe 0%, #60a5fa 50%, #1d4ed8 100%);
            text-shadow: 0 1px 2px rgba(0,0,0,0.15);
        }
        .premium-member {
            background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-md antialiased min-h-screen flex flex-col pt-20">

    <!-- Shared Top Navbar -->
    <c:import url="/WEB-INF/view/common/navbar.jsp">
        <c:param name="activePage" value="profile"/>
    </c:import>

    <!-- Main Content Area -->
    <main class="flex-1 w-full bg-slate-50/50 overflow-y-auto">
        <div class="max-w-[1280px] mx-auto px-6 py-8 space-y-8">
            
            <!-- Page Header -->
            <div>
                <h2 class="text-3xl font-bold tracking-tight text-slate-900">Hồ sơ cá nhân</h2>
                <p class="text-slate-500 mt-1">Quản lý tài khoản, xem hạng thành viên và các phương tiện đã đăng ký.</p>
            </div>

            <!-- Bento Grid Layout -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                
                <!-- Left Side: Member & Points Summary -->
                <div class="space-y-6 lg:col-span-1">
                    
                    <!-- Loyalty Tier Card -->
                    <c:set var="tierName" value="${not empty currentUser.loyaltyTier ? currentUser.loyaltyTier.name : 'Member'}" />
                    <c:set var="tierClass" value="premium-member text-slate-700" />
                    <c:if test="${tierName eq 'Silver'}"><c:set var="tierClass" value="premium-silver text-slate-800" /></c:if>
                    <c:if test="${tierName eq 'Gold'}"><c:set var="tierClass" value="premium-gold text-white" /></c:if>
                    <c:if test="${tierName eq 'Platinum'}"><c:set var="tierClass" value="premium-platinum text-white" /></c:if>
                    
                    <div id="tier-card" class="${tierClass} p-6 rounded-2xl shadow-md flex justify-between items-center transform transition-all duration-300 hover:scale-[1.02] cursor-pointer">
                        <div class="space-y-1">
                            <span class="text-xs font-bold uppercase tracking-wider opacity-75">Hạng thành viên</span>
                            <h3 id="tier-name" class="text-2xl font-extrabold tracking-tight"><c:out value="${tierName}"/></h3>
                        </div>
                        <div class="w-14 h-14 bg-white/20 backdrop-blur-md rounded-2xl flex items-center justify-center shadow-inner">
                            <svg class="w-8 h-8 fill-current" viewBox="0 0 24 24">
                                <path d="M2 4l3 5 7-6 7 6 3-5v14H2V4zm2 12h16v-2H4v2zm0-4h16V9.8L17.7 7l-5.7 4.9L6.3 7 4 9.8V12z"/>
                            </svg>
                        </div>
                    </div>

                    <!-- Points Card -->
                    <div class="bg-white p-6 rounded-2xl border border-slate-200/60 shadow-sm flex items-center justify-between">
                        <div class="space-y-1">
                            <div class="flex items-center gap-1.5 text-slate-500 font-medium text-sm">
                                <span class="material-symbols-outlined text-[18px]">monetization_on</span>
                                Điểm tích lũy
                            </div>
                            <div class="flex items-baseline gap-1 mt-1">
                                <span id="points-val" class="text-3xl font-extrabold text-slate-900">
                                    <fmt:formatNumber value="${currentUser.pointsBalance}" type="number"/>
                                </span>
                                <span class="text-slate-500 font-semibold text-sm">điểm</span>
                            </div>
                        </div>
                        <div class="w-12 h-12 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                            <span class="material-symbols-outlined text-2xl fill">star</span>
                        </div>
                    </div>

                    <!-- Next Tier Progression -->
                    <c:choose>
                        <c:when test="${not empty nextTier}">
                            <div id="progression-card" class="bg-white p-6 rounded-2xl border border-slate-200/60 shadow-sm space-y-4">
                                <div class="flex items-center gap-1.5 text-slate-500 font-medium text-sm">
                                    <span class="material-symbols-outlined text-[18px]">trending_up</span>
                                    Phần thưởng tiếp theo
                                </div>
                                <div class="flex items-center justify-between">
                                    <span class="font-bold text-slate-800" id="progression-title">Nâng hạng lên <c:out value="${nextTier.name}"/></span>
                                    <span id="progression-badge" class="px-2.5 py-1 bg-primary/5 text-primary text-xs font-bold rounded-lg">
                                        Còn <fmt:formatNumber value="${remainingSpend}" type="number"/> điểm nữa
                                    </span>
                                </div>
                                <div class="space-y-2">
                                    <div class="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                                        <div id="progress-fill" class="h-full bg-primary rounded-full transition-all duration-500" style="width: ${progressPercent}%;"></div>
                                    </div>
                                    <div class="flex justify-between text-xs font-semibold text-slate-400">
                                        <span id="label-current"><fmt:formatNumber value="${currentUser.lifetimeSpent}" type="number"/> điểm đã tích</span>
                                        <span id="label-target">Yêu cầu: <fmt:formatNumber value="${nextTier.minSpend}" type="number"/> điểm</span>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                    </c:choose>

                </div>

                <!-- Right Side: Vehicles & Personal Details (Grid columns spanning 2) -->
                <div class="lg:col-span-2 space-y-8">
                    
                    <!-- Vehicles Management Section -->
                    <div class="bg-white rounded-2xl border border-slate-200/60 shadow-sm overflow-hidden">
                        <div class="p-6 border-b border-slate-100 flex items-center justify-between">
                            <div class="flex items-center gap-2">
                                <span class="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center">
                                    <span class="material-symbols-outlined text-[20px]">directions_car</span>
                                </span>
                                <h3 class="font-bold text-lg text-slate-900">Danh sách xe</h3>
                            </div>
                            <button class="px-4 py-2 bg-primary hover:bg-primary/95 text-white font-semibold text-sm rounded-xl flex items-center gap-1.5 transition-colors shadow-sm" onclick="showAddForm()">
                                <span class="material-symbols-outlined text-[18px]">add</span>
                                Thêm xe mới
                            </button>
                        </div>

                        <!-- Alerts and Notifications for Vehicles -->
                        <div id="vehicle-alert" class="px-6 pt-4">
                            <c:if test="${param.msg eq 'vehicle_add_success'}">
                                <div class="p-4 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 flex items-center gap-2 alert-box">
                                    <span class="material-symbols-outlined text-emerald-600 fill">check_circle</span>
                                    <span class="font-semibold text-sm">Thêm phương tiện thành công!</span>
                                </div>
                            </c:if>
                            <c:if test="${param.msg eq 'vehicle_update_success'}">
                                <div class="p-4 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 flex items-center gap-2 alert-box">
                                    <span class="material-symbols-outlined text-emerald-600 fill">check_circle</span>
                                    <span class="font-semibold text-sm">Cập nhật phương tiện thành công!</span>
                                </div>
                            </c:if>
                            <c:if test="${param.msg eq 'vehicle_delete_success'}">
                                <div class="p-4 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 flex items-center gap-2 alert-box">
                                    <span class="material-symbols-outlined text-emerald-600 fill">check_circle</span>
                                    <span class="font-semibold text-sm">Xóa phương tiện thành công!</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty vehicleError}">
                                <div class="p-4 rounded-xl bg-red-50 text-red-800 border border-red-200 flex items-center gap-2 alert-box">
                                    <span class="material-symbols-outlined text-red-600 fill">error</span>
                                    <span class="font-semibold text-sm"><c:out value="${vehicleError}"/></span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Add Vehicle Inline Form -->
                        <div id="addForm" class="hidden px-6 py-5 border-b border-slate-100 bg-slate-50/50">
                            <div class="flex items-center justify-between mb-4">
                                <h4 class="font-bold text-slate-800 flex items-center gap-1.5">
                                    <span class="material-symbols-outlined text-[18px]">add_circle</span>
                                    Thêm xe mới
                                </h4>
                                <button class="w-8 h-8 rounded-full hover:bg-slate-200 flex items-center justify-center text-slate-500 transition-colors" onclick="closeForms()">&times;</button>
                            </div>
                            <form id="addVehicleForm" method="POST" action="<c:url value='/vehicles/add'/>" class="space-y-4">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-xs font-bold text-slate-500 uppercase">Biển số xe *</label>
                                        <input type="text" id="add-plate" name="licensePlate" placeholder="Ví dụ: 29A-12345" required class="px-4 py-2.5 rounded-xl border border-slate-200 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary text-sm font-semibold">
                                    </div>
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-xs font-bold text-slate-500 uppercase">Hãng xe</label>
                                        <input type="text" id="add-brand" name="brand" placeholder="Ví dụ: Toyota" class="px-4 py-2.5 rounded-xl border border-slate-200 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary text-sm">
                                    </div>
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-xs font-bold text-slate-500 uppercase">Dòng xe</label>
                                        <input type="text" id="add-model" name="model" placeholder="Ví dụ: Camry" class="px-4 py-2.5 rounded-xl border border-slate-200 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary text-sm">
                                    </div>
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-xs font-bold text-slate-500 uppercase">Màu xe</label>
                                        <input type="text" id="add-color" name="color" placeholder="Ví dụ: Trắng" class="px-4 py-2.5 rounded-xl border border-slate-200 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary text-sm">
                                    </div>
                                </div>
                                <div class="flex justify-end gap-3 pt-2">
                                    <button type="button" class="px-4 py-2 rounded-xl text-slate-500 hover:bg-slate-100 font-semibold text-sm transition-colors" onclick="closeForms()">Hủy</button>
                                    <button type="submit" id="addSubmitBtn" class="px-5 py-2 rounded-xl bg-primary hover:bg-primary/95 text-white font-semibold text-sm flex items-center gap-1.5 shadow-sm transition-colors">
                                        <span class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin hidden" id="addSpinner"></span>
                                        <span id="addBtnText">✓ Thêm</span>
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Edit Vehicle Inline Form -->
                        <div id="editForm" class="hidden px-6 py-5 border-b border-slate-100 bg-amber-50/20">
                            <div class="flex items-center justify-between mb-4">
                                <h4 class="font-bold text-amber-800 flex items-center gap-1.5">
                                    <span class="material-symbols-outlined text-[18px]">edit_square</span>
                                    Cập nhật xe
                                </h4>
                                <button class="w-8 h-8 rounded-full hover:bg-amber-100/50 flex items-center justify-center text-amber-800 transition-colors" onclick="closeForms()">&times;</button>
                            </div>
                            <form id="editVehicleForm" method="POST" action="<c:url value='/vehicles/update'/>" class="space-y-4">
                                <input type="hidden" id="edit-id" name="vehicleId">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-xs font-bold text-amber-800/80 uppercase">Biển số xe *</label>
                                        <input type="text" id="edit-plate" name="licensePlate" required class="px-4 py-2.5 rounded-xl border border-amber-200 focus:outline-none focus:border-amber-600 focus:ring-1 focus:ring-amber-600 text-sm font-semibold bg-white">
                                    </div>
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-xs font-bold text-amber-800/80 uppercase">Hãng xe</label>
                                        <input type="text" id="edit-brand" name="brand" class="px-4 py-2.5 rounded-xl border border-amber-200 focus:outline-none focus:border-amber-600 focus:ring-1 focus:ring-amber-600 text-sm bg-white">
                                    </div>
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-xs font-bold text-amber-800/80 uppercase">Dòng xe</label>
                                        <input type="text" id="edit-model" name="model" class="px-4 py-2.5 rounded-xl border border-amber-200 focus:outline-none focus:border-amber-600 focus:ring-1 focus:ring-amber-600 text-sm bg-white">
                                    </div>
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-xs font-bold text-amber-800/80 uppercase">Màu xe</label>
                                        <input type="text" id="edit-color" name="color" class="px-4 py-2.5 rounded-xl border border-amber-200 focus:outline-none focus:border-amber-600 focus:ring-1 focus:ring-amber-600 text-sm bg-white">
                                    </div>
                                </div>
                                <div class="flex justify-end gap-3 pt-2">
                                    <button type="button" class="px-4 py-2 rounded-xl text-slate-500 hover:bg-slate-100 font-semibold text-sm transition-colors" onclick="closeForms()">Hủy</button>
                                    <button type="submit" id="editSubmitBtn" class="px-5 py-2 rounded-xl bg-amber-600 hover:bg-amber-750 text-white font-semibold text-sm flex items-center gap-1.5 shadow-sm transition-colors">
                                        <span class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin hidden" id="editSpinner"></span>
                                        <span id="editBtnText">Cập nhật</span>
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Vehicles List Layout -->
                        <div id="vehicles-container" class="divide-y divide-slate-100">
                            <c:choose>
                                <c:when test="${empty vehicles}">
                                    <div class="p-8 text-center text-slate-400 font-medium italic">
                                        Bạn chưa đăng ký phương tiện nào.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="v" items="${vehicles}">
                                        <div class="p-6 flex items-center justify-between hover:bg-slate-50/50 transition-colors">
                                            <div class="flex items-center gap-4">
                                                <div class="w-12 h-12 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center shadow-inner">
                                                    <span class="material-symbols-outlined text-[24px]">directions_car</span>
                                                </div>
                                                <div class="space-y-0.5">
                                                    <span class="text-base font-bold text-slate-900 block"><c:out value="${v.licensePlate}"/></span>
                                                    <span class="text-xs font-semibold text-slate-500 uppercase tracking-wide">
                                                        <c:out value="${v.brand}"/> 
                                                        <c:out value="${v.model}"/> 
                                                        <c:if test="${not empty v.color}">
                                                            • Mọi xe: <c:out value="${v.color}"/>
                                                        </c:if>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="flex items-center gap-2">
                                                <button class="w-9 h-9 rounded-xl hover:bg-amber-50 text-slate-500 hover:text-amber-600 flex items-center justify-center transition-colors" title="Sửa thông tin xe" onclick="showEditForm(
                                                                '${v.id}',
                                                                '${v.licensePlate}',
                                                                '${v.brand}',
                                                                '${v.model}',
                                                                '${v.color}'
                                                                )">
                                                    <span class="material-symbols-outlined text-[20px]">edit</span>
                                                </button>
                                                <form method="POST" action="<c:url value='/vehicles/delete'/>" class="inline" onsubmit="return confirm('Bạn chắc chắn muốn xóa xe biển số ${v.licensePlate}?');">
                                                    <input type="hidden" name="vehicleId" value="${v.id}">
                                                    <button type="submit" class="w-9 h-9 rounded-xl hover:bg-red-50 text-slate-500 hover:text-red-600 flex items-center justify-center transition-colors" title="Xóa phương tiện">
                                                        <span class="material-symbols-outlined text-[20px]">delete</span>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Personal Information Form Card -->
                    <div class="bg-white rounded-2xl border border-slate-200/60 shadow-sm overflow-hidden">
                        <div class="p-6 border-b border-slate-100 flex items-center gap-2">
                            <span class="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">person_filled</span>
                            </span>
                            <h3 class="font-bold text-lg text-slate-900">Thông tin cá nhân</h3>
                        </div>

                        <!-- Alerts and Notifications for Profile -->
                        <div id="profile-alert" class="px-6 pt-4">
                            <c:if test="${param.msg eq 'profile_success'}">
                                <div class="p-4 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 flex items-center gap-2 alert-box">
                                    <span class="material-symbols-outlined text-emerald-600 fill">check_circle</span>
                                    <span class="font-semibold text-sm">Cập nhật thông tin cá nhân thành công!</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty profileError}">
                                <div class="p-4 rounded-xl bg-red-50 text-red-800 border border-red-200 flex items-center gap-2 alert-box">
                                    <span class="material-symbols-outlined text-red-600 fill">error</span>
                                    <span class="font-semibold text-sm"><c:out value="${profileError}"/></span>
                                </div>
                            </c:if>
                        </div>

                        <form id="profileForm" method="POST" action="<c:url value='/profile/update'/>" class="p-6 space-y-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">Tên tài khoản (Không thể thay đổi)</label>
                                    <input type="text" id="acc-username" value="${currentUser.username}" disabled class="px-4 py-2.5 rounded-xl border border-slate-100 bg-slate-50 text-slate-400 font-semibold cursor-not-allowed text-sm">
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">Vai trò</label>
                                    <input type="text" id="acc-role" value="${currentUser.role}" disabled class="px-4 py-2.5 rounded-xl border border-slate-100 bg-slate-50 text-slate-400 font-semibold cursor-not-allowed text-sm">
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">Họ và Tên hiển thị</label>
                                    <input type="text" id="acc-fullname" name="fullname" value="${currentUser.fullname}" required class="px-4 py-2.5 rounded-xl border border-slate-200 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary text-sm font-semibold">
                                </div>
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">Số điện thoại</label>
                                    <input type="tel" id="acc-phone" name="phone" value="${currentUser.phone}" pattern="0[0-9]{9}" maxlength="10" required class="px-4 py-2.5 rounded-xl border border-slate-200 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary text-sm font-semibold">
                                </div>
                            </div>
                            <div class="flex justify-end pt-4 border-t border-slate-100">
                                <button type="submit" id="profileSubmitBtn" class="px-6 py-2.5 bg-primary hover:bg-primary/95 text-white font-semibold text-sm rounded-xl flex items-center gap-1.5 shadow-sm transition-colors">
                                    <span class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin hidden" id="profileSpinner"></span>
                                    <span id="profileBtnText">Lưu Thay Đổi</span>
                                </button>
                            </div>
                        </form>
                    </div>

                </div>

            </div>

        </div>
    </main>

    <script>
        const tierCard = document.getElementById('tier-card');
        if (tierCard) {
            tierCard.addEventListener('click', function () {
                const style = tierCard.style;
                style.transform = 'translateY(-2px) scale(0.98)';
                setTimeout(() => {
                    style.transform = '';
                }, 150);
            });
        }

        function showAddForm() {
            closeForms();
            const addForm = document.getElementById('addForm');
            addForm.classList.remove('hidden');
            document.getElementById('add-plate').focus();
        }

        function showEditForm(id, plate, brand, model, color) {
            closeForms();
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-plate').value = plate;
            document.getElementById('edit-brand').value = brand;
            document.getElementById('edit-model').value = model;
            document.getElementById('edit-color').value = color;
            
            const editForm = document.getElementById('editForm');
            editForm.classList.remove('hidden');
            document.getElementById('edit-plate').focus();
        }

        function closeForms() {
            document.getElementById('addForm').classList.add('hidden');
            document.getElementById('editForm').classList.add('hidden');
            document.getElementById('addVehicleForm').reset();
            document.getElementById('editVehicleForm').reset();
        }

        document.getElementById('addVehicleForm').addEventListener('submit', function () {
            document.getElementById('addSpinner').classList.remove('hidden');
            document.getElementById('addBtnText').textContent = 'Đang thêm...';
            document.getElementById('addSubmitBtn').disabled = true;
        });

        document.getElementById('editVehicleForm').addEventListener('submit', function () {
            document.getElementById('editSpinner').classList.remove('hidden');
            document.getElementById('editBtnText').textContent = 'Đang cập nhật...';
            document.getElementById('editSubmitBtn').disabled = true;
        });

        document.getElementById('profileForm').addEventListener('submit', function () {
            document.getElementById('profileSpinner').classList.remove('hidden');
            document.getElementById('profileBtnText').textContent = 'Đang lưu...';
            document.getElementById('profileSubmitBtn').disabled = true;
        });

        // Auto close alert banners
        const alertBoxes = document.querySelectorAll('.alert-box');
        alertBoxes.forEach(box => {
            setTimeout(() => {
                box.style.display = 'none';
            }, 4000);
        });
    </script>
</body>
</html>
