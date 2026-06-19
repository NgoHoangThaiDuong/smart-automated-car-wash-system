<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách khách hàng - Smart Car Wash</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <style>
        .customers-header {
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

        /* Filter Controls Styling */
        .filter-card {
            background: var(--surface);
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }
        .filter-form {
            display: flex;
            gap: 1rem;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .filter-group {
            flex: 1;
            min-width: 200px;
        }
        .filter-group-small {
            flex: 0 0 220px;
        }
        .filter-label {
            display: block;
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--text);
            margin-bottom: 0.5rem;
        }
        .filter-input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        .filter-input-icon {
            position: absolute;
            left: 0.875rem;
            color: var(--text-light);
            pointer-events: none;
        }
        .filter-control {
            width: 100%;
            padding: 0.625rem 0.875rem;
            font-size: 0.95rem;
            border-radius: 8px;
            border: 1px solid var(--border);
            background-color: var(--surface);
            color: var(--text);
            transition: border-color 0.15s ease, box-shadow 0.15s ease;
        }
        .filter-control-iconic {
            padding-left: 2.25rem;
        }
        .filter-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(29, 78, 216, 0.15);
        }
        .filter-actions {
            display: flex;
            gap: 0.75rem;
        }

        /* Table Card & Data Grid Styling */
        .table-card {
            background: var(--surface);
            border-radius: 16px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 3rem;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.95rem;
        }
        .data-table th {
            background-color: #f8fafc;
            font-weight: 700;
            color: var(--text);
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }
        .data-table td {
            padding: 1.25rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
            color: var(--text);
        }
        .data-table tbody tr:last-child td {
            border-bottom: none;
        }
        .data-table tbody tr:hover {
            background-color: #f8fafc;
        }

        /* Customer Info badge details */
        .customer-meta-cell {
            display: flex;
            flex-direction: column;
        }
        .customer-name {
            font-weight: 700;
            color: var(--text);
        }
        .customer-username {
            font-size: 0.8rem;
            color: var(--text-light);
        }

        /* Loyalty Tier Badges mapping colors */
        .badge-tier {
            display: inline-flex;
            align-items: center;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.25rem 0.6rem;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }
        /* Default fallback dynamic mapping if badge tier classes matches standard name dynamic */
        .tier-silver {
            background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e1 100%);
            color: #475569;
            border: 1px solid #94a3b8;
        }
        .tier-gold {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            color: #b45309;
            border: 1px solid #f59e0b;
        }
        .tier-platinum {
            background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
            color: #0369a1;
            border: 1px solid #38bdf8;
        }
        .tier-diamond {
            background: linear-gradient(135deg, #fae8ff 0%, #f5d0fe 100%);
            color: #a21caf;
            border: 1px solid #e879f9;
        }
        .tier-bronze, .tier-standard, .tier-normal {
            background: linear-gradient(135deg, #ffedd5 0%, #fed7aa 100%);
            color: #c2410c;
            border: 1px solid #fb923c;
        }

        /* Counter numbers */
        .stat-count-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background-color: #f1f5f9;
            color: var(--text);
            font-weight: 700;
            padding: 0.25rem 0.5rem;
            border-radius: 6px;
            font-size: 0.85rem;
            border: 1px solid var(--border);
        }
        .stat-count-badge.has-items {
            background-color: #e0f2fe;
            color: #0369a1;
            border-color: #bae6fd;
        }

        .customer-points {
            font-weight: 700;
            color: var(--primary);
        }
        .customer-spend {
            font-weight: 800;
            color: #16a34a;
        }
        .customer-washes {
            font-weight: 700;
            color: var(--text);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/view/common/navbar.jsp">
    <jsp:param name="activePage" value="customers" />
</jsp:include>

<div class="main-container">
    <div class="customers-header">
        <div>
            <h1 class="admin-page-title">Cơ sở dữ liệu Khách hàng</h1>
            <p class="admin-page-subtitle">Quản lý tài khoản, tích lũy điểm và thứ hạng Loyalty của khách hàng</p>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="filter-card">
        <form class="filter-form" action="<c:url value='/admin/customers'/>" method="GET">
            <div class="filter-group">
                <label class="filter-label" for="search">Tìm kiếm khách hàng</label>
                <div class="filter-input-wrapper">
                    <span class="filter-input-icon">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </span>
                    <input type="text" id="search" name="search" class="filter-control filter-control-iconic" placeholder="Tìm theo tên, SĐT hoặc username..." value="<c:out value='${search}'/>">
                </div>
            </div>

            <div class="filter-group filter-group-small">
                <label class="filter-label" for="tierId">Hạng thành viên (Loyalty Tier)</label>
                <select id="tierId" name="tierId" class="filter-control">
                    <option value="">-- Tất cả hạng --</option>
                    <c:forEach var="t" items="${tiers}">
                        <option value="${t.id}" ${selectedTierId == t.id ? 'selected' : ''}>
                            <c:out value="${t.name}"/>
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-actions">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                <a href="<c:url value='/admin/customers'/>" class="btn btn-secondary" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">Đặt lại</a>
            </div>
        </form>
    </div>

    <!-- Customers Table Card -->
    <div class="table-card">
        <c:choose>
            <c:when test="${not empty customers}">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Khách hàng</th>
                            <th>Số điện thoại</th>
                            <th>Hạng Loyalty</th>
                            <th style="text-align: center;">Số lượng xe</th>
                            <th style="text-align: center;">Số lần rửa xe</th>
                            <th style="text-align: center;">Điểm tích lũy</th>
                            <th style="text-align: right;">Tổng chi tiêu</th>
                            <th>Ngày tham gia</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${customers}">
                            <tr>
                                <td>
                                    <div class="customer-meta-cell">
                                        <span class="customer-name"><c:out value="${u.fullname}"/></span>
                                        <span class="customer-username">@<c:out value="${u.username}"/></span>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty u.phone}">
                                            <c:out value="${u.phone}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--text-light); font-style: italic;">Chưa cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty u.loyaltyTier}">
                                            <!-- Xác định class cho badge dựa vào tên hạng (chuyển thường) -->
                                            <c:set var="tierClass" value="tier-standard"/>
                                            <c:set var="tNameLower" value="${u.loyaltyTier.name.toLowerCase()}"/>
                                            <c:choose>
                                                <c:when test="${tNameLower.contains('silver') || tNameLower.contains('bạc')}">
                                                    <c:set var="tierClass" value="tier-silver"/>
                                                </c:when>
                                                <c:when test="${tNameLower.contains('gold') || tNameLower.contains('vàng')}">
                                                    <c:set var="tierClass" value="tier-gold"/>
                                                </c:when>
                                                <c:when test="${tNameLower.contains('platinum') || tNameLower.contains('bạch kim')}">
                                                    <c:set var="tierClass" value="tier-platinum"/>
                                                </c:when>
                                                <c:when test="${tNameLower.contains('diamond') || tNameLower.contains('kim cương')}">
                                                    <c:set var="tierClass" value="tier-diamond"/>
                                                </c:when>
                                                <c:when test="${tNameLower.contains('bronze') || tNameLower.contains('đồng')}">
                                                    <c:set var="tierClass" value="tier-bronze"/>
                                                </c:when>
                                            </c:choose>
                                            <span class="badge-tier ${tierClass}">
                                                <c:out value="${u.loyaltyTier.name}"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-tier tier-standard">Chưa có hạng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: center;">
                                    <span class="stat-count-badge ${u.vehicleCount > 0 ? 'has-items' : ''}">
                                        <c:out value="${u.vehicleCount}"/>
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <span class="customer-washes"><c:out value="${u.totalWashes}"/></span>
                                </td>
                                <td style="text-align: center;">
                                    <span class="customer-points">
                                        <fmt:formatNumber value="${u.pointsBalance}" type="number" groupingUsed="true"/>
                                    </span>
                                </td>
                                <td style="text-align: right;">
                                    <span class="customer-spend">
                                        <fmt:formatNumber value="${u.lifetimeSpent}" type="number" groupingUsed="true"/>₫
                                    </span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 5rem 2rem; color: var(--text-light);">
                    <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 1rem; color: var(--text-light); opacity: 0.6;">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--text); margin-bottom: 0.25rem;">Không tìm thấy khách hàng</h3>
                    <p style="font-size: 0.9rem;">Thử thay đổi từ khóa hoặc bộ lọc hạng thành viên khác.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
