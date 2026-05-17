package controller;

import dto.LoginDTO;
import dto.RegisterDTO;
import exception.AuthException;
import model.User;
import service.AuthService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/login";
        }

        // Xử lý dữ liệu Flash Session (PRG Pattern)
        HttpSession session = req.getSession();
        String flashError = (String) session.getAttribute("flashError");
        if (flashError != null) {
            req.setAttribute("error", flashError);
            session.removeAttribute("flashError");
        }
        String flashUsername = (String) session.getAttribute("flashUsername");
        if (flashUsername != null) {
            req.setAttribute("username", flashUsername);
            session.removeAttribute("flashUsername");
        }
        RegisterDTO flashDto = (RegisterDTO) session.getAttribute("flashDto");
        if (flashDto != null) {
            req.setAttribute("dto", flashDto);
            session.removeAttribute("flashDto");
        }

        switch (action) {
            case "/login":
                req.getRequestDispatcher("/view/auth/login.jsp").forward(req, res);
                break;
            case "/register":
                req.getRequestDispatcher("/view/auth/register.jsp").forward(req, res);
                break;
            case "/logout":
                handleLogout(req, res);
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
            action = "/login";
        }

        switch (action) {
            case "/login":
                handleLogin(req, res);
                break;
            case "/register":
                handleRegister(req, res);
                break;
            case "/logout":
                handleLogout(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        LoginDTO dto = new LoginDTO(
                req.getParameter("username"),
                req.getParameter("password")
        );

        HttpSession session = req.getSession();
        String err = dto.validate();
        if (err != null) {
            session.setAttribute("flashError", err);
            session.setAttribute("flashUsername", dto.getUsername());
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        try {
            User user = authService.login(dto.getUsername(), dto.getPassword());
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(30 * 60); // Session timeout 30 phút
            res.sendRedirect(req.getContextPath() + "/home");
        } catch (AuthException e) {
            session.setAttribute("flashError", e.getMessage());
            session.setAttribute("flashUsername", dto.getUsername());
            res.sendRedirect(req.getContextPath() + "/auth/login");
        } catch (Exception e) {
            session.setAttribute("flashError", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            session.setAttribute("flashUsername", dto.getUsername());
            res.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse res) throws IOException {
        RegisterDTO dto = new RegisterDTO(
                req.getParameter("username"),
                req.getParameter("password"),
                req.getParameter("confirmPassword"),
                req.getParameter("fullname"),
                req.getParameter("phone")
        );

        HttpSession session = req.getSession();
        String err = dto.validate();
        if (err != null) {
            session.setAttribute("flashError", err);
            session.setAttribute("flashDto", dto);
            res.sendRedirect(req.getContextPath() + "/auth/register");
            return;
        }

        try {
            authService.register(dto.getUsername(), dto.getPassword(), dto.getFullname(), dto.getPhone());
            res.sendRedirect(req.getContextPath() + "/auth/login?reg=success");
        } catch (AuthException e) {
            session.setAttribute("flashError", e.getMessage());
            session.setAttribute("flashDto", dto);
            res.sendRedirect(req.getContextPath() + "/auth/register");
        } catch (Exception e) {
            session.setAttribute("flashError", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            session.setAttribute("flashDto", dto);
            res.sendRedirect(req.getContextPath() + "/auth/register");
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        res.sendRedirect(req.getContextPath() + "/auth/login");
    }
}
