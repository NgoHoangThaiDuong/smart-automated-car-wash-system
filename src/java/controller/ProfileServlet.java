package controller;

import dao.UserDAO;
import dao.LoyaltyTierDAO;
import model.User;
import model.LoyaltyTier;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/profile/*")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userRepo = new UserDAO();
    private final LoyaltyTierDAO tierRepo = new LoyaltyTierDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeJson(res, false, "Chưa đăng nhập! Vui lòng đăng nhập lại.", null);
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

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":true,");
        json.append("\"user\":{");
        json.append("\"id\":").append(freshestUser.getId()).append(",");
        json.append("\"username\":\"").append(escapeJson(freshestUser.getUsername())).append("\",");
        json.append("\"fullname\":\"").append(escapeJson(freshestUser.getFullname())).append("\",");
        json.append("\"phone\":\"").append(escapeJson(freshestUser.getPhone())).append("\",");
        json.append("\"role\":\"").append(escapeJson(freshestUser.getRole())).append("\",");
        json.append("\"pointsBalance\":").append(freshestUser.getPointsBalance()).append(",");
        json.append("\"lifetimeSpent\":").append(freshestUser.getLifetimeSpent());
        
        if (freshestUser.getLoyaltyTier() != null) {
            LoyaltyTier lt = freshestUser.getLoyaltyTier();
            json.append(",\"loyaltyTier\":{");
            json.append("\"id\":").append(lt.getId()).append(",");
            json.append("\"name\":\"").append(escapeJson(lt.getName())).append("\",");
            json.append("\"pointMultiplier\":").append(lt.getPointMultiplier()).append(",");
            json.append("\"bookingWindowDays\":").append(lt.getBookingWindowDays()).append(",");
            json.append("\"minWashes\":").append(lt.getMinWashes()).append(",");
            json.append("\"minSpend\":").append(lt.getMinSpend());
            json.append("}");
        }
        json.append("}");

        if (nextTier != null) {
            double remainingSpend = nextTier.getMinSpend() - freshestUser.getLifetimeSpent();
            double progressPercent = Math.min(100.0, (freshestUser.getLifetimeSpent() / nextTier.getMinSpend()) * 100.0);
            json.append(",\"nextTier\":{");
            json.append("\"name\":\"").append(escapeJson(nextTier.getName())).append("\",");
            json.append("\"minSpend\":").append(nextTier.getMinSpend());
            json.append("},");
            json.append("\"progressPercent\":").append(progressPercent).append(",");
            json.append("\"remainingSpend\":").append(remainingSpend);
        } else {
            json.append(",\"nextTier\":null");
        }
        json.append("}");

        try (PrintWriter out = res.getWriter()) {
            out.print(json.toString());
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeJson(res, false, "Chưa đăng nhập! Vui lòng đăng nhập lại.", null);
            return;
        }

        String action = req.getPathInfo();
        if ("/update".equals(action)) {
            User currentUser = (User) session.getAttribute("currentUser");
            String fullname = req.getParameter("fullname");
            String phone = req.getParameter("phone");

            if (phone != null && !phone.trim().isEmpty() && !phone.trim().matches("^0\\d{9}$")) {
                writeJson(res, false, "Số điện thoại không hợp lệ (phải bắt đầu bằng số 0 và có đúng 10 chữ số)!", null);
                return;
            }

            try {
                userRepo.updateProfile(currentUser.getId(), fullname != null ? fullname.trim() : "", phone != null ? phone.trim() : "");
                User updatedUser = userRepo.findById(currentUser.getId());
                session.setAttribute("currentUser", updatedUser);
                writeJson(res, true, "Cập nhật hồ sơ thành công!", null);
            } catch (Exception e) {
                writeJson(res, false, "Lỗi hệ thống khi cập nhật hồ sơ cá nhân.", null);
            }
        } else {
            res.setStatus(HttpServletResponse.SC_NOT_FOUND);
            writeJson(res, false, "Endpoint not found", null);
        }
    }

    private void writeJson(HttpServletResponse res, boolean success, String message, String extraJson) throws IOException {
        try (PrintWriter out = res.getWriter()) {
            StringBuilder sb = new StringBuilder();
            sb.append("{\"success\":").append(success);
            sb.append(",\"message\":\"").append(escapeJson(message)).append("\"");
            if (extraJson != null) {
                sb.append(",").append(extraJson);
            }
            sb.append("}");
            out.print(sb.toString());
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
