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
import java.util.Map;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        System.out.println("DEBUG GET PATH: " + pathInfo);

        if (pathInfo == null || "/".equals(pathInfo) || "/login".equals(pathInfo)) {

            System.out.println("Forward to login.jsp");
            req.getRequestDispatcher("/login.jsp").forward(req, res);

        } else if ("/register".equals(pathInfo)) {

            System.out.println("Forward to register.jsp");
            req.getRequestDispatcher("/register.jsp").forward(req, res);

        } else if ("/logout".equals(pathInfo)) {

            System.out.println("Logout");
            handleLogout(req, res);

        } else {

            System.out.println("404 NOT FOUND");
            res.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String pathInfo = req.getPathInfo();
        System.out.println("DEBUG POST PATH: " + pathInfo);

        if ("/login".equals(pathInfo)) {

            handleLogin(req, res);

        } else if ("/register".equals(pathInfo)) {

            handleRegister(req, res);

        } else {

            System.out.println("POST 404");
            res.sendError(404);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        System.out.println("=== HANDLE LOGIN ===");

        String usernameVal = req.getParameter("username");
        String passwordVal = req.getParameter("password");

        System.out.println("Username: " + usernameVal);

        LoginDTO dto = new LoginDTO(usernameVal, passwordVal);
        String err = dto.validate();

        if (err != null) {

            System.out.println("LOGIN VALIDATE ERROR: " + err);

            req.setAttribute("error", err);
            req.setAttribute("username", usernameVal);

            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        try {

            System.out.println("Calling authService.login()");

            User user = authService.login(dto.getUsername(), dto.getPassword());

            System.out.println("LOGIN SUCCESS");

            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(30 * 60);

            System.out.println("Redirect dashboard");

            res.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (AuthException e) {

            System.out.println("AUTH ERROR LOGIN: " + e.getMessage());

            req.setAttribute("error", e.getMessage());
            req.setAttribute("username", usernameVal);

            req.getRequestDispatcher("/login.jsp").forward(req, res);

        } catch (Exception e) {

            System.out.println("SYSTEM ERROR LOGIN");
            e.printStackTrace();

            req.setAttribute("error", "Hệ thống đang bận, vui lòng thử lại sau.");
            req.setAttribute("username", usernameVal);

            req.getRequestDispatcher("/login.jsp").forward(req, res);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        System.out.println("=== HANDLE REGISTER ===");

        String usernameVal = req.getParameter("username");
        String passwordVal = req.getParameter("password");
        String confirmPasswordVal = req.getParameter("confirmPassword");
        String fullnameVal = req.getParameter("fullname");
        String phoneVal = req.getParameter("phone");

        System.out.println("Username: " + usernameVal);
        System.out.println("Fullname: " + fullnameVal);
        System.out.println("Phone: " + phoneVal);

        RegisterDTO dto = new RegisterDTO(
                usernameVal,
                passwordVal,
                confirmPasswordVal,
                fullnameVal,
                phoneVal
        );

        Map<String, String> err = dto.validate();

        if (!err.isEmpty()) {

            System.out.println("REGISTER VALIDATE ERROR");
            System.out.println(err);

            req.setAttribute("error", err);
            req.setAttribute("username", usernameVal);
            req.setAttribute("fullname", fullnameVal);
            req.setAttribute("phone", phoneVal);

            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }

        try {

            System.out.println("Calling authService.register()");

            authService.register(
                    dto.getUsername(),
                    dto.getPassword(),
                    dto.getFullname(),
                    dto.getPhone()
            );

            System.out.println("REGISTER SUCCESS");

            String redirectURL = req.getContextPath() + "/auth/login?reg=success";

            System.out.println("Redirect URL: " + redirectURL);

            res.sendRedirect(redirectURL);

        } catch (AuthException e) {

            System.out.println("AUTH ERROR REGISTER: " + e.getMessage());

            req.setAttribute("error", e.getMessage());
            req.setAttribute("username", usernameVal);
            req.setAttribute("fullname", fullnameVal);
            req.setAttribute("phone", phoneVal);

            req.getRequestDispatcher("/register.jsp").forward(req, res);

        } catch (Exception e) {

            System.out.println("SYSTEM ERROR REGISTER");
            e.printStackTrace();

            req.setAttribute("error", "Hệ thống đang bận, vui lòng thử lại sau.");
            req.setAttribute("username", usernameVal);
            req.setAttribute("fullname", fullnameVal);
            req.setAttribute("phone", phoneVal);

            req.getRequestDispatcher("/register.jsp").forward(req, res);
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        System.out.println("=== LOGOUT ===");

        HttpSession session = req.getSession(false);

        if (session != null) {

            System.out.println("Invalidate session");
            session.invalidate();
        }

        System.out.println("Redirect login");

        res.sendRedirect(req.getContextPath() + "/auth/login");
    }
}