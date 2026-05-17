<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty error}">
    <div class="alert alert-danger">
        ⚠️ <c:out value="${error}"/>
    </div>
</c:if>

<c:if test="${not empty success}">
    <div class="alert alert-success">
        ✅ <c:out value="${success}"/>
    </div>
</c:if>

<c:if test="${param.success == '1'}">
    <div class="alert alert-success">
        ✅ <c:out value="${not empty param.successMsg ? param.successMsg : 'Thao tác hoàn tất thành công!'}"/>
    </div>
</c:if>

<c:if test="${param.reg == 'success'}">
    <div class="alert alert-success">
        🎉 Đăng ký tài khoản thành công! Hãy đăng nhập để tiếp tục.
    </div>
</c:if>
