package controller;

import dto.PageResult;
import dto.WashHistoryDTO;
import model.User;
import model.Vehicle;
import model.WashService;
import service.VehicleService;
import service.WashHistoryService;
import service.WashServiceService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/wash-history")
public class WashHistoryServlet extends HttpServlet {

    private final WashHistoryService washHistoryService = new WashHistoryService();
    private final VehicleService vehicleService = new VehicleService();
    private final WashServiceService washServiceService = new WashServiceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        int userId = currentUser.getId();

        // Read and normalize query parameters
        String search = req.getParameter("search");
        String period = req.getParameter("period");
        Integer serviceId = washHistoryService.parsePositiveId(req.getParameter("serviceId"));
        Integer vehicleId = washHistoryService.parsePositiveId(req.getParameter("vehicleId"));
        int page = washHistoryService.normalizePage(req.getParameter("page"));

        // Fetch paginated wash history
        PageResult<WashHistoryDTO> result = washHistoryService.getPage(
                userId, search, period, serviceId, vehicleId, page);

        // Fetch filter options (customer's own vehicles and all active services)
        List<Vehicle> vehicles = vehicleService.findByUserId(userId);
        List<WashService> services = washServiceService.getActiveServices();

        // Preserve normalized parameters for JSP
        req.setAttribute("pageResult", result);
        req.setAttribute("vehicles", vehicles);
        req.setAttribute("services", services);
        req.setAttribute("paramSearch", search == null ? "" : search.trim());
        req.setAttribute("paramPeriod", washHistoryService.normalizePeriod(period));
        req.setAttribute("paramServiceId", serviceId);
        req.setAttribute("paramVehicleId", vehicleId);
        req.setAttribute("activePage", "wash-history");

        req.getRequestDispatcher("/WEB-INF/view/customer/wash-history.jsp").forward(req, res);
    }
}
