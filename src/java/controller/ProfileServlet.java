package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/profile/*")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userRepo = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = req.getPathInfo();
        if ("/update".equals(pathInfo)) {
            handleUpdate(req, res, session);
        } else {
            res.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
        User currentUser = (User) session.getAttribute("currentUser");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        if (phone != null && !phone.trim().isEmpty() && !phone.trim().matches("^0\\d{9}$")) {
            session.setAttribute("profileError", "Số điện thoại không hợp lệ (phải bắt đầu bằng số 0 và có đúng 10 chữ số)!");
            res.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        try {
            userRepo.updateProfile(currentUser.getId(), fullname != null ? fullname.trim() : "", phone != null ? phone.trim() : "");
            User updatedUser = userRepo.findById(currentUser.getId());
            session.setAttribute("currentUser", updatedUser);
            
            res.sendRedirect(req.getContextPath() + "/dashboard?msg=profile_success");
        } catch (Exception e) {
            session.setAttribute("profileError", "Lỗi hệ thống khi cập nhật hồ sơ cá nhân.");
            res.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }
}
