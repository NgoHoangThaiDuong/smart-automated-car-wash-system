package controller;

import repository.TierRepository;
import repository.UserRepository;
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

    private final UserRepository userRepo = new UserRepository();
    private final TierRepository tierRepo = new TierRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/view";
        }

        if ("/view".equals(action)) {
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

            String flashError = (String) session.getAttribute("flashError");
            if (flashError != null) {
                req.setAttribute("error", flashError);
                session.removeAttribute("flashError");
            }

            List<model.Tier> allTiers = tierRepo.findAll();
            model.Tier nextTier = null;
            for (model.Tier t : allTiers) {
                if (t.getMinSpend() > freshestUser.getLifetimeSpent()) {
                    nextTier = t;
                    break;
                }
            }

            if (nextTier != null) {
                double remainingSpend = nextTier.getMinSpend() - freshestUser.getLifetimeSpent();
                double progressPercent = Math.min(100.0, (freshestUser.getLifetimeSpent() / nextTier.getMinSpend()) * 100.0);
                req.setAttribute("nextTier", nextTier);
                req.setAttribute("progressPercent", progressPercent);
                req.setAttribute("remainingSpend", remainingSpend);
            }

            req.getRequestDispatcher("/view/profile/view.jsp").forward(req, res);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getPathInfo();
        if ("/update".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("currentUser") == null) {
                res.sendRedirect(req.getContextPath() + "/auth/login");
                return;
            }

            User currentUser = (User) session.getAttribute("currentUser");
            String fullname = req.getParameter("fullname");
            String phone = req.getParameter("phone");

            if (phone != null && !phone.trim().isEmpty() && !phone.trim().matches("^0\\d{9}$")) {
                session.setAttribute("flashError", "Invalid phone number (must start with 0 and contain exactly 10 digits)");
                res.sendRedirect(req.getContextPath() + "/profile/view");
                return;
            }

            try {
                userRepo.updateProfile(currentUser.getId(), fullname != null ? fullname.trim() : "", phone != null ? phone.trim() : "");
                User updatedUser = userRepo.findById(currentUser.getId());
                session.setAttribute("currentUser", updatedUser);
                res.sendRedirect(req.getContextPath() + "/profile/view?success=1");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashError", "Hệ thống đang bận, vui lòng thử lại sau.");
                res.sendRedirect(req.getContextPath() + "/profile/view");
            }
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
