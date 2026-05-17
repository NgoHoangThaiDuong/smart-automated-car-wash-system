<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Đăng ký tài khoản" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div style="max-width: 550px; margin: 3rem auto;">
    <div class="card">
        <div class="card-header" style="text-align: center;">
            <h2 style="color: var(--primary); font-weight: 700;">Đăng Ký Tài Khoản</h2>
            <p style="color: var(--text-light); margin-top: 0.5rem; font-size: 0.95rem;">Tạo tài khoản mới để trải nghiệm dịch vụ rửa xe tự động</p>
        </div>
        <div class="card-body">
            <jsp:include page="/view/components/alert.jsp"/>

            <form method="POST" action="${pageContext.request.contextPath}/auth/register">
                <div class="form-group">
                    <label for="username" class="form-label">Tên đăng nhập *</label>
                    <input type="text" id="username" name="username" class="form-control"
                           value="<c:out value="${dto != null ? dto.username : param.username}"/>" placeholder="Nhập username (3-50 ký tự)" required autofocus>
                </div>

                <div class="form-group">
                    <label for="fullname" class="form-label">Họ và tên</label>
                    <input type="text" id="fullname" name="fullname" class="form-control"
                           value="<c:out value="${dto != null ? dto.fullname : param.fullname}"/>" placeholder="Nhập họ và tên đầy đủ">
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="tel" id="phone" name="phone" class="form-control"
                           value="<c:out value="${dto != null ? dto.phone : param.phone}"/>" placeholder="Nhập số điện thoại (10 số, bắt đầu bằng 0)" pattern="0[0-9]{9}" maxlength="10">
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Mật khẩu *</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Mật khẩu tối thiểu 6 ký tự" required>
                        <span class="password-toggle" onclick="togglePassword('password', this)" title="Hiển thị mật khẩu">👁️</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu *</label>
                    <div class="password-container">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               placeholder="Nhập lại mật khẩu" required>
                        <span class="password-toggle" onclick="togglePassword('confirmPassword', this)" title="Hiển thị mật khẩu">👁️</span>
                    </div>
                </div>

                <div style="margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Đăng Ký Ngay</button>
                </div>
            </form>

            <div style="margin-top: 1.5rem; text-align: center; font-size: 0.95rem; color: var(--text-light);">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login" style="color: var(--primary); font-weight: 600; text-decoration: none;">Đăng nhập ngay</a>
            </div>
        </div>
    </div>
</div>

<script>
function togglePassword(inputId, icon) {
    const input = document.getElementById(inputId);
    if (input.type === "password") {
        input.type = "text";
        icon.innerText = "🙈";
        icon.title = "Ẩn mật khẩu";
    } else {
        input.type = "password";
        icon.innerText = "👁️";
        icon.title = "Hiển thị mật khẩu";
    }
}
</script>

<jsp:include page="/view/layout/footer.jsp"/>
