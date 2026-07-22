package service;

import dao.PaymentDAO;
import dao.BookingDAO;
import dao.UserDAO;
import model.Booking;
import model.Payment;
import model.PaymentDetail;
import model.User;

public class PaymentService {

    private PaymentDAO paymentDAO = new PaymentDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    private UserDAO userDAO = new UserDAO();

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

        processLoyaltyUpgrade(bookingId);
    }

    public void processLoyaltyUpgrade(int bookingId) {
        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null) return;

        if (!"COMPLETED".equalsIgnoreCase(booking.getBookingStatus())) return;
        if (!"PAID".equalsIgnoreCase(booking.getPaymentStatus())) return;
        if (booking.getPointsEarned() > 0) return;

        User user = userDAO.findById(booking.getUserId());
        if (user == null) return;

        double multiplier = (user.getLoyaltyTier() != null)
                ? user.getLoyaltyTier().getPointMultiplier() : 1.0;

        int pointsEarned = (int) ((booking.getTotalAmount() / 1000) * multiplier);
        bookingDAO.updatePointsEarned(booking.getId(), pointsEarned);
        userDAO.updateUserStatsAndTier(user.getId(), booking.getTotalAmount(), pointsEarned);
    }
}
