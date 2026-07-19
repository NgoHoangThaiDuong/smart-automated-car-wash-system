package controller;

import model.Booking;
import model.Vehicle;
import model.User;
import model.LoyaltyTier;
import dto.PageResult;
import service.BookingService;
import service.UserService;
import service.VehicleService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/customers", "/admin/customers/*"})
public class AdminCustomerServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final VehicleService vehicleService = new VehicleService();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) {
            handleCustomerList(req, res);
        } else if ("/detail".equals(pathInfo)) {
            handleCustomerDetail(req, res);
        } else {
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
            case "/ban":
                handleBanCustomer(req, res);
                break;
            case "/reset-password":
                handleResetPasswordCustomer(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleCustomerList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
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

        req.setAttribute("totalCustomers", userService.getCustomerCount());
        req.setAttribute("totalVehicles", userService.getRegisteredVehicleCount());
        req.setAttribute("totalRevenue", userService.getLifetimeSpentSum());

        req.getRequestDispatcher("/WEB-INF/view/admin/customers.jsp").forward(req, res);
    }

    private void handleCustomerDetail(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        try {
            int customerId = Integer.parseInt(idParam);
            User customer = userService.findById(customerId);
            if (customer == null || !"CUSTOMER".equals(customer.getRole())) {
                res.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khách hàng.");
                return;
            }

            dto.CustomerDashboardDTO stats = userService.getCustomerDashboard(customerId);
            List<Vehicle> vehicles = vehicleService.findByUser(customerId);
            List<Booking> bookings = bookingService.getBookingsByUser(customerId);

            HttpSession session = req.getSession(false);
            if (session != null) {
                String msg = (String) session.getAttribute("adminMsg");
                String err = (String) session.getAttribute("adminError");
                if (msg != null) { req.setAttribute("adminMsg", msg); session.removeAttribute("adminMsg"); }
                if (err != null) { req.setAttribute("adminError", err); session.removeAttribute("adminError"); }
            }

            req.setAttribute("customer", customer);
            req.setAttribute("stats", stats);
            req.setAttribute("vehicles", vehicles);
            req.setAttribute("bookings", bookings);
            req.setAttribute("activePage", "customers");

            req.getRequestDispatcher("/WEB-INF/view/admin/customer-detail.jsp").forward(req, res);
        } catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khách hàng không hợp lệ.");
        }
    }

    private void handleBanCustomer(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        String idParam = req.getParameter("customerId");
        String banParam = req.getParameter("ban");
        boolean ban = banParam == null || "true".equalsIgnoreCase(banParam.trim());
        try {
            int customerId = Integer.parseInt(idParam);
            userService.banUser(customerId, ban);
            if (session != null) {
                if (ban) {
                    session.setAttribute("adminMsg", "Đã chặn tài khoản khách hàng thành công.");
                } else {
                    session.setAttribute("adminMsg", "Đã mở khóa tài khoản khách hàng thành công.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("adminError", "Lỗi: " + e.getMessage());
            }
        }
        res.sendRedirect(req.getContextPath() + "/admin/customers/detail?id=" + idParam);
    }

    private void handleResetPasswordCustomer(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        String idParam = req.getParameter("customerId");
        try {
            int customerId = Integer.parseInt(idParam);
            userService.resetPassword(customerId, "123456");
            if (session != null) {
                session.setAttribute("adminMsg", "Đặt lại mật khẩu của khách hàng về mặc định (123456) thành công.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("adminError", "Lỗi đặt lại mật khẩu: " + e.getMessage());
            }
        }
        res.sendRedirect(req.getContextPath() + "/admin/customers/detail?id=" + idParam);
    }
}
