package controller;

import model.User;
import model.Vehicle;
import mylib.VehicleImageStorage;
import service.VehicleService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;

@WebServlet({"/vehicles", "/vehicles/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class VehicleServlet extends HttpServlet {

    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User currentUser = getCurrentCustomer(req, res);
        if (currentUser == null) {
            return;
        }

        String path = req.getPathInfo();
        if (path == null || "/".equals(path)) {
            showVehiclePage(req, res, currentUser);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User currentUser = getCurrentCustomer(req, res);
        if (currentUser == null) {
            return;
        }

        String path = req.getPathInfo();
        if ("/add".equals(path)) {
            handleAdd(req, res, currentUser);
        } else if ("/update".equals(path)) {
            handleUpdate(req, res, currentUser);
        } else if ("/delete".equals(path)) {
            handleDelete(req, res, currentUser);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showVehiclePage(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlash(session, req, "vehicleMessage");
            moveFlash(session, req, "vehicleError");
            moveFlash(session, req, "vehicleFormMode");
            moveFlash(session, req, "vehicleFormData");
        }

        req.setAttribute("vehicles", vehicleService.findByUser(currentUser.getId()));
        req.setAttribute("activePage", "vehicles");
        req.getRequestDispatcher("/WEB-INF/view/customer/vehicles.jsp").forward(req, res);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws IOException {
        HttpSession session = req.getSession();
        Vehicle formData = vehicleFromRequest(req);
        String uploadedImagePath = null;
        try {
            validateVehicleForm(formData);
            uploadedImagePath = VehicleImageStorage.save(req.getPart("vehicleImage"));
            String imagePath = uploadedImagePath == null
                    ? VehicleService.DEFAULT_IMAGE_PATH : uploadedImagePath;
            formData.setImagePath(imagePath);
            vehicleService.create(
                    currentUser.getId(),
                    formData.getLicensePlate(),
                    formData.getBrand(),
                    formData.getModel(),
                    formData.getColor(),
                    imagePath
            );
            session.setAttribute("vehicleMessage", "Thêm phương tiện thành công.");
        } catch (IllegalStateException e) {
            VehicleImageStorage.delete(uploadedImagePath);
            setFormError(session, "Ảnh không được vượt quá 5 MB.", "add", formData);
        } catch (IllegalArgumentException e) {
            VehicleImageStorage.delete(uploadedImagePath);
            setFormError(session, e.getMessage(), "add", formData);
        } catch (ServletException e) {
            VehicleImageStorage.delete(uploadedImagePath);
            setFormError(session, "Không thể đọc file ảnh đã chọn.", "add", formData);
        } catch (Exception e) {
            VehicleImageStorage.delete(uploadedImagePath);
            log("Cannot add customer vehicle", e);
            setFormError(session, "Không thể thêm phương tiện lúc này.", "add", formData);
        }
        res.sendRedirect(req.getContextPath() + "/vehicles");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws IOException {
        HttpSession session = req.getSession();
        Vehicle formData = vehicleFromRequest(req);
        String uploadedImagePath = null;
        String oldImagePath = null;
        try {
            int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
            formData.setId(vehicleId);
            Vehicle existing = vehicleService.findById(vehicleId, currentUser.getId());
            if (existing == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy phương tiện thuộc tài khoản của bạn.");
            }

            validateVehicleForm(formData);
            oldImagePath = existing.getImagePath();
            uploadedImagePath = VehicleImageStorage.save(req.getPart("vehicleImage"));
            String imagePath = uploadedImagePath == null ? oldImagePath : uploadedImagePath;
            formData.setImagePath(imagePath);
            vehicleService.update(
                    vehicleId,
                    currentUser.getId(),
                    formData.getLicensePlate(),
                    formData.getBrand(),
                    formData.getModel(),
                    formData.getColor(),
                    imagePath
            );
            if (uploadedImagePath != null) {
                VehicleImageStorage.delete(oldImagePath);
            }
            session.setAttribute("vehicleMessage", "Cập nhật phương tiện thành công.");
        } catch (NumberFormatException e) {
            VehicleImageStorage.delete(uploadedImagePath);
            session.setAttribute("vehicleError", "Mã phương tiện không hợp lệ.");
        } catch (IllegalStateException e) {
            VehicleImageStorage.delete(uploadedImagePath);
            formData.setImagePath(oldImagePath);
            setFormError(session, "Ảnh không được vượt quá 5 MB.", "edit", formData);
        } catch (IllegalArgumentException e) {
            VehicleImageStorage.delete(uploadedImagePath);
            formData.setImagePath(oldImagePath);
            setFormError(session, e.getMessage(), "edit", formData);
        } catch (ServletException e) {
            VehicleImageStorage.delete(uploadedImagePath);
            formData.setImagePath(oldImagePath);
            setFormError(session, "Không thể đọc file ảnh đã chọn.", "edit", formData);
        } catch (Exception e) {
            VehicleImageStorage.delete(uploadedImagePath);
            formData.setImagePath(oldImagePath);
            log("Cannot update customer vehicle", e);
            setFormError(session, "Không thể cập nhật phương tiện lúc này.", "edit", formData);
        }
        res.sendRedirect(req.getContextPath() + "/vehicles");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws IOException {
        HttpSession session = req.getSession();
        try {
            int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
            vehicleService.delete(vehicleId, currentUser.getId());
            session.setAttribute("vehicleMessage", "Xóa phương tiện thành công.");
        } catch (NumberFormatException e) {
            session.setAttribute("vehicleError", "Mã phương tiện không hợp lệ.");
        } catch (IllegalArgumentException e) {
            session.setAttribute("vehicleError", e.getMessage());
        } catch (Exception e) {
            log("Cannot delete customer vehicle", e);
            session.setAttribute("vehicleError", "Không thể xóa phương tiện lúc này.");
        }
        res.sendRedirect(req.getContextPath() + "/vehicles");
    }

    private User getCurrentCustomer(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return null;
        }
        if (!"CUSTOMER".equals(currentUser.getRole())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        return currentUser;
    }

    private Vehicle vehicleFromRequest(HttpServletRequest req) {
        Vehicle vehicle = new Vehicle();
        vehicle.setLicensePlate(req.getParameter("licensePlate"));
        vehicle.setBrand(req.getParameter("brand"));
        vehicle.setModel(req.getParameter("model"));
        vehicle.setColor(req.getParameter("color"));
        return vehicle;
    }

    private void validateVehicleForm(Vehicle vehicle) {
        vehicleService.validateVehicle(
                vehicleService.normalizeLicensePlate(vehicle.getLicensePlate()),
                vehicleService.normalizeText(vehicle.getBrand()),
                vehicleService.normalizeText(vehicle.getModel()),
                vehicleService.normalizeText(vehicle.getColor())
        );
    }

    private void moveFlash(HttpSession session, HttpServletRequest req, String name) {
        Object value = session.getAttribute(name);
        if (value != null) {
            req.setAttribute(name, value);
            session.removeAttribute(name);
        }
    }

    private void setFormError(HttpSession session, String message,
            String formMode, Vehicle formData) {
        session.setAttribute("vehicleError", message);
        session.setAttribute("vehicleFormMode", formMode);
        session.setAttribute("vehicleFormData", formData);
    }
}
