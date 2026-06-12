package controller;

import dao.LoyaltyTierDAO;
import dao.UserDAO;
import dao.VehicleDAO;
import model.LoyaltyTier;
import model.User;
import model.Vehicle;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/profile/*")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userRepo = new UserDAO();
    private final LoyaltyTierDAO tierRepo = new LoyaltyTierDAO();
    private final VehicleDAO vehicleRepo = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = (User) session.getAttribute("currentUser");

        User freshUser = userRepo.findById(sessionUser.getId());
        if (freshUser != null) {
            session.setAttribute("currentUser", freshUser);
        } else {
            freshUser = sessionUser;
        }

        List<LoyaltyTier> allTiers = tierRepo.findAll();
        LoyaltyTier nextTier = null;
        for (LoyaltyTier t : allTiers) {
            if (t.getMinSpend() > freshUser.getLifetimeSpent()) {
                nextTier = t;
                break;
            }
        }

        if (nextTier != null) {
            double remaining = nextTier.getMinSpend() - freshUser.getLifetimeSpent();
            double progress = Math.min(100.0, (freshUser.getLifetimeSpent() / nextTier.getMinSpend()) * 100.0);
            req.setAttribute("nextTier", nextTier);
            req.setAttribute("remainingSpend", remaining);
            req.setAttribute("progressPercent", progress);
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

        List<Vehicle> vehicles = vehicleRepo.findByUserId(freshUser.getId());
        req.setAttribute("vehicles", vehicles);

        req.getRequestDispatcher("/profile.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        String pathInfo = req.getPathInfo();

        if ("/update".equals(pathInfo)) {
            handleUpdate(req, res, session);
        } else {
            res.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
        User currentUser = (User) session.getAttribute("currentUser");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        if (phone != null && !phone.trim().isEmpty() && !phone.trim().matches("^0\\d{9}$")) {
            session.setAttribute("profileError", "Số điện thoại không hợp lệ (phải bắt đầu bằng số 0 và có đúng 10 chữ số)!");
            res.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        try {
            userRepo.updateProfile(currentUser.getId(),
                    fullname != null ? fullname.trim() : "",
                    phone != null ? phone.trim() : "");
            User updatedUser = userRepo.findById(currentUser.getId());
            session.setAttribute("currentUser", updatedUser);
            res.sendRedirect(req.getContextPath() + "/profile?msg=profile_success");
        } catch (Exception e) {
            session.setAttribute("profileError", "Lỗi hệ thống khi cập nhật hồ sơ cá nhân.");
            res.sendRedirect(req.getContextPath() + "/profile");
        }
    }
}
