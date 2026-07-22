package controller;

import dto.CustomerDashboardDTO;
import model.User;
import service.BookingService;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private UserService userService = new UserService();
    private BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        if ("ADMIN".equals(currentUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        User freshUser = userService.findById(currentUser.getId());
        if (freshUser == null) {
            session.invalidate();
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        CustomerDashboardDTO dashboard = userService.getCustomerDashboard(freshUser.getId());
        if (dashboard == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        session.setAttribute("currentUser", freshUser);
        req.setAttribute("dashboard", dashboard);
        req.setAttribute("upcomingBooking", bookingService.getUpcomingBooking(freshUser.getId()));
        req.setAttribute("recentWashHistory", bookingService.getRecentWashHistory(freshUser.getId(), 5));
        req.setAttribute("activePage", "dashboard");

        req.getRequestDispatcher("/WEB-INF/view/customer/dashboard.jsp").forward(req, res);
    }
}
