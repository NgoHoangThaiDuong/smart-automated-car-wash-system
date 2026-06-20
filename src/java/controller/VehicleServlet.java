package controller;

import service.VehicleService;
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

    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/profile");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        String pathInfo = req.getPathInfo();

        if ("/add".equals(pathInfo)) {
            handleAdd(req, res, session);
        } else if ("/update".equals(pathInfo)) {
            handleUpdate(req, res, session);
        } else if ("/delete".equals(pathInfo)) {
            handleDelete(req, res, session);
        } else {
            res.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
        User currentUser = (User) session.getAttribute("currentUser");

        String licensePlate = req.getParameter("licensePlate");
        String brand = req.getParameter("brand");
        String model = req.getParameter("model");
        String color = req.getParameter("color");

        licensePlate = licensePlate == null ? "" : licensePlate.trim().toUpperCase();
        brand = brand == null ? "" : brand.trim();
        model = model == null ? "" : model.trim();
        color = color == null ? "" : color.trim();

        if (!brand.isEmpty()) {
            brand = brand.substring(0, 1).toUpperCase() + brand.substring(1).toLowerCase();
        }

        if (!model.isEmpty()) {
            model = model.substring(0, 1).toUpperCase() + model.substring(1).toLowerCase();
        }

        if (!color.isEmpty()) {
            color = color.substring(0, 1).toUpperCase() + color.substring(1).toLowerCase();
        }

        if (licensePlate.isEmpty()) {
            session.setAttribute("vehicleError", "Biển số xe không được để trống!");
            res.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        if (!licensePlate.matches("^[0-9]{2}[A-Z]{1,2}-[0-9]{4,5}$")) {
            session.setAttribute("vehicleError", "Biển số xe không hợp lệ. Ví dụ: 29A-12345");
            res.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        if (vehicleService.existsByPlate(licensePlate)) {
            session.setAttribute("vehicleError", "Biển số xe đã tồn tại!");
            res.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        try {
            vehicleService.createVehicle(currentUser.getId(), licensePlate, brand, model, color);
            res.sendRedirect(req.getContextPath() + "/profile?msg=vehicle_add_success");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("vehicleError", "Lỗi khi thêm xe!");
            res.sendRedirect(req.getContextPath() + "/profile");
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

            licensePlate = licensePlate == null ? "" : licensePlate.trim().toUpperCase();
            brand = brand == null ? "" : brand.trim();
            model = model == null ? "" : model.trim();
            color = color == null ? "" : color.trim();

            if (!brand.isEmpty()) {
                brand = brand.substring(0, 1).toUpperCase() + brand.substring(1).toLowerCase();
            }

            if (!model.isEmpty()) {
                model = model.substring(0, 1).toUpperCase() + model.substring(1).toLowerCase();
            }

            if (!color.isEmpty()) {
                color = color.substring(0, 1).toUpperCase() + color.substring(1).toLowerCase();
            }

            if (licensePlate.isEmpty()) {
                session.setAttribute("vehicleError", "Biển số xe không được để trống!");
                res.sendRedirect(req.getContextPath() + "/profile");
                return;
            }

            if (!licensePlate.matches("^[0-9]{2}[A-Z]{1,2}-[0-9]{4,5}$")) {
                session.setAttribute("vehicleError", "Biển số xe không hợp lệ. Ví dụ: 29A-12345");
                res.sendRedirect(req.getContextPath() + "/profile");
                return;
            }

            if (vehicleService.existsByPlateExceptId(licensePlate, id)) {
                session.setAttribute("vehicleError", "Biển số xe đã tồn tại!");
                res.sendRedirect(req.getContextPath() + "/profile");
                return;
            }

            Vehicle v = vehicleService.findById(id);

            if (v != null && v.getUserId() == currentUser.getId()) {
                vehicleService.updateVehicle(id, licensePlate, brand, model, color);
                res.sendRedirect(req.getContextPath() + "/profile?msg=vehicle_update_success");
            } else {
                session.setAttribute("vehicleError", "Không có quyền sửa xe này!");
                res.sendRedirect(req.getContextPath() + "/profile");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("vehicleError", "Lỗi khi cập nhật xe!");
            res.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws IOException {
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            int id = Integer.parseInt(req.getParameter("vehicleId"));
            Vehicle v = vehicleService.findById(id);
            if (v != null && v.getUserId() == currentUser.getId()) {
                vehicleService.deleteVehicle(id);
                res.sendRedirect(req.getContextPath() + "/profile?msg=vehicle_delete_success");
            } else {
                session.setAttribute("vehicleError", "Không có quyền xóa phương tiện này hoặc không tìm thấy!");
                res.sendRedirect(req.getContextPath() + "/profile");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("vehicleError", "Lỗi khi xóa phương tiện: " + e.getMessage());
            res.sendRedirect(req.getContextPath() + "/profile");
        }
    }
}
