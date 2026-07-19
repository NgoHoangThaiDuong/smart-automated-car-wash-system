<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Lịch Đặt - Smart Car Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/typography.css'/>">
    <style>
        :root {
            --primary: #0b4dcc;
            --primary-hover: #083da3;
            --primary-light: #e8f0ff;
            --success: #10b981;
            --success-light: #ecfdf5;
            --error: #ef4444;
            --error-light: #fef2f2;
            --bg-gray: #f8fafc;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
        }

        body {
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-gray);
            color: var(--text-dark);
            -webkit-font-smoothing: antialiased;
        }

        .payment-container {
            max-width: 900px;
            margin: 60px auto 100px;
            padding: 0 24px;
        }

        .payment-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .payment-header h1 {
            font-size: 32px;
            font-weight: 800;
            margin: 0 0 10px;
            letter-spacing: -0.025em;
        }

        .payment-header p {
            color: var(--text-muted);
            font-size: 16px;
            margin: 0;
        }

        .bento-grid {
            display: grid;
            grid-template-columns: 1.25fr 1fr;
            gap: 28px;
        }

        @media (max-width: 768px) {
            .bento-grid {
                grid-template-columns: 1fr;
            }
        }

        .payment-card {
            background-color: #fff;
            border: 1px solid var(--border-color);
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            padding: 32px;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .card-full {
            grid-column: 1 / -1;
        }

        .payment-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, var(--primary), #4f46e5);
        }

        .booking-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 14px;
            background-color: var(--primary-light);
            color: var(--primary);
            font-weight: 800;
            font-size: 13px;
            border-radius: 30px;
            margin-bottom: 20px;
            width: fit-content;
        }

        .invoice-title {
            font-size: 24px;
            font-weight: 800;
            margin: 0 0 8px;
            letter-spacing: -0.02em;
        }

        .invoice-subtitle {
            font-size: 14px;
            color: var(--text-muted);
            margin: 0 0 24px;
        }

        .divider {
            height: 1px;
            background-color: var(--border-color);
            margin: 24px 0;
        }

        .info-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .info-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .info-value {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .tier-badge {
            display: inline-flex;
            align-items: center;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            width: fit-content;
            margin-top: 4px;
        }

        .tier-GOLD { background-color: #fef3c7; color: #d97706; }
        .tier-SILVER { background-color: #f1f5f9; color: #475569; }
        .tier-PLATINUM { background-color: #e0f2fe; color: #0369a1; }
        .tier-REGULAR { background-color: #f3f4f6; color: #1f2937; }

        .service-details {
            background-color: #f8fafc;
            border-radius: 16px;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid var(--border-color);
            margin-top: auto;
        }

        .service-info {
            flex: 1;
            min-width: 0;
            margin-right: 16px;
        }

        .service-info h4 {
            margin: 0 0 6px;
            font-size: 18px;
            font-weight: 700;
        }

        .service-info p {
            margin: 0;
            font-size: 14px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .price-tag {
            font-size: 26px;
            font-weight: 800;
            color: var(--primary);
            white-space: nowrap;
            flex-shrink: 0;
        }

        /* Form styling */
        .payment-methods-title {
            font-size: 18px;
            font-weight: 700;
            margin: 0 0 16px;
        }

        .method-options {
            display: grid;
            gap: 14px;
        }

        .method-card {
            border: 2px solid var(--border-color);
            border-radius: 14px;
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 16px;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
        }

        .method-card:hover {
            border-color: var(--primary);
            background-color: #fafafa;
        }

        .method-card input[type="radio"] {
            margin: 0;
            width: 20px;
            height: 20px;
            accent-color: var(--primary);
            cursor: pointer;
        }

        .method-card.selected {
            border-color: var(--primary);
            background-color: var(--primary-light);
        }

        .method-icon {
            font-size: 24px;
        }

        .method-text {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .method-name {
            font-size: 16px;
            font-weight: 700;
        }

        .method-desc {
            font-size: 13px;
            color: var(--text-muted);
        }

        .submit-btn {
            width: 100%;
            padding: 16px;
            background-color: var(--primary);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 6px -1px rgba(11, 77, 204, 0.2);
            margin-top: 24px;
        }

        .submit-btn:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .submit-btn:active {
            transform: translateY(1px);
        }

        /* Success screen styling */
        .success-screen {
            text-align: center;
            padding: 24px 0;
        }

        .success-icon-wrapper {
            width: 80px;
            height: 80px;
            background-color: var(--success-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            color: var(--success);
            font-size: 40px;
            animation: pulse-success 2s infinite;
        }

        @keyframes pulse-success {
            0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.4); }
            70% { box-shadow: 0 0 0 15px rgba(16, 185, 129, 0); }
            100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); }
        }

        .success-title {
            font-size: 28px;
            font-weight: 800;
            margin: 0 0 8px;
            color: var(--success);
        }

        .success-desc {
            font-size: 15px;
            color: var(--text-muted);
            margin: 0 0 32px;
        }

        .receipt-table {
            width: 100%;
            background-color: #f8fafc;
            border-radius: 16px;
            padding: 20px;
            border: 1px dashed var(--border-color);
            margin-bottom: 32px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            box-sizing: border-box;
        }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
        }

        .receipt-label {
            color: var(--text-muted);
        }

        .receipt-value {
            font-weight: 600;
            text-align: right;
            white-space: nowrap;
        }

        .receipt-total {
            font-size: 18px;
            font-weight: 800;
            color: var(--primary);
            border-top: 1px dashed var(--border-color);
            padding-top: 12px;
            margin-top: 4px;
        }

        .action-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
        }

        .btn {
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 700;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary {
            background-color: var(--primary);
            color: #fff;
            border: none;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
        }

        .btn-secondary {
            background-color: #fff;
            color: var(--text-dark);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background-color: #f1f5f9;
        }

        /* Alert Box */
        .alert {
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-error {
            background-color: var(--error-light);
            color: var(--error);
            border: 1px solid #fee2e2;
        }

        .alert-success {
            background-color: var(--success-light);
            color: var(--success);
            border: 1px solid #d1fae5;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/navbar.jsp"/>

    <main class="payment-container">
        <div class="payment-header">
            <h1>Thông Tin Thanh Toán</h1>
            <p>Vui lòng kiểm tra chi tiết hóa đơn dịch vụ rửa xe của bạn.</p>
        </div>

        <c:if test="${not empty paymentError}">
            <div class="alert alert-error">
                <span>⚠️</span>
                <div>${paymentError}</div>
            </div>
        </c:if>

        <c:if test="${not empty paymentMessage}">
            <div class="alert alert-success">
                <span>✓</span>
                <div>${paymentMessage}</div>
            </div>
        </c:if>

        <div class="bento-grid">
            
            <c:choose>
                <c:when test="${payment.paymentStatus eq 'PAID'}">
                    <!-- Màn hình thanh toán thành công -->
                    <div class="payment-card card-full">
                        <div class="success-screen">
                            <div class="success-icon-wrapper">
                                ✓
                            </div>
                            <h2 class="success-title">Thanh Toán Thành Công</h2>
                            <p class="success-desc">Cảm ơn bạn đã sử dụng dịch vụ tại Smart Car Wash!</p>
                            
                            <div class="receipt-table">
                                <div class="receipt-row">
                                    <span class="receipt-label">Mã lịch đặt (Booking ID)</span>
                                    <span class="receipt-value">#SW-${detail.bookingId}</span>
                                </div>
                                <div class="receipt-row">
                                    <span class="receipt-label">Khách hàng</span>
                                    <span class="receipt-value">${detail.customerName}</span>
                                </div>
                                <div class="receipt-row">
                                    <span class="receipt-label">Phương tiện</span>
                                    <span class="receipt-value">${detail.vehicleBrand} ${detail.vehicleModel} (${detail.licensePlate})</span>
                                </div>
                                <div class="receipt-row">
                                    <span class="receipt-label">Dịch vụ</span>
                                    <span class="receipt-value">${detail.serviceName}</span>
                                </div>
                                <div class="receipt-row">
                                    <span class="receipt-label">Thời gian</span>
                                    <span class="receipt-value">${detail.timeSlot}</span>
                                </div>
                                <div class="receipt-row">
                                    <span class="receipt-label">Phương thức thanh toán</span>
                                    <span class="receipt-value">
                                        <c:choose>
                                            <c:when test="${payment.paymentMethod eq 'CASH'}">Tiền mặt tại quầy</c:when>
                                            <c:when test="${payment.paymentMethod eq 'BANK_TRANSFER'}">Chuyển khoản Banking</c:when>
                                            <c:otherwise>${payment.paymentMethod}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="receipt-row receipt-total">
                                    <span class="receipt-label">Tổng tiền đã thanh toán</span>
                                    <span class="receipt-value">
                                        <fmt:formatNumber value="${detail.amount}" type="number" groupingUsed="true"/> đ
                                    </span>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">Bảng Điều Khiển</a>
                                <a href="${pageContext.request.contextPath}/booking" class="btn btn-secondary">Xem Lịch Đặt</a>
                            </div>
                        </div>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <!-- Màn hình thực hiện thanh toán -->
                    <div class="payment-card">
                        <div class="booking-badge">MÃ LỊCH ĐẶT #SW-${detail.bookingId}</div>
                        <h2 class="invoice-title">Chi Tiết Hóa Đơn</h2>
                        <p class="invoice-subtitle">Chi tiết dịch vụ và thông tin xe đăng ký.</p>
                        
                        <div class="info-group">
                            <div class="info-item">
                                <span class="info-label">Khách hàng</span>
                                <span class="info-value">${detail.customerName}</span>
                                <span class="tier-badge tier-${currentUser.loyaltyTier.name}">
                                    ${currentUser.loyaltyTier.name} Member
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Phương tiện</span>
                                <span class="info-value">${detail.vehicleBrand} ${detail.vehicleModel}</span>
                                <span style="font-size: 13px; color: var(--text-muted); font-weight: 500;">
                                    Biển số: ${detail.licensePlate}
                                </span>
                            </div>
                        </div>
                        
                        <div class="divider"></div>
                        
                        <div class="service-details">
                            <div class="service-info">
                                <h4>${detail.serviceName}</h4>
                                <p>
                                    <span>⏱</span> ${detail.timeSlot}
                                </p>
                            </div>
                            <div class="price-tag">
                                <fmt:formatNumber value="${detail.amount}" type="number" groupingUsed="true"/> đ
                            </div>
                        </div>
                    </div>
                    
                    <div class="payment-card">
                        <h2 class="invoice-title">Thanh Toán</h2>
                        <p class="invoice-subtitle">Vui lòng chọn hình thức thanh toán thuận tiện.</p>
                        
                        <form action="${pageContext.request.contextPath}/payment" method="post">
                            <input type="hidden" name="bookingId" value="${detail.bookingId}">
                            
                            <div class="method-options">
                                <label class="method-card selected" id="label-cash">
                                    <input type="radio" name="paymentMethod" value="CASH" checked onclick="selectMethod('CASH')">
                                    <span class="method-icon">💵</span>
                                    <span class="method-text">
                                        <span class="method-name">Tiền mặt tại quầy</span>
                                        <span class="method-desc">Thanh toán trực tiếp sau khi rửa xe xong</span>
                                    </span>
                                </label>
                                
                                <label class="method-card" id="label-banking">
                                    <input type="radio" name="paymentMethod" value="BANK_TRANSFER" onclick="selectMethod('BANK_TRANSFER')">
                                    <span class="method-icon">🏦</span>
                                    <span class="method-text">
                                        <span class="method-name">Chuyển khoản Banking</span>
                                        <span class="method-desc">Quét mã QR hoặc chuyển khoản nhanh</span>
                                    </span>
                                </label>
                            </div>
                            
                            <button class="submit-btn" type="submit">
                                Xác Nhận Thanh Toán
                            </button>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
            
        </div>
    </main>

    <script>
        function selectMethod(method) {
            const labelCash = document.getElementById('label-cash');
            const labelBanking = document.getElementById('label-banking');
            
            if (method === 'CASH') {
                labelCash.classList.add('selected');
                labelBanking.classList.remove('selected');
            } else {
                labelBanking.classList.add('selected');
                labelCash.classList.remove('selected');
            }
        }
    </script>
</body>
</html>
