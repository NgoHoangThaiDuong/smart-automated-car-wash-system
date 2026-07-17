<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Quản lý khuyến mãi</title>

        <style>
            body {
                margin: 0;
                padding: 30px;
                font-family: Arial, sans-serif;
                background: #f4f6f9;
            }

            .container {
                max-width: 1250px;
                margin: 0 auto;
                background: #ffffff;
                padding: 24px;
                border-radius: 14px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            }

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 22px;
            }

            h1 {
                margin: 0;
                color: #1e293b;
            }

            .back-link {
                text-decoration: none;
                background: #64748b;
                color: white;
                padding: 10px 16px;
                border-radius: 8px;
            }

            .alert {
                padding: 12px 16px;
                margin-bottom: 18px;
                border-radius: 8px;
            }

            .alert-success {
                color: #166534;
                background: #dcfce7;
                border: 1px solid #86efac;
            }

            .alert-error {
                color: #991b1b;
                background: #fee2e2;
                border: 1px solid #fca5a5;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th,
            td {
                padding: 12px 10px;
                border-bottom: 1px solid #e2e8f0;
                text-align: left;
                vertical-align: middle;
            }

            th {
                background: #0f172a;
                color: white;
                font-size: 14px;
            }

            tr:hover {
                background: #f8fafc;
            }

            .promotion-name {
                font-weight: bold;
                color: #1e293b;
            }

            .description {
                color: #64748b;
                font-size: 13px;
                margin-top: 4px;
            }

            .badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
            }

            .badge-active {
                color: #166534;
                background: #dcfce7;
            }

            .badge-inactive {
                color: #991b1b;
                background: #fee2e2;
            }

            .btn {
                display: inline-block;
                padding: 8px 12px;
                border: none;
                border-radius: 7px;
                font-size: 14px;
                cursor: pointer;
                text-decoration: none;
            }

            .btn-edit {
                background: #2563eb;
                color: white;
            }

            .btn-delete {
                background: #dc2626;
                color: white;
            }

            .delete-form {
                display: inline;
            }

            .empty-row {
                text-align: center;
                color: #64748b;
                padding: 30px;
            }
        </style>
    </head>

    <body>
        <c:set var="activePage" value="promotions" scope="request"/>
        <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>
        <div class="container">

            <div class="page-header">
                <div>
                    <h1>Quản lý khuyến mãi</h1>
                    <p>Danh sách khuyến mãi đang có trong hệ thống</p>
                </div>

                <a class="btn btn-create"
                   href="${pageContext.request.contextPath}/admin/promotions/new">
                    + Thêm khuyến mãi
                </a>

                <a class="back-link"
                   href="${pageContext.request.contextPath}/admin">
                    Quay lại Dashboard
                </a>
            </div>

            <c:if test="${not empty promotionMessage}">
                <div class="alert alert-success">
                    <c:out value="${promotionMessage}"/>
                </div>
            </c:if>

            <c:if test="${not empty promotionError}">
                <div class="alert alert-error">
                    <c:out value="${promotionError}"/>
                </div>
            </c:if>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khuyến mãi</th>
                        <th>Loại giảm</th>
                        <th>Giá trị</th>
                        <th>Tier áp dụng</th>
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>

                <tbody>

                    <c:forEach var="promotion"
                               items="${promotions}">

                        <tr>
                            <td>${promotion.id}</td>

                            <td>
                                <div class="promotion-name">
                                    <c:out value="${promotion.promotionName}"/>
                                </div>

                                <div class="description">
                                    <c:out value="${promotion.description}"/>
                                </div>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${promotion.discountType == 'PERCENT'}">
                                        Phần trăm
                                    </c:when>

                                    <c:otherwise>
                                        Số tiền
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${promotion.discountType == 'PERCENT'}">
                                        <fmt:formatNumber
                                            value="${promotion.discountValue}"
                                            maxFractionDigits="2"/>
                                        %
                                    </c:when>

                                    <c:otherwise>
                                        <fmt:formatNumber
                                            value="${promotion.discountValue}"
                                            type="number"/>
                                        VNĐ
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${empty promotion.targetTierId}">
                                        Tất cả
                                    </c:when>

                                    <c:otherwise>
                                        <c:out value="${promotion.targetTierName}"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <div>${promotion.startDate}</div>
                                <div>đến</div>
                                <div>${promotion.endDate}</div>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${promotion.status == 'ACTIVE'}">
                                        <span class="badge badge-active">
                                            Đang hoạt động
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge badge-inactive">
                                            Ngừng hoạt động
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <a class="btn btn-edit"
                                   href="${pageContext.request.contextPath}/admin/promotions/edit?id=${promotion.id}">
                                    Sửa
                                </a>

                                <form class="delete-form"
                                      action="${pageContext.request.contextPath}/admin/promotions/delete"
                                      method="post"
                                      onsubmit="return confirm('Bạn có chắc muốn xóa khuyến mãi này không?');">

                                    <input type="hidden"
                                           name="id"
                                           value="${promotion.id}">

                                    <button type="submit"
                                            class="btn btn-delete">
                                        Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>

                    </c:forEach>

                    <c:if test="${empty promotions}">
                        <tr>
                            <td colspan="8"
                                class="empty-row">
                                Chưa có khuyến mãi nào.
                            </td>
                        </tr>
                    </c:if>

                </tbody>
            </table>

        </div>

    </body>
</html>