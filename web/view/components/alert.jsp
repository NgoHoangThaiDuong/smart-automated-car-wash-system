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
        ✅ <c:out value="${not empty param.successMsg ? param.successMsg : 'Operation completed successfully!'}"/>
    </div>
</c:if>

<c:if test="${param.reg == 'success'}">
    <div class="alert alert-success">
        🎉 Account registered successfully! Please log in to continue.
    </div>
</c:if>
