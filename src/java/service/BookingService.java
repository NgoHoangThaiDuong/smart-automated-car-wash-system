package service;

import dao.BookingDAO;
import dao.UserDAO;
import dao.VehicleDAO;
import dao.WashServiceDAO;
import model.Booking;
import model.User;
import model.Vehicle;
import model.WashService;
import dto.PageResult;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

public class BookingService {

    private static final LocalTime OPENING_TIME = LocalTime.of(8, 0);
    private static final LocalTime CLOSING_TIME = LocalTime.of(18, 0);
    private static final int SLOT_INTERVAL_MINUTES = 30;
    private static final int MAX_CONCURRENT_BOOKINGS = 3;
    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm");

    private final BookingDAO bookingDAO = new BookingDAO();
    private final UserDAO userDAO = new UserDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final WashServiceDAO washServiceDAO = new WashServiceDAO();

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

    public List<Booking> getBookingsByUserId(int userId) {
        return bookingDAO.findByUserId(userId);
    }

    public boolean isBookingDateAllowed(LocalDate selectedDate, LocalDate today, int bookingWindowDays) {
        if (selectedDate == null || today == null || bookingWindowDays < 0) {
            return false;
        }
        return !selectedDate.isBefore(today) && !selectedDate.isAfter(today.plusDays(bookingWindowDays));
    }

    public boolean isValidStartTime(String startTime, int durationMinutes) {
        if (startTime == null || durationMinutes <= 0) {
            return false;
        }
        try {
            LocalTime start = LocalTime.parse(startTime, TIME_FORMAT);
            if (start.getMinute() % SLOT_INTERVAL_MINUTES != 0) {
                return false;
            }
            return !start.isBefore(OPENING_TIME) && !start.plusMinutes(durationMinutes).isAfter(CLOSING_TIME);
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    public List<String> generateTimeSlots(LocalDate bookingDate, int durationMinutes, LocalDateTime now) {
        List<String> slots = new ArrayList<>();
        if (bookingDate == null || now == null || durationMinutes <= 0) {
            return slots;
        }

        LocalTime start = OPENING_TIME;
        while (!start.plusMinutes(durationMinutes).isAfter(CLOSING_TIME)) {
            if (!bookingDate.equals(now.toLocalDate()) || !start.isBefore(now.toLocalTime())) {
                slots.add(start.format(TIME_FORMAT));
            }
            start = start.plusMinutes(SLOT_INTERVAL_MINUTES);
        }
        return slots;
    }

    public List<String> getAvailableTimeSlots(LocalDate bookingDate, int durationMinutes, LocalDateTime now) {
        List<String> available = new ArrayList<>();
        for (String startTime : generateTimeSlots(bookingDate, durationMinutes, now)) {
            boolean hasCapacity = true;
            for (String interval : getCapacityIntervals(startTime, durationMinutes)) {
                String[] range = interval.split("-");
                int currentBookings = bookingDAO.countOverlappingBookings(
                        Date.valueOf(bookingDate), range[0], range[1]);
                if (currentBookings >= MAX_CONCURRENT_BOOKINGS) {
                    hasCapacity = false;
                    break;
                }
            }
            if (hasCapacity) {
                available.add(startTime);
            }
        }
        return available;
    }

    public List<String> getCapacityIntervals(String startTime, int durationMinutes) {
        List<String> intervals = new ArrayList<>();
        if (!isValidStartTime(startTime, durationMinutes)) {
            return intervals;
        }

        LocalTime current = LocalTime.parse(startTime, TIME_FORMAT);
        LocalTime bookingEnd = current.plusMinutes(durationMinutes);
        while (current.isBefore(bookingEnd)) {
            LocalTime intervalEnd = current.plusMinutes(SLOT_INTERVAL_MINUTES);
            if (intervalEnd.isAfter(bookingEnd)) {
                intervalEnd = bookingEnd;
            }
            intervals.add(current.format(TIME_FORMAT) + "-" + intervalEnd.format(TIME_FORMAT));
            current = intervalEnd;
        }
        return intervals;
    }

    public int createCustomerBooking(int userId, int vehicleId, int serviceId,
            String bookingDateValue, String startTime) {
        User user = userDAO.findById(userId);
        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            throw new IllegalArgumentException("Tài khoản customer không hợp lệ.");
        }

        Vehicle vehicle = vehicleDAO.findById(vehicleId);
        if (vehicle == null || vehicle.getUserId() != userId) {
            throw new IllegalArgumentException("Xe đã chọn không thuộc tài khoản của bạn.");
        }

        WashService washService = washServiceDAO.findActiveById(serviceId);
        if (washService == null) {
            throw new IllegalArgumentException("Dịch vụ đã chọn không còn khả dụng.");
        }

        LocalDate bookingDate;
        try {
            bookingDate = LocalDate.parse(bookingDateValue);
        } catch (Exception e) {
            throw new IllegalArgumentException("Ngày đặt lịch không hợp lệ.");
        }

        int bookingWindowDays = user.getLoyaltyTier() == null
                ? 7 : user.getLoyaltyTier().getBookingWindowDays();
        LocalDateTime now = LocalDateTime.now();
        if (!isBookingDateAllowed(bookingDate, now.toLocalDate(), bookingWindowDays)) {
            throw new IllegalArgumentException("Ngày đặt lịch nằm ngoài thời hạn membership.");
        }
        if (!isValidStartTime(startTime, washService.getDurationMinutes())) {
            throw new IllegalArgumentException("Khung giờ đã chọn không hợp lệ.");
        }
        if (bookingDate.equals(now.toLocalDate())
                && LocalTime.parse(startTime, TIME_FORMAT).isBefore(now.toLocalTime())) {
            throw new IllegalArgumentException("Không thể chọn khung giờ đã qua.");
        }

        String endTime = calculateEndTime(startTime, washService.getDurationMinutes());
        return bookingDAO.createBookingWithAvailabilityCheck(
                userId,
                vehicleId,
                serviceId,
                Date.valueOf(bookingDate),
                startTime + "-" + endTime,
                startTime,
                endTime,
                BigDecimal.valueOf(washService.getPrice()),
                MAX_CONCURRENT_BOOKINGS
        );
    }

    public String calculateEndTime(String startTime, int durationMinutes) {
        return LocalTime.parse(startTime, TIME_FORMAT)
                .plusMinutes(durationMinutes)
                .format(TIME_FORMAT);
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
