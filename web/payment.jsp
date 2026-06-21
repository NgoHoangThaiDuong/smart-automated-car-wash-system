<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Checkout</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f7f8fc;
            color: #111827;
        }

        .container {
            width: 760px;
            margin: 60px auto;
        }

        .title {
            text-align: center;
            margin-bottom: 35px;
        }

        .title h1 {
            font-size: 34px;
            margin-bottom: 10px;
        }

        .title p {
            color: #555;
        }

        .card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .booking-title {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 25px;
        }

        .divider {
            border-top: 1px solid #e5e7eb;
            margin: 24px 0;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            gap: 80px;
        }

        .info-box {
            width: 50%;
        }

        .label {
            font-size: 13px;
            font-weight: bold;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .value {
            font-size: 18px;
            margin-bottom: 6px;
        }

        .sub {
            color: #0b3f9c;
            font-size: 15px;
        }

        .service-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .service-name {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .time {
            color: #444;
        }

        .amount {
            font-size: 34px;
            font-weight: bold;
            color: #0b47c5;
        }

        .payment-title {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 18px;
        }

        .method-option {
            display: block;
            border: 1px solid #d1d5db;
            border-radius: 12px;
            padding: 18px;
            margin-bottom: 14px;
            font-size: 18px;
            cursor: pointer;
        }

        .method-option input {
            margin-right: 14px;
            transform: scale(1.25);
        }

        .btn {
            width: 100%;
            margin-top: 28px;
            padding: 17px;
            background: #073fc0;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 17px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn:hover {
            background: #0033a0;
        }

        .success {
            text-align: center;
            color: green;
            font-size: 24px;
            font-weight: bold;
            margin-top: 30px;
        }

        .error {
            background: #ffe5e5;
            color: red;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid red;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>

<div class="container">

    <div class="title">
        <h1>Payment Checkout</h1>
        <p>Review booking information and select a payment method.</p>
    </div>

    <div class="card">

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <div class="booking-title">
            Booking #SW-${detail.bookingId}
        </div>

        <div class="divider"></div>

        <div class="info-row">
            <div class="info-box">
                <div class="label">Customer</div>
                <div class="value">${detail.customerName}</div>
                <div class="sub">Gold Tier</div>
            </div>

            <div class="info-box">
                <div class="label">Vehicle</div>
                <div class="value">${detail.vehicleBrand} ${detail.vehicleModel}</div>
                <div>${detail.licensePlate}</div>
            </div>
        </div>

        <div class="divider"></div>

        <div class="service-row">
            <div>
                <div class="service-name">${detail.serviceName}</div>
                <div class="time">⏱ ${detail.timeSlot}</div>
            </div>

            <div class="amount">
                ${detail.amount} đ
            </div>
        </div>

        <div class="divider"></div>

        <c:if test="${payment.paymentStatus eq 'UNPAID'}">
            <div class="payment-title">Payment Method</div>

            <form action="${pageContext.request.contextPath}/PaymentServlet" method="post">
                <input type="hidden" name="bookingId" value="${detail.bookingId}">

                <label class="method-option">
                    <input type="radio" name="paymentMethod" value="CASH" checked>
                    Cash
                </label>

                <label class="method-option">
                    <input type="radio" name="paymentMethod" value="BANK_TRANSFER">
                    Banking
                </label>

                <button class="btn" type="submit">
                    Confirm Payment
                </button>
            </form>
        </c:if>

        <c:if test="${payment.paymentStatus eq 'PAID'}">
            <div class="success">
                ✔ Payment Successful
                <br><br>
                Payment Method : ${payment.paymentMethod}
            </div>
        </c:if>

    </div>
</div>

</body>
</html>