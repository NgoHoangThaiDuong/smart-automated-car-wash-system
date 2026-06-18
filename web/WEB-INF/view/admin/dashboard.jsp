<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/navbar.css'/>">
</head>
<body style="font-family: 'Inter', sans-serif; background: #f5f7fb; margin: 0;">
    <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

    <main style="width: min(1200px, calc(100% - 48px)); margin: 50px auto;">
        <h1 style="margin-bottom: 10px; color: #111827;">Admin Dashboard</h1>
        <p style="color: #667085;">
            Welcome, <strong><c:out value="${sessionScope.currentUser.fullname}"/></strong>.
            The admin dashboard content will be developed in the next phase.
        </p>
    </main>
</body>
</html>
