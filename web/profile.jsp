<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ sơ cá nhân - Smart Car Wash</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
        <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    </head>
    <body>

        <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

        <div class="main-container">

            <div id="tier-card" class="tier-card tier-${not empty currentUser.loyaltyTier ? currentUser.loyaltyTier.name : 'Member'}">
                <div class="tier-info">
                    <span class="tier-label">Hạng thành viên</span>
                    <span id="tier-name" class="tier-name"><c:out value="${not empty currentUser.loyaltyTier ? currentUser.loyaltyTier.name : 'Member'}"/></span>
                </div>
                <div class="tier-badge-icon">
                    <svg viewBox="0 0 24 24">
                    <path d="M2 4l3 5 7-6 7 6 3-5v14H2V4zm2 12h16v-2H4v2zm0-4h16V9.8L17.7 7l-5.7 4.9L6.3 7 4 9.8V12z"/>
                    </svg>
                </div>
            </div>

            <div class="card">
                <div class="card-title">
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                    </svg>
                    Điểm tích lũy
                </div>
                <div class="points-display">
                    <div id="points-val" class="points-value">
                        <fmt:formatNumber value="${currentUser.pointsBalance}" type="number"/>
                    </div>
                    <div class="points-unit">điểm</div>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty nextTier}">
                    <div id="progression-card" class="card" style="display: flex;">
                        <div class="card-title">
                            <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v13m0-13V6a2 2 0 112 2h-2zm0 0V5a2 2 0 10-2 2h2zm-8 4h16M5 11h14a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2z"/>
                            </svg>
                            Phần thưởng tiếp theo
                        </div>
                        <div class="reward-info">
                            <span id="progression-title">Nâng hạng lên <c:out value="${nextTier.name}"/></span>
                            <span id="progression-badge" class="reward-badge">
                                <fmt:formatNumber value="${remainingSpend}" type="number"/> điểm nữa
                            </span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-track">
                                <div id="progress-fill" class="progress-fill" style="width: ${progressPercent}%;"></div>
                            </div>
                            <div class="progress-labels">
                                <span id="label-current"><fmt:formatNumber value="${currentUser.lifetimeSpent}" type="number"/> điểm</span>
                                <span id="label-target"><fmt:formatNumber value="${nextTier.minSpend}" type="number"/> điểm</span>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="progression-card" class="card" style="display: none;"></div>
                </c:otherwise>
            </c:choose>

            <div class="card">
                <div class="card-header">
                    <div class="card-title">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                        <path d="M18.92 11.01C18.72 10.42 18.16 10 17.5 10H6.5c-.66 0-1.21.42-1.42 1.01L3 17v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.85 12h10.3l1.04 3H5.81l1.04-3zM6 21c-.83 0-1.5-.67-1.5-1.5S5.17 18 6 18s1.5.67 1.5 1.5S6.83 21 6 21zm12 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/>
                        </svg>
                        Danh sách xe
                    </div>
                    <button class="btn-add-vehicle" onclick="showAddForm()">+ Thêm xe</button>
                </div>

                <div id="vehicle-alert">
                    <c:if test="${param.msg eq 'vehicle_add_success'}">
                        <div class="alert alert-success" style="display:block;">Thêm phương tiện thành công!</div>
                    </c:if>
                    <c:if test="${param.msg eq 'vehicle_update_success'}">
                        <div class="alert alert-success" style="display:block;">Cập nhật phương tiện thành công!</div>
                    </c:if>
                    <c:if test="${param.msg eq 'vehicle_delete_success'}">
                        <div class="alert alert-success" style="display:block;">Xóa phương tiện thành công!</div>
                    </c:if>
                    <c:if test="${not empty vehicleError}">
                        <div class="alert alert-danger" style="display:block;"><c:out value="${vehicleError}"/></div>
                    </c:if>
                </div>

                <div id="addForm" class="sliding-form">
                    <button class="form-close" onclick="closeForms()">&times;</button>
                    <h4 style="font-weight: 700;">Thêm xe mới</h4>
                    <form id="addVehicleForm" method="POST" action="<c:url value='/vehicles/add'/>">
                        <div class="form-grid">
                            <div class="form-field">
                                <label>Biển số xe *</label>
                                <input type="text" id="add-plate" name="licensePlate" placeholder="29A-12345" required>
                            </div>
                            <div class="form-field">
                                <label>Hãng xe</label>
                                <input type="text" id="add-brand" name="brand" placeholder="Toyota">
                            </div>
                            <div class="form-field">
                                <label>Dòng xe</label>
                                <input type="text" id="add-model" name="model" placeholder="Camry">
                            </div>
                            <div class="form-field">
                                <label>Màu xe</label>
                                <input type="text" id="add-color" name="color" placeholder="Trắng">
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="button" class="btn-form btn-form-cancel" onclick="closeForms()">Hủy</button>
                            <button type="submit" id="addSubmitBtn" class="btn-form btn-form-submit">
                                <span class="spinner" id="addSpinner" style="display:none;"></span>
                                <span id="addBtnText">✓ Thêm</span>
                            </button>
                        </div>
                    </form>
                </div>

                <div id="editForm" class="sliding-form edit-mode">
                    <button class="form-close" onclick="closeForms()">&times;</button>
                    <h4 style="font-weight: 700; color: #b45309;">Cập nhật xe</h4>
                    <form id="editVehicleForm" method="POST" action="<c:url value='/vehicles/update'/>">
                        <input type="hidden" id="edit-id" name="vehicleId">
                        <div class="form-grid">
                            <div class="form-field">
                                <label>Biển số xe *</label>
                                <input type="text" id="edit-plate" name="licensePlate" required>
                            </div>
                            <div class="form-field">
                                <label>Hãng xe</label>
                                <input type="text" id="edit-brand" name="brand">
                            </div>
                            <div class="form-field">
                                <label>Dòng xe</label>
                                <input type="text" id="edit-model" name="model">
                            </div>
                            <div class="form-field">
                                <label>Màu xe</label>
                                <input type="text" id="edit-color" name="color">
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="button" class="btn-form btn-form-cancel" onclick="closeForms()">Hủy</button>
                            <button type="submit" id="editSubmitBtn" class="btn-form btn-form-submit" style="background: #d97706;">
                                <span class="spinner" id="editSpinner" style="display:none;"></span>
                                <span id="editBtnText">Cập nhật</span>
                            </button>
                        </div>
                    </form>
                </div>

                <div id="vehicles-container" class="vehicle-list">
                    <c:choose>
                        <c:when test="${empty vehicles}">
                            <p style="color: var(--text-light); text-align: center; padding: 1.5rem 0; font-style: italic;">Bạn chưa đăng ký phương tiện nào.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="v" items="${vehicles}">
                                <div class="vehicle-item">
                                    <div class="vehicle-meta">
                                        <div class="vehicle-avatar">
                                            <svg viewBox="0 0 24 24" fill="currentColor">
                                            <path d="M18.92 11.01C18.72 10.42 18.16 10 17.5 10H6.5c-.66 0-1.21.42-1.42 1.01L3 17v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.85 12h10.3l1.04 3H5.81l1.04-3zM6 21c-.83 0-1.5-.67-1.5-1.5S5.17 18 6 18s1.5.67 1.5 1.5S6.83 21 6 21zm12 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/>
                                            </svg>
                                        </div>
                                        <div class="vehicle-text">
                                            <span class="vehicle-plate"><c:out value="${v.licensePlate}"/></span>
                                            <span class="vehicle-type"><c:out value="${v.brand}"/> 
                                                <c:out value="${v.model}"/> 
                                                • 
                                                <c:out value="${v.color}"/></span>
                                        </div>
                                    </div>
                                    <div class="vehicle-actions">
                                        <button class="btn-icon btn-edit" title="Edit vehicle info" onclick="showEditForm(
                                                        '${v.id}',
                                                        '${v.licensePlate}',
                                                        '${v.brand}',
                                                        '${v.model}',
                                                        '${v.color}'
                                                        )">
                                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                            </svg>
                                        </button>
                                        <form method="POST" action="<c:url value='/vehicles/delete'/>" style="display:inline;" onsubmit="return confirm('Bạn chắc chắn muốn xóa xe biển số ${v.licensePlate}?');">
                                            <input type="hidden" name="vehicleId" value="${v.id}">
                                            <button type="submit" class="btn-icon btn-delete" title="Delete vehicle">
                                                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-4v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                </svg>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="card">
                <div class="card-title">
                    <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                    </svg>
                    Thông tin cá nhân
                </div>

                <div id="profile-alert" class="alert">
                    <c:if test="${param.msg eq 'profile_success'}">
                        <div class="alert alert-success" style="display:block;">Cập nhật thông tin cá nhân thành công!</div>
                    </c:if>
                    <c:if test="${not empty profileError}">
                        <div class="alert alert-danger" style="display:block;"><c:out value="${profileError}"/></div>
                    </c:if>
                </div>

                <form id="profileForm" method="POST" action="<c:url value='/profile/update'/>">
                    <div class="account-grid">
                        <div class="form-field">
                            <label>Tên tài khoản (Không thể thay đổi)</label>
                            <input type="text" id="acc-username" value="${currentUser.username}" disabled style="background-color: #F3F4F6; color: var(--text-light); cursor: not-allowed;">
                        </div>
                        <div class="form-field">
                            <label>Vai trò</label>
                            <input type="text" id="acc-role" value="${currentUser.role}" disabled style="background-color: #F3F4F6; color: var(--text-light); cursor: not-allowed;">
                        </div>
                        <div class="form-field">
                            <label>Họ và Tên hiển thị</label>
                            <input type="text" id="acc-fullname" name="fullname" value="${currentUser.fullname}" required>
                        </div>
                        <div class="form-field">
                            <label>Số điện thoại</label>
                            <input type="tel" id="acc-phone" name="phone" value="${currentUser.phone}" pattern="0[0-9]{9}" maxlength="10" required>
                        </div>
                    </div>
                    <div class="form-actions" style="margin-top: 1rem;">
                        <button type="submit" id="profileSubmitBtn" class="btn-form btn-form-submit" style="padding: 0.6rem 1.2rem;">
                            <span class="spinner" id="profileSpinner" style="display:none;"></span>
                            <span id="profileBtnText">Lưu Thay Đổi</span>
                        </button>
                    </div>
                </form>
            </div>

        </div>

        <script>
            const tierCard = document.getElementById('tier-card');
            tierCard.addEventListener('click', function () {
                const style = tierCard.style;
                style.transform = 'translateY(-2px) scale(0.98)';
                setTimeout(() => {
                    style.transform = '';
                }, 150);
            });

            function showAddForm() {
                closeForms();
                document.getElementById('addForm').style.display = 'block';
                document.getElementById('add-plate').focus();
            }

            function showEditForm(id, plate, brand, model, color) {
                closeForms();
                document.getElementById('edit-id').value = id;
                document.getElementById('edit-plate').value = plate;
                document.getElementById('edit-brand').value = brand;
                document.getElementById('edit-model').value = model;
                document.getElementById('edit-color').value = color;
                document.getElementById('editForm').style.display = 'block';
                document.getElementById('edit-plate').focus();
            }

            function closeForms() {
                document.getElementById('addForm').style.display = 'none';
                document.getElementById('editForm').style.display = 'none';
                document.getElementById('addVehicleForm').reset();
                document.getElementById('editVehicleForm').reset();
            }

            document.getElementById('addVehicleForm').addEventListener('submit', function () {
                document.getElementById('addSpinner').style.display = 'inline-block';
                document.getElementById('addBtnText').textContent = 'Đang thêm...';
                document.getElementById('addSubmitBtn').disabled = true;
            });

            document.getElementById('editVehicleForm').addEventListener('submit', function () {
                document.getElementById('editSpinner').style.display = 'inline-block';
                document.getElementById('editBtnText').textContent = 'Đang cập nhật...';
                document.getElementById('editSubmitBtn').disabled = true;
            });

            document.getElementById('profileForm').addEventListener('submit', function () {
                document.getElementById('profileSpinner').style.display = 'inline-block';
                document.getElementById('profileBtnText').textContent = 'Đang lưu...';
                document.getElementById('profileSubmitBtn').disabled = true;
            });

            const alertDivs = document.querySelectorAll('.alert > div');
            alertDivs.forEach(div => {
                setTimeout(() => {
                    div.style.display = 'none';
                }, 4000);
            });
        </script>
    </body>
</html>
