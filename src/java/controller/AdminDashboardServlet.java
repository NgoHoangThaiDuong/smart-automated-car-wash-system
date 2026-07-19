package controller;

import model.Booking;
import dto.PageResult;
import service.BookingService;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.LinkedList;

@WebServlet({"/admin", "/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    public static final List<String> BOOKING_STATUSES = new LinkedList<>();
    static {
        BOOKING_STATUSES.add("CONFIRMED");
        BOOKING_STATUSES.add("IN_PROGRESS");
        BOOKING_STATUSES.add("COMPLETED");
        BOOKING_STATUSES.add("CANCELLED");
        BOOKING_STATUSES.add("NO_SHOW");
    }

    private final BookingService bookingService = new BookingService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("confirmedCount", bookingService.countByStatus("CONFIRMED"));
        req.setAttribute("inProgressCount", bookingService.countByStatus("IN_PROGRESS"));
        req.setAttribute("completedCount", bookingService.countByStatus("COMPLETED"));
        req.setAttribute("todayCount", bookingService.countTodayBookings());
        req.setAttribute("totalRevenue", bookingService.sumRevenue());
        req.setAttribute("totalCustomers", userService.getCustomerCount());
        req.setAttribute("unpaidCount", bookingService.countByPaymentStatus("UNPAID"));

        // Booking table trên dashboard
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

        req.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(req, res);
    }
}
