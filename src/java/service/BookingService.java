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
import dto.BookingDTO;

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

    public int countByStatus(String status) {
        return bookingDAO.countByStatus(status);
    }

    public int countByPaymentStatus(String paymentStatus) {
        return bookingDAO.countByPaymentStatus(paymentStatus);
    }

    public double sumRevenue() {
        return bookingDAO.sumRevenue();
    }

    public int countTodayBookings() {
        return bookingDAO.countTodayBookings();
    }
    public PageResult<Booking> getBookingsPage(String search, String status, String date, String sortBy, int page, int pageSize) {
        if (page < 1) {
            page = 1;
        }
        int totalEntries = bookingDAO.countBookings(search, status, date);

        int totalPages = (int) Math.ceil((double) totalEntries / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * pageSize;
        if (offset < 0) {
            offset = 0;
        }

        List<Booking> data = bookingDAO.searchBookingsPaginated(search, status, date, sortBy, offset, pageSize);
        return new PageResult<>(data, page, pageSize, totalEntries);
    }

    public Booking getBookingById(int id) {
        return bookingDAO.findById(id);
    }


    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> bookings = bookingDAO.findByUser(userId);
        for (Booking booking : bookings) {
            applyCustomerActions(booking);
        }
        return bookings;
    }

    public boolean updateBookingStatus(int bookingId, String newStatus) {
        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null) {
            return false;
        }

        boolean updated = bookingDAO.updateStatus(bookingId, newStatus);
        if (updated && "COMPLETED".equals(newStatus) && "PAID".equals(booking.getPaymentStatus())) {
            Booking updatedBooking = bookingDAO.findById(bookingId);
            processLoyaltyUpgrade(updatedBooking);
        }
        return updated;
    }

    public int create(int userId, BookingDTO dto) {
        User user = userDAO.findById(userId);
        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            throw new IllegalArgumentException("Tài khoản customer không hợp lệ.");
        }

        Vehicle vehicle = vehicleDAO.findById(dto.getVehicleId());
        if (vehicle == null || vehicle.getUserId() != userId) {
            throw new IllegalArgumentException("Xe đã chọn không thuộc tài khoản của bạn.");
        }

        WashService washService = washServiceDAO.findActiveById(dto.getServiceId());
        if (washService == null) {
            throw new IllegalArgumentException("Dịch vụ đã chọn không còn khả dụng.");
        }

        LocalDate bookingDate = parseDate(dto.getBookingDate());
        int bookingWindowDays = getBookingWindowDays(user);
        LocalDateTime now = LocalDateTime.now();

        if (!isBookingDateAllowed(bookingDate, now.toLocalDate(), bookingWindowDays)) {
            throw new IllegalArgumentException("Ngày đặt lịch nằm ngoài thời hạn membership.");
        }

        if (!isValidStartTime(dto.getTime(), washService.getDurationMinutes())) {
            throw new IllegalArgumentException("Khung giờ đã chọn không hợp lệ.");
        }

        if (bookingDate.equals(now.toLocalDate()) && LocalTime.parse(dto.getTime(), TIME_FORMAT).isBefore(now.toLocalTime())) {
            throw new IllegalArgumentException("Không thể chọn khung giờ đã qua.");
        }

        String endTime = calculateEndTime(dto.getTime(), washService.getDurationMinutes());
        return bookingDAO.create(
                userId,
                dto.getVehicleId(),
                dto.getServiceId(),
                Date.valueOf(bookingDate),
                dto.getTime() + "-" + endTime,
                dto.getTime(),
                endTime,
                BigDecimal.valueOf(washService.getPrice()),
                MAX_CONCURRENT_BOOKINGS
        );
    }

    public BookingDTO prepareBookingFormContext(int customerId, String vehicleIdParam, String serviceIdParam, String bookingDate, String selectedTime) {
        User customer = userDAO.findById(customerId);
        if (customer == null || !"CUSTOMER".equals(customer.getRole())) {
            throw new IllegalArgumentException("Khách hàng không hợp lệ.");
        }

        List<Vehicle> vehicles = vehicleDAO.findByUserId(customerId);
        List<WashService> services = washServiceDAO.findAllActive();

        Integer selectedVehicleId = parsePositiveInt(vehicleIdParam);
        Integer selectedServiceId = parsePositiveInt(serviceIdParam);

        Vehicle selectedVehicle = findVehicleInList(vehicles, selectedVehicleId);
        WashService selectedService = findServiceInList(services, selectedServiceId);

        String trimmedDate = (bookingDate != null) ? bookingDate.trim() : null;
        String trimmedTime = (selectedTime != null) ? selectedTime.trim() : null;

        List<String> availableSlots = new ArrayList<>();
        if (selectedService != null && trimmedDate != null && !trimmedDate.isEmpty()) {
            try {
                availableSlots = getAvailableTimeSlots(customerId, selectedService.getId(), trimmedDate);
            } catch (Exception ignored) {
            }
        }

        int bookingWindowDays = getBookingWindowDays(customer);
        LocalDate today = LocalDate.now();

        return new BookingDTO(
                vehicles,
                services,
                selectedVehicleId,
                selectedServiceId,
                selectedVehicle,
                selectedService,
                trimmedDate,
                trimmedTime,
                availableSlots,
                bookingWindowDays,
                today.toString(),
                today.plusDays(bookingWindowDays).toString()
        );
    }


    public Booking getUpcomingBooking(int userId) {
        return bookingDAO.getUpcomingBooking(userId);
    }

    public List<Booking> getRecentWashHistory(int userId, int limit) {
        return bookingDAO.getRecentWashHistory(userId, limit);
    }

    public Booking getCustomerBooking(int bookingId, int userId) {
        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null || booking.getUserId() != userId) {
            return null;
        }
        applyCustomerActions(booking);
        return booking;
    }

    public boolean canCustomerCancel(Booking booking) {
        if (booking == null || !"UNPAID".equals(booking.getPaymentStatus())) {
            return false;
        }
        return "PENDING".equals(booking.getBookingStatus()) || "CONFIRMED".equals(booking.getBookingStatus());
    }

    public boolean canCustomerPay(Booking booking) {
        if (booking == null || !"UNPAID".equals(booking.getPaymentStatus())) {
            return false;
        }
        return "PENDING".equals(booking.getBookingStatus()) || "CONFIRMED".equals(booking.getBookingStatus());
    }

    public void cancel(int bookingId, int userId) {
        Booking booking = getCustomerBooking(bookingId, userId);
        if (booking == null) {
            throw new IllegalArgumentException("Booking không tồn tại hoặc không thuộc tài khoản của bạn.");
        }
        if (!canCustomerCancel(booking)) {
            throw new IllegalArgumentException("Booking này không còn được phép hủy.");
        }
        if (!bookingDAO.cancel(bookingId, userId)) {
            throw new IllegalArgumentException("Không thể hủy booking. Trạng thái có thể đã thay đổi.");
        }
    }

    public List<String> getAvailableTimeSlots(int userId, int serviceId, String bookingDateValue) {
        User user = userDAO.findById(userId);
        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            throw new IllegalArgumentException("Tài khoản customer không hợp lệ.");
        }

        WashService washService = washServiceDAO.findActiveById(serviceId);
        if (washService == null) {
            throw new IllegalArgumentException("Dịch vụ không tồn tại hoặc đã bị vô hiệu hóa.");
        }

        LocalDate bookingDate = parseDate(bookingDateValue);
        int bookingWindowDays = getBookingWindowDays(user);
        LocalDateTime now = LocalDateTime.now();

        if (!isBookingDateAllowed(bookingDate, now.toLocalDate(), bookingWindowDays)) {
            throw new IllegalArgumentException("Ngày đặt lịch nằm ngoài thời hạn membership.");
        }

        return getAvailableTimeSlots(bookingDate, washService.getDurationMinutes(), now);
    }


    public List<String> getAvailableTimeSlots(LocalDate bookingDate, int durationMinutes, LocalDateTime now) {
        List<String> available = new ArrayList<>();
        for (String startTime : generateTimeSlots(bookingDate, durationMinutes, now)) {
            if (hasCapacity(bookingDate, startTime, durationMinutes)) {
                available.add(startTime);
            }
        }
        return available;
    }

 
    public List<String> generateTimeSlots(LocalDate bookingDate, int durationMinutes, LocalDateTime now) {
        List<String> slots = new ArrayList<>();
        if (bookingDate == null || now == null || durationMinutes <= 0) {
            return slots;
        }

        LocalTime start = OPENING_TIME;
        while (!start.plusMinutes(durationMinutes).isAfter(CLOSING_TIME)) {
            boolean isToday = bookingDate.equals(now.toLocalDate());
            boolean isPassed = start.isBefore(now.toLocalTime());
            if (!isToday || !isPassed) {
                slots.add(start.format(TIME_FORMAT));
            }
            start = start.plusMinutes(SLOT_INTERVAL_MINUTES);
        }
        return slots;
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


    public String calculateEndTime(String startTime, int durationMinutes) {
        return LocalTime.parse(startTime, TIME_FORMAT).plusMinutes(durationMinutes).format(TIME_FORMAT);
    }


    private void applyCustomerActions(Booking booking) {
        booking.setCustomerCancellable(canCustomerCancel(booking));
        booking.setCustomerPayable(canCustomerPay(booking));
    }


    private void processLoyaltyUpgrade(Booking booking) {
        if (booking.getPointsEarned() > 0) {
            return;
        }
        User user = userDAO.findById(booking.getUserId());
        if (user == null) {
            return;
        }

        double multiplier = 1.0;
        if (user.getLoyaltyTier() != null) {
            multiplier = user.getLoyaltyTier().getPointMultiplier();
        }

        int pointsEarned = (int) ((booking.getTotalAmount() / 1000) * multiplier);
        bookingDAO.updatePointsEarned(booking.getId(), pointsEarned);
        userDAO.updateUserStatsAndTier(user.getId(), booking.getTotalAmount(), pointsEarned);
    }


    private boolean hasCapacity(LocalDate bookingDate, String startTime, int durationMinutes) {
        for (String interval : getCapacityIntervals(startTime, durationMinutes)) {
            String[] range = interval.split("-");
            int count = bookingDAO.countOverlappingBookings(Date.valueOf(bookingDate), range[0], range[1]);
            if (count >= MAX_CONCURRENT_BOOKINGS) {
                return false;
            }
        }
        return true;
    }


    private int getBookingWindowDays(User user) {
        return (user.getLoyaltyTier() == null) ? 7 : user.getLoyaltyTier().getBookingWindowDays();
    }


    private LocalDate parseDate(String dateStr) {
        try {
            return LocalDate.parse(dateStr);
        } catch (Exception e) {
            throw new IllegalArgumentException("Ngày đặt lịch không hợp lệ.");
        }
    }


    private Integer parsePositiveInt(String value) {
        try {
            int id = Integer.parseInt(value);
            return id > 0 ? id : null;
        } catch (Exception e) {
            return null;
        }
    }

 
    private Vehicle findVehicleInList(List<Vehicle> list, Integer id) {
        if (id == null || list == null) {
            return null;
        }
        for (Vehicle v : list) {
            if (v.getId() == id) {
                return v;
            }
        }
        return null;
    }

    
    private WashService findServiceInList(List<WashService> list, Integer id) {
        if (id == null || list == null) {
            return null;
        }
        for (WashService s : list) {
            if (s.getId() == id) {
                return s;
            }
        }
        return null;
    }
}
