<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Sửa khuyến mãi</title>

    <style>
        body {
            margin: 0;
            padding: 30px;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .container {
            max-width: 750px;
            margin: 0 auto;
            background: white;
            padding: 28px;
            border-radius: 14px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }

        h1 {
            margin-top: 0;
            color: #1e293b;
        }

        .alert-error {
            color: #991b1b;
            background: #fee2e2;
            border: 1px solid #fca5a5;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 18px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
            color: #334155;
        }

        input,
        textarea,
        select {
            width: 100%;
            padding: 11px 12px;
            box-sizing: border-box;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
        }

        input:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        textarea {
            min-height: 110px;
            resize: vertical;
        }

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 24px;
        }

        .btn {
            border: none;
            padding: 11px 18px;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-size: 15px;
        }

        .btn-save {
            color: white;
            background: #16a34a;
        }

        .btn-back {
            color: white;
            background: #64748b;
        }
    </style>
</head>

<body>
 <c:set var="activePage" value="promotions" scope="request"/>
<jsp:include page="/WEB-INF/view/common/navbar.jsp"/>
<div class="container">

    <h1>Sửa khuyến mãi</h1>

    <c:if test="${not empty promotionError}">
        <div class="alert-error">
            <c:out value="${promotionError}"/>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/promotions/update"
          method="post">

        <input type="hidden"
               name="id"
               value="${promotion.id}">

        <div class="form-group">
            <label for="promotionName">
                Tên khuyến mãi
            </label>

            <input type="text"
                   id="promotionName"
                   name="promotionName"
                   value="<c:out value='${promotion.promotionName}'/>"
                   maxlength="150"
                   required>
        </div>

        <div class="form-group">
            <label for="description">
                Mô tả
            </label>

            <textarea id="description"
                      name="description"
                      maxlength="500"><c:out value="${promotion.description}"/></textarea>
        </div>

        <div class="form-group">
            <label for="discountType">
                Loại giảm giá
            </label>

            <select id="discountType"
                    name="discountType"
                    required>

                <option value="PERCENT"
                        ${promotion.discountType == 'PERCENT'
                            ? 'selected' : ''}>
                    Giảm theo phần trăm
                </option>

                <option value="FIXED"
                        ${promotion.discountType == 'FIXED'
                            ? 'selected' : ''}>
                    Giảm theo số tiền
                </option>
            </select>
        </div>

        <div class="form-group">
            <label for="discountValue">
                Giá trị giảm
            </label>

            <input type="number"
                   id="discountValue"
                   name="discountValue"
                   value="${promotion.discountValue}"
                   min="0.01"
                   step="0.01"
                   required>
        </div>

        <div class="form-group">
            <label for="targetTierId">
                Tier áp dụng
            </label>

            <select id="targetTierId"
                    name="targetTierId">

                <option value=""
                        ${empty promotion.targetTierId
                            ? 'selected' : ''}>
                    Tất cả khách hàng
                </option>

                <option value="1"
                        ${promotion.targetTierId == 1
                            ? 'selected' : ''}>
                    Member
                </option>

                <option value="2"
                        ${promotion.targetTierId == 2
                            ? 'selected' : ''}>
                    Silver
                </option>

                <option value="3"
                        ${promotion.targetTierId == 3
                            ? 'selected' : ''}>
                    Gold
                </option>

                <option value="4"
                        ${promotion.targetTierId == 4
                            ? 'selected' : ''}>
                    Platinum
                </option>
            </select>
        </div>

        <div class="form-group">
            <label for="startDate">
                Ngày bắt đầu
            </label>

            <input type="date"
                   id="startDate"
                   name="startDate"
                   value="${promotion.startDate}"
                   required>
        </div>

        <div class="form-group">
            <label for="endDate">
                Ngày kết thúc
            </label>

            <input type="date"
                   id="endDate"
                   name="endDate"
                   value="${promotion.endDate}"
                   required>
        </div>

        <div class="form-group">
            <label for="status">
                Trạng thái
            </label>

            <select id="status"
                    name="status"
                    required>

                <option value="ACTIVE"
                        ${promotion.status == 'ACTIVE'
                            ? 'selected' : ''}>
                    Đang hoạt động
                </option>

                <option value="INACTIVE"
                        ${promotion.status == 'INACTIVE'
                            ? 'selected' : ''}>
                    Ngừng hoạt động
                </option>
            </select>
        </div>

        <div class="actions">
            <button type="submit"
                    class="btn btn-save">
                Lưu thay đổi
            </button>

            <a class="btn btn-back"
               href="${pageContext.request.contextPath}/admin/promotions">
                Quay lại
            </a>
        </div>

    </form>

</div>

</body>
</html>