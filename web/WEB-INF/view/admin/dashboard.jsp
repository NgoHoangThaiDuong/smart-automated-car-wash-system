<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Smart Car Wash</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <style>
        .dashboard-header {
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
        
        /* Stats Grid Styling */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .stat-card {
            background: var(--surface);
            border-radius: 16px;
            padding: 1.5rem;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.25s ease;
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.05);
        }
        .stat-info {
            display: flex;
            flex-direction: column;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            line-height: 1.1;
            letter-spacing: -0.02em;
            color: var(--text);
        }
        .stat-label {
            font-size: 0.875rem;
            color: var(--text-light);
            font-weight: 600;
            margin-top: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .stat-icon-wrapper {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .stat-icon-wrapper svg {
            width: 24px;
            height: 24px;
            fill: currentColor;
        }
        
        /* Theme for Card States */
        .stat-confirmed .stat-icon-wrapper {
            background-color: #eff6ff;
            color: #1d4ed8;
        }
        .stat-inprogress .stat-icon-wrapper {
            background-color: #fffbeb;
            color: #d97706;
        }
        .stat-completed .stat-icon-wrapper {
            background-color: #ecfdf5;
            color: #059669;
        }
        .stat-today .stat-icon-wrapper {
            background-color: #f5f3ff;
            color: #7c3aed;
        }
        .stat-revenue .stat-icon-wrapper {
            background-color: #fef2f2;
            color: #dc2626;
        }
        .stat-revenue .stat-value {
            font-size: 1.65rem;
        }
        
        /* Sections */
        .dashboard-section {
            margin-top: 2.5rem;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.25rem;
        }
        .section-header h2 {
            font-size: 1.5rem;
            font-weight: 750;
            color: var(--text);
            letter-spacing: -0.02em;
        }
        
        /* Recent Activities Table Updates */
        .recent-table-card {
            background: var(--surface);
            border-radius: 16px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }
        .table-custom {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.9rem;
        }
        .table-custom th {
            background-color: #f8fafc;
            color: var(--text-light);
            font-weight: 700;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
        }
        .table-custom td {
            padding: 1.1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            color: var(--text);
            vertical-align: middle;
        }
        .table-custom tr:last-child td {
            border-bottom: none;
        }
        .table-custom tr:hover td {
            background-color: #f9fafb;
        }
        
        /* Status & Payment Badges styling */
        .badge-status {
            display: inline-flex;
            align-items: center;
            padding: 0.3rem 0.75rem;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
        }
        .badge-status-confirmed {
            background-color: #dce1ff;
            color: #0037b0;
        }
        .badge-status-in-progress {
            background-color: #ffe0b2;
            color: #e65100;
        }
        .badge-status-completed {
            background-color: #c8e6c9;
            color: #2e7d32;
        }
        .badge-status-cancelled {
            background-color: #ffdad6;
            color: #ba1a1a;
        }
        .badge-status-no-show {
            background-color: #e2e2e9;
            color: #45464f;
        }

        .badge-payment {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.6rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .badge-payment-paid {
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }
        .badge-payment-unpaid {
            background-color: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
        }
        
        .action-link {
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            transition: color 0.15s ease;
        }
        .action-link:hover {
            color: var(--primary-hover);
        }
        
        .empty-state {
            padding: 3rem 2rem;
            text-align: center;
            color: var(--text-light);
            font-style: italic;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/view/common/navbar.jsp">
    <jsp:param name="activePage" value="dashboard" />
</jsp:include>

<div class="main-container">
    <div class="dashboard-header">
        <h1 class="admin-page-title">Hệ thống Quản lý</h1>
        <p class="admin-page-subtitle">Tổng quan hoạt động và thống kê trạm rửa xe tự động</p>
    </div>

    <!-- Stats Grid -->
    <div class="stats-grid">
        <!-- Confirmed (Chờ xử lý) -->
        <div class="stat-card stat-confirmed">
            <div class="stat-info">
                <span class="stat-value"><c:out value="${confirmedCount}"/></span>
                <span class="stat-label">Chờ xử lý</span>
            </div>
            <div class="stat-icon-wrapper">
                <svg viewBox="0 0 24 24">
                    <path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10 10-4.5 10-10S17.5 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67V7z"/>
                </svg>
            </div>
        </div>

        <!-- In Progress (Đang rửa) -->
        <div class="stat-card stat-inprogress">
            <div class="stat-info">
                <span class="stat-value"><c:out value="${inProgressCount}"/></span>
                <span class="stat-label">Đang rửa</span>
            </div>
            <div class="stat-icon-wrapper">
                <svg viewBox="0 0 24 24">
                    <path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
                </svg>
            </div>
        </div>

        <!-- Completed (Hoàn thành) -->
        <div class="stat-card stat-completed">
            <div class="stat-info">
                <span class="stat-value"><c:out value="${completedCount}"/></span>
                <span class="stat-label">Hoàn thành</span>
            </div>
            <div class="stat-icon-wrapper">
                <svg viewBox="0 0 24 24">
                    <path d="M9 16.17 4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>
                </svg>
            </div>
        </div>

        <!-- Today (Trong ngày) -->
        <div class="stat-card stat-today">
            <div class="stat-info">
                <span class="stat-value"><c:out value="${todayCount}"/></span>
                <span class="stat-label">Hôm nay</span>
            </div>
            <div class="stat-icon-wrapper">
                <svg viewBox="0 0 24 24">
                    <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/>
                </svg>
            </div>
        </div>

        <!-- Total Revenue (Doanh thu) -->
        <div class="stat-card stat-revenue">
            <div class="stat-info">
                <span class="stat-value">
                    <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/>₫
                </span>
                <span class="stat-label">Doanh thu (PAID)</span>
            </div>
            <div class="stat-icon-wrapper">
                <svg viewBox="0 0 24 24">
                    <path d="M21 18v1c0 1.1-.9 2-2 2H5c-1.11 0-2-.9-2-2V5c0-1.1.89-2 2-2h14c1.1 0 2 .9 2 2v1h-9c-1.11 0-2 .9-2 2v8c0 1.1.89 2 2 2h9zm-9-2h10V8H12v8zm4-2.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/>
                </svg>
            </div>
        </div>
    </div>

    <!-- Recent Bookings Section -->
    <div class="dashboard-section">
        <div class="section-header">
            <h2>Đơn đặt dịch vụ gần đây</h2>
            <a href="<c:url value='/admin/bookings'/>" class="btn btn-secondary" style="font-size:0.875rem; padding: 0.5rem 1rem;">
                Xem tất cả đơn đặt
            </a>
        </div>

        <div class="recent-table-card">
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
                            <th>Thông tin xe</th>
                            <th>Dịch vụ rửa</th>
                            <th>Thời gian</th>
                            <th>Thành tiền</th>
                            <th>Trạng thái</th>
                            <th>Thanh toán</th>
                            <th style="text-align: right;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty recentBookings}">
                                <c:forEach var="b" items="${recentBookings}">
                                    <tr>
                                        <td style="font-weight: 700; color: var(--text-light);">
                                            #<c:out value="${b.id}"/>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600;"><c:out value="${b.user.fullname}"/></div>
                                            <div style="font-size: 0.78rem; color: var(--text-light);">@<c:out value="${b.user.username}"/></div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 700; font-family: monospace; letter-spacing: 0.05em;"><c:out value="${b.vehicle.licensePlate}"/></div>
                                            <div style="font-size: 0.78rem; color: var(--text-light);"><c:out value="${b.vehicle.brand}"/> <c:out value="${b.vehicle.model}"/></div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600;"><c:out value="${b.service.name}"/></div>
                                            <div style="font-size: 0.78rem; color: var(--text-light);"><fmt:formatNumber value="${b.service.price}" type="number" groupingUsed="true"/>₫</div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600;"><c:out value="${b.bookingDate}"/></div>
                                            <div style="font-size: 0.78rem; color: var(--text-light);"><c:out value="${b.timeSlot}"/></div>
                                        </td>
                                        <td style="font-weight: 700; color: var(--text);">
                                            <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/>₫
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${b.bookingStatus eq 'CONFIRMED'}">
                                                    <span class="badge-status badge-status-confirmed">Chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'IN_PROGRESS'}">
                                                    <span class="badge-status badge-status-in-progress">Đang rửa</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'COMPLETED'}">
                                                    <span class="badge-status badge-status-completed">Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'CANCELLED'}">
                                                    <span class="badge-status badge-status-cancelled">Đã hủy</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus eq 'NO_SHOW'}">
                                                    <span class="badge-status badge-status-no-show">No Show</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${b.paymentStatus eq 'PAID'}">
                                                    <span class="badge-payment badge-payment-paid">PAID</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-payment badge-payment-unpaid">UNPAID</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: right;">
                                            <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="action-link">
                                                Chi tiết
                                                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor" style="vertical-align: middle;">
                                                    <path d="M8.59 16.59 13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/>
                                                </svg>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="empty-state">Không có lịch đặt gần đây.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>
