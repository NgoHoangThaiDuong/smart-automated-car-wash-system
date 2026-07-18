<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Promotion - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/promotions.css'/>">
</head>
<body>

<!-- Sticky Top Navbar -->
<c:set var="activePage" value="promotions" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">

    <!-- Page Header & Breadcrumbs -->
    <div class="page-header-container">
        <div class="breadcrumb-trail">
            <a href="<c:url value='/admin/dashboard'/>">Dashboard</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <a href="<c:url value='/admin/promotions'/>">Promotions</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <span style="font-weight: 700;">New</span>
        </div>
        <div class="header-action-row">
            <div>
                <h1 class="page-title">New Promotion</h1>
            </div>
            <div>
                <a href="<c:url value='/admin/promotions'/>" class="btn-admin-secondary" style="text-decoration: none;">
                    <span class="material-symbols-outlined">arrow_back</span>
                    Back to List
                </a>
            </div>
        </div>
    </div>

    <!-- Error Alert -->
    <c:if test="${not empty promotionError}">
        <div class="alert-box alert-error" style="margin-bottom: 1.5rem;">
            <span><c:out value="${promotionError}"/></span>
            <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
        </div>
    </c:if>

    <!-- Promotion Form -->
    <div class="promo-form-card">
        <form action="${pageContext.request.contextPath}/admin/promotions/create" method="post">

            <div class="promo-form-grid">

                <!-- Promotion Name (full width) -->
                <div class="form-group form-group-full">
                    <label class="promo-form-label" for="promotionName">Promotion Name</label>
                    <input type="text"
                           class="promo-form-input"
                           id="promotionName"
                           name="promotionName"
                           value="<c:out value='${promotion.promotionName}'/>"
                           maxlength="150"
                           placeholder="e.g. Summer Wash Sale"
                           required>
                </div>

                <!-- Description (full width) -->
                <div class="form-group form-group-full">
                    <label class="promo-form-label" for="description">Description</label>
                    <textarea class="promo-form-textarea"
                              id="description"
                              name="description"
                              maxlength="500"
                              placeholder="Brief description of the promotion..."><c:out value="${promotion.description}"/></textarea>
                </div>

                <!-- Discount Type -->
                <div class="form-group">
                    <label class="promo-form-label" for="discountType">Discount Type</label>
                    <select class="promo-form-select" id="discountType" name="discountType" required>
                        <option value="PERCENT" ${promotion.discountType == 'PERCENT' ? 'selected' : ''}>
                            Percentage (%)
                        </option>
                        <option value="FIXED" ${promotion.discountType == 'FIXED' ? 'selected' : ''}>
                            Fixed Amount (₫)
                        </option>
                    </select>
                </div>

                <!-- Discount Value -->
                <div class="form-group">
                    <label class="promo-form-label" for="discountValue">Discount Value</label>
                    <input type="number"
                           class="promo-form-input"
                           id="discountValue"
                           name="discountValue"
                           value="${promotion.discountValue}"
                           min="0.01"
                           step="0.01"
                           placeholder="0.00"
                           required>
                </div>

                <!-- Target Tier -->
                <div class="form-group">
                    <label class="promo-form-label" for="targetTierId">Target Tier</label>
                    <select class="promo-form-select" id="targetTierId" name="targetTierId">
                        <option value="">All Customers</option>
                        <option value="1">Member</option>
                        <option value="2">Silver</option>
                        <option value="3">Gold</option>
                        <option value="4">Platinum</option>
                    </select>
                </div>

                <!-- Status -->
                <div class="form-group">
                    <label class="promo-form-label" for="status">Status</label>
                    <select class="promo-form-select" id="status" name="status" required>
                        <option value="ACTIVE">Active</option>
                        <option value="INACTIVE">Inactive</option>
                    </select>
                </div>

                <!-- Start Date -->
                <div class="form-group">
                    <label class="promo-form-label" for="startDate">Start Date</label>
                    <input type="date"
                           class="promo-form-input"
                           id="startDate"
                           name="startDate"
                           value="${promotion.startDate}"
                           required>
                </div>

                <!-- End Date -->
                <div class="form-group">
                    <label class="promo-form-label" for="endDate">End Date</label>
                    <input type="date"
                           class="promo-form-input"
                           id="endDate"
                           name="endDate"
                           value="${promotion.endDate}"
                           required>
                </div>

            </div>

            <!-- Form Actions -->
            <div class="promo-form-actions">
                <button type="submit" class="btn-admin-primary">
                    <span class="material-symbols-outlined">add</span>
                    Create Promotion
                </button>
                <a href="<c:url value='/admin/promotions'/>" class="btn-admin-secondary" style="text-decoration: none;">
                    Cancel
                </a>
            </div>

        </form>
    </div>

</div>

</body>
</html>