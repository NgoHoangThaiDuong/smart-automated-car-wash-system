package controller;

import model.Booking;
import model.WashService;
import service.BookingService;
import service.WashServiceService;

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

        List<Booking> allBookings = bookingService.getAllBookings(null, null, null);
        List<Booking> recentBookings = allBookings.size() > 5 ? allBookings.subList(0, 5) : allBookings;
        req.setAttribute("recentBookings", recentBookings);

        req.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(req, res);
    }

    private void handleBookingList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String search = req.getParameter("search");
        String status = req.getParameter("status");
        String date = req.getParameter("date");
        List<Booking> bookings = bookingService.getAllBookings(search, status, date);
        req.setAttribute("bookings", bookings);
        req.setAttribute("search", search);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("date", date);
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
            session.setAttribute("adminError", "Lỗi: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }
}
