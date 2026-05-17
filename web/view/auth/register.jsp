<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Sign Up" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div style="max-width: 550px; margin: 3rem auto;">
    <div class="card">
        <div class="card-header" style="text-align: center;">
            <h2 style="color: var(--primary); font-weight: 700;">Create an Account</h2>
            <p style="color: var(--text-light); margin-top: 0.5rem; font-size: 0.95rem;">Register to experience automated car wash services</p>
        </div>
        <div class="card-body">
            <jsp:include page="/view/components/alert.jsp"/>

            <form method="POST" action="${pageContext.request.contextPath}/auth/register">
                <div class="form-group">
                    <label for="username" class="form-label">Username *</label>
                    <input type="text" id="username" name="username" class="form-control"
                           value="<c:out value="${dto != null ? dto.username : param.username}"/>" placeholder="Enter username (3-50 characters)" required autofocus>
                </div>

                <div class="form-group">
                    <label for="fullname" class="form-label">Full Name</label>
                    <input type="text" id="fullname" name="fullname" class="form-control"
                           value="<c:out value="${dto != null ? dto.fullname : param.fullname}"/>" placeholder="Enter your full name">
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control"
                           value="<c:out value="${dto != null ? dto.phone : param.phone}"/>" placeholder="Enter 10-digit phone number starting with 0" pattern="0[0-9]{9}" maxlength="10">
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Password *</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Minimum 6 characters" required>
                        <span class="password-toggle" onclick="togglePassword('password', this)" title="Show password">👁️</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password *</label>
                    <div class="password-container">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               placeholder="Re-enter your password" required>
                        <span class="password-toggle" onclick="togglePassword('confirmPassword', this)" title="Show password">👁️</span>
                    </div>
                </div>

                <div style="margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Sign Up Now</button>
                </div>
            </form>

            <div style="margin-top: 1.5rem; text-align: center; font-size: 0.95rem; color: var(--text-light);">
                Already have an account? <a href="${pageContext.request.contextPath}/auth/login" style="color: var(--primary); font-weight: 600; text-decoration: none;">Sign in now</a>
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
        icon.title = "Hide password";
    } else {
        input.type = "password";
        icon.innerText = "👁️";
        icon.title = "Show password";
    }
}
</script>

<jsp:include page="/view/layout/footer.jsp"/>
