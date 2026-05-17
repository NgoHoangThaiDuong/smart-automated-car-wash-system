<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Đăng nhập hệ thống" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div style="max-width: 450px; margin: 3rem auto;">
    <div class="card">
        <div class="card-header" style="text-align: center;">
            <h2 style="color: var(--primary); font-weight: 700;">Đăng Nhập</h2>
            <p style="color: var(--text-light); margin-top: 0.5rem; font-size: 0.95rem;">Truy cập vào tài khoản Smart CarWash của bạn</p>
        </div>
        <div class="card-body">
            <jsp:include page="/view/components/alert.jsp"/>

            <form method="POST" action="${pageContext.request.contextPath}/auth/login">
                <div class="form-group">
                    <label for="username" class="form-label">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" class="form-control"
                           value="<c:out value="${not empty username ? username : param.username}"/>" placeholder="Nhập username" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Nhập mật khẩu" required>
                        <span class="password-toggle" onclick="togglePassword('password', this)" title="Hiển thị mật khẩu">👁️</span>
                    </div>
                </div>

                <div style="margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Đăng Nhập</button>
                </div>
            </form>

            <div style="margin-top: 1.5rem; text-align: center; font-size: 0.95rem; color: var(--text-light);">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/auth/register" style="color: var(--primary); font-weight: 600; text-decoration: none;">Đăng ký ngay</a>
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
