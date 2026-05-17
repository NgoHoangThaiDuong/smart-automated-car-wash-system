<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title != null ? param.title : 'Hệ thống Rửa xe Tự động'}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-logo">🚗 Smart CarWash</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/" class="nav-item">Trang chủ</a>
            <c:if test="${sessionScope.currentUser != null}">
                <a href="${pageContext.request.contextPath}/order/list" class="nav-item">Đơn hàng</a>
                <a href="${pageContext.request.contextPath}/profile/view" class="nav-item profile-link">👤 ${sessionScope.currentUser.fullname != null && !sessionScope.currentUser.fullname.isEmpty() ? sessionScope.currentUser.fullname : sessionScope.currentUser.username}</a>
                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item admin-badge">Admin Panel</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline-danger">Đăng xuất</a>
            </c:if>
            <c:if test="${sessionScope.currentUser == null}">
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-secondary">Đăng ký</a>
            </c:if>
        </div>
    </div>
</nav>
<div class="main-container">
