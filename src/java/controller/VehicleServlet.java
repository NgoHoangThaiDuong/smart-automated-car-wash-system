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

@WebServlet("/vehicles/*")
public class VehicleServlet extends HttpServlet {

    private final VehicleDAO vehicleRepo = new VehicleDAO();

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
        if ("/add".equals(pathInfo)) {
            handleAdd(req, res, session);
        } else if ("/update".equals(pathInfo)) {
            handleUpdate(req, res, session);
        } else if ("/delete".equals(pathInfo)) {
            handleDelete(req, res, session);
        } else {
            res.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
        User currentUser = (User) session.getAttribute("currentUser");

        String licensePlate = req.getParameter("licensePlate");
        String brand = req.getParameter("brand");
        String model = req.getParameter("model");
        String color = req.getParameter("color");

        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            session.setAttribute("vehicleError", "Biển số xe không được để trống!");
            res.sendRedirect(req.getContextPath() + "/dashboard");
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
            res.sendRedirect(req.getContextPath() + "/dashboard?msg=vehicle_add_success");
        } catch (Exception e) {
            session.setAttribute("vehicleError", "Biển số xe đã được đăng ký hoặc xảy ra lỗi hệ thống!");
            res.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
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
                res.sendRedirect(req.getContextPath() + "/dashboard?msg=vehicle_update_success");
            } else {
                session.setAttribute("vehicleError", "Không có quyền sửa đổi phương tiện này!");
                res.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } catch (Exception e) {
            session.setAttribute("vehicleError", "Lỗi khi cập nhật xe: " + e.getMessage());
            res.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int id = Integer.parseInt(req.getParameter("vehicleId"));
            Vehicle v = vehicleRepo.findById(id);
            if (v != null && v.getUserId() == currentUser.getId()) {
                vehicleRepo.delete(id);
                res.sendRedirect(req.getContextPath() + "/dashboard?msg=vehicle_delete_success");
            } else {
                session.setAttribute("vehicleError", "Không có quyền xóa phương tiện này hoặc không tìm thấy!");
                res.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } catch (Exception e) {
            session.setAttribute("vehicleError", "Lỗi khi xóa phương tiện: " + e.getMessage());
            res.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }
}
