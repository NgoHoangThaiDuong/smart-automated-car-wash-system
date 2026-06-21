<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wash History - Smart Car Wash</title>
    <meta name="description" content="Xem lại lịch sử rửa xe đã hoàn thành và điểm thưởng của bạn.">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/typography.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/customer/wash-history.css'/>">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

    <main class="wh-page">
        <%-- Page Heading --%>
        <section class="wh-heading">
            <div class="wh-heading-text">
                <h1>Wash History</h1>
                <p>Xem lại các dịch vụ rửa xe đã hoàn thành và điểm thưởng.</p>
            </div>
            <div class="wh-period-quick">
                <form id="periodQuickForm" method="get" action="<c:url value='/wash-history'/>">
                    <input type="hidden" name="search" value="${paramSearch}">
                    <input type="hidden" name="serviceId" value="${paramServiceId != null ? paramServiceId : ''}">
                    <input type="hidden" name="vehicleId" value="${paramVehicleId != null ? paramVehicleId : ''}">
                    <select name="period" id="periodQuickSelect" onchange="this.form.submit()">
                        <option value="7" ${paramPeriod eq '7' ? 'selected' : ''}>7 ngày gần nhất</option>
                        <option value="30" ${paramPeriod eq '30' ? 'selected' : ''}>30 ngày gần nhất</option>
                        <option value="90" ${paramPeriod eq '90' ? 'selected' : ''}>90 ngày gần nhất</option>
                        <option value="all" ${paramPeriod eq 'all' ? 'selected' : ''}>Tất cả</option>
                    </select>
                </form>
            </div>
        </section>

        <%-- Main Card --%>
        <section class="wh-card">
            <%-- Card Header with Search and Filter Toggle --%>
            <div class="wh-card-header">
                <h2>Completed Wash History</h2>
                <button type="button" class="wh-filter-toggle" onclick="toggleFilter()">
                    <span class="material-symbols-outlined">tune</span> Filter
                </button>
            </div>

            <%-- Search and Filter Panel --%>
            <div class="wh-filter-panel" id="filterPanel">
                <form method="get" action="<c:url value='/wash-history'/>" class="wh-filter-form">
                    <div class="wh-search-row">
                        <input type="text" name="search" value="${paramSearch}"
                               placeholder="Tìm theo mã booking, biển số, tên xe hoặc dịch vụ"
                               class="wh-search-input" id="searchInput">
                    </div>
                    <div class="wh-filter-row">
                        <div class="wh-filter-group">
                            <label for="filterPeriod">Khoảng thời gian</label>
                            <select name="period" id="filterPeriod">
                                <option value="7" ${paramPeriod eq '7' ? 'selected' : ''}>7 ngày gần nhất</option>
                                <option value="30" ${paramPeriod eq '30' ? 'selected' : ''}>30 ngày gần nhất</option>
                                <option value="90" ${paramPeriod eq '90' ? 'selected' : ''}>90 ngày gần nhất</option>
                                <option value="all" ${paramPeriod eq 'all' ? 'selected' : ''}>Tất cả</option>
                            </select>
                        </div>
                        <div class="wh-filter-group">
                            <label for="filterService">Dịch vụ</label>
                            <select name="serviceId" id="filterService">
                                <option value="">Tất cả dịch vụ</option>
                                <c:forEach var="s" items="${services}">
                                    <option value="${s.id}" ${paramServiceId eq s.id ? 'selected' : ''}><c:out value="${s.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="wh-filter-group">
                            <label for="filterVehicle">Phương tiện</label>
                            <select name="vehicleId" id="filterVehicle">
                                <option value="">Tất cả phương tiện</option>
                                <c:forEach var="v" items="${vehicles}">
                                    <option value="${v.id}" ${paramVehicleId eq v.id ? 'selected' : ''}><c:out value="${v.brand}"/> <c:out value="${v.model}"/> - <c:out value="${v.licensePlate}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="wh-filter-actions">
                        <button type="submit" class="wh-btn-apply">Áp dụng</button>
                        <a href="<c:url value='/wash-history'/>" class="wh-btn-reset">Đặt lại</a>
                    </div>
                </form>
            </div>

            <%-- Content Area --%>
            <c:choose>
                <%-- No history at all and no active filters --%>
                <c:when test="${pageResult.totalEntries == 0 && empty paramSearch && paramPeriod eq '30' && paramServiceId == null && paramVehicleId == null}">
                    <div class="wh-empty-state">
                        <span class="material-symbols-outlined wh-empty-icon">history</span>
                        <h3>Bạn chưa có lịch sử rửa xe.</h3>
                        <p>Các booking đã hoàn thành sẽ xuất hiện tại đây.</p>
                    </div>
                </c:when>

                <%-- No results matching current filters --%>
                <c:when test="${pageResult.totalEntries == 0}">
                    <div class="wh-empty-state">
                        <span class="material-symbols-outlined wh-empty-icon">search_off</span>
                        <h3>Không tìm thấy lịch sử phù hợp với điều kiện hiện tại.</h3>
                        <p>Hãy thử thay đổi bộ lọc hoặc từ khóa tìm kiếm.</p>
                        <a href="<c:url value='/wash-history'/>" class="wh-btn-apply">Đặt lại bộ lọc</a>
                    </div>
                </c:when>

                <%-- Results Table --%>
                <c:otherwise>
                    <div class="wh-table-wrapper">
                        <table class="wh-table" id="washHistoryTable">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Wash Date</th>
                                    <th>Vehicle</th>
                                    <th>Service</th>
                                    <th class="text-right">Amount Paid</th>
                                    <th class="text-right">Points</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="row" items="${pageResult.data}">
                                    <tr>
                                        <td>
                                            <span class="wh-booking-id">#BK-${row.bookingId}</span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${row.washDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <div class="wh-vehicle-cell">
                                                <c:choose>
                                                    <c:when test="${not empty row.vehicleImagePath && row.vehicleImagePath ne '/images/vehicles/car-default.svg'}">
                                                        <img src="<c:url value='${row.vehicleImagePath}'/>"
                                                             alt="${row.vehicleBrand} ${row.vehicleModel}"
                                                             class="wh-vehicle-img"
                                                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                                        <span class="wh-vehicle-icon-fallback" style="display:none;">
                                                            <span class="material-symbols-outlined">directions_car</span>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="wh-vehicle-icon-fallback">
                                                            <span class="material-symbols-outlined">directions_car</span>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="wh-vehicle-info">
                                                    <strong><c:out value="${row.vehicleBrand}"/> <c:out value="${row.vehicleModel}"/></strong>
                                                    <span><c:out value="${row.licensePlate}"/></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="wh-service-name"><c:out value="${row.serviceName}"/></span>
                                        </td>
                                        <td class="text-right">
                                            <span class="wh-amount"><fmt:formatNumber value="${row.amountPaid}" type="number" groupingUsed="true"/> ₫</span>
                                        </td>
                                        <td class="text-right">
                                            <span class="wh-points">+${row.pointsEarned}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <%-- Pagination --%>
                    <div class="wh-pagination">
                        <span class="wh-pagination-info">
                            Hiển thị ${pageResult.startEntry}–${pageResult.endEntry} trong tổng số ${pageResult.totalEntries} kết quả
                        </span>
                        <div class="wh-pagination-nav">
                            <%-- Previous --%>
                            <c:choose>
                                <c:when test="${pageResult.currentPage <= 1}">
                                    <span class="wh-page-btn disabled">‹</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="wh-page-btn"
                                       href="<c:url value='/wash-history'/>?search=${paramSearch}&period=${paramPeriod}&serviceId=${paramServiceId != null ? paramServiceId : ''}&vehicleId=${paramVehicleId != null ? paramVehicleId : ''}&page=${pageResult.currentPage - 1}">‹</a>
                                </c:otherwise>
                            </c:choose>

                            <%-- Page Numbers (show window of pages around current) --%>
                            <c:set var="windowStart" value="${pageResult.currentPage - 2 < 1 ? 1 : pageResult.currentPage - 2}"/>
                            <c:set var="windowEnd" value="${windowStart + 4 > pageResult.totalPages ? pageResult.totalPages : windowStart + 4}"/>
                            <c:if test="${windowEnd - windowStart < 4 && windowEnd - 4 > 0}">
                                <c:set var="windowStart" value="${windowEnd - 4}"/>
                            </c:if>
                            <c:if test="${windowStart < 1}">
                                <c:set var="windowStart" value="1"/>
                            </c:if>

                            <c:forEach var="p" begin="${windowStart}" end="${windowEnd}">
                                <c:choose>
                                    <c:when test="${p == pageResult.currentPage}">
                                        <span class="wh-page-btn active">${p}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="wh-page-btn"
                                           href="<c:url value='/wash-history'/>?search=${paramSearch}&period=${paramPeriod}&serviceId=${paramServiceId != null ? paramServiceId : ''}&vehicleId=${paramVehicleId != null ? paramVehicleId : ''}&page=${p}">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <%-- Next --%>
                            <c:choose>
                                <c:when test="${pageResult.currentPage >= pageResult.totalPages}">
                                    <span class="wh-page-btn disabled">›</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="wh-page-btn"
                                       href="<c:url value='/wash-history'/>?search=${paramSearch}&period=${paramPeriod}&serviceId=${paramServiceId != null ? paramServiceId : ''}&vehicleId=${paramVehicleId != null ? paramVehicleId : ''}&page=${pageResult.currentPage + 1}">›</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <script>
        function toggleFilter() {
            var panel = document.getElementById('filterPanel');
            panel.classList.toggle('show');
        }
    </script>
</body>
</html>
