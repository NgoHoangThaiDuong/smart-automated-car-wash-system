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

    <!-- Danh Sách Xe & Lịch Sử Điểm -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 4rem;">
        <div class="card">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h3 style="font-size: 1.15rem; font-weight: 700;">🚗 Phương tiện của tôi</h3>
            </div>
            <div class="card-body" style="padding: 1.5rem;">
                <c:if test="${empty vehicleList}">
                    <p style="color: var(--text-light); font-size: 0.95rem; text-align: center; padding: 1rem 0;">Chưa có phương tiện nào được lưu.</p>
                </c:if>
                <c:if test="${not empty vehicleList}">
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <c:forEach var="v" items="${vehicleList}">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 0.75rem 1rem; background-color: var(--bg); border-radius: 8px; border: 1px solid var(--border);">
                                <span style="font-weight: 700; font-size: 1.1rem; color: var(--primary);"><c:out value="${v.licensePlate}"/></span>
                                <c:if test="${v.default}">
                                    <span class="badge badge-completed">Mặc định</span>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 style="font-size: 1.15rem; font-weight: 700;">⭐ Lịch sử điểm thưởng</h3>
            </div>
            <div class="card-body" style="padding: 1.5rem; max-height: 350px; overflow-y: auto;">
                <c:if test="${empty historyList}">
                    <p style="color: var(--text-light); font-size: 0.95rem; text-align: center; padding: 1rem 0;">Chưa có biến động điểm thưởng nào.</p>
                </c:if>
                <c:if test="${not empty historyList}">
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <c:forEach var="h" items="${historyList}">
                            <div style="padding: 0.75rem; border-bottom: 1px solid var(--border); font-size: 0.9rem;">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 0.25rem;">
                                    <span style="font-weight: 600;"><c:out value="${h.reason}"/></span>
                                    <span style="font-weight: 800; color: ${h.pointsChanged >= 0 ? 'var(--success)' : 'var(--danger)'};">
                                        ${h.pointsChanged >= 0 ? '+' : ''}${h.pointsChanged} pts
                                    </span>
                                </div>
                                <div style="color: var(--text-light); font-size: 0.8rem;">
                                    <fmt:formatDate value="${h.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/view/layout/footer.jsp"/>
