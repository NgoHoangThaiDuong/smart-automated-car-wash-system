<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký tài khoản - Smart Car Wash</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    </head>
    <body>

        <div class="register-container">
            <div class="icon-wrapper">
                <svg viewBox="0 0 24 24">
                <path d="M18.92 11.01C18.72 10.42 18.16 10 17.5 10H6.5c-.66 0-1.21.42-1.42 1.01L3 17v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.85 12h10.3l1.04 3H5.81l1.04-3zM6 21c-.83 0-1.5-.67-1.5-1.5S5.17 18 6 18s1.5.67 1.5 1.5S6.83 21 6 21zm12 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/>
                </svg>
            </div>

            <h1>Đăng ký tài khoản</h1>
            <p class="subtitle">Trở thành thành viên Smart Car Wash</p>

            <form method="POST" action="${pageContext.request.contextPath}/auth/register"
                  novalidate>
                <div class="form-group">
                    <label class="form-label" for="username">Tài khoản</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                            </svg>
                        </span>
                        <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tài khoản" value="<c:out value="${username}"/>" required autocomplete="username">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                            </svg>
                        </span>
                        <input type="password"
                               id="password"
                               name="password"
                               class="form-control"
                               placeholder="Nhập mật khẩu"
                               minlength="6"
                               required
                               autocomplete="new-password">
                        <button type="button" id="togglePasswordBtn" class="toggle-password" title="Show/Hide password">
                            <svg id="eye-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Xác nhận mật khẩu</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                            </svg>
                        </span>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required autocomplete="new-password">
                        <button type="button" id="toggleConfirmPasswordBtn" class="toggle-password" title="Show/Hide password">
                            <svg id="confirm-eye-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="fullname">Họ và Tên</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                            </svg>
                        </span>
                        <input type="text" id="fullname" name="fullname" class="form-control" placeholder="Nhập họ và tên hiển thị" value="<c:out value="${fullname}"/>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="phone">Số điện thoại</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.94.725l.548 2.2a1 1 0 01-.321.988l-1.305.98a10.582 10.582 0 004.872 4.872l.98-1.305a1 1 0 01.988-.321l2.2.548a1 1 0 01.725.94V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                            </svg>
                        </span>
                        <input type="tel" id="phone" name="phone" class="form-control" placeholder="0901234567" pattern="0[0-9]{9}" maxlength="10" value="<c:out value="${phone}"/>" required>
                    </div>
                </div>

                <div id="alertBox">

                    <!-- Hiển thị lỗi -->
                    <c:if test="${not empty error}">

                        <c:forEach var="e" items="${error}">
                            <div class="alert alert-danger" style="display:block;">
                                ${e.value}
                            </div>
                        </c:forEach>

                    </c:if>

                    <!-- Hiển thị thành công -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success" style="display:block;">
                            ${success}
                        </div>
                    </c:if>

                </div>

                <button type="submit" id="submitBtn" class="btn-submit">
                    <span class="spinner" id="btnSpinner" style="display:none;"></span>
                    <span id="btnText">Đăng ký</span>
                </button>
            </form>

            <p class="footer-text">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập ngay</a>
            </p>
        </div>

        <script>
            // ===== PASSWORD TOGGLE =====
            const passwordInput = document.getElementById('password');
            const toggleBtn = document.getElementById('togglePasswordBtn');
            const eyeIcon = document.getElementById('eye-icon');

            toggleBtn.addEventListener('click', function () {

                const isPassword =
                        passwordInput.getAttribute('type') === 'password';

                passwordInput.setAttribute(
                        'type',
                        isPassword ? 'text' : 'password'
                        );

                if (isPassword) {

                    eyeIcon.innerHTML =
                            `<path stroke-linecap="round" stroke-linejoin="round"
                    d="M13.875 18.825A10.05 10.05 0 0112 19
                    c-4.478 0-8.268-2.943-9.543-7
                    a9.97 9.97 0 011.563-3.029
                    m5.858.908a3 3 0 114.243 4.243
                    M9.878 9.878l4.242 4.242
                    M9.88 9.88l-3.29-3.29
                    m7.532 7.532l3.29 3.29
                    M3 3l3.59 3.59
                    m0 0A9.953 9.953 0 0112 5
                    c4.478 0 8.268 2.943 9.543 7
                    a10.025 10.025 0 01-4.132 5.411
                    m0 0L21 21" />`;

                } else {

                    eyeIcon.innerHTML =
                            `
                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M15 12a3 3 0 11-6 0
                      3 3 0 016 0z"/>

                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M2.458 12C3.732 7.943
                      7.523 5 12 5c4.478 0
                      8.268 2.943 9.542 7
                      -1.274 4.057-5.064 7
                      -9.542 7-4.477
                      0-8.268-2.943-9.542-7z"/>
            `;
                }
            });

            // ===== CONFIRM PASSWORD TOGGLE =====
            const confirmPasswordInput =
                    document.getElementById('confirmPassword');

            const toggleConfirmBtn =
                    document.getElementById('toggleConfirmPasswordBtn');

            const confirmEyeIcon =
                    document.getElementById('confirm-eye-icon');

            toggleConfirmBtn.addEventListener('click', function () {

                const isPassword =
                        confirmPasswordInput.getAttribute('type') === 'password';

                confirmPasswordInput.setAttribute(
                        'type',
                        isPassword ? 'text' : 'password'
                        );

                if (isPassword) {

                    confirmEyeIcon.innerHTML =
                            `<path stroke-linecap="round" stroke-linejoin="round"
                    d="M13.875 18.825A10.05 10.05 0 0112 19
                    c-4.478 0-8.268-2.943-9.543-7
                    a9.97 9.97 0 011.563-3.029
                    m5.858.908a3 3 0 114.243 4.243
                    M9.878 9.878l4.242 4.242
                    M9.88 9.88l-3.29-3.29
                    m7.532 7.532l3.29 3.29
                    M3 3l3.59 3.59
                    m0 0A9.953 9.953 0 0112 5
                    c4.478 0 8.268 2.943 9.543 7
                    a10.025 10.025 0 01-4.132 5.411
                    m0 0L21 21" />`;

                } else {

                    confirmEyeIcon.innerHTML =
                            `
                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M15 12a3 3 0 11-6 0
                      3 3 0 016 0z"/>

                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M2.458 12C3.732 7.943
                      7.523 5 12 5c4.478 0
                      8.268 2.943 9.542 7
                      -1.274 4.057-5.064 7
                      -9.542 7-4.477
                      0-8.268-2.943-9.542-7z"/>
            `;
                }
            });

            // ===== FORM VALIDATION =====
            const form = document.querySelector('form');

            form.addEventListener('submit', function (e) {

                const passwordVal =
                        passwordInput.value.trim();

                const confirmPasswordVal =
                        confirmPasswordInput.value.trim();

                const alertBox =
                        document.getElementById('alertBox');

                // reset error
                alertBox.innerHTML = '';

                // password < 6
                if (passwordVal.length < 6) {

                    e.preventDefault();

                    alertBox.innerHTML =
                            '<div class="alert alert-danger" style="display:block;">Mật khẩu phải có ít nhất 6 ký tự!</div>';

                    return;
                }

                // confirm password wrong
                if (passwordVal !== confirmPasswordVal) {

                    e.preventDefault();

                    alertBox.innerHTML =
                            '<div class="alert alert-danger" style="display:block;">Mật khẩu xác nhận không khớp!</div>';

                    return;
                }

                // loading
                document.getElementById('btnSpinner').style.display =
                        'inline-block';

                document.getElementById('btnText').textContent =
                        'Đang đăng ký...';

                document.getElementById('submitBtn').disabled = true;
            });
        </script>
    </body>
</html>
