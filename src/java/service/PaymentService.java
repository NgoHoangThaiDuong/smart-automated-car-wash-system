package service;

import dao.PaymentDAO;
import model.Payment;
import model.PaymentDetail;

public class PaymentService {

    private PaymentDAO paymentDAO = new PaymentDAO();

    public PaymentDetail getPaymentDetail(int bookingId) {
        return paymentDAO.getPaymentDetail(bookingId);
    }

    public Payment getPaymentByBookingId(int bookingId) {
        return paymentDAO.getPaymentByBookingId(bookingId);
    }

    public void processPayment(int bookingId, String paymentMethod) {
        Payment payment = paymentDAO.getPaymentByBookingId(bookingId);

        if (payment == null) {
            throw new IllegalArgumentException("Không tìm thấy thông tin thanh toán.");
        }

        if (Payment.PAID.equalsIgnoreCase(payment.getPaymentStatus())) {
            throw new IllegalArgumentException("Booking đã được thanh toán.");
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn phương thức thanh toán.");
        }

        boolean success = paymentDAO.updatePayment(bookingId, paymentMethod);

        if (!success) {
            throw new RuntimeException("Thanh toán thất bại.");
        }
    }
}
