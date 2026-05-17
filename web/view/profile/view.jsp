<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="title" value="Thông tin hồ sơ cá nhân" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div style="max-width: 650px; margin: 3rem auto;">
    <div class="card">
        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2 style="color: var(--primary); font-weight: 700;">Hồ Sơ Cá Nhân</h2>
                <p style="color: var(--text-light); margin-top: 0.25rem; font-size: 0.95rem;">Quản lý thông tin tài khoản của bạn</p>
            </div>
            <span class="admin-badge" style="font-size: 0.95rem; padding: 0.4rem 0.8rem;">Vai trò: <c:out value="${sessionScope.currentUser.role}"/></span>
        </div>
        <div class="card-body">
            <jsp:include page="/view/components/alert.jsp">
                <jsp:param name="successMsg" value="Cập nhật thông tin hồ sơ thành công!"/>
            </jsp:include>

            <div style="background-color: #f1f5f9; padding: 1.25rem; border-radius: 12px; margin-bottom: 2rem; display: flex; gap: 1.5rem; align-items: center;">
                <div style="width: 64px; height: 64px; background-color: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.75rem; font-weight: 700;">
                    👤
                </div>
                <div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--text);"><c:out value="${sessionScope.currentUser.username}"/></h3>
                    <p style="color: var(--text-light); font-size: 0.9rem; margin-top: 0.25rem;">
                        Ngày tham gia: <fmt:formatDate value="${sessionScope.currentUser.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </p>
                </div>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/profile/update">
                <div class="form-group">
                    <label class="form-label" style="color: var(--text-light);">Tên đăng nhập (Không thể thay đổi)</label>
                    <input type="text" class="form-control" value="<c:out value="${sessionScope.currentUser.username}"/>" disabled style="background-color: #e2e8f0; cursor: not-allowed;">
                </div>

                <div class="form-group">
                    <label for="fullname" class="form-label">Họ và tên hiển thị</label>
                    <input type="text" id="fullname" name="fullname" class="form-control"
                           value="<c:out value="${sessionScope.currentUser.fullname}"/>" placeholder="Nhập họ và tên đầy đủ">
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Số điện thoại liên hệ</label>
                    <input type="tel" id="phone" name="phone" class="form-control"
                           value="<c:out value="${sessionScope.currentUser.phone}"/>" placeholder="Nhập số điện thoại (10 số, bắt đầu bằng 0)" pattern="0[0-9]{9}" maxlength="10">
                </div>

                <div style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: flex-end;">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Quay Lại</a>
                    <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/view/layout/footer.jsp"/>
