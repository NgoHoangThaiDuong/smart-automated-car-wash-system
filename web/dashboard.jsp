<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <a href="<c:url value='/dashboard'/>" class="nav-logo">Smart CarWash</a>
            <div class="nav-user">
                <a href="<c:url value='/profile'/>" class="user-greeting" style="text-decoration: none; color: inherit; cursor: pointer;">
                    Xin chào, <span><c:out value="${not empty currentUser.fullname ? currentUser.fullname : currentUser.username}"/></span>!
                </a>
                <a href="<c:url value='/auth/logout'/>" class="btn-logout" style="text-decoration: none; display: inline-block;">Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <%-- Nội dung dashboard sẽ được bổ sung ở các Phase tiếp theo --%>
    </div>

</body>
</html>
