<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Promotions - Smart Car Wash</title>
        <link
            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap"
            rel="stylesheet">
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="<c:url value='/css/admin/common.css'/>">
        <link rel="stylesheet" href="<c:url value='/css/admin/promotions.css'/>">
    </head>

    <body>

        <!-- Sticky Top Navbar -->
        <c:set var="activePage" value="promotions" scope="request" />
        <jsp:include page="/WEB-INF/view/common/navbar.jsp" />

        <div class="admin-container">

            <!-- Page Header & Breadcrumbs -->
            <div class="page-header-container">
                <div class="breadcrumb-trail">
                    <a href="<c:url value='/admin/dashboard'/>">Dashboard</a>
                    <span class="material-symbols-outlined">chevron_right</span>
                    <span style="font-weight: 700;">Promotions</span>
                </div>
                <div class="header-action-row">
                    <div>
                        <h1 class="page-title">Promotions</h1>
                    </div>
                    <div style="display: flex; gap: 0.75rem;">
                        <a href="<c:url value='/admin/promotions'/>" class="btn-admin-secondary"
                           style="text-decoration: none;">
                            <span class="material-symbols-outlined">refresh</span>
                            Refresh
                        </a>
                        <a href="<c:url value='/admin/promotions/new'/>" class="btn-admin-primary"
                           style="text-decoration: none;">
                            <span class="material-symbols-outlined">add</span>
                            New Promotion
                        </a>
                    </div>
                </div>
            </div>

            <!-- Alert Notifications -->
            <c:if test="${not empty promotionMessage}">
                <div class="alert-box alert-success" style="margin-bottom: 1.5rem;">
                    <span>
                        <c:out value="${promotionMessage}" />
                    </span>
                    <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty promotionError}">
                <div class="alert-box alert-error" style="margin-bottom: 1.5rem;">
                    <span>
                        <c:out value="${promotionError}" />
                    </span>
                    <button class="alert-close-btn" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <!-- Promotions Table -->
            <div class="mgmt-card">
                <div style="overflow-x: auto;">
                    <table class="booking-table">
                        <thead>
                            <tr>
                                <th style="width: 5%;">ID</th>
                                <th style="width: 25%;">Promotion</th>
                                <th style="width: 10%;">Type</th>
                                <th style="width: 10%; text-align: right;">Value</th>
                                <th style="width: 12%;">Target Tier</th>
                                <th style="width: 18%;">Duration</th>
                                <th style="width: 10%; text-align: center;">Status</th>
                                <th style="width: 10%; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty promotions}">
                                    <c:forEach var="promotion" items="${promotions}">
                                        <tr>
                                            <!-- ID -->
                                            <td style="font-weight: 600; color: var(--text-slate-muted);">
                                                ${promotion.id}</td>

                                            <!-- Promotion Name + Description -->
                                            <td>
                                                <div class="promo-name">
                                                    <c:out value="${promotion.promotionName}" />
                                                </div>
                                                <c:if test="${not empty promotion.description}">
                                                    <div class="promo-desc">
                                                        <c:out value="${promotion.description}" />
                                                    </div>
                                                </c:if>
                                            </td>

                                            <!-- Discount Type -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${promotion.discountType == 'PERCENT'}">
                                                        <span
                                                            class="discount-type-tag discount-type-percent">
                                                            <span class="material-symbols-outlined"
                                                                  style="font-size: 0.9rem;">percent</span>
                                                            Percent
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="discount-type-tag discount-type-fixed">
                                                            <span class="material-symbols-outlined"
                                                                  style="font-size: 0.9rem;">payments</span>
                                                            Fixed
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Discount Value -->
                                            <td style="text-align: right;">
                                                <span class="discount-value">
                                                    <c:choose>
                                                        <c:when
                                                            test="${promotion.discountType == 'PERCENT'}">
                                                            <fmt:formatNumber
                                                                value="${promotion.discountValue}"
                                                                maxFractionDigits="2" />%
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber
                                                                value="${promotion.discountValue}"
                                                                type="number" />₫
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>

                                            <!-- Target Tier -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty promotion.targetTierId}">
                                                        <span class="promo-tier-badge">Tiers</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="promo-tier-badge">
                                                            <c:out value="${promotion.targetTierName}" />
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Duration -->
                                            <td>
                                                <div class="date-range-cell">
                                                    <div class="date-value">${promotion.startDate}</div>
                                                    <div class="date-range-separator">to</div>
                                                    <div class="date-value">${promotion.endDate}</div>
                                                </div>
                                            </td>

                                            <!-- Status -->
                                            <td style="text-align: center;">
                                                <c:choose>
                                                    <c:when test="${promotion.status == 'ACTIVE'}">
                                                        <span
                                                            class="promo-badge promo-badge-active">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span
                                                            class="promo-badge promo-badge-inactive">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Actions -->
                                            <td style="text-align: center;">
                                                <div class="actions-cell-group"
                                                     style="justify-content: center;">
                                                    <a class="btn-action-icon btn-action-edit"
                                                       href="${pageContext.request.contextPath}/admin/promotions/edit?id=${promotion.id}"
                                                       title="Edit">
                                                        <span class="material-symbols-outlined">edit</span>
                                                    </a>

                                                    <form class="delete-form"
                                                          action="${pageContext.request.contextPath}/admin/promotions/delete"
                                                          method="post"
                                                          onsubmit="return confirm('Are you sure you want to delete this promotion?');">
                                                        <input type="hidden" name="id"
                                                               value="${promotion.id}">
                                                        <button type="submit"
                                                                class="btn-action-icon btn-action-delete"
                                                                title="Delete">
                                                            <span
                                                                class="material-symbols-outlined">delete</span>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="promo-empty-state">
                                            <div class="promo-empty-state-inner">
                                                <span class="material-symbols-outlined">campaign</span>
                                                <span>No promotions found.</span>
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

    </body>

</html>