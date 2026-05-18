<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="title" value="Car Wash Order History" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div class="main-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 style="color: var(--primary); font-weight: 800; font-size: 2rem;">📋 Your Order History</h1>
            <p style="color: var(--text-light); margin-top: 0.25rem; font-size: 1rem;">Track status and appointments for your wash packages</p>
        </div>
        <a href="${pageContext.request.contextPath}/order/book" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.5rem; font-size: 1.05rem;">
            ➕ New Appointment
        </a>
    </div>

    <jsp:include page="/view/components/alert.jsp">
        <jsp:param name="successMsg" value="Appointment booked successfully! Your order is being processed by the system."/>
    </jsp:include>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="card" style="padding: 4rem 2rem; text-align: center;">
                <div style="font-size: 4rem; margin-bottom: 1rem;">📭</div>
                <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--text); margin-bottom: 0.5rem;">You Don't Have Any Orders Yet</h3>
                <p style="color: var(--text-light); max-width: 500px; margin: 0 auto 2rem auto; line-height: 1.5;">Start experiencing our smart automated car wash system today by booking your first wash appointment.</p>
                <a href="${pageContext.request.contextPath}/order/book" class="btn btn-primary" style="padding: 0.75rem 2rem; font-size: 1.05rem;">
                    🚗 Book a Wash Now
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Service</th>
                            <th>License Plate</th>
                            <th>Appointment Time</th>
                            <th>Price</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td style="font-weight: 700; color: var(--primary);">#<c:out value="${order.id}"/></td>
                                <td style="font-weight: 600;"><c:out value="${order.serviceName}"/></td>
                                <td><span style="background-color: #f1f5f9; padding: 0.25rem 0.65rem; border-radius: 6px; font-weight: 700; font-family: monospace; font-size: 1.05rem;"><c:out value="${order.carPlate}"/></span></td>
                                <td><fmt:formatDate value="${order.bookDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td style="font-weight: 700; color: #059669;"><fmt:formatNumber value="${order.servicePrice}" type="number" pattern="###,###"/> VND</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'COMPLETED'}">
                                            <span class="badge badge-completed">✓ Đã hoàn thành</span>
                                            <c:if test="${order.finalPrice > 0}">
                                                <div style="font-size: 0.8rem; color: var(--text-light); margin-top: 0.25rem;"><fmt:formatNumber value="${order.finalPrice}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/></div>
                                            </c:if>
                                        </c:when>
                                        <c:when test="${order.status == 'CANCELLED'}">
                                            <span class="badge badge-cancelled">✗ Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                                <span class="badge badge-pending">⏳ Chờ rửa xe</span>
                                                <form method="POST" action="${pageContext.request.contextPath}/order/complete" style="display: inline;">
                                                    <input type="hidden" name="orderId" value="${order.id}">
                                                    <button type="submit" class="btn btn-primary" style="padding: 0.25rem 0.65rem; font-size: 0.85rem;" title="Mô phỏng hoàn thành đơn để tích điểm">✓ Hoàn thành</button>
                                                </form>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/view/layout/footer.jsp"/>
