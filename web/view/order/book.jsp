<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="title" value="Đặt Lịch Rửa Xe" scope="request" />
<jsp:include page="/view/layout/header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<div style="max-width: 700px; margin: 3rem auto; padding: 0 1.5rem;">
    <div class="card">
        <div class="card-header">
            <h2 style="color: var(--primary); font-weight: 800; font-size: 1.75rem;">🚗 Đặt Lịch Rửa Xe Mới</h2>
            <p style="color: var(--text-light); margin-top: 0.25rem; font-size: 0.95rem;">Lựa chọn dịch vụ và thời gian phù hợp với bạn</p>
        </div>
        <div class="card-body">
            <jsp:include page="/view/components/alert.jsp"/>

            <form method="POST" action="${pageContext.request.contextPath}/order/book">
                <div class="form-group">
                    <label for="serviceId" class="form-label">Chọn gói dịch vụ</label>
                    <select id="serviceId" name="serviceId" class="form-control" onchange="updateServicePreview()">
                        <option value="">-- Vui lòng chọn gói dịch vụ --</option>
                        <c:forEach var="srv" items="${services}">
                            <option value="${srv.id}" data-price="${srv.price}" data-desc="<c:out value='${srv.description}'/>"
                                    <c:if test="${srv.id == selectedServiceId}">selected</c:if>>
                                <c:out value="${srv.name}"/> (<fmt:formatNumber value="${srv.price}" type="number" pattern="###,###"/> VND)
                            </option>
                        </c:forEach>
                    </select>

                    <div id="servicePreview" class="service-preview">
                        <div id="previewPrice" class="service-preview-price"></div>
                        <div id="previewDesc" class="service-preview-desc"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="carPlate" class="form-label">Biển số xe (Ví dụ: 29A-12345)</label>
                    <input type="text" id="carPlate" name="carPlate" class="form-control"
                           value="<c:out value="${carPlate}"/>" placeholder="Nhập biển số xe của bạn (ít nhất 5 ký tự)">
                </div>

                <div class="form-group">
                    <label for="bookDate" class="form-label">Thời gian dự kiến mang xe đến</label>
                    <input type="datetime-local" id="bookDate" name="bookDate" class="form-control"
                           value="<c:out value="${bookDate}"/>">
                </div>

                <div style="margin-top: 2.5rem; display: flex; gap: 1rem; justify-content: flex-end;">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Quay Lại</a>
                    <button type="submit" class="btn btn-primary" style="padding: 0.75rem 2rem; font-size: 1.05rem;">Xác Nhận Đặt Lịch</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function updateServicePreview() {
    const select = document.getElementById("serviceId");
    const previewBox = document.getElementById("servicePreview");
    const previewPrice = document.getElementById("previewPrice");
    const previewDesc = document.getElementById("previewDesc");
    
    if (select.selectedIndex > 0) {
        const option = select.options[select.selectedIndex];
        const price = parseFloat(option.getAttribute("data-price")).toLocaleString("vi-VN");
        const desc = option.getAttribute("data-desc");
        
        previewPrice.innerText = price + " VND";
        previewDesc.innerText = desc;
        previewBox.style.display = "block";
    } else {
        previewBox.style.display = "none";
    }
}

// Chạy lần đầu khi load trang (nếu có form validation error load lại)
document.addEventListener("DOMContentLoaded", function() {
    updateServicePreview();
    
    // Nếu chưa chọn ngày giờ, tự động điền ngày giờ hiện tại + 1 tiếng
    const dateInput = document.getElementById("bookDate");
    if (!dateInput.value) {
        const now = new Date();
        now.setHours(now.getHours() + 1);
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        dateInput.value = year + "-" + month + "-" + day + "T" + hours + ":" + minutes;
    }
});
</script>

<jsp:include page="/view/layout/footer.jsp"/>
