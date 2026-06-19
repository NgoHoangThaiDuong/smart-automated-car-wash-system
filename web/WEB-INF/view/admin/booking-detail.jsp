<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Booking #<c:out value="${booking.id}"/> - Smart Car Wash Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <style>
        .booking-detail-wrapper {
            margin-top: 1.5rem;
        }
        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 1.5rem 0 1rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .section-title::before {
            content: '';
            display: inline-block;
            width: 4px;
            height: 18px;
            background: var(--primary);
            border-radius: 2px;
        }
        .action-panel-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 1.25rem;
            margin-top: 1.5rem;
        }
        .payment-collect-box {
            background: #EFF6FF;
            border: 1px solid #BFDBFE;
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
        }
        .payment-method-select {
            width: 100%;
            padding: 0.6rem 0.85rem;
            border: 1px solid #93C5FD;
            border-radius: 10px;
            font-family: inherit;
            font-size: 0.875rem;
            background: #ffffff;
            margin: 0.75rem 0 1rem 0;
        }
        .payment-method-select:focus {
            outline: none;
            border-color: var(--primary);
        }
        .alert {
            padding: 0.75rem 1.25rem;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 1.25rem;
        }
        .alert-success {
            background-color: #DEF7EC;
            color: #03543F;
            border: 1px solid #BCF0DA;
        }
        .alert-danger {
            background-color: #FDE8E8;
            color: #9B1C1C;
            border: 1px solid #FBD5D5;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/view/common/navbar.jsp">
    <jsp:param name="activePage" value="bookings" />
</jsp:include>

<div class="admin-container">
    <div class="detail-header">
        <a href="<c:url value='/admin/bookings'/>" class="back-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: text-bottom; margin-right: 0.2rem;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
            Quay lại danh sách
        </a>
    </div>
    
    <h2 class="admin-page-title" style="margin-bottom: 1.25rem;">Thông tin Booking #<c:out value="${booking.id}"/></h2>

    <!-- Alerts -->
    <c:if test="${not empty sessionScope.adminMsg}">
        <div class="alert alert-success">
            <c:out value="${sessionScope.adminMsg}"/>
        </div>
        <c:remove var="adminMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.adminError}">
        <div class="alert alert-danger">
            <c:out value="${sessionScope.adminError}"/>
        </div>
        <c:remove var="adminError" scope="session"/>
    </c:if>

    <!-- Info Grid -->
    <div class="detail-grid">
        <!-- Customer Info -->
        <div class="detail-card">
            <div class="detail-card-title">👤 Khách hàng</div>
            <div class="detail-row">
                <span class="detail-label">Họ tên</span>
                <span class="detail-value"><c:out value="${not empty booking.user.fullname ? booking.user.fullname : booking.user.username}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Tên đăng nhập</span>
                <span class="detail-value" style="color:var(--text-light); font-weight:normal;"><c:out value="${booking.user.username}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Số điện thoại</span>
                <span class="detail-value"><c:out value="${not empty booking.user.phone ? booking.user.phone : 'Chưa cập nhật'}"/></span>
            </div>
            <c:if test="${not empty booking.user.loyaltyTier}">
                <div class="detail-row">
                    <span class="detail-label">Hạng thành viên</span>
                    <span class="detail-value" style="font-weight: 700; color: var(--primary);"><c:out value="${booking.user.loyaltyTier.tierName}"/></span>
                </div>
            </c:if>
        </div>

        <!-- Vehicle Info -->
        <div class="detail-card">
            <div class="detail-card-title">🚗 Phương tiện</div>
            <div class="detail-row">
                <span class="detail-label">Biển số xe</span>
                <span class="detail-value plate-cell" style="font-size:1rem;"><c:out value="${booking.vehicle.licensePlate}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Thương hiệu</span>
                <span class="detail-value"><c:out value="${booking.vehicle.brand}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Màu sắc</span>
                <span class="detail-value"><c:out value="${booking.vehicle.color}"/></span>
            </div>
        </div>

        <!-- Wash Service Info -->
        <div class="detail-card">
            <div class="detail-card-title">💦 Dịch vụ & Lịch hẹn</div>
            <div class="detail-row">
                <span class="detail-label">Gói dịch vụ</span>
                <span class="detail-value" style="color:var(--primary);"><c:out value="${booking.service.name}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Ngày hẹn</span>
                <span class="detail-value"><c:out value="${booking.bookingDate}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Khung giờ</span>
                <span class="detail-value" style="font-weight:700;"><c:out value="${booking.timeSlot}"/></span>
            </div>
            <div class="detail-row" style="border-top:1px dashed var(--border); padding-top:0.5rem; margin-top:0.25rem;">
                <span class="detail-label" style="font-weight:700; color:var(--text-dark);">Tổng chi phí</span>
                <span class="detail-value amount-cell" style="font-size:1.1rem; color:var(--text-dark);"><fmt:formatNumber value="${booking.totalAmount}" type="number" groupingUsed="true"/>₫</span>
            </div>
        </div>

        <!-- Status Summary -->
        <div class="detail-card">
            <div class="detail-card-title">📊 Trạng thái đơn</div>
            <div class="detail-row">
                <span class="detail-label">Booking</span>
                <span class="status-badge status-${booking.bookingStatus}"><c:out value="${booking.bookingStatus}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Thanh toán</span>
                <span class="payment-badge payment-${booking.paymentStatus}"><c:out value="${booking.paymentStatus}"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Ngày đặt</span>
                <span class="detail-value" style="font-size: 0.85rem;"><fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
            </div>
            <c:if test="${not empty booking.completedAt}">
                <div class="detail-row">
                    <span class="detail-label">Hoàn thành lúc</span>
                    <span class="detail-value" style="font-size: 0.85rem; color: #059669;"><fmt:formatDate value="${booking.completedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
            </c:if>
            <c:if test="${booking.pointsEarned > 0}">
                <div class="detail-row">
                    <span class="detail-label">Điểm tích lũy</span>
                    <span class="detail-value" style="color: #7C3AED; font-weight:700;">+<c:out value="${booking.pointsEarned}"/> điểm</span>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Notes Card if any -->
    <c:if test="${not empty booking.notes}">
        <div class="detail-card" style="margin-top: 1.25rem; width: 100%;">
            <div class="detail-card-title">📝 Ghi chú từ khách hàng</div>
            <div style="font-size: 0.875rem; color: var(--text-gray); line-height: 1.5; white-space: pre-line;">
                <c:out value="${booking.notes}"/>
            </div>
        </div>
    </c:if>

    <!-- Action Section Grid -->
    <div class="action-panel-grid">
        <!-- Quick Payment Processing -->
        <c:if test="${booking.paymentStatus ne 'PAID' and booking.bookingStatus ne 'CANCELLED'}">
            <div class="payment-collect-box">
                <div class="detail-card-title" style="border-bottom: 1px solid #93C5FD; color: #1E3A8A; font-weight: 800;">💵 Thu tiền & Xác nhận thanh toán</div>
                <p style="font-size: 0.82rem; color: #1E40AF; margin-top: 0.5rem; line-height: 1.4;">
                    Vui lòng chọn phương thức giao dịch thực tế của khách hàng để cập nhật trạng thái thanh toán cho hóa đơn này.
                </p>
                <form method="POST" action="<c:url value='/admin/bookings/collect-payment'/>">
                    <input type="hidden" name="bookingId" value="<c:out value='${booking.id}'/>">
                    <label for="paymentMethod" class="filter-label" style="color: #1E3A8A; margin-top: 0.5rem; display: block;">Phương thức thanh toán</label>
                    <select id="paymentMethod" name="paymentMethod" class="payment-method-select">
                        <option value="CASH">💵 Tiền mặt (Cash)</option>
                        <option value="BANK_TRANSFER">💳 Chuyển khoản (Bank Transfer)</option>
                    </select>
                    <button type="submit" class="btn-admin-primary" style="width: 100%; justify-content: center; background: #2563EB;">
                        Xác nhận đã thanh toán thành công
                    </button>
                </form>
            </div>
        </c:if>

        <!-- Status Management Actions -->
        <c:if test="${booking.bookingStatus ne 'COMPLETED' and booking.bookingStatus ne 'CANCELLED' and booking.bookingStatus ne 'NO_SHOW'}">
            <div class="status-actions">
                <div class="detail-card-title" style="margin-bottom:1rem; font-weight: 800;">⚙️ Quản lý trạng thái Booking</div>
                <form method="POST" action="<c:url value='/admin/bookings/update-status'/>">
                    <input type="hidden" name="bookingId" value="<c:out value='${booking.id}'/>">
                    <div class="action-buttons">
                        <c:if test="${booking.bookingStatus eq 'CONFIRMED'}">
                            <button type="submit" name="newStatus" value="IN_PROGRESS" class="btn-status btn-inprogress" style="flex:1;">▶ Tiến hành rửa</button>
                            <button type="submit" name="newStatus" value="NO_SHOW" class="btn-status btn-noshow" style="flex:1;" onclick="return confirm('Xác nhận khách hàng không đến?')">✗ Vắng mặt</button>
                            <button type="submit" name="newStatus" value="CANCELLED" class="btn-status btn-cancel" style="flex:1;" onclick="return confirm('Xác nhận hủy lịch đặt này?')">✕ Hủy đơn</button>
                        </c:if>
                        <c:if test="${booking.bookingStatus eq 'IN_PROGRESS'}">
                            <button type="submit" name="newStatus" value="COMPLETED" class="btn-status btn-complete" style="flex: 1 0 100%; margin-bottom: 0.5rem; font-size: 0.95rem; padding: 0.75rem;" onclick="return confirm('Xác nhận hoàn thành rửa xe? (Đơn hàng bắt buộc phải ở trạng thái ĐÃ THANH TOÁN)')">✔ Hoàn thành dịch vụ</button>
                            <button type="submit" name="newStatus" value="NO_SHOW" class="btn-status btn-noshow" style="flex:1;" onclick="return confirm('Xác nhận khách hàng không đến?')">✗ Vắng mặt</button>
                            <button type="submit" name="newStatus" value="CANCELLED" class="btn-status btn-cancel" style="flex:1;" onclick="return confirm('Xác nhận hủy lịch đặt này?')">✕ Hủy đơn</button>
                        </c:if>
                    </div>
                </form>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>
