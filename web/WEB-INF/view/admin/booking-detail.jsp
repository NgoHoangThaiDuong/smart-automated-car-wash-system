<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Booking #<c:out value="${booking.id}"/> - Smart Car Wash Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body>
<nav class="navbar">
    <div class="nav-container" style="max-width:1100px;">
        <a href="<c:url value='/admin/dashboard'/>" class="nav-logo">⚙️ Smart CarWash Admin</a>
        <div class="nav-user">
            <a href="<c:url value='/admin/bookings'/>" class="admin-nav-link active">Booking</a>
            <span class="user-greeting"><c:out value="${sessionScope.currentUser.username}"/></span>
            <a href="<c:url value='/auth/logout'/>" class="btn-logout" style="text-decoration:none;display:inline-block;">Đăng xuất</a>
        </div>
    </div>
</nav>

<div class="admin-container">
    <div class="detail-header">
        <a href="<c:url value='/admin/bookings'/>" class="back-link">← Quay lại danh sách</a>
        <h2 class="admin-page-title">Booking #<c:out value="${booking.id}"/></h2>
    </div>

    <c:if test="${not empty adminMsg}">
        <div class="alert alert-success"><c:out value="${adminMsg}"/></div>
    </c:if>
    <c:if test="${not empty adminError}">
        <div class="alert alert-danger"><c:out value="${adminError}"/></div>
    </c:if>

    <div class="detail-grid">
        <div class="detail-card">
            <div class="detail-card-title">Thông tin khách hàng</div>
            <div class="detail-row">
                <span class="detail-label">Họ tên</span>
                <span class="detail-value"><c:out value="${not empty booking.user.fullname ? booking.user.fullname : booking.user.username}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Tài khoản</span>
                <span class="detail-value"><c:out value="${booking.user.username}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Số điện thoại</span>
                <span class="detail-value"><c:out value="${not empty booking.user.phone ? booking.user.phone : '—'}"/></span>
            </div>
        </div>

        <div class="detail-card">
            <div class="detail-card-title">Thông tin xe</div>
            <div class="detail-row">
                <span class="detail-label">Biển số</span>
                <span class="detail-value plate-cell"><c:out value="${booking.vehicle.licensePlate}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Hãng xe</span>
                <span class="detail-value"><c:out value="${booking.vehicle.brand}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Màu</span>
                <span class="detail-value"><c:out value="${booking.vehicle.color}"/></span>
            </div>
        </div>

        <div class="detail-card">
            <div class="detail-card-title">Thông tin dịch vụ</div>
            <div class="detail-row">
                <span class="detail-label">Dịch vụ</span>
                <span class="detail-value"><c:out value="${booking.service.name}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Ngày hẹn</span>
                <span class="detail-value"><c:out value="${booking.bookingDate}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Giờ</span>
                <span class="detail-value"><c:out value="${booking.timeSlot}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Thành tiền</span>
                <span class="detail-value amount-cell"><fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/>₫</span>
            </div>
        </div>

        <div class="detail-card">
            <div class="detail-card-title">Trạng thái</div>
            <div class="detail-row">
                <span class="detail-label">Booking</span>
                <span class="status-badge status-${booking.bookingStatus}"><c:out value="${booking.bookingStatus}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Thanh toán</span>
                <span class="payment-badge payment-${booking.paymentStatus}"><c:out value="${booking.paymentStatus}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Đặt lúc</span>
                <span class="detail-value"><fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
            </div>
            <c:if test="${not empty booking.completedAt}">
                <div class="detail-row">
                    <span class="detail-label">Hoàn thành</span>
                    <span class="detail-value"><fmt:formatDate value="${booking.completedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
            </c:if>
        </div>
    </div>

    <c:if test="${booking.bookingStatus ne 'COMPLETED' and booking.bookingStatus ne 'CANCELLED' and booking.bookingStatus ne 'NO_SHOW'}">
        <div class="status-actions">
            <div class="detail-card-title" style="margin-bottom:1rem;">Cập nhật trạng thái</div>
            <form method="POST" action="<c:url value='/admin/bookings/update-status'/>">
                <input type="hidden" name="bookingId" value="<c:out value='${booking.id}'/>">
                <div class="action-buttons">
                    <c:if test="${booking.bookingStatus eq 'CONFIRMED'}">
                        <button type="submit" name="newStatus" value="IN_PROGRESS" class="btn-status btn-inprogress">▶ In Progress</button>
                        <button type="submit" name="newStatus" value="NO_SHOW" class="btn-status btn-noshow">✗ No Show</button>
                        <button type="submit" name="newStatus" value="CANCELLED" class="btn-status btn-cancel" onclick="return confirm('Xác nhận hủy booking?')">✕ Hủy</button>
                    </c:if>
                    <c:if test="${booking.bookingStatus eq 'IN_PROGRESS'}">
                        <button type="submit" name="newStatus" value="COMPLETED" class="btn-status btn-complete" onclick="return confirm('Hoàn thành? Booking phải đã thanh toán.')">✔ Hoàn thành</button>
                        <button type="submit" name="newStatus" value="NO_SHOW" class="btn-status btn-noshow">✗ No Show</button>
                        <button type="submit" name="newStatus" value="CANCELLED" class="btn-status btn-cancel" onclick="return confirm('Xác nhận hủy booking?')">✕ Hủy</button>
                    </c:if>
                </div>
            </form>
        </div>
    </c:if>
</div>
</body>
</html>
