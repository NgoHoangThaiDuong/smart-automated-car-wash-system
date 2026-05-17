package controller;

import exception.ValidationException;
import model.User;
import service.OrderBusinessService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {

    private final OrderBusinessService orderBusinessService = new OrderBusinessService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/list";
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");

        switch (action) {
            case "/book":
                req.setAttribute("services", orderBusinessService.getAllServices());
                req.getRequestDispatcher("/view/order/book.jsp").forward(req, res);
                break;
            case "/list":
                req.setAttribute("orders", orderBusinessService.getOrdersForUser(currentUser.getId()));
                req.getRequestDispatcher("/view/order/list.jsp").forward(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/list";
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");

        if ("/book".equals(action)) {
            handleBookOrder(req, res, currentUser);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleBookOrder(HttpServletRequest req, HttpServletResponse res, User currentUser) throws ServletException, IOException {
        String serviceIdStr = req.getParameter("serviceId");
        String carPlate = req.getParameter("carPlate");
        String bookDateStr = req.getParameter("bookDate");

        int serviceId = 0;
        try {
            if (serviceIdStr != null && !serviceIdStr.trim().isEmpty()) {
                serviceId = Integer.parseInt(serviceIdStr);
            }
        } catch (NumberFormatException ignored) {}

        try {
            orderBusinessService.bookOrder(currentUser.getId(), serviceId, carPlate, bookDateStr);
            // Áp dụng PRG Pattern: Redirect sau khi POST thành công
            res.sendRedirect(req.getContextPath() + "/order/list?success=1");
        } catch (ValidationException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("selectedServiceId", serviceId);
            req.setAttribute("carPlate", carPlate);
            req.setAttribute("bookDate", bookDateStr);
            req.setAttribute("services", orderBusinessService.getAllServices());
            req.getRequestDispatcher("/view/order/book.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            req.setAttribute("selectedServiceId", serviceId);
            req.setAttribute("carPlate", carPlate);
            req.setAttribute("bookDate", bookDateStr);
            req.setAttribute("services", orderBusinessService.getAllServices());
            req.getRequestDispatcher("/view/order/book.jsp").forward(req, res);
        }
    }
}
