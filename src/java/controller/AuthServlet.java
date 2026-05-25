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
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo) || "/login".equals(pathInfo)) {
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        } else if ("/register".equals(pathInfo)) {
            req.getRequestDispatcher("/register.jsp").forward(req, res);
        } else if ("/logout".equals(pathInfo)) {
            handleLogout(req, res);
        } else {
            res.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String pathInfo = req.getPathInfo();
        
        if ("/login".equals(pathInfo)) {
            handleLogin(req, res);
        } else if ("/register".equals(pathInfo)) {
            handleRegister(req, res);
        } else {
            res.sendError(404);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String usernameVal = req.getParameter("username");
        String passwordVal = req.getParameter("password");

        LoginDTO dto = new LoginDTO(usernameVal, passwordVal);
        String err = dto.validate();
        
        if (err != null) {
            req.setAttribute("error", err);
            req.setAttribute("username", usernameVal);
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        try {
            User user = authService.login(dto.getUsername(), dto.getPassword());
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(30 * 60);
            
            // Redirect after successful POST (PRG Pattern)
            res.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (AuthException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("username", usernameVal);
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Hệ thống đang bận, vui lòng thử lại sau.");
            req.setAttribute("username", usernameVal);
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String usernameVal = req.getParameter("username");
        String passwordVal = req.getParameter("password");
        String confirmPasswordVal = req.getParameter("confirmPassword");
        String fullnameVal = req.getParameter("fullname");
        String phoneVal = req.getParameter("phone");

        RegisterDTO dto = new RegisterDTO(usernameVal, passwordVal, confirmPasswordVal, fullnameVal, phoneVal);
        String err = dto.validate();
        
        if (err != null) {
            req.setAttribute("error", err);
            req.setAttribute("username", usernameVal);
            req.setAttribute("fullname", fullnameVal);
            req.setAttribute("phone", phoneVal);
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }

        try {
            authService.register(dto.getUsername(), dto.getPassword(), dto.getFullname(), dto.getPhone());
            
            // Redirect to login page after successful registration (PRG Pattern)
            res.sendRedirect(req.getContextPath() + "/auth/login?reg=success");
        } catch (AuthException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("username", usernameVal);
            req.setAttribute("fullname", fullnameVal);
            req.setAttribute("phone", phoneVal);
            req.getRequestDispatcher("/register.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "Hệ thống đang bận, vui lòng thử lại sau.");
            req.setAttribute("username", usernameVal);
            req.setAttribute("fullname", fullnameVal);
            req.setAttribute("phone", phoneVal);
            req.getRequestDispatcher("/register.jsp").forward(req, res);
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
