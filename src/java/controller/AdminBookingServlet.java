package controller;

import model.Booking;
import model.User;
import model.LoyaltyTier;
import dto.PageResult;
import dto.BookingDTO;
import service.BookingService;
import service.UserService;
import service.PaymentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/bookings", "/admin/bookings/*"})
public class AdminBookingServlet extends HttpServlet {

    private BookingService bookingService = new BookingService();
    private UserService userService = new UserService();
    private PaymentService paymentService = new PaymentService();
    private dao.BookingStatusDAO bookingStatusDAO = new dao.BookingStatusDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) {
            handleBookingList(req, res);
        } else {
            switch (pathInfo) {
                case "/new":
                    handleBookingNew(req, res);
                    break;
                case "/detail":
                    handleBookingDetail(req, res);
                    break;
                default:
                    res.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
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
            case "/create":
                handleBookingCreate(req, res);
                break;
            case "/update-status":
                handleUpdateStatus(req, res);
                break;
            case "/collect-payment":
                handleCollectPayment(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleBookingList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
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
        req.setAttribute("bookingStatuses", bookingStatusDAO.findAll());
        req.setAttribute("currentPage", pageResult.getCurrentPage());
        req.setAttribute("totalPages", pageResult.getTotalPages());
        req.setAttribute("totalEntries", pageResult.getTotalEntries());
        req.setAttribute("startEntry", pageResult.getStartEntry());
        req.setAttribute("endEntry", pageResult.getEndEntry());

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
            if (session != null) {
                String msg = (String) session.getAttribute("adminMsg");
                String err = (String) session.getAttribute("adminError");
                if (msg != null) {
                    req.setAttribute("adminMsg", msg);
                    session.removeAttribute("adminMsg");
                }
                if (err != null) {
                    req.setAttribute("adminError", err);
                    session.removeAttribute("adminError");
                }
            }
            req.getRequestDispatcher("/WEB-INF/view/admin/booking-detail.jsp").forward(req, res);
        } catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        String status = req.getParameter("newStatus");
        try {
            boolean updated = bookingService.updateBookingStatus(bookingId, status);
            if (updated) {
                session.setAttribute("adminMsg", "Booking status updated successfully.");
            } else {
                session.setAttribute("adminError", "Failed to update booking status.");
            }
            res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + bookingId);
        } catch (Exception e) {
            session.setAttribute("adminError", "Error: " + e.getMessage());
            res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + bookingId);
        }
    }

    private void handleCollectPayment(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        String idParam = req.getParameter("bookingId");
        String paymentMethod = req.getParameter("paymentMethod");
        String redirect = req.getParameter("redirect");
        try {
            int id = Integer.parseInt(idParam);
            paymentService.processPayment(id, paymentMethod);
            session.setAttribute("adminMsg", "Payment collected successfully.");
            if ("list".equals(redirect)) {
                res.sendRedirect(req.getContextPath() + "/admin/bookings");
            } else {
                res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + id);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error: " + e.getMessage());
            if ("list".equals(redirect)) {
                res.sendRedirect(req.getContextPath() + "/admin/bookings");
            } else {
                res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + idParam);
            }
        }
    }

    private void handleBookingNew(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String customerIdParam = req.getParameter("customerId");
        if (customerIdParam == null || customerIdParam.trim().isEmpty()) {
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

            req.setAttribute("hasNoCustomer", true);
            req.getRequestDispatcher("/WEB-INF/view/admin/booking-create.jsp").forward(req, res);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdParam);
            User customer = userService.findById(customerId);
            if (customer == null || !"CUSTOMER".equals(customer.getRole())) {
                req.setAttribute("bookingError", "Valid customer not found.");
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
        int customerId;
        try {
            customerId = Integer.parseInt(customerIdValue != null ? customerIdValue.trim() : "");
        } catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        BookingDTO formDTO = BookingDTO.fromRequest(req);
        String validationError = formDTO.validate();
        if (validationError != null) {
            req.setAttribute("bookingError", validationError);
            req.setAttribute("customerId", customerIdValue);
            handleBookingNew(req, res);
            return;
        }

        try {
            int bookingId = bookingService.create(customerId, formDTO);
            res.sendRedirect(req.getContextPath() + "/admin/bookings/detail?id=" + bookingId);
        } catch (Exception e) {
            req.setAttribute("bookingError", e.getMessage() != null ? e.getMessage() : "Failed to create booking. Please try again.");
            req.setAttribute("customerId", customerIdValue);
            handleBookingNew(req, res);
        }
        req.setAttribute("customerId", customerIdValue);
        handleBookingNew(req, res);
    }
}
