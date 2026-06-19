<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Booking - Smart Car Wash Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <style>
        .filter-section {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid var(--border);
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--card-shadow);
        }
        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: flex-end;
        }
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
        }
        .filter-label {
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--text-gray);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .filter-actions {
            display: flex;
            gap: 0.5rem;
            justify-content: flex-end;
            margin-top: 1rem;
            border-top: 1px solid var(--border);
            padding-top: 1rem;
        }
        .results-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .results-count {
            font-size: 0.875rem;
            color: var(--text-light);
            font-weight: 500;
        }
        .results-count strong {
            color: var(--text-dark);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/view/common/navbar.jsp">
    <jsp:param name="activePage" value="bookings" />
</jsp:include>

<div class="admin-container">
    <h2 class="admin-page-title">Quản lý đặt lịch (Bookings)</h2>

    <!-- Search and Filter Form -->
    <div class="filter-section">
        <form method="GET" action="<c:url value='/admin/bookings'/>">
            <div class="filter-grid">
                <div class="filter-group">
                    <label for="search" class="filter-label">Tìm kiếm</label>
                    <input id="search" name="search" type="text" placeholder="Mã đặt lịch, tên KH, biển số..." class="filter-input" style="min-width: 100%;" value="<c:out value='${search}'/>">
                </div>
                <div class="filter-group">
                    <label for="statusFilter" class="filter-label">Trạng thái Booking</label>
                    <select id="statusFilter" name="status" class="filter-select" style="min-width: 100%;">
                        <option value="">-- Tất cả trạng thái --</option>
                        <option value="CONFIRMED" <c:if test="${selectedStatus eq 'CONFIRMED'}">selected</c:if>>Confirmed (Đã xác nhận)</option>
                        <option value="IN_PROGRESS" <c:if test="${selectedStatus eq 'IN_PROGRESS'}">selected</c:if>>In Progress (Đang rửa)</option>
                        <option value="COMPLETED" <c:if test="${selectedStatus eq 'COMPLETED'}">selected</c:if>>Completed (Hoàn thành)</option>
                        <option value="CANCELLED" <c:if test="${selectedStatus eq 'CANCELLED'}">selected</c:if>>Cancelled (Đã hủy)</option>
                        <option value="NO_SHOW" <c:if test="${selectedStatus eq 'NO_SHOW'}">selected</c:if>>No Show (Không đến)</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="dateFilter" class="filter-label">Ngày hẹn</label>
                    <input id="dateFilter" name="date" type="date" class="filter-input" style="min-width: 100%;" value="<c:out value='${date}'/>">
                </div>
            </div>
            <div class="filter-actions">
                <a href="<c:url value='/admin/bookings'/>" class="btn-admin-secondary">Xóa bộ lọc</a>
                <button type="submit" class="btn-admin-primary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.4rem;"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    Áp dụng bộ lọc
                </button>
            </div>
        </form>
    </div>

    <!-- Metadata under Filter -->
    <div class="results-meta">
        <div class="results-count">
            Tìm thấy <strong><c:out value="${bookings != null ? bookings.size() : 0}"/></strong> lịch đặt xe
        </div>
    </div>

    <!-- Booking Table Grid -->
    <div class="table-wrapper">
        <table class="booking-table">
            <thead>
                <tr>
                    <th style="width: 70px;">Mã Đơn</th>
                    <th>Khách hàng</th>
                    <th>Phương tiện</th>
                    <th>Gói Dịch vụ</th>
                    <th>Lịch hẹn</th>
                    <th>Trạng thái</th>
                    <th>Thanh toán</th>
                    <th style="text-align: right;">Thành tiền</th>
                    <th style="width: 80px; text-align: center;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty bookings}">
                        <tr>
                            <td colspan="9" class="table-empty">Không tìm thấy lịch đặt nào phù hợp với bộ lọc.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td class="booking-id">#<c:out value="${b.id}"/></td>
                                <td>
                                    <div class="cell-main"><c:out value="${not empty b.user.fullname ? b.user.fullname : b.user.username}"/></div>
                                    <div class="cell-sub"><c:out value="${b.user.phone != null ? b.user.phone : 'Không có SĐT'}"/></div>
                                </td>
                                <td>
                                    <span class="plate-cell"><c:out value="${b.vehicle.licensePlate}"/></span>
                                    <div class="cell-sub" style="font-size:0.75rem;"><c:out value="${b.vehicle.brand} ${b.vehicle.color}"/></div>
                                </td>
                                <td>
                                    <div class="cell-main"><c:out value="${b.service.name}"/></div>
                                </td>
                                <td>
                                    <div class="cell-main"><c:out value="${b.bookingDate}"/></div>
                                    <div class="cell-sub" style="font-weight: 600; color: var(--primary);"><c:out value="${b.timeSlot}"/></div>
                                </td>
                                <td>
                                    <span class="status-badge status-${b.bookingStatus}"><c:out value="${b.bookingStatus}"/></span>
                                </td>
                                <td>
                                    <span class="payment-badge payment-${b.paymentStatus}"><c:out value="${b.paymentStatus}"/></span>
                                    <c:if test="${b.paymentStatus eq 'PAID'}">
                                        <div class="cell-sub" style="font-size: 0.72rem; font-weight: 500;">
                                            <c:choose>
                                                <c:when test="${b.paymentMethod eq 'CASH'}">💵 Tiền mặt</c:when>
                                                <c:when test="${b.paymentMethod eq 'BANK_TRANSFER'}">💳 Chuyển khoản</c:when>
                                                <c:otherwise><c:out value="${b.paymentMethod}"/></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                </td>
                                <td class="amount-cell" style="text-align: right; font-size: 0.95rem;">
                                    <fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/>₫
                                </td>
                                <td style="text-align: center;">
                                    <a href="<c:url value='/admin/bookings/detail?id=${b.id}'/>" class="btn-detail">Chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
