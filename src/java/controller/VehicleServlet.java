package controller;

import model.User;
import model.Vehicle;
import service.VehicleService;

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

        req.setAttribute("vehicles", vehicleService.findByUserId(currentUser.getId()));
        req.setAttribute("activePage", "vehicles");
        req.getRequestDispatcher("/WEB-INF/view/customer/vehicles.jsp").forward(req, res);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws IOException {
        HttpSession session = req.getSession();
        Vehicle formData = vehicleFromRequest(req);
        try {
            vehicleService.createCustomerVehicle(
                    currentUser.getId(),
                    formData.getLicensePlate(),
                    formData.getBrand(),
                    formData.getModel(),
                    formData.getColor()
            );
            session.setAttribute("vehicleMessage", "Thêm phương tiện thành công.");
        } catch (IllegalArgumentException e) {
            session.setAttribute("vehicleError", e.getMessage());
            session.setAttribute("vehicleFormMode", "add");
            session.setAttribute("vehicleFormData", formData);
        } catch (Exception e) {
            log("Cannot add customer vehicle", e);
            session.setAttribute("vehicleError", "Không thể thêm phương tiện lúc này.");
            session.setAttribute("vehicleFormMode", "add");
            session.setAttribute("vehicleFormData", formData);
        }
        res.sendRedirect(req.getContextPath() + "/vehicles");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws IOException {
        HttpSession session = req.getSession();
        Vehicle formData = vehicleFromRequest(req);
        try {
            int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
            formData.setId(vehicleId);
            vehicleService.updateCustomerVehicle(
                    vehicleId,
                    currentUser.getId(),
                    formData.getLicensePlate(),
                    formData.getBrand(),
                    formData.getModel(),
                    formData.getColor()
            );
            session.setAttribute("vehicleMessage", "Cập nhật phương tiện thành công.");
        } catch (NumberFormatException e) {
            session.setAttribute("vehicleError", "Mã phương tiện không hợp lệ.");
        } catch (IllegalArgumentException e) {
            session.setAttribute("vehicleError", e.getMessage());
            session.setAttribute("vehicleFormMode", "edit");
            session.setAttribute("vehicleFormData", formData);
        } catch (Exception e) {
            log("Cannot update customer vehicle", e);
            session.setAttribute("vehicleError", "Không thể cập nhật phương tiện lúc này.");
            session.setAttribute("vehicleFormMode", "edit");
            session.setAttribute("vehicleFormData", formData);
        }
        res.sendRedirect(req.getContextPath() + "/vehicles");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse res, User currentUser)
            throws IOException {
        HttpSession session = req.getSession();
        try {
            int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
            vehicleService.deleteCustomerVehicle(vehicleId, currentUser.getId());
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

    private void moveFlash(HttpSession session, HttpServletRequest req, String name) {
        Object value = session.getAttribute(name);
        if (value != null) {
            req.setAttribute(name, value);
            session.removeAttribute(name);
        }
    }
}
