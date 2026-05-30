package controller;

import dao.UserDAO;
import dao.LoyaltyTierDAO;
import dao.VehicleDAO;
import model.User;
import model.LoyaltyTier;
import model.Vehicle;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final UserDAO userRepo = new UserDAO();
    private final LoyaltyTierDAO tierRepo = new LoyaltyTierDAO();
    private final VehicleDAO vehicleRepo = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        User sessionUser = (User) session.getAttribute("currentUser");
        User freshestUser = userRepo.findById(sessionUser.getId());
        if (freshestUser != null) {
            session.setAttribute("currentUser", freshestUser);
        } else {
            freshestUser = sessionUser;
        }

        List<LoyaltyTier> allTiers = tierRepo.findAll();
        LoyaltyTier nextTier = null;
        for (LoyaltyTier t : allTiers) {
            if (t.getMinSpend() > freshestUser.getLifetimeSpent()) {
                nextTier = t;
                break;
            }
        }

        if (nextTier != null) {
            double remainingSpend = nextTier.getMinSpend() - freshestUser.getLifetimeSpent();
            double progressPercent = Math.min(100.0, (freshestUser.getLifetimeSpent() / nextTier.getMinSpend()) * 100.0);
            req.setAttribute("nextTier", nextTier);
            req.setAttribute("remainingSpend", remainingSpend);
            req.setAttribute("progressPercent", progressPercent);
        }

        String profileError = (String) session.getAttribute("profileError");
        if (profileError != null) {
            req.setAttribute("profileError", profileError);
            session.removeAttribute("profileError");
        }
        
        String vehicleError = (String) session.getAttribute("vehicleError");
        if (vehicleError != null) {
            req.setAttribute("vehicleError", vehicleError);
            session.removeAttribute("vehicleError");
        }

        List<Vehicle> vehicles = vehicleRepo.findByUserId(freshestUser.getId());
        req.setAttribute("vehicles", vehicles);

        req.getRequestDispatcher("/dashboard.jsp").forward(req, res);
    }
}
