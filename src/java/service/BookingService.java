package service;

import dao.BookingDAO;
import dao.UserDAO;
import model.Booking;
import dto.PageResult;

import java.util.List;

public class BookingService {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final UserDAO userDAO = new UserDAO();

    public List<Booking> getAllBookings(String search, String status, String date) {
        return bookingDAO.searchBookings(search, status, date);
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
        if ("COMPLETED".equals(newStatus) && !"PAID".equals(booking.getPaymentStatus())) {
            throw new IllegalArgumentException("Không thể hoàn thành booking chưa thanh toán");
        }
        bookingDAO.updateStatus(bookingId, newStatus);
        
        if ("COMPLETED".equals(newStatus) && "PAID".equals(booking.getPaymentStatus())) {
            Booking updatedBooking = bookingDAO.findById(bookingId);
            processLoyaltyUpgrade(updatedBooking);
        }
    }

    public void collectPayment(int bookingId, String paymentMethod) {
        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null) {
            throw new IllegalArgumentException("Booking không tồn tại: " + bookingId);
        }
        if ("PAID".equals(booking.getPaymentStatus())) {
            return;
        }
        bookingDAO.updatePaymentStatus(bookingId, "PAID", paymentMethod);
        
        if ("COMPLETED".equals(booking.getBookingStatus())) {
            Booking updatedBooking = bookingDAO.findById(bookingId);
            processLoyaltyUpgrade(updatedBooking);
        }
    }

    private void processLoyaltyUpgrade(Booking booking) {
        if (booking.getPointsEarned() > 0) {
            return;
        }
        model.User user = userDAO.findById(booking.getUserId());
        if (user == null) return;
        
        double multiplier = 1.0;
        if (user.getLoyaltyTier() != null) {
            multiplier = user.getLoyaltyTier().getPointMultiplier();
        }
        
        int pointsEarned = (int) ((booking.getTotalAmount() / 1000) * multiplier);
        bookingDAO.updatePointsEarned(booking.getId(), pointsEarned);
        userDAO.updateUserStatsAndTier(user.getId(), booking.getTotalAmount(), pointsEarned);
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

    public int countByStatus(String status) {
        return bookingDAO.countByStatus(status);
    }

    public double sumRevenue() {
        return bookingDAO.sumRevenue();
    }

    public int countTodayBookings() {
        return bookingDAO.countTodayBookings();
    }

    public Booking getUpcomingBookingByUserId(int userId) {
        return bookingDAO.getUpcomingBookingByUserId(userId);
    }

    public List<Booking> getRecentWashHistoryByUserId(int userId, int limit) {
        return bookingDAO.getRecentWashHistoryByUserId(userId, limit);
    }

    public PageResult<Booking> getBookingsPage(String search, String status, String date, int page, int pageSize) {
        if (page < 1) page = 1;
        int totalEntries = bookingDAO.countBookings(search, status, date);
        
        int totalPages = (int) Math.ceil((double) totalEntries / pageSize);
        if (totalPages == 0) totalPages = 1;
        
        if (page > totalPages) page = totalPages;
        
        int offset = (page - 1) * pageSize;
        if (offset < 0) offset = 0;
        
        List<Booking> data = bookingDAO.searchBookingsPaginated(search, status, date, offset, pageSize);
        return new PageResult<>(data, page, pageSize, totalEntries);
    }
}
