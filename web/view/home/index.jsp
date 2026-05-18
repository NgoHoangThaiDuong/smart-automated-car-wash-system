<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Home Dashboard" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div class="main-container">
    <div class="hero-section">
        <h1 class="hero-title">Hello, <c:out value="${sessionScope.currentUser.fullname != null ? sessionScope.currentUser.fullname : sessionScope.currentUser.username}"/>!</h1>
        <p class="hero-subtitle">Welcome to the Smart Automated Car Wash Management & Booking System. Experience premium automotive care today.</p>
        
        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/profile/view" class="btn-hero btn-hero-primary">
                👤 My Profile
            </a>
        </div>
    </div>

    <div style="text-align: center; margin-bottom: 2rem;">
        <h2 style="font-size: 2rem; font-weight: 800; color: var(--text);">Why Choose Us?</h2>
        <p style="color: var(--text-light); margin-top: 0.5rem;">Fully automated systems delivering outstanding quality</p>
    </div>

    <div class="feature-grid">
        <div class="feature-card">
            <span class="feature-icon">⚡</span>
            <h3 class="feature-title">Lightning Fast</h3>
            <p class="feature-desc">Automated wash cycles finish in just 10-15 minutes, saving you valuable time.</p>
        </div>

        <div class="feature-card">
            <span class="feature-icon">✨</span>
            <h3 class="feature-title">Snow Foam Technology</h3>
            <p class="feature-desc">High-grade snow foam formulas deep clean and protect your vehicle's pristine showroom shine.</p>
        </div>

        <div class="feature-card">
            <span class="feature-icon">📱</span>
            <h3 class="feature-title">Convenient Booking</h3>
            <p class="feature-desc">Schedule your appointment and favorite service from your phone or desktop anytime, anywhere.</p>
        </div>
    </div>
</div>

<jsp:include page="/view/layout/footer.jsp"/>
