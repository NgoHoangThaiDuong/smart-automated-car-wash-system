package service;

import dao.BookingDAO;
import model.Booking;

import java.util.List;

public class BookingService {

    private final BookingDAO bookingDAO = new BookingDAO();

    public List<Booking> getAllBookings(String search, String status, String date) {
        return bookingDAO.findByFilter(search, status, date);
    }

    public Booking getBookingById(int id) {
        return bookingDAO.findById(id);
    }

    public void updateBookingStatus(int bookingId, String newStatus) {
        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null) {
            throw new IllegalArgumentException("Booking không tồn tại: " + bookingId);
        }
        validateTransition(booking.getBookingStatus(), newStatus);
        if ("COMPLETED".equals(newStatus)) {
            completeBooking(booking);
        } else {
            bookingDAO.updateStatus(bookingId, newStatus);
        }
    }

    private void validateTransition(String current, String next) {
        switch (current) {
            case "CONFIRMED":
                if ("IN_PROGRESS".equals(next) || "CANCELLED".equals(next) || "NO_SHOW".equals(next)) return;
                break;
            case "IN_PROGRESS":
                if ("COMPLETED".equals(next) || "CANCELLED".equals(next) || "NO_SHOW".equals(next)) return;
                break;
            default:
                break;
        }
        throw new IllegalArgumentException("Không thể chuyển trạng thái từ " + current + " sang " + next);
    }

    private void completeBooking(Booking booking) {
        if (!"PAID".equals(booking.getPaymentStatus())) {
            throw new IllegalArgumentException("Không thể hoàn thành booking chưa thanh toán");
        }
        bookingDAO.updateStatusCompleted(booking.getId());
    }

    public int countByStatus(String status) {
        return bookingDAO.countByStatus(status);
    }

    public double sumRevenue() {
        return bookingDAO.sumRevenue();
    }

    public int countTodayBookings() {
        return bookingDAO.countTodayBookings();
    }
}
