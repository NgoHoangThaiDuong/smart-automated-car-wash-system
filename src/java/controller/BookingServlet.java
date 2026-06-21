package controller;

import model.Booking;
import model.User;
import service.BookingService;
import service.UserService;
import dto.BookingDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/booking", "/booking/*", "/wash-history"})
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User currentUser = getCurrentCustomer(req, res);
        if (currentUser == null) {
            return;
        }

        String servletPath = req.getServletPath();
        if ("/wash-history".equals(servletPath)) {
            showWashHistory(req, res, currentUser);
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

        req.setAttribute("bookings", bookingService.getBookingsByUser(currentUser.getId()));
        req.setAttribute("activePage", "booking");
        req.getRequestDispatcher("/WEB-INF/view/customer/booking-list.jsp").forward(req, res);
    }

    private void showWashHistory(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "bookingMessage");
            moveFlashMessage(session, req, "bookingError");
        }

        req.setAttribute("bookings", bookingService.getRecentWashHistory(currentUser.getId(), 100));
        req.setAttribute("activePage", "wash-history");
        req.getRequestDispatcher("/WEB-INF/view/customer/wash-history.jsp").forward(req, res);
    }

    private void showBookingForm(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        prepareBookingForm(req, currentUser);
        req.getRequestDispatcher("/WEB-INF/view/customer/booking-form.jsp").forward(req, res);
    }

    private void createBooking(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        String vehicleIdValue = req.getParameter("vehicleId") == null ? "" : req.getParameter("vehicleId").trim();
        String serviceIdValue = req.getParameter("serviceId") == null ? "" : req.getParameter("serviceId").trim();
        String bookingDate = req.getParameter("bookingDate") == null ? "" : req.getParameter("bookingDate").trim();
        String time = req.getParameter("time") == null ? "" : req.getParameter("time").trim();

        try {
            int bookingId = bookingService.create(
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
            bookingService.cancel(bookingId, currentUser.getId());
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

    private void prepareBookingForm(HttpServletRequest req, User currentUser) {
        dto.BookingDTO context = bookingService.prepareBookingFormContext(
                currentUser.getId(),
                req.getParameter("vehicleId"),
                req.getParameter("serviceId"),
                req.getParameter("bookingDate"),
                req.getParameter("time")
        );

        context.putIntoRequest(req);
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

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String name) {
        Object value = session.getAttribute(name);
        if (value != null) {
            req.setAttribute(name, value);
            session.removeAttribute(name);
        }
    }
}
