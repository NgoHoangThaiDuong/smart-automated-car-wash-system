<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý dịch vụ - Smart Car Wash</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <style>
        .services-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        .admin-page-title {
            font-size: 2.25rem;
            font-weight: 800;
            color: var(--text);
            letter-spacing: -0.03em;
            margin-bottom: 0.25rem;
        }
        .admin-page-subtitle {
            color: var(--text-light);
            font-size: 1rem;
        }

        /* Alert styling */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .alert-success {
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }
        .alert-danger {
            background-color: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
        }
        .alert-close {
            background: none;
            border: none;
            color: inherit;
            font-size: 1.2rem;
            cursor: pointer;
            padding: 0;
            line-height: 1;
        }

        /* Cards and List */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .service-card {
            background: var(--surface);
            border-radius: 16px;
            padding: 1.75rem;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .service-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        }
        .service-card-inactive {
            opacity: 0.7;
            border-style: dashed;
        }
        .service-status-badge {
            position: absolute;
            top: 1.25rem;
            right: 1.25rem;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.25rem 0.6rem;
            border-radius: 20px;
        }
        .status-active {
            background-color: #e2f9e1;
            color: #1e7e34;
        }
        .status-inactive {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        .service-name {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--text);
            margin-bottom: 0.5rem;
            padding-right: 4rem; /* Tránh đè lên status badge */
        }
        .service-desc {
            color: var(--text-light);
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1.5rem;
            flex-grow: 1;
        }
        .service-meta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 1rem;
            border-top: 1px solid var(--border);
            margin-bottom: 1.25rem;
        }
        .service-price {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--primary);
        }
        .service-duration {
            font-size: 0.85rem;
            color: var(--text-light);
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        .service-stats {
            background: #f8fafc;
            border-radius: 8px;
            padding: 0.5rem 0.75rem;
            font-size: 0.8rem;
            color: var(--text-light);
            margin-bottom: 1.25rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .service-actions {
            display: flex;
            gap: 0.5rem;
        }
        .service-actions form {
            flex: 1;
        }
        .service-actions .btn {
            width: 100%;
            padding: 0.5rem 0.75rem;
            font-size: 0.85rem;
        }

        /* Modal styling */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(15, 23, 42, 0.45);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
        }
        .modal.show {
            display: flex;
        }
        .modal-content {
            background-color: var(--surface);
            border-radius: 16px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            border: 1px solid var(--border);
            animation: modalFadeIn 0.25s ease-out;
            display: flex;
            flex-direction: column;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-title {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--text);
        }
        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--text-light);
            cursor: pointer;
        }
        .modal-body {
            padding: 1.5rem;
        }
        .modal-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }
        
        /* Form inputs styling */
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-label {
            display: block;
            font-weight: 600;
            font-size: 0.875rem;
            color: var(--text);
            margin-bottom: 0.5rem;
        }
        .form-control {
            width: 100%;
            padding: 0.625rem 0.875rem;
            font-size: 0.95rem;
            border-radius: 8px;
            border: 1px solid var(--border);
            background-color: var(--surface);
            color: var(--text);
            transition: border-color 0.15s ease, box-shadow 0.15s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(29, 78, 216, 0.15);
        }
        .form-check {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }
        .form-check-input {
            width: 1rem;
            height: 1rem;
            cursor: pointer;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/view/common/navbar.jsp">
    <jsp:param name="activePage" value="services" />
</jsp:include>

<div class="main-container">
    <div class="services-header">
        <div>
            <h1 class="admin-page-title">Quản lý Dịch vụ</h1>
            <p class="admin-page-subtitle">Quản lý danh sách các gói dịch vụ rửa xe và giá cả</p>
        </div>
        <button onclick="openCreateModal()" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.5rem;">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            Thêm dịch vụ mới
        </button>
    </div>

    <!-- Alert Notifications -->
    <c:if test="${not empty adminMsg}">
        <div class="alert alert-success">
            <span><c:out value="${adminMsg}"/></span>
            <button class="alert-close" onclick="this.parentElement.remove()">×</button>
        </div>
    </c:if>
    <c:if test="${not empty adminError}">
        <div class="alert alert-danger">
            <span><c:out value="${adminError}"/></span>
            <button class="alert-close" onclick="this.parentElement.remove()">×</button>
        </div>
    </c:if>

    <!-- Services Grid -->
    <div class="services-grid">
        <c:choose>
            <c:when test="${not empty services}">
                <c:forEach var="ws" items="${services}">
                    <div class="service-card ${ws.active ? '' : 'service-card-inactive'}">
                        <!-- Status Badge -->
                        <c:choose>
                            <c:when test="${ws.active}">
                                <span class="service-status-badge status-active">Hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="service-status-badge status-inactive">Tạm ngưng</span>
                            </c:otherwise>
                        </c:choose>

                        <div>
                            <div class="service-name"><c:out value="${ws.name}"/></div>
                            <div class="service-desc"><c:out value="${ws.description}"/></div>
                        </div>

                        <div>
                            <div class="service-meta">
                                <span class="service-price">
                                    <fmt:formatNumber value="${ws.price}" type="number" groupingUsed="true"/>₫
                                </span>
                                <span class="service-duration">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle;">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <c:out value="${ws.durationMinutes}"/> phút
                                </span>
                            </div>

                            <div class="service-stats">
                                <span>Lượt đặt dịch vụ:</span>
                                <span style="font-weight: 700; color: var(--text);"><c:out value="${ws.bookingCount}"/></span>
                            </div>

                            <div class="service-actions">
                                <button class="btn btn-secondary" onclick="openEditModal(${ws.id}, '${ws.name}', '${ws.description}', ${ws.price}, ${ws.durationMinutes}, ${ws.active})">Sửa</button>
                                
                                <form action="<c:url value='/admin/services/toggle-status'/>" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn thay đổi trạng thái dịch vụ này?')">
                                    <input type="hidden" name="id" value="${ws.id}">
                                    <button type="submit" class="btn btn-secondary">
                                        <c:out value="${ws.active ? 'Tạm ngưng' : 'Kích hoạt'}"/>
                                    </button>
                                </form>

                                <form action="<c:url value='/admin/services/delete'/>" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có thực sự muốn xóa dịch vụ này? Hành động này không thể hoàn tác!')">
                                    <input type="hidden" name="id" value="${ws.id}">
                                    <button type="submit" class="btn btn-secondary" style="color: var(--error); border-color: var(--error); background: transparent;">
                                        Xóa
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="grid-column: 1/-1; text-align: center; padding: 4rem; color: var(--text-light); background: var(--surface); border-radius: 16px; border: 1px solid var(--border);">
                    Không có dịch vụ nào trong hệ thống.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Create/Edit Service Modal -->
<div id="serviceModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="modal-title" id="modalTitle">Thêm dịch vụ mới</span>
            <button class="modal-close" onclick="closeModal()">&times;</button>
        </div>
        <form id="serviceForm" action="<c:url value='/admin/services/create'/>" method="POST">
            <div class="modal-body">
                <input type="hidden" name="id" id="serviceId">

                <div class="form-group">
                    <label class="form-label" for="name">Tên dịch vụ <span style="color:var(--error)">*</span></label>
                    <input type="text" class="form-control" name="name" id="name" required placeholder="Ví dụ: Rửa xe tiêu chuẩn">
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Mô tả dịch vụ</label>
                    <textarea class="form-control" name="description" id="description" rows="3" placeholder="Mô tả các bước thực hiện..." style="resize: none; font-family: inherit;"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label" for="price">Giá dịch vụ (₫) <span style="color:var(--error)">*</span></label>
                    <input type="number" class="form-control" name="price" id="price" min="0" required placeholder="Ví dụ: 150000">
                </div>

                <div class="form-group">
                    <label class="form-label" for="durationMinutes">Thời lượng rửa (phút) <span style="color:var(--error)">*</span></label>
                    <input type="number" class="form-control" name="durationMinutes" id="durationMinutes" min="1" required placeholder="Ví dụ: 30">
                </div>

                <div class="form-group form-check" id="activeGroup">
                    <input type="checkbox" class="form-check-input" name="isActive" id="isActive" checked>
                    <label class="form-label" for="isActive" style="margin-bottom: 0; cursor: pointer;">Trạng thái hoạt động</label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn btn-primary" id="btnSubmit">Lưu lại</button>
            </div>
        </form>
    </div>
</div>

<script>
    const modal = document.getElementById('serviceModal');
    const form = document.getElementById('serviceForm');
    const modalTitle = document.getElementById('modalTitle');
    const btnSubmit = document.getElementById('btnSubmit');

    function openCreateModal() {
        modalTitle.innerText = "Thêm dịch vụ mới";
        btnSubmit.innerText = "Thêm mới";
        form.action = "<c:url value='/admin/services/create'/>";
        
        document.getElementById('serviceId').value = "";
        document.getElementById('name').value = "";
        document.getElementById('description').value = "";
        document.getElementById('price').value = "";
        document.getElementById('durationMinutes').value = "";
        document.getElementById('isActive').checked = true;

        modal.classList.add('show');
    }

    function openEditModal(id, name, description, price, duration, isActive) {
        modalTitle.innerText = "Chỉnh sửa dịch vụ";
        btnSubmit.innerText = "Lưu thay đổi";
        form.action = "<c:url value='/admin/services/update'/>";

        document.getElementById('serviceId').value = id;
        document.getElementById('name').value = name;
        document.getElementById('description').value = description;
        document.getElementById('price').value = price;
        document.getElementById('durationMinutes').value = duration;
        document.getElementById('isActive').checked = isActive;

        modal.classList.add('show');
    }

    function closeModal() {
        modal.classList.remove('show');
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
