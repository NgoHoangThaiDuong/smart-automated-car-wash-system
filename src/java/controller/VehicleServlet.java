package controller;

import dao.VehicleDAO;
import model.User;
import model.Vehicle;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/vehicles/*")
public class VehicleServlet extends HttpServlet {

    private final VehicleDAO vehicleRepo = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeJson(res, false, "Chưa đăng nhập! Vui lòng đăng nhập lại.");
            return;
        }

        String action = req.getPathInfo();
        if (action == null || action.equals("/") || action.equals("/list")) {
            User currentUser = (User) session.getAttribute("currentUser");
            List<Vehicle> list = vehicleRepo.findByUserId(currentUser.getId());

            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < list.size(); i++) {
                Vehicle v = list.get(i);
                json.append("{");
                json.append("\"id\":").append(v.getId()).append(",");
                json.append("\"userId\":").append(v.getUserId()).append(",");
                json.append("\"licensePlate\":\"").append(escapeJson(v.getLicensePlate())).append("\",");
                json.append("\"vehicleType\":\"").append(escapeJson(v.getVehicleType())).append("\",");
                json.append("\"color\":\"").append(escapeJson(v.getColor())).append("\"");
                json.append("}");
                if (i < list.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            try (PrintWriter out = res.getWriter()) {
                out.print(json.toString());
                out.flush();
            }
        } else if ("/delete".equals(action)) {
            handleDelete(req, res);
        } else {
            res.setStatus(HttpServletResponse.SC_NOT_FOUND);
            writeJson(res, false, "Endpoint not found");
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
            writeJson(res, false, "Chưa đăng nhập! Vui lòng đăng nhập lại.");
            return;
        }

        String action = req.getPathInfo();
        if ("/add".equals(action)) {
            handleAdd(req, res);
        } else if ("/update".equals(action)) {
            handleUpdate(req, res);
        } else if ("/delete".equals(action)) {
            handleDelete(req, res);
        } else {
            res.setStatus(HttpServletResponse.SC_NOT_FOUND);
            writeJson(res, false, "Endpoint not found");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        String licensePlate = req.getParameter("licensePlate");
        String brand = req.getParameter("brand");
        String model = req.getParameter("model");
        String color = req.getParameter("color");

        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            writeJson(res, false, "Biển số xe không được để trống!");
            return;
        }

        String brandStr = brand != null ? brand.trim() : "";
        String modelStr = model != null ? model.trim() : "";
        String vehicleType = (brandStr + " " + modelStr).trim();
        if (vehicleType.isEmpty()) {
            vehicleType = "Khác";
        }

        try {
            vehicleRepo.create(currentUser.getId(), licensePlate.trim(), vehicleType, color != null ? color.trim() : "");
            writeJson(res, true, "Đăng ký xe mới thành công!");
        } catch (Exception e) {
            writeJson(res, false, "Biển số xe đã được đăng ký hoặc lỗi hệ thống!");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int id = Integer.parseInt(req.getParameter("vehicleId"));
            String licensePlate = req.getParameter("licensePlate");
            String brand = req.getParameter("brand");
            String model = req.getParameter("model");
            String color = req.getParameter("color");

            Vehicle v = vehicleRepo.findById(id);
            if (v != null && v.getUserId() == currentUser.getId()) {
                String brandStr = brand != null ? brand.trim() : "";
                String modelStr = model != null ? model.trim() : "";
                String vehicleType = (brandStr + " " + modelStr).trim();
                if (vehicleType.isEmpty()) {
                    vehicleType = "Khác";
                }

                vehicleRepo.update(id, licensePlate.trim(), vehicleType, color != null ? color.trim() : "");
                writeJson(res, true, "Cập nhật xe thành công!");
            } else {
                writeJson(res, false, "Không có quyền sửa đổi phương tiện này!");
            }
        } catch (Exception e) {
            writeJson(res, false, "Lỗi khi cập nhật xe: " + e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int id = Integer.parseInt(req.getParameter("vehicleId"));
            Vehicle v = vehicleRepo.findById(id);
            if (v != null && v.getUserId() == currentUser.getId()) {
                vehicleRepo.delete(id);
                writeJson(res, true, "Xóa phương tiện thành công!");
            } else {
                writeJson(res, false, "Không có quyền xóa phương tiện này hoặc không tìm thấy!");
            }
        } catch (Exception e) {
            writeJson(res, false, "Lỗi khi xóa phương tiện: " + e.getMessage());
        }
    }

    private void writeJson(HttpServletResponse res, boolean success, String message) throws IOException {
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
