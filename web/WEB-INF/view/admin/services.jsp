<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services - SmartWash Pro</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/services.css'/>">

</head>
<body>

<!-- Sticky Top Navbar -->
<c:set var="activePage" value="services" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">
    
    <!-- Page Header & Breadcrumbs -->
    <div class="page-header-container">
        <div class="breadcrumb-trail">
            <a href="<c:url value='/admin/dashboard'/>">Dashboard</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <span style="font-weight: 700;">Services</span>
        </div>
        <div class="header-action-row">
            <div>
                <h1 class="page-title">Services</h1>
                <p class="page-subtitle">Configure car wash packages, service pricing, and washing durations.</p>
            </div>
            <div>
                <button onclick="openCreateModal()" class="btn-create-service">
                    <span class="material-symbols-outlined">add</span>
                    New Service
                </button>
            </div>
        </div>
    </div>

    <!-- Alert Notifications -->
    <c:if test="${not empty adminMsg}">
        <div class="alert-box alert-success">
            <span><c:out value="${adminMsg}"/></span>
            <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
        </div>
    </c:if>
    <c:if test="${not empty adminError}">
        <div class="alert-box alert-error">
            <span><c:out value="${adminError}"/></span>
            <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
        </div>
    </c:if>

    <!-- Services Bento Grid -->
    <div class="services-grid">
        <c:choose>
            <c:when test="${not empty services}">
                <c:forEach var="ws" items="${services}">
                    <div class="service-card ${ws.active ? '' : 'inactive'}">
                        
                        <!-- Status Badge -->
                        <div class="service-card-status-badge">
                            <c:choose>
                                <c:when test="${ws.active}">
                                    <span class="status-pill status-active">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-pill status-inactive">Paused</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Card Body Details -->
                        <div class="service-card-body">
                            <h3 class="service-card-title"><c:out value="${ws.name}"/></h3>
                            <p class="service-card-desc" title="<c:out value='${ws.description}'/>"><c:out value="${ws.description}"/></p>
                        </div>

                        <!-- Price, Duration and Order count stats -->
                        <div class="service-card-footer">
                            <div class="service-price-row">
                                <span class="service-price-tag">
                                    <fmt:formatNumber value="${ws.price}" type="number" groupingUsed="true"/> ₫
                                </span>
                                <span class="service-duration-badge">
                                    <span class="material-symbols-outlined">schedule</span>
                                    <c:out value="${ws.durationMinutes}"/> mins
                                </span>
                            </div>

                            <div class="service-total-orders-card">
                                <span class="label">
                                    <span class="material-symbols-outlined" style="font-size: 0.95rem;">book_online</span>
                                    Total Bookings
                                </span>
                                <span class="val"><c:out value="${ws.bookingCount}"/></span>
                            </div>

                            <!-- Operations Actions -->
                            <div class="actions-row-grid">
                                <!-- Edit Button -->
                                <button onclick="openEditModal(${ws.id}, '${ws.name}', '${ws.description}', ${ws.price}, ${ws.durationMinutes}, ${ws.active})" class="btn-card-action btn-card-edit" title="Edit Service">
                                    <span class="material-symbols-outlined">edit</span> Edit
                                </button>

                                <!-- Toggle Pause/Resume -->
                                <form action="<c:url value='/admin/services/toggle-status'/>" method="POST" onsubmit="return confirm('Do you want to toggle operational status for this service?')" style="margin: 0;">
                                    <input type="hidden" name="id" value="${ws.id}">
                                    <button type="submit" class="btn-card-action btn-card-toggle" style="width: 100%;" title="${ws.active ? 'Pause Service' : 'Resume Service'}">
                                        <span class="material-symbols-outlined">${ws.active ? 'pause' : 'play_arrow'}</span>
                                        <c:out value="${ws.active ? 'Pause' : 'Resume'}"/>
                                    </button>
                                </form>

                                <!-- Delete Service -->
                                <form action="<c:url value='/admin/services/delete'/>" method="POST" onsubmit="return confirm('Are you sure you want to delete this service? All linked records might be affected!')" style="margin: 0;">
                                    <input type="hidden" name="id" value="${ws.id}">
                                    <button type="submit" class="btn-card-action btn-card-delete" style="width: 100%;" title="Delete Service">
                                        <span class="material-symbols-outlined">delete</span> Delete
                                    </button>
                                </form>
                            </div>
                        </div>

                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="grid-column: 1 / -1; background: #ffffff; border: 2px dashed #E2E8F0; border-radius: 20px; padding: 4rem 2rem; text-align: center; color: #94A3B8; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.75rem;">
                    <span class="material-symbols-outlined" style="font-size: 3.5rem; color: #94A3B8;">assignment_late</span>
                    <span style="font-weight: 700; font-size: 1.1rem; color: #475569;">No services found in system.</span>
                    <span style="font-size: 0.85rem;">Click 'New Service' to start adding custom washing slots.</span>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<!-- Create / Edit Service Modal -->
