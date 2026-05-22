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
import java.io.PrintWriter;

@WebServlet("/api/auth/*")
public class AuthServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getPathInfo();
        if ("/logout".equals(action)) {
            handleLogout(req, res);
        } else {
            res.setStatus(HttpServletResponse.SC_NOT_FOUND);
            writeJson(res, false, "Endpoint not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getPathInfo();
        
        if ("/login".equals(action)) {
            handleLogin(req, res);
        } else if ("/register".equals(action)) {
            handleRegister(req, res);
        } else if ("/logout".equals(action)) {
            handleLogout(req, res);
        } else {
            res.setStatus(HttpServletResponse.SC_NOT_FOUND);
            writeJson(res, false, "Endpoint not found");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        LoginDTO dto = new LoginDTO(
                req.getParameter("username"),
                req.getParameter("password")
        );

        String err = dto.validate();
        if (err != null) {
            writeJson(res, false, err);
            return;
        }

        try {
            User user = authService.login(dto.getUsername(), dto.getPassword());
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(30 * 60);
            writeJson(res, true, "Đăng nhập thành công!");
        } catch (AuthException e) {
            writeJson(res, false, e.getMessage());
        } catch (Exception e) {
            writeJson(res, false, "Hệ thống đang bận, vui lòng thử lại sau.");
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

        String err = dto.validate();
        if (err != null) {
            writeJson(res, false, err);
            return;
        }

        try {
            authService.register(dto.getUsername(), dto.getPassword(), dto.getFullname(), dto.getPhone());
            writeJson(res, true, "Đăng ký thành công! Vui lòng đăng nhập.");
        } catch (AuthException e) {
            writeJson(res, false, e.getMessage());
        } catch (Exception e) {
            writeJson(res, false, "Hệ thống đang bận, vui lòng thử lại sau.");
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        writeJson(res, true, "Đăng xuất thành công!");
    }

    private void writeJson(HttpServletResponse res, boolean success, String message) throws IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        try (PrintWriter out = res.getWriter()) {
            out.print("{\"success\":" + success + ",\"message\":\"" + escapeJson(message) + "\"}");
            out.flush();
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            switch (ch) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (ch < ' ') {
                        String t = "000" + Integer.toHexString(ch);
                        sb.append("\\u").append(t.substring(t.length() - 4));
                    } else {
                        sb.append(ch);
                    }
            }
        }
        return sb.toString();
    }
}
