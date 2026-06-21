package controller;

import service.UserService;
import service.VehicleService;
import model.User;
import model.Vehicle;
import dto.ProfileDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/profile", "/profile/*"})
public class ProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = (User) session.getAttribute("currentUser");

        User freshUser = userService.findById(sessionUser.getId());
        if (freshUser != null) {
            session.setAttribute("currentUser", freshUser);
        } else {
            freshUser = sessionUser;
        }

        ProfileDTO profileCtx = userService.getProfileContext(freshUser);
        if (profileCtx.getNextTier() != null) {
            req.setAttribute("nextTier", profileCtx.getNextTier());
            req.setAttribute("remainingSpend", profileCtx.getRemainingSpend());
            req.setAttribute("progressPercent", profileCtx.getProgressPercent());
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

        List<Vehicle> vehicles = vehicleService.findByUser(freshUser.getId());
        req.setAttribute("vehicles", vehicles);

        req.setAttribute("activePage", "profile");
        req.getRequestDispatcher("/profile.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        String pathInfo = req.getPathInfo();

        if ("/update".equals(pathInfo)) {
            handleUpdate(req, res, session);
        } else if ("/change-password".equals(pathInfo)) {
            handleChangePassword(req, res, session);
        } else {
            res.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
        User currentUser = (User) session.getAttribute("currentUser");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        try {
            ProfileDTO updateDTO = new ProfileDTO(fullname, phone);
            userService.updateProfile(currentUser.getId(), updateDTO);
            User updatedUser = userService.findById(currentUser.getId());
            session.setAttribute("currentUser", updatedUser);
            res.sendRedirect(req.getContextPath() + "/profile?msg=profile_success");
        } catch (IllegalArgumentException e) {
            session.setAttribute("profileError", e.getMessage());
            res.sendRedirect(req.getContextPath() + "/profile");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("profileError", "Lỗi hệ thống khi cập nhật hồ sơ cá nhân.");
            res.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
        User currentUser = (User) session.getAttribute("currentUser");
        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        try {
            userService.changePassword(currentUser.getId(), oldPassword, newPassword, confirmPassword);
            res.sendRedirect(req.getContextPath() + "/profile?msg=password_success");
        } catch (IllegalArgumentException e) {
            session.setAttribute("profileError", e.getMessage());
            res.sendRedirect(req.getContextPath() + "/profile");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("profileError", "Lỗi hệ thống khi đổi mật khẩu.");
            res.sendRedirect(req.getContextPath() + "/profile");
        }
    }
}
