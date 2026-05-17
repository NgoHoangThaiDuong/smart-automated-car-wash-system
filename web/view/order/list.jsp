<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="title" value="Lịch Sử Đơn Hàng Rửa Xe" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div class="main-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 style="color: var(--primary); font-weight: 800; font-size: 2rem;">📋 Lịch Sử Đơn Hàng Của Bạn</h1>
            <p style="color: var(--text-light); margin-top: 0.25rem; font-size: 1rem;">Theo dõi trạng thái và lịch hẹn các gói dịch vụ rửa xe</p>
        </div>
        <a href="${pageContext.request.contextPath}/order/book" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.5rem; font-size: 1.05rem;">
            ➕ Đặt Lịch Mới
        </a>
    </div>

    <jsp:include page="/view/components/alert.jsp">
        <jsp:param name="successMsg" value="Đặt lịch rửa xe thành công! Đơn hàng của bạn đang được hệ thống xử lý."/>
    </jsp:include>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="card" style="padding: 4rem 2rem; text-align: center;">
                <div style="font-size: 4rem; margin-bottom: 1rem;">📭</div>
                <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--text); margin-bottom: 0.5rem;">Bạn Chưa Có Đơn Hàng Nào</h3>
                <p style="color: var(--text-light); max-width: 500px; margin: 0 auto 2rem auto; line-height: 1.5;">Hãy bắt đầu trải nghiệm hệ thống rửa xe thông minh tự động ngay hôm nay bằng việc đặt lịch rửa xe đầu tiên của bạn.</p>
                <a href="${pageContext.request.contextPath}/order/book" class="btn btn-primary" style="padding: 0.75rem 2rem; font-size: 1.05rem;">
                    🚗 Đặt Lịch Rửa Xe Ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mã Đơn</th>
                            <th>Dịch Vụ</th>
                            <th>Biển Số Xe</th>
                            <th>Thời Gian Hẹn</th>
                            <th>Giá Tiền</th>
                            <th>Trạng Thái</th>
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
                                            <span class="badge badge-completed">✓ Đã Hoàn Thành</span>
                                        </c:when>
                                        <c:when test="${order.status == 'CANCELLED'}">
                                            <span class="badge badge-cancelled">✗ Đã Hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-pending">⏳ Chờ Mang Xe Đến</span>
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
