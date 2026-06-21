package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.Payment;
import model.PaymentDetail;
import service.PaymentService;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() {
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdRaw = request.getParameter("bookingId");

        if (bookingIdRaw == null || bookingIdRaw.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Booking ID is required.");
            return;
        }

        int bookingId;

        try {
            bookingId = Integer.parseInt(bookingIdRaw);
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Booking ID invalid");
            return;
        }

        PaymentDetail detail
                = paymentService.getPaymentDetail(bookingId);

        Payment payment
                = paymentService.getPaymentByBookingId(bookingId);

        if (detail == null || payment == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Payment not found");

            return;
        }

        request.setAttribute("detail", detail);
        request.setAttribute("payment", payment);

        request.getRequestDispatcher("/payment.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId
                = Integer.parseInt(
                        request.getParameter("bookingId"));

        String paymentMethod
                = request.getParameter("paymentMethod");

        try {

            paymentService.processPayment(
                    bookingId,
                    paymentMethod);

            response.sendRedirect(
                    request.getContextPath()
                    + "/PaymentServlet?bookingId="
                    + bookingId);

        } catch (Exception e) {

            request.setAttribute("error",
                    e.getMessage());

            doGet(request, response);

        }

    }

}
