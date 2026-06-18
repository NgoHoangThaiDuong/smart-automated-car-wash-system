package controller;

import dao.BookingDAO;
import dao.CustomerDashboardDAO;
import dao.UserDAO;
import dto.CustomerDashboardDTO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final CustomerDashboardDAO dashboardDAO = new CustomerDashboardDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

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

        User freshUser = userDAO.findById(currentUser.getId());
        if (freshUser == null) {
            session.invalidate();
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        CustomerDashboardDTO dashboard = dashboardDAO.getCustomerDashboard(freshUser.getId());
        if (dashboard == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        session.setAttribute("currentUser", freshUser);
        req.setAttribute("dashboard", dashboard);
        req.setAttribute("upcomingBooking", bookingDAO.getUpcomingBookingByUserId(freshUser.getId()));
        req.setAttribute("recentWashHistory", bookingDAO.getRecentWashHistoryByUserId(freshUser.getId(), 5));
        req.setAttribute("activePage", "dashboard");

        req.getRequestDispatcher("/WEB-INF/view/customer/dashboard.jsp").forward(req, res);
    }
}
