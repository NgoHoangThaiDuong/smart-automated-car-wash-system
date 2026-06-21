package controller;

import model.Booking;
import model.WashService;
import model.User;
import model.LoyaltyTier;
import dto.PageResult;
import dto.BookingDTO;
import service.BookingService;
import service.WashServiceService;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

@WebServlet({"/admin", "/admin/*"})
public class AdminServlet extends HttpServlet {

    public static final Map<String, String> BOOKING_STATUSES = new LinkedHashMap<>();
    static {
        BOOKING_STATUSES.put("CONFIRMED", "Confirmed (Đã xác nhận)");
        BOOKING_STATUSES.put("IN_PROGRESS", "In Progress (Đang rửa)");
        BOOKING_STATUSES.put("COMPLETED", "Completed (Hoàn thành)");
        BOOKING_STATUSES.put("CANCELLED", "Cancelled (Đã hủy)");
        BOOKING_STATUSES.put("NO_SHOW", "No Show (Không đến)");
    }

    private final BookingService bookingService = new BookingService();
    private final WashServiceService washServiceService = new WashServiceService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) pathInfo = "/dashboard";

        switch (pathInfo) {
            case "/dashboard":
                handleDashboard(req, res);
                break;
            case "/bookings":
                handleBookingList(req, res);
                break;
            case "/bookings/new":
                handleBookingNew(req, res);
                break;
            case "/bookings/detail":
                handleBookingDetail(req, res);
                break;
            case "/services":
                handleServiceList(req, res);
                break;
            case "/customers":
                handleCustomerList(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        switch (pathInfo) {
            case "/bookings/create":
                handleBookingCreate(req, res);
                break;
            case "/bookings/update-status":
                handleUpdateStatus(req, res);
                break;
            case "/bookings/collect-payment":
                handleCollectPayment(req, res);
                break;
            case "/services/create":
                handleCreateService(req, res);
                break;
            case "/services/update":
                handleUpdateService(req, res);
                break;
            case "/services/toggle-status":
                handleToggleServiceStatus(req, res);
                break;
            case "/services/delete":
                handleDeleteService(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private PageResult<Booking> populateBookingPageAttributes(HttpServletRequest req) {
        String search = req.getParameter("search");
        String status = req.getParameter("status");
        String date = req.getParameter("date");
        String sortBy = req.getParameter("sortBy");

        int page = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
            }
        }

        PageResult<Booking> pageResult = bookingService.getBookingsPage(search, status, date, sortBy, page, pageSize);

        req.setAttribute("bookings", pageResult.getData());
        req.setAttribute("search", search);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("date", date);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("bookingStatuses", BOOKING_STATUSES);
        req.setAttribute("currentPage", pageResult.getCurrentPage());
        req.setAttribute("totalPages", pageResult.getTotalPages());
        req.setAttribute("totalEntries", pageResult.getTotalEntries());
        req.setAttribute("startEntry", pageResult.getStartEntry());
        req.setAttribute("endEntry", pageResult.getEndEntry());
        return pageResult;
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("confirmedCount", bookingService.countByStatus("CONFIRMED"));
        req.setAttribute("inProgressCount", bookingService.countByStatus("IN_PROGRESS"));
        req.setAttribute("completedCount", bookingService.countByStatus("COMPLETED"));
        req.setAttribute("todayCount", bookingService.countTodayBookings());
        req.setAttribute("totalRevenue", bookingService.sumRevenue());

        populateBookingPageAttributes(req);

        req.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(req, res);
    }

    private void handleBookingList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        populateBookingPageAttributes(req);
        req.getRequestDispatcher("/WEB-INF/view/admin/booking-list.jsp").forward(req, res);
    }

    private void handleBookingDetail(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null) {
            res.sendRedirect(req.getContextPath() + "/admin/bookings");
            return;
        }
        try {
            Booking booking = bookingService.getBookingById(Integer.parseInt(idParam));
            if (booking == null) {
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            req.setAttribute("booking", booking);
            HttpSession session = req.getSession(false);
            String msg = (String) session.getAttribute("adminMsg");
            String err = (String) session.getAttribute("adminError");
            if (msg != null) { req.setAttribute("adminMsg", msg); session.removeAttribute("adminMsg"); }
            if (err != null) { req.setAttribute("adminError", err); session.removeAttribute("adminError"); }
            req.getRequestDispatcher("/WEB-INF/view/admin/booking-detail.jsp").forward(req, res);
        } catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        String idParam = req.getParameter("bookingId");
        String newStatus = req.getParameter("newStatus");
        try {
            int id = Integer.parseInt(idParam);
            bookingService.updateBookingStatus(id, newStatus);
            session.setAttribute("adminMsg", "Cập nhật trạng thái thành công.");
            res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + id);
        } catch (IllegalArgumentException e) {
            session.setAttribute("adminError", e.getMessage());
            res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + idParam);
        }
    }

    private void handleServiceList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<WashService> services = washServiceService.getAllServicesWithBookingCount();
        req.setAttribute("services", services);

        HttpSession session = req.getSession(false);
        if (session != null) {
            String msg = (String) session.getAttribute("adminMsg");
            String err = (String) session.getAttribute("adminError");
            if (msg != null) { req.setAttribute("adminMsg", msg); session.removeAttribute("adminMsg"); }
            if (err != null) { req.setAttribute("adminError", err); session.removeAttribute("adminError"); }
        }

        req.getRequestDispatcher("/WEB-INF/view/admin/services.jsp").forward(req, res);
    }

    private void handleCreateService(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            int duration = Integer.parseInt(req.getParameter("durationMinutes"));
            boolean isActive = req.getParameter("isActive") != null;

            WashService ws = new WashService();
            ws.setName(name);
            ws.setDescription(description);
            ws.setPrice(price);
            ws.setDurationMinutes(duration);
            ws.setActive(isActive);

            washServiceService.createService(ws);
            session.setAttribute("adminMsg", "Thêm dịch vụ mới thành công.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Lỗi: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleUpdateService(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            int duration = Integer.parseInt(req.getParameter("durationMinutes"));
            boolean isActive = req.getParameter("isActive") != null;

            WashService ws = new WashService();
            ws.setId(id);
            ws.setName(name);
            ws.setDescription(description);
            ws.setPrice(price);
            ws.setDurationMinutes(duration);
            ws.setActive(isActive);

            washServiceService.updateService(ws);
            session.setAttribute("adminMsg", "Cập nhật dịch vụ thành công.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Lỗi: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleToggleServiceStatus(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            washServiceService.toggleServiceStatus(id);
            session.setAttribute("adminMsg", "Đã thay đổi trạng thái hoạt động của dịch vụ.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Lỗi: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleDeleteService(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            washServiceService.deleteService(id);
            session.setAttribute("adminMsg", "Xóa dịch vụ thành công.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Lỗi: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private PageResult<User> populateCustomersPageAttributes(HttpServletRequest req) {
        String search = req.getParameter("search");
        String tierIdParam = req.getParameter("tierId");
        String sortBy = req.getParameter("sortBy");
        Integer tierId = null;
        if (tierIdParam != null && !tierIdParam.trim().isEmpty()) {
            try {
                tierId = Integer.parseInt(tierIdParam);
            } catch (NumberFormatException e) {
            }
        }

        int page = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
            }
        }

        PageResult<User> pageResult = userService.getCustomersPage(search, tierId, sortBy, page, pageSize);
        List<LoyaltyTier> tiers = userService.getAllLoyaltyTiers();

        req.setAttribute("customers", pageResult.getData());
        req.setAttribute("tiers", tiers);
        req.setAttribute("search", search);
        req.setAttribute("selectedTierId", tierId);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("currentPage", pageResult.getCurrentPage());
        req.setAttribute("totalPages", pageResult.getTotalPages());
        req.setAttribute("totalEntries", pageResult.getTotalEntries());
        req.setAttribute("startEntry", pageResult.getStartEntry());
        req.setAttribute("endEntry", pageResult.getEndEntry());
        return pageResult;
    }

    private void handleCustomerList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        populateCustomersPageAttributes(req);
        req.setAttribute("totalCustomers", userService.getCustomerCount());
        req.setAttribute("totalVehicles", userService.getRegisteredVehicleCount());
        req.setAttribute("totalRevenue", userService.getLifetimeSpentSum());

        req.getRequestDispatcher("/WEB-INF/view/admin/customers.jsp").forward(req, res);
    }

    private void handleCollectPayment(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        String idParam = req.getParameter("bookingId");
        String paymentMethod = req.getParameter("paymentMethod");
        try {
            int id = Integer.parseInt(idParam);
            bookingService.collectPayment(id, paymentMethod);
            session.setAttribute("adminMsg", "Xác nhận thanh toán thành công.");
            res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + id);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Lỗi: " + e.getMessage());
            res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + idParam);
        }
    }

    private void handleBookingNew(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String customerIdParam = req.getParameter("customerId");
        if (customerIdParam == null || customerIdParam.trim().isEmpty()) {
            populateCustomersPageAttributes(req);
            req.setAttribute("hasNoCustomer", true);
            req.getRequestDispatcher("/WEB-INF/view/admin/booking-create.jsp").forward(req, res);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdParam);
            User customer = userService.findById(customerId);
            if (customer == null || !"CUSTOMER".equals(customer.getRole())) {
                req.setAttribute("bookingError", "Không tìm thấy khách hàng hợp lệ.");
                req.getRequestDispatcher("/WEB-INF/view/admin/booking-create.jsp").forward(req, res);
                return;
            }

            BookingDTO context = bookingService.prepareBookingFormContext(
                    customerId,
                    req.getParameter("vehicleId"),
                    req.getParameter("serviceId"),
                    req.getParameter("bookingDate"),
                    req.getParameter("time")
            );

            req.setAttribute("customer", customer);
            context.putIntoRequest(req);
            req.setAttribute("activePage", "bookings");

            req.getRequestDispatcher("/WEB-INF/view/admin/booking-create.jsp").forward(req, res);
        } catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleBookingCreate(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String customerIdValue = req.getParameter("customerId");
        String vehicleIdValue = req.getParameter("vehicleId");
        String serviceIdValue = req.getParameter("serviceId");
        String bookingDate = req.getParameter("bookingDate");
        String time = req.getParameter("time");

        if (customerIdValue != null) customerIdValue = customerIdValue.trim();
        if (vehicleIdValue != null) vehicleIdValue = vehicleIdValue.trim();
        if (serviceIdValue != null) serviceIdValue = serviceIdValue.trim();
        if (bookingDate != null) bookingDate = bookingDate.trim();
        if (time != null) time = time.trim();

        try {
            int customerId = Integer.parseInt(customerIdValue);
            int vehicleId = Integer.parseInt(vehicleIdValue);
            int serviceId = Integer.parseInt(serviceIdValue);

            int bookingId = bookingService.create(
                    customerId,
                    vehicleId,
                    serviceId,
                    bookingDate,
                    time
            );
            
            res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + bookingId);
        } catch (Exception e) {
            req.setAttribute("bookingError", e.getMessage() != null ? e.getMessage() : "Không thể tạo booking. Vui lòng thử lại.");
            req.setAttribute("customerId", customerIdValue);
            req.setAttribute("vehicleId", vehicleIdValue);
            req.setAttribute("serviceId", serviceIdValue);
            req.setAttribute("bookingDate", bookingDate);
            req.setAttribute("time", time);
            handleBookingNew(req, res);
        }
    }

}
