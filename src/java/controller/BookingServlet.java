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
        } else if ("/slots".equals(path)) {
            showAvailableSlots(req, res, currentUser);
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

        String path = req.getPathInfo();
        if ("/create".equals(path)) {
            createBooking(req, res, currentUser);
        } else if ("/cancel".equals(path)) {
            cancelBooking(req, res, currentUser);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showBookingList(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "bookingMessage");
            moveFlashMessage(session, req, "bookingError");
        }

        req.setAttribute("bookings", bookingService.getBookingsByUserId(currentUser.getId()));
        req.setAttribute("activePage", "booking");
        req.getRequestDispatcher("/WEB-INF/view/customer/booking-list.jsp").forward(req, res);
    }

    private void showBookingForm(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        prepareBookingForm(req, currentUser);
        req.getRequestDispatcher("/WEB-INF/view/customer/booking-form.jsp").forward(req, res);
    }

    private void createBooking(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        String vehicleIdValue = trim(req.getParameter("vehicleId"));
        String serviceIdValue = trim(req.getParameter("serviceId"));
        String bookingDate = trim(req.getParameter("bookingDate"));
        String time = trim(req.getParameter("time"));

        try {
            int bookingId = bookingService.createCustomerBooking(
                    currentUser.getId(),
                    Integer.parseInt(vehicleIdValue),
                    Integer.parseInt(serviceIdValue),
                    bookingDate,
                    time
            );
            res.sendRedirect(req.getContextPath() + "/payment?bookingId=" + bookingId);
        } catch (NumberFormatException e) {
            req.setAttribute("bookingError", "Vui lòng chọn đầy đủ xe và dịch vụ.");
            prepareBookingForm(req, currentUser);
            req.getRequestDispatcher("/WEB-INF/view/customer/booking-form.jsp").forward(req, res);
        } catch (IllegalArgumentException e) {
            req.setAttribute("bookingError", e.getMessage());
            prepareBookingForm(req, currentUser);
            req.getRequestDispatcher("/WEB-INF/view/customer/booking-form.jsp").forward(req, res);
        } catch (Exception e) {
            log("Cannot create customer booking", e);
            req.setAttribute("bookingError", "Không thể tạo booking lúc này. Vui lòng thử lại.");
            prepareBookingForm(req, currentUser);
            req.getRequestDispatcher("/WEB-INF/view/customer/booking-form.jsp").forward(req, res);
        }
    }

    private void cancelBooking(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws IOException {
        HttpSession session = req.getSession();
        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            bookingService.cancelCustomerBooking(bookingId, currentUser.getId());
            session.setAttribute("bookingMessage", "Hủy booking thành công.");
        } catch (NumberFormatException e) {
            session.setAttribute("bookingError", "Booking không hợp lệ.");
        } catch (IllegalArgumentException e) {
            session.setAttribute("bookingError", e.getMessage());
        } catch (Exception e) {
            log("Cannot cancel customer booking", e);
            session.setAttribute("bookingError", "Không thể hủy booking lúc này.");
        }
        res.sendRedirect(req.getContextPath() + "/booking");
    }

    private void showAvailableSlots(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws IOException {
        res.setContentType("application/json;charset=UTF-8");
        try {
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));
            String bookingDate = trim(req.getParameter("bookingDate"));
            List<String> slots = bookingService.getAvailableTimeSlotsForCustomer(
                    currentUser.getId(), serviceId, bookingDate);
            res.getWriter().write(toJson(slots));
        } catch (IllegalArgumentException e) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            res.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            log("Cannot load customer booking slots", e);
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write("{\"error\":\"Không thể tải khung giờ lúc này.\"}");
        }
    }

    private void prepareBookingForm(HttpServletRequest req, User currentUser) {
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
        java.time.LocalDate today = java.time.LocalDate.now();

        req.setAttribute("vehicles", vehicles);
        req.setAttribute("services", services);
        req.setAttribute("selectedVehicleId", selectedVehicle == null ? null : selectedVehicle.getId());
        req.setAttribute("selectedServiceId", selectedService == null ? null : selectedService.getId());
        req.setAttribute("selectedVehicle", selectedVehicle);
        req.setAttribute("selectedService", selectedService);
        req.setAttribute("selectedDate", selectedDate);
        req.setAttribute("selectedTime", selectedTime);
        req.setAttribute("availableSlots", Collections.emptyList());
        req.setAttribute("bookingWindowDays", bookingWindowDays);
        req.setAttribute("minBookingDate", today.toString());
        req.setAttribute("maxBookingDate", today.plusDays(bookingWindowDays).toString());
        req.setAttribute("activePage", "booking");
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
        if (id != null) {
            for (Vehicle vehicle : vehicles) {
                if (vehicle.getId() == id) {
                    return vehicle;
                }
            }
        }
        return null;
    }

    private WashService findActiveService(List<WashService> services, Integer id) {
        if (id != null) {
            for (WashService service : services) {
                if (service.getId() == id) {
                    return service;
                }
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

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String name) {
        Object value = session.getAttribute(name);
        if (value != null) {
            req.setAttribute(name, value);
            session.removeAttribute(name);
        }
    }

    private String toJson(List<String> slots) {
        StringBuilder json = new StringBuilder("{\"slots\":[");
        for (int i = 0; i < slots.size(); i++) {
            if (i > 0) {
                json.append(',');
            }
            json.append('"').append(escapeJson(slots.get(i))).append('"');
        }
        return json.append("]}").toString();
    }

    private String escapeJson(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
