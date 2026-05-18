<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="title" value="User Profile & Loyalty" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div class="main-container" style="max-width: 800px; margin: 3rem auto;">
    <div style="margin-bottom: 2rem;">
        <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text);">Hồ sơ Thành viên & Loyalty</h1>
        <p style="color: var(--text-light); margin-top: 0.25rem;">Quản lý tài khoản, phương tiện và theo dõi tiến trình thăng hạng</p>
    </div>

    <jsp:include page="/view/components/alert.jsp">
        <jsp:param name="successMsg" value="Cập nhật hồ sơ thành công!"/>
    </jsp:include>

    <!-- Thẻ Thành Viên (Membership Card) -->
    <div class="membership-card tier-<c:out value="${sessionScope.currentUser.tier != null ? sessionScope.currentUser.tier.name : 'Member'}"/>">
        <div class="membership-header">
            <span class="membership-brand">🚗 Smart CarWash Loyalty</span>
            <span class="membership-tier-badge">👑 <c:out value="${sessionScope.currentUser.tier != null ? sessionScope.currentUser.tier.name : 'Member'}"/></span>
        </div>
        <div class="membership-body">
            <div class="membership-username"><c:out value="${sessionScope.currentUser.username}"/></div>
            <div class="membership-fullname"><c:out value="${sessionScope.currentUser.fullname != null && !sessionScope.currentUser.fullname.isEmpty() ? sessionScope.currentUser.fullname : 'Khách hàng thân thiết'}"/></div>
        </div>
        <div class="membership-footer">
            <div class="membership-stat">
                <span class="membership-stat-label">Điểm thưởng hiện có</span>
                <span class="membership-stat-val"><fmt:formatNumber value="${sessionScope.currentUser.pointsBalance}" type="number"/> pts</span>
            </div>
            <div class="membership-stat" style="text-align: right;">
                <span class="membership-stat-label">Tổng tích lũy chi tiêu</span>
                <span class="membership-stat-val"><fmt:formatNumber value="${sessionScope.currentUser.lifetimeSpent}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/></span>
            </div>
        </div>
    </div>

    <!-- Thanh Tiến Trình Lên Hạng -->
    <div class="loyalty-progress-container">
        <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem; display: flex; align-items: center; justify-content: space-between;">
            <span>🚀 Tiến trình thăng hạng</span>
            <c:if test="${nextTier != null}">
                <span style="font-size: 0.95rem; color: var(--primary); font-weight: 800;"><fmt:formatNumber value="${progressPercent}" maxFractionDigits="1"/>%</span>
            </c:if>
        </h3>
        <c:if test="${nextTier != null}">
            <div class="progress-track">
                <div class="progress-fill" style="width: ${progressPercent}%;"></div>
            </div>
            <p style="color: var(--text-light); font-size: 0.95rem; margin-top: 0.75rem;">
                Bạn cần chi tiêu thêm <strong style="color: var(--text);"><fmt:formatNumber value="${remainingSpend}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/></strong> hoặc thực hiện thêm dịch vụ để thăng hạng <strong style="color: var(--primary);">${nextTier.name}</strong> và nhận ưu đãi giảm giá đặc quyền!
            </p>
        </c:if>
        <c:if test="${nextTier == null}">
            <div class="alert alert-success" style="margin-top: 1rem; margin-bottom: 0;">
                🎉 Chúc mừng! Bạn đang sở hữu bậc hạng cao nhất (Platinum) với toàn bộ đặc quyền tối thượng của hệ thống!
            </div>
        </c:if>
    </div>

    <!-- Thông Tin Hồ sơ -->
    <div class="card" style="margin-bottom: 2.5rem;">
        <div class="card-header">
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--text);">⚙️ Thông tin cá nhân</h3>
        </div>
        <div class="card-body">
            <form method="POST" action="${pageContext.request.contextPath}/profile/update">
                <div class="form-group">
                    <label class="form-label" style="color: var(--text-light);">Tên tài khoản (Không thể thay đổi)</label>
                    <input type="text" class="form-control" value="<c:out value="${sessionScope.currentUser.username}"/>" disabled style="background-color: #e2e8f0; cursor: not-allowed;">
                </div>

                <div class="form-group">
                    <label for="fullname" class="form-label">Họ và Tên hiển thị</label>
                    <input type="text" id="fullname" name="fullname" class="form-control"
                           value="<c:out value="${sessionScope.currentUser.fullname}"/>" placeholder="Nhập họ và tên của bạn">
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Số điện thoại liên hệ</label>
                    <input type="tel" id="phone" name="phone" class="form-control"
                           value="<c:out value="${sessionScope.currentUser.phone}"/>" placeholder="Nhập số điện thoại 10 số (bắt đầu bằng số 0)" pattern="0[0-9]{9}" maxlength="10">
                </div>

                <div style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: flex-end;">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Quay lại Trang chủ</a>
                    <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>

</div>

<jsp:include page="/view/layout/footer.jsp"/>
