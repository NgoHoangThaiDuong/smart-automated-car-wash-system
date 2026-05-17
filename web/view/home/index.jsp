<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Trang Chủ Dashboard" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div class="main-container">
    <div class="hero-section">
        <h1 class="hero-title">Xin chào, <c:out value="${sessionScope.currentUser.fullname != null ? sessionScope.currentUser.fullname : sessionScope.currentUser.username}"/>!</h1>
        <p class="hero-subtitle">Chào mừng bạn đến với Hệ thống Quản lý và Đặt lịch Rửa xe Tự động Thông minh. Hãy trải nghiệm dịch vụ chăm sóc xe hàng đầu ngay hôm nay.</p>
        
        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/order/book" class="btn-hero btn-hero-primary">
                🚗 Đặt Lịch Rửa Xe
            </a>
            <a href="${pageContext.request.contextPath}/order/list" class="btn-hero btn-hero-secondary">
                📋 Lịch Sử Đơn Hàng
            </a>
        </div>
    </div>

    <div style="text-align: center; margin-bottom: 2rem;">
        <h2 style="font-size: 2rem; font-weight: 800; color: var(--text);">Tại Sao Chọn Chúng Tôi?</h2>
        <p style="color: var(--text-light); margin-top: 0.5rem;">Hệ thống tự động hóa hoàn toàn mang lại chất lượng vượt trội</p>
    </div>

    <div class="feature-grid">
        <div class="feature-card">
            <span class="feature-icon">⚡</span>
            <h3 class="feature-title">Tốc Độ Vượt Trội</h3>
            <p class="feature-desc">Quy trình rửa xe tự động hoàn tất chỉ trong vòng 10-15 phút, giúp bạn tiết kiệm thời gian chờ đợi tối đa.</p>
        </div>

        <div class="feature-card">
            <span class="feature-icon">✨</span>
            <h3 class="feature-title">Công Nghệ Bọt Tuyết</h3>
            <p class="feature-desc">Sử dụng dung dịch bọt tuyết cao cấp siêu sạch, bảo vệ lớp sơn xe luôn sáng bóng như mới xuất xưởng.</p>
        </div>

        <div class="feature-card">
            <span class="feature-icon">📱</span>
            <h3 class="feature-title">Đặt Lịch Tiện Lợi</h3>
            <p class="feature-desc">Chủ động lựa chọn khung giờ và dịch vụ yêu thích ngay trên điện thoại hoặc máy tính mọi lúc mọi nơi.</p>
        </div>
    </div>
</div>

<jsp:include page="/view/layout/footer.jsp"/>
