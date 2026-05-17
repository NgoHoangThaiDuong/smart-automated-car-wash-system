package controller;

import model.User;
import repository.UserRepository;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/profile/*")
public class ProfileServlet extends HttpServlet {

    private final UserRepository userRepo = new UserRepository();

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

            try {
                userRepo.updateProfile(currentUser.getId(), fullname != null ? fullname.trim() : "", phone != null ? phone.trim() : "");
                // Cập nhật lại thông tin user trong session
                User updatedUser = userRepo.findById(currentUser.getId());
                session.setAttribute("currentUser", updatedUser);
                res.sendRedirect(req.getContextPath() + "/profile/view?success=1");
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi cập nhật hồ sơ: " + e.getMessage());
                req.getRequestDispatcher("/view/profile/view.jsp").forward(req, res);
            }
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
