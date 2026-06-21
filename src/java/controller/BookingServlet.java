package controller;

import model.Booking;
import model.User;
import model.Vehicle;
import model.WashService;
import service.BookingService;
import service.UserService;
import service.VehicleService;
import service.WashServiceService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

@WebServlet({"/booking", "/booking/*"})
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final VehicleService vehicleService = new VehicleService();
    private final WashServiceService washServiceService = new WashServiceService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User currentUser = getCurrentCustomer(req, res);
        if (currentUser == null) {
            return;
        }

        String path = req.getPathInfo();
        if (path == null || "/".equals(path)) {
            showBookingList(req, res, currentUser);
        } else if ("/new".equals(path)) {
            showBookingForm(req, res, currentUser);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentCustomer(req, res);
        if (currentUser == null) {
            return;
        }

        if (!"/new".equals(req.getPathInfo())) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String vehicleId = req.getParameter("vehicleId");
        String serviceId = req.getParameter("serviceId");
        String bookingDate = req.getParameter("bookingDate");
        String time = req.getParameter("time");
        HttpSession session = req.getSession();

        try {
            int bookingId = bookingService.createCustomerBooking(
                    currentUser.getId(),
                    Integer.parseInt(vehicleId),
                    Integer.parseInt(serviceId),
                    bookingDate,
                    time
            );
            res.sendRedirect(req.getContextPath() + "/booking/new?success=" + bookingId);
        } catch (NumberFormatException e) {
            session.setAttribute("bookingError", "Vui lòng chọn đầy đủ xe và dịch vụ.");
            redirectToForm(req, res, vehicleId, serviceId, bookingDate, time);
        } catch (IllegalArgumentException e) {
            session.setAttribute("bookingError", e.getMessage());
            redirectToForm(req, res, vehicleId, serviceId, bookingDate, time);
        } catch (Exception e) {
            log("Cannot create customer booking", e);
            session.setAttribute("bookingError", "Không thể tạo booking lúc này. Vui lòng thử lại.");
            redirectToForm(req, res, vehicleId, serviceId, bookingDate, time);
        }
    }

    private void showBookingList(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        req.setAttribute("bookings", bookingService.getBookingsByUserId(currentUser.getId()));
        req.setAttribute("activePage", "booking");
        req.getRequestDispatcher("/WEB-INF/view/customer/booking-list.jsp").forward(req, res);
    }

    private void showBookingForm(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        List<Vehicle> vehicles = vehicleService.findByUserId(currentUser.getId());
        List<WashService> services = washServiceService.getActiveServices();

        Integer selectedVehicleId = parsePositiveInt(req.getParameter("vehicleId"));
        Integer selectedServiceId = parsePositiveInt(req.getParameter("serviceId"));
        String selectedDate = trim(req.getParameter("bookingDate"));
        String selectedTime = trim(req.getParameter("time"));

        Vehicle selectedVehicle = findOwnedVehicle(vehicles, selectedVehicleId);
        WashService selectedService = findActiveService(services, selectedServiceId);

        int bookingWindowDays = currentUser.getLoyaltyTier() == null
                ? 7 : currentUser.getLoyaltyTier().getBookingWindowDays();
        LocalDate today = LocalDate.now();
        List<String> availableSlots = Collections.emptyList();

        if (selectedService != null && !selectedDate.isEmpty()) {
            try {
                LocalDate date = LocalDate.parse(selectedDate);
                if (bookingService.isBookingDateAllowed(date, today, bookingWindowDays)) {
                    availableSlots = bookingService.getAvailableTimeSlots(
                            date, selectedService.getDurationMinutes(), LocalDateTime.now());
                    if (!availableSlots.contains(selectedTime)) {
                        selectedTime = "";
                    }
                }
            } catch (Exception ignored) {
                selectedDate = "";
                selectedTime = "";
            }
        }

        Booking successBooking = null;
        Integer successId = parsePositiveInt(req.getParameter("success"));
        if (successId != null) {
            Booking booking = bookingService.getBookingById(successId);
            if (booking != null && booking.getUserId() == currentUser.getId()) {
                successBooking = booking;
            }
        }

        HttpSession session = req.getSession(false);
        if (session != null) {
            String bookingError = (String) session.getAttribute("bookingError");
            if (bookingError != null) {
                req.setAttribute("bookingError", bookingError);
                session.removeAttribute("bookingError");
            }
        }

        req.setAttribute("vehicles", vehicles);
        req.setAttribute("services", services);
        req.setAttribute("selectedVehicleId", selectedVehicleId);
        req.setAttribute("selectedServiceId", selectedServiceId);
        req.setAttribute("selectedVehicle", selectedVehicle);
        req.setAttribute("selectedService", selectedService);
        req.setAttribute("selectedDate", selectedDate);
        req.setAttribute("selectedTime", selectedTime);
        req.setAttribute("availableSlots", availableSlots);
        req.setAttribute("bookingWindowDays", bookingWindowDays);
        req.setAttribute("minBookingDate", today.toString());
        req.setAttribute("maxBookingDate", today.plusDays(bookingWindowDays).toString());
        req.setAttribute("successBooking", successBooking);
        req.setAttribute("activePage", "booking");
        req.getRequestDispatcher("/WEB-INF/view/customer/booking-form.jsp").forward(req, res);
    }

    private User getCurrentCustomer(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = session == null ? null : (User) session.getAttribute("currentUser");
        if (sessionUser == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return null;
        }

        User currentUser = userService.findById(sessionUser.getId());
        if (currentUser == null) {
            session.invalidate();
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return null;
        }
        if (!"CUSTOMER".equals(currentUser.getRole())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }

        session.setAttribute("currentUser", currentUser);
        return currentUser;
    }

    private Vehicle findOwnedVehicle(List<Vehicle> vehicles, Integer id) {
        if (id == null) {
            return null;
        }
        for (Vehicle vehicle : vehicles) {
            if (vehicle.getId() == id) {
                return vehicle;
            }
        }
        return null;
    }

    private WashService findActiveService(List<WashService> services, Integer id) {
        if (id == null) {
            return null;
        }
        for (WashService service : services) {
            if (service.getId() == id) {
                return service;
            }
        }
        return null;
    }

    private Integer parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void redirectToForm(HttpServletRequest req, HttpServletResponse res,
            String vehicleId, String serviceId, String bookingDate, String time) throws IOException {
        String query = "?vehicleId=" + encode(vehicleId)
                + "&serviceId=" + encode(serviceId)
                + "&bookingDate=" + encode(bookingDate)
                + "&time=" + encode(time);
        res.sendRedirect(req.getContextPath() + "/booking/new" + query);
    }

    private String encode(String value) throws IOException {
        return URLEncoder.encode(value == null ? "" : value, "UTF-8");
    }
}
