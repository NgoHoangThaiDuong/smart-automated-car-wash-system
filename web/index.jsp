<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Smart CarWash - Hệ thống Rửa xe Tự động 4.0" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div style="text-align: center; padding: 4rem 1rem; background: linear-gradient(135deg, #1e3a8a, #3b82f6); color: white; border-radius: 24px; margin-bottom: 3rem; box-shadow: 0 20px 25px -5px rgba(37, 99, 235, 0.2);">
    <span style="background-color: rgba(255, 255, 255, 0.2); padding: 0.5rem 1rem; border-radius: 9999px; font-weight: 600; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1px;">
        🌟 Chào mừng đến với Kỷ nguyên Rửa xe Tự động
    </span>
    <h1 style="font-size: 3.5rem; font-weight: 800; margin: 1.5rem 0 1rem; line-height: 1.2;">
        Smart Automated Car Wash<br>Management System
    </h1>
    <p style="font-size: 1.25rem; max-width: 700px; margin: 0 auto 2.5rem; opacity: 0.9;">
        Hệ thống rửa xe tự động thông minh chuẩn 4.0. Đặt lịch trực tuyến nhanh chóng, tiết kiệm thời gian và chăm sóc xế yêu của bạn một cách hoàn hảo.
    </p>

    <div style="display: flex; gap: 1.25rem; justify-content: center;">
        <c:choose>
            <c:when test="${sessionScope.currentUser != null}">
                <a href="${pageContext.request.contextPath}/order/list" class="btn btn-primary" style="background-color: #10b981; font-size: 1.1rem; padding: 0.85rem 2rem; box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.4);">
                    🚗 Đặt Lịch Rửa Xe Ngay
                </a>
                <a href="${pageContext.request.contextPath}/profile/view" class="btn" style="background-color: rgba(255,255,255,0.2); color: white; font-size: 1.1rem; padding: 0.85rem 2rem;">
                    Hồ Sơ Của Tôi
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary" style="background-color: #10b981; font-size: 1.1rem; padding: 0.85rem 2rem; box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.4);">
                    🔑 Bắt Đầu Ngay (Đăng Nhập)
                </a>
                <a href="${pageContext.request.contextPath}/auth/register" class="btn" style="background-color: rgba(255,255,255,0.2); color: white; font-size: 1.1rem; padding: 0.85rem 2rem;">
                    📝 Đăng Ký Tài Khoản
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem; margin-bottom: 4rem;">
    <div class="card" style="padding: 2.5rem; text-align: center; transition: transform 0.3s; border-top: 4px solid var(--primary);">
        <div style="font-size: 3rem; margin-bottom: 1.5rem;">⏱️</div>
        <h3 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 1rem; color: var(--text);">Siêu Tốc & Tiện Lợi</h3>
        <p style="color: var(--text-light); line-height: 1.6;">Quy trình tự động hóa 100%, làm sạch sâu toàn diện chỉ từ 5 đến 15 phút mà không cần phải chờ đợi lâu.</p>
    </div>

    <div class="card" style="padding: 2.5rem; text-align: center; transition: transform 0.3s; border-top: 4px solid #10b981;">
        <div style="font-size: 3rem; margin-bottom: 1.5rem;">📱</div>
        <h3 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 1rem; color: var(--text);">Đặt Lịch Trực Tuyến</h3>
        <p style="color: var(--text-light); line-height: 1.6;">Lựa chọn thời gian và các gói dịch vụ mong muốn trực tiếp ngay trên điện thoại hoặc máy tính của bạn.</p>
    </div>

    <div class="card" style="padding: 2.5rem; text-align: center; transition: transform 0.3s; border-top: 4px solid #f59e0b;">
        <div style="font-size: 3rem; margin-bottom: 1.5rem;">💎</div>
        <h3 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 1rem; color: var(--text);">Chất Lượng Đỉnh Cao</h3>
        <p style="color: var(--text-light); line-height: 1.6;">Công nghệ vòi phun áp lực cao và hóa chất chuyên dụng bảo vệ lớp sơn xế yêu luôn sáng bóng như mới.</p>
    </div>
</div>

<jsp:include page="/view/layout/footer.jsp"/>
