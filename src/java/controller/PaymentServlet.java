package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.Booking;
import model.Payment;
import model.PaymentDetail;
import model.User;
import service.PaymentService;
import service.BookingService;
import service.UserService;

@WebServlet({"/payment", "/payment/*"})
public class PaymentServlet extends HttpServlet {

    private PaymentService paymentService = new PaymentService();
    private BookingService bookingService = new BookingService();
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getCurrentCustomer(request, response);
        if (currentUser == null) {
            return;
        }

        String bookingIdRaw = request.getParameter("bookingId");
        if (bookingIdRaw == null || bookingIdRaw.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking ID is required.");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdRaw);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking ID invalid.");
            return;
        }

        PaymentDetail detail = paymentService.getPaymentDetail(bookingId);
        Payment payment = paymentService.getPaymentByBookingId(bookingId);

        if (detail == null || payment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy thông tin thanh toán.");
            return;
        }

        // Security check: only the booking owner can access this payment checkout page
        Booking booking = bookingService.getBookingById(bookingId);
        if (booking == null || booking.getUserId() != currentUser.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang thanh toán này.");
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            moveFlashMessage(session, request, "paymentMessage");
            moveFlashMessage(session, request, "paymentError");
        }

        request.setAttribute("detail", detail);
        request.setAttribute("payment", payment);
        request.setAttribute("activePage", "booking");

        request.getRequestDispatcher("/WEB-INF/view/customer/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentCustomer(request, response);
        if (currentUser == null) {
            return;
        }

        String bookingIdRaw = request.getParameter("bookingId");
        String paymentMethod = request.getParameter("paymentMethod");

        if (bookingIdRaw == null || bookingIdRaw.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking ID is required.");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdRaw);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking ID invalid.");
            return;
        }

        // Security check: verify booking ownership
        Booking booking = bookingService.getBookingById(bookingId);
        if (booking == null || booking.getUserId() != currentUser.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thanh toán cho booking này.");
            return;
        }

        HttpSession session = request.getSession();
        try {
            paymentService.processPayment(bookingId, paymentMethod);
            session.setAttribute("paymentMessage", "Thanh toán thành công!");
            response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + bookingId);
        } catch (Exception e) {
            session.setAttribute("paymentError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + bookingId);
        }
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
