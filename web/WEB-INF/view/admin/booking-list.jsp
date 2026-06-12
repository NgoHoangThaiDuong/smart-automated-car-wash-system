<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Booking - Smart Car Wash Admin</title>
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
    <h2 class="admin-page-title">Danh sách Booking</h2>

    <form method="GET" action="<c:url value='/admin/bookings'/>" class="filter-bar">
        <input id="search" name="search" type="text" placeholder="Mã booking, tên KH, biển số..." class="filter-input" value="<c:out value='${search}'/>">
        <select id="statusFilter" name="status" class="filter-select">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="CONFIRMED"   <c:if test="${selectedStatus eq 'CONFIRMED'}">selected</c:if>>Confirmed</option>
            <option value="IN_PROGRESS" <c:if test="${selectedStatus eq 'IN_PROGRESS'}">selected</c:if>>In Progress</option>
            <option value="COMPLETED"   <c:if test="${selectedStatus eq 'COMPLETED'}">selected</c:if>>Completed</option>
            <option value="CANCELLED"   <c:if test="${selectedStatus eq 'CANCELLED'}">selected</c:if>>Cancelled</option>
            <option value="NO_SHOW"     <c:if test="${selectedStatus eq 'NO_SHOW'}">selected</c:if>>No Show</option>
        </select>
        <input id="dateFilter" name="date" type="date" class="filter-input" value="<c:out value='${date}'/>">
        <button type="submit" class="btn-admin-primary">Lọc</button>
        <a href="<c:url value='/admin/bookings'/>" class="btn-admin-secondary">Xóa lọc</a>
    </form>

    <div class="table-wrapper">
        <table class="booking-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Khách hàng</th>
                    <th>Biển số</th>
                    <th>Dịch vụ</th>
                    <th>Ngày hẹn</th>
                    <th>Giờ</th>
                    <th>Trạng thái</th>
                    <th>Thanh toán</th>
                    <th>Thành tiền</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty bookings}">
                        <tr><td colspan="10" class="table-empty">Không tìm thấy booking nào.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td class="booking-id">#<c:out value="${b.id}"/></td>
                                <td>
                                    <div class="cell-main"><c:out value="${not empty b.user.fullname ? b.user.fullname : b.user.username}"/></div>
                                    <div class="cell-sub"><c:out value="${b.user.username}"/></div>
                                </td>
                                <td class="plate-cell"><c:out value="${b.vehicle.licensePlate}"/></td>
                                <td><c:out value="${b.service.name}"/></td>
                                <td><c:out value="${b.bookingDate}"/></td>
                                <td><c:out value="${b.timeSlot}"/></td>
                                <td><span class="status-badge status-${b.bookingStatus}"><c:out value="${b.bookingStatus}"/></span></td>
                                <td><span class="payment-badge payment-${b.paymentStatus}"><c:out value="${b.paymentStatus}"/></span></td>
                                <td class="amount-cell"><fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true"/>₫</td>
                                <td>
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
