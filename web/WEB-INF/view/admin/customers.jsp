<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customers - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/components/booking-table.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin/customers.css'/>">
</head>
<body>

<!-- Sticky Top Navbar -->
<c:set var="activePage" value="customers" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

<div class="admin-container">
    
    <!-- Page Header & Breadcrumbs -->
    <div class="page-header-container">
        <div class="breadcrumb-trail">
            <a href="<c:url value='/admin/dashboard'/>">Dashboard</a>
            <span class="material-symbols-outlined">chevron_right</span>
            <span style="font-weight: 700;">Customers</span>
        </div>
        <div class="header-action-row">
            <div>
                <h1 class="page-title">Customers</h1>
            </div>
            <div>
                <a href="<c:url value='/admin/customers'/>" class="btn-admin-secondary" style="text-decoration: none;">
                    <span class="material-symbols-outlined">refresh</span>
                    Refresh Data
                </a>
            </div>
        </div>
    </div>

    <!-- Analytics Cards (Bento style) -->
    <div class="analytics-grid">
        <!-- Total Customers -->
        <div class="analytics-card">
            <div>
                <span class="analytics-card-label">Total Customers</span>
                <div class="analytics-card-val"><c:out value="${totalCustomers}"/></div>
            </div>
            <div class="analytics-card-icon icon-blue">
                <span class="material-symbols-outlined">group</span>
            </div>
        </div>

        <!-- Lifetime Spent -->
        <div class="analytics-card">
            <div>
                <span class="analytics-card-label">Lifetime Revenue</span>
                <div class="analytics-card-val" style="font-size: 1.8rem; font-weight: 800;">
                    <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫
                </div>
            </div>
            <div class="analytics-card-icon icon-green">
                <span class="material-symbols-outlined">payments</span>
            </div>
        </div>

        <!-- Registered Vehicles -->
        <div class="analytics-card">
            <div>
                <span class="analytics-card-label">Registered Vehicles</span>
                <div class="analytics-card-val"><c:out value="${totalVehicles}"/></div>
            </div>
            <div class="analytics-card-icon icon-amber">
                <span class="material-symbols-outlined">directions_car</span>
            </div>
        </div>
    </div>

    <!-- Shared Search and Filter Card -->
    <div class="filter-card">
        <form action="<c:url value='/admin/customers'/>" method="GET" style="margin: 0;">
            <div class="filter-form-grid">
                
                <!-- Search Field -->
                <div class="search-input-wrapper">
                    <span class="material-symbols-outlined">search</span>
                    <input name="search" class="search-input-field" placeholder="Search by name, phone number, or username..." type="text" value="<c:out value='${search}'/>">
                </div>

                <!-- Tier Filter Select -->
                <select name="tierId" class="filter-select-field">
                    <option value="">All Tiers</option>
                    <c:forEach var="t" items="${tiers}">
                        <option value="${t.id}" ${selectedTierId == t.id ? 'selected' : ''}>
                            <c:out value="${t.name}"/>
                        </option>
                    </c:forEach>
                </select>

                <!-- Sort By Select -->
                <select name="sortBy" class="filter-select-field">
                    <option value="name_asc" <c:if test="${empty sortBy or sortBy eq 'name_asc'}">selected</c:if>>Tên (A-Z)</option>
                    <option value="name_desc" <c:if test="${sortBy eq 'name_desc'}">selected</c:if>>Tên (Z-A)</option>
                    <option value="spent_desc" <c:if test="${sortBy eq 'spent_desc'}">selected</c:if>>Số tiền đã tiêu (Cao -> Thấp)</option>
                    <option value="spent_asc" <c:if test="${sortBy eq 'spent_asc'}">selected</c:if>>Số tiền đã tiêu (Thấp -> Cao)</option>
                    <option value="washes_desc" <c:if test="${sortBy eq 'washes_desc'}">selected</c:if>>Số lượt rửa (Nhiều -> Ít)</option>
                    <option value="washes_asc" <c:if test="${sortBy eq 'washes_asc'}">selected</c:if>>Số lượt rửa (Ít -> Nhiều)</option>
                    <option value="points_desc" <c:if test="${sortBy eq 'points_desc'}">selected</c:if>>Điểm tích lũy (Nhiều -> Ít)</option>
                    <option value="points_asc" <c:if test="${sortBy eq 'points_asc'}">selected</c:if>>Điểm tích lũy (Ít -> Nhiều)</option>
                </select>

                <!-- Filter Submit -->
                <button type="submit" class="btn-submit-filter">
                    <span class="material-symbols-outlined" style="font-size: 1.15rem;">tune</span> Filter
                </button>
            </div>
        </form>
    </div>

    <!-- Customer Table Section -->
    <div class="mgmt-card">

        <!-- Customers Table -->
        <div style="overflow-x: auto;">
            <table class="booking-table">
                <thead>
                    <tr>
                        <th style="width: 25%;">Customer</th>
                        <th style="width: 12%;">Membership Tier</th>
                        <th style="width: 12%; text-align: right;">Loyalty Points</th>
                        <th style="width: 15%; text-align: right;">Lifetime Spent</th>
                        <th style="width: 10%; text-align: center;">Wash Count</th>
                        <th style="width: 8%; text-align: center;">Vehicles</th>
                        <th style="width: 18%;">Tier Upgrade Progress</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty customers}">
                            <c:forEach var="u" items="${customers}">
                                <tr>
                                    <!-- Customer Profile -->
                                    <td>
                                        <div class="customer-cell">
                                            <div class="customer-avatar">
                                                <c:out value="${fn:substring(u.username, 0, 2).toUpperCase()}"/>
                                            </div>
                                            <div>
                                                <div class="customer-name"><c:out value="${u.fullname}"/></div>
                                                <div class="customer-sub">
                                                    @<c:out value="${u.username}"/> • <c:out value="${not empty u.phone ? u.phone : 'No Phone'}"/>
                                                </div>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Tier Badge -->
                                    <td>
                                        <c:set var="tierName" value="${not empty u.loyaltyTier ? u.loyaltyTier.name : 'Member'}"/>
                                        <span class="tier-badge tier-${tierName}">
                                            <c:out value="${tierName}"/>
                                        </span>
                                    </td>

                                    <!-- Points -->
                                    <td class="td-points">
                                        <fmt:formatNumber value="${u.pointsBalance}" type="number" groupingUsed="true"/> pts
                                    </td>

                                    <!-- Spent -->
                                    <td class="td-spent">
                                        <fmt:formatNumber value="${u.lifetimeSpent}" type="number" groupingUsed="true"/> ₫
                                    </td>

                                    <!-- Total Washes -->
                                    <td class="td-washes">${u.totalWashes}</td>

                                    <!-- Total Vehicles Count Tag -->
                                    <td class="td-vehicle-count">
                                        <span class="vehicle-count-tag">${u.vehicleCount}</span>
                                    </td>

                                    <!-- Upgrade Progress Bar -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${tierName eq 'Platinum'}">
                                                <div class="progress-container">
                                                    <div class="progress-info">
                                                        <span style="color: #2563EB; font-weight: 700;">MAX TIER REACHED</span>
                                                        <span class="material-symbols-outlined" style="font-size: 14px; color: #3B82F6;">stars</span>
                                                    </div>
                                                    <div class="progress-bar-bg">
                                                        <div class="progress-bar-fill" style="width: 100%; background: #3B82F6;"></div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when test="${tierName eq 'Gold'}">
                                                <c:set var="targetWashes" value="30"/>
                                                <c:set var="progPercent" value="${u.totalWashes * 100 / targetWashes}"/>
                                                <c:if test="${progPercent > 100}"><c:set var="progPercent" value="100"/></c:if>
                                                <div class="progress-container">
                                                    <div class="progress-info">
                                                        <span>${u.totalWashes} / ${targetWashes} washes</span>
                                                        <span><fmt:formatNumber value="${progPercent}" maxFractionDigits="0"/>%</span>
                                                    </div>
                                                    <div class="progress-bar-bg">
                                                        <div class="progress-bar-fill" style="width: ${progPercent}%; background: #F59E0B;"></div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when test="${tierName eq 'Silver'}">
                                                <c:set var="targetWashes" value="15"/>
                                                <c:set var="progPercent" value="${u.totalWashes * 100 / targetWashes}"/>
                                                <c:if test="${progPercent > 100}"><c:set var="progPercent" value="100"/></c:if>
                                                <div class="progress-container">
                                                    <div class="progress-info">
                                                        <span>${u.totalWashes} / ${targetWashes} washes</span>
                                                        <span><fmt:formatNumber value="${progPercent}" maxFractionDigits="0"/>%</span>
                                                    </div>
                                                    <div class="progress-bar-bg">
                                                        <div class="progress-bar-fill" style="width: ${progPercent}%; background: #475569;"></div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="targetWashes" value="5"/>
                                                <c:set var="progPercent" value="${u.totalWashes * 100 / targetWashes}"/>
                                                <c:if test="${progPercent > 100}"><c:set var="progPercent" value="100"/></c:if>
                                                <div class="progress-container">
                                                    <div class="progress-info">
                                                        <span>${u.totalWashes} / ${targetWashes} washes</span>
                                                        <span><fmt:formatNumber value="${progPercent}" maxFractionDigits="0"/>%</span>
                                                    </div>
                                                    <div class="progress-bar-bg">
                                                        <div class="progress-bar-fill" style="width: ${progPercent}%; background: #10B981;"></div>
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
                                <td colspan="7" style="text-align: center; color: #94A3B8; padding: 4rem 2rem; font-style: italic;">
                                    <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.5rem;">
                                        <span class="material-symbols-outlined" style="font-size: 3rem; color: #94A3B8;">person_search</span>
                                        <span>No loyalty accounts match filter constraints.</span>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination Section matching UI layout spec -->
        <c:if test="${totalPages > 0}">
            <div class="pagination-container" style="border-top: 1px solid var(--border-slate);">
                <div class="pagination-wrapper">
                    <ul class="pagination-list">
                        <li>
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <c:url value="/admin/customers" var="prevUrl">
                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                        <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                        <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                        <c:param name="page" value="${currentPage - 1}"/>
                                    </c:url>
                                    <a href="${prevUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">
                                        <span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_left</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="page-item-btn disabled">
                                        <span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_left</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <c:choose>
                            <%-- If totalPages <= 5, show all pages without any ellipsis --%>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li>
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <button class="page-item-btn active">${i}</button>
                                            </c:when>
                                            <c:otherwise>
                                                <c:url value="/admin/customers" var="pageUrl">
                                                    <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                    <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                                    <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                    <c:param name="page" value="${i}"/>
                                                </c:url>
                                                <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:forEach>
                            </c:when>
                            
                            <%-- If totalPages > 5, apply ellipsis logic --%>
                            <c:otherwise>
                                <c:choose>
                                    <%-- Case 1: Near the beginning --%>
                                    <c:when test="${currentPage <= 3}">
                                        <c:forEach var="i" begin="1" end="4">
                                            <li>
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <button class="page-item-btn active">${i}</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:url value="/admin/customers" var="pageUrl">
                                                            <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                            <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                                            <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                            <c:param name="page" value="${i}"/>
                                                        </c:url>
                                                        <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </c:forEach>
                                        <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                        <li>
                                            <c:url value="/admin/customers" var="pageUrl">
                                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                                <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                <c:param name="page" value="${totalPages}"/>
                                            </c:url>
                                            <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${totalPages}</a>
                                        </li>
                                    </c:when>
                                    
                                    <%-- Case 2: Near the end --%>
                                    <c:when test="${currentPage >= totalPages - 2}">
                                        <li>
                                            <c:url value="/admin/customers" var="pageUrl">
                                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                                <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                <c:param name="page" value="1"/>
                                            </c:url>
                                            <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">1</a>
                                        </li>
                                        <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                        <c:forEach var="i" begin="${totalPages - 3}" end="${totalPages}">
                                            <li>
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <button class="page-item-btn active">${i}</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:url value="/admin/customers" var="pageUrl">
                                                            <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                            <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                                            <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                            <c:param name="page" value="${i}"/>
                                                        </c:url>
                                                        <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    
                                    <%-- Case 3: In the middle --%>
                                    <c:otherwise>
                                        <li>
                                            <c:url value="/admin/customers" var="pageUrl">
                                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                                <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                <c:param name="page" value="1"/>
                                            </c:url>
                                            <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">1</a>
                                        </li>
                                        <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                        <c:forEach var="i" begin="${currentPage - 1}" end="${currentPage + 1}">
                                            <li>
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <button class="page-item-btn active">${i}</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:url value="/admin/customers" var="pageUrl">
                                                            <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                            <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                                            <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                            <c:param name="page" value="${i}"/>
                                                        </c:url>
                                                        <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </c:forEach>
                                        <li><span style="padding: 0.5rem; color: #64748B;">...</span></li>
                                        <li>
                                            <c:url value="/admin/customers" var="pageUrl">
                                                <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                                <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                                <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                                <c:param name="page" value="${totalPages}"/>
                                            </c:url>
                                            <a href="${pageUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">${totalPages}</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                        <li>
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <c:url value="/admin/customers" var="nextUrl">
                                        <c:if test="${not empty search}"><c:param name="search" value="${search}"/></c:if>
                                        <c:if test="${not empty selectedTierId}"><c:param name="tierId" value="${selectedTierId}"/></c:if>
                                        <c:if test="${not empty sortBy}"><c:param name="sortBy" value="${sortBy}"/></c:if>
                                        <c:param name="page" value="${currentPage + 1}"/>
                                    </c:url>
                                    <a href="${nextUrl}" class="page-item-btn" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">
                                        <span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_right</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="page-item-btn disabled">
                                        <span class="material-symbols-outlined" style="font-size: 1.1rem;">chevron_right</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </ul>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Tier Rule Guidelines Card -->
    <div class="rules-card">
        <span class="material-symbols-outlined rules-card-icon">info</span>
        <div>
            <h4 class="rules-title">Loyalty Tier Upgrade Requirements</h4>
            <p class="rules-desc">Membership levels are calculated automatically using total completed washes or cumulative customer billing totals.</p>
            <div class="rules-badge-row">
                <div class="rule-pill-badge">🥈 Silver: 5 washes / 2,000,000 ₫</div>
                <div class="rule-pill-badge">🥇 Gold: 15 washes / 6,000,000 ₫</div>
                <div class="rule-pill-badge">💎 Platinum: 30 washes / 15,000,000 ₫</div>
            </div>
        </div>
    </div>

</div>

</body>
</html>