<div id="serviceModal" class="modal-overlay">
    <div class="modal-box">
        
        <!-- Modal Header -->
        <div class="modal-header">
            <h3 id="modalTitle">New Service</h3>
            <button class="modal-close-btn" onclick="closeModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <!-- Modal Form -->
        <form id="serviceForm" action="<c:url value='/admin/services/create'/>" method="POST" style="margin: 0;">
            <div class="modal-body">
                <input type="hidden" name="id" id="serviceId">

                <!-- Service Name -->
                <div class="form-group">
                    <label class="form-label" for="name">Service Name <span style="color: #EF4444;">*</span></label>
                    <input type="text" class="input-field" name="name" id="name" required placeholder="e.g. Standard Exterior Wash">
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label class="form-label" for="description">Description</label>
                    <textarea class="input-field textarea-field" name="description" id="description" placeholder="Specify washing steps, detail treatments..."></textarea>
                </div>

                <!-- Price and Duration Row -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label" for="price">Price (₫) <span style="color: #EF4444;">*</span></label>
                        <input type="number" class="input-field" name="price" id="price" min="0" required placeholder="e.g. 150000">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="durationMinutes">Duration (mins) <span style="color: #EF4444;">*</span></label>
                        <input type="number" class="input-field" name="durationMinutes" id="durationMinutes" min="1" required placeholder="e.g. 30">
                    </div>
                </div>

                <!-- Active Toggle Checkbox Box -->
                <div class="checkbox-container" id="activeGroup">
                    <input type="checkbox" name="isActive" id="isActive" checked>
                    <label for="isActive">Enable service immediately</label>
                </div>
            </div>

            <!-- Modal Footer -->
            <div class="modal-footer">
                <button type="button" class="btn-modal-cancel" onclick="closeModal()">Cancel</button>
                <button type="submit" class="btn-modal-submit" id="btnSubmit">
                    <span class="material-symbols-outlined">save</span>
                    Save Service
                </button>
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
        modalTitle.innerText = "New Service";
        btnSubmit.innerHTML = `<span class="material-symbols-outlined">save</span>Save Service`;
        form.action = "<c:url value='/admin/services/create'/>";
        
        document.getElementById('serviceId').value = "";
        document.getElementById('name').value = "";
        document.getElementById('description').value = "";
        document.getElementById('price').value = "";
        document.getElementById('durationMinutes').value = "";
        document.getElementById('isActive').checked = true;

        modal.classList.add('active');
    }

    function openEditModal(id, name, description, price, duration, isActive) {
        modalTitle.innerText = "Edit Service";
        btnSubmit.innerHTML = `<span class="material-symbols-outlined">save</span>Update Service`;
        form.action = "<c:url value='/admin/services/update'/>";

        document.getElementById('serviceId').value = id;
        document.getElementById('name').value = name;
        document.getElementById('description').value = description;
        document.getElementById('price').value = price;
        document.getElementById('durationMinutes').value = duration;
        document.getElementById('isActive').checked = isActive;

        modal.classList.add('active');
    }

    function closeModal() {
        modal.classList.remove('active');
    }

    window.onclick = function(event) {
        if (event.target === modal) {
            closeModal();
        }
    }
</script>
</body>
</html>
