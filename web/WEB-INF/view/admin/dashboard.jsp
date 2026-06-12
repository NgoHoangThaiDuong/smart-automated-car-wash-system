<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body style="font-family: 'Inter', sans-serif; background: #f3f4f6; margin: 0; padding: 2rem;">
    <div style="max-width: 900px; margin: 0 auto;">
        <h1 style="color: #1f2937;">Admin Dashboard</h1>
        <p style="color: #6b7280;">Xin chào, <strong><c:out value="${sessionScope.currentUser.username}"/></strong>
            &nbsp;[Role: <c:out value="${sessionScope.currentUser.role}"/>]
        </p>
        <hr>
        <p style="color: #9ca3af; font-style: italic;">
            ⚙️ Dashboard đang được xây dựng — Phase 4
        </p>
        <a href="<c:url value='/auth/logout'/>" style="color: #ef4444;">Đăng xuất</a>
    </div>
</body>
</html>
