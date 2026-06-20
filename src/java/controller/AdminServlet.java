package controller;

import model.Booking;
import model.WashService;
import model.User;
import model.LoyaltyTier;
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

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final WashServiceService washServiceService = new WashServiceService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/dashboard";

        switch (pathInfo) {
            case "/dashboard":
                handleDashboard(req, res);
                break;
            case "/bookings":
                handleBookingList(req, res);
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

    private void handleDashboard(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("confirmedCount", bookingService.countByStatus("CONFIRMED"));
        req.setAttribute("inProgressCount", bookingService.countByStatus("IN_PROGRESS"));
        req.setAttribute("completedCount", bookingService.countByStatus("COMPLETED"));
        req.setAttribute("todayCount", bookingService.countTodayBookings());
        req.setAttribute("totalRevenue", bookingService.sumRevenue());

        int page = 1;
        int pageSize = 5;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
            }
        }

        List<Booking> allBookings = bookingService.getAllBookings(null, null, null);
        int totalBookings = allBookings.size();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        if (page < 1) {
            page = 1;
        }

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalBookings);
        List<Booking> recentBookings = totalBookings > 0 ? allBookings.subList(start, end) : allBookings;

        req.setAttribute("recentBookings", recentBookings);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalEntries", totalBookings);
        req.setAttribute("startEntry", totalBookings == 0 ? 0 : start + 1);
        req.setAttribute("endEntry", end);

        req.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(req, res);
    }

    private void handleBookingList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String search = req.getParameter("search");
        String status = req.getParameter("status");
        String date = req.getParameter("date");
        List<Booking> bookings = bookingService.getAllBookings(search, status, date);

        int page = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
            }
        }

        int totalBookings = bookings.size();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        if (page < 1) {
            page = 1;
        }

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalBookings);
        List<Booking> paginatedBookings = totalBookings > 0 ? bookings.subList(start, end) : bookings;

        req.setAttribute("bookings", paginatedBookings);
        req.setAttribute("search", search);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("date", date);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalEntries", totalBookings);
        req.setAttribute("startEntry", totalBookings == 0 ? 0 : start + 1);
        req.setAttribute("endEntry", end);
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

    private void handleCustomerList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String search = req.getParameter("search");
        String tierIdParam = req.getParameter("tierId");
        Integer tierId = null;
        if (tierIdParam != null && !tierIdParam.trim().isEmpty()) {
            try {
                tierId = Integer.parseInt(tierIdParam);
            } catch (NumberFormatException e) {
            }
        }

        List<User> customers = userService.searchCustomers(search, tierId);
        List<LoyaltyTier> tiers = userService.getAllLoyaltyTiers();

        req.setAttribute("customers", customers);
        req.setAttribute("tiers", tiers);
        req.setAttribute("search", search);
        req.setAttribute("selectedTierId", tierId);
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
}
