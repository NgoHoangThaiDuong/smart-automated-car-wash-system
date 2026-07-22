package controller;

import model.WashService;
import service.WashServiceService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/services", "/admin/services/*"})
public class AdminServiceServlet extends HttpServlet {

    private WashServiceService washServiceService = new WashServiceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        handleServiceList(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        switch (pathInfo) {
            case "/create":
                handleCreateService(req, res);
                break;
            case "/update":
                handleUpdateService(req, res);
                break;
            case "/toggle-status":
                handleToggleServiceStatus(req, res);
                break;
            case "/delete":
                handleDeleteService(req, res);
                break;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleServiceList(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<WashService> services = washServiceService.getAllServicesWithBookingCount();
        req.setAttribute("services", services);

        HttpSession session = req.getSession(false);
        if (session != null) {
            String msg = (String) session.getAttribute("adminMsg");
            String err = (String) session.getAttribute("adminError");
            if (msg != null) { req.setAttribute("adminMsg", msg); session.removeAttribute("adminMsg"); }
            if (err != null) { req.setAttribute("adminError", err); session.removeAttribute("adminError"); }
        }

        req.getRequestDispatcher("/WEB-INF/view/admin/services.jsp").forward(req, res);
    }

    private void handleCreateService(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            int duration = Integer.parseInt(req.getParameter("durationMinutes"));
            boolean isActive = req.getParameter("isActive") != null;

            WashService ws = new WashService();
            ws.setName(name);
            ws.setDescription(description);
            ws.setPrice(price);
            ws.setDurationMinutes(duration);
            ws.setActive(isActive);

            washServiceService.createService(ws);
            session.setAttribute("adminMsg", "New wash service created successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleUpdateService(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            int duration = Integer.parseInt(req.getParameter("durationMinutes"));
            boolean isActive = req.getParameter("isActive") != null;

            WashService ws = new WashService();
            ws.setId(id);
            ws.setName(name);
            ws.setDescription(description);
            ws.setPrice(price);
            ws.setDurationMinutes(duration);
            ws.setActive(isActive);

            washServiceService.updateService(ws);
            session.setAttribute("adminMsg", "Wash service updated successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleToggleServiceStatus(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            washServiceService.toggleServiceStatus(id);
            session.setAttribute("adminMsg", "Service status toggled successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }

    private void handleDeleteService(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            washServiceService.deleteService(id);
            session.setAttribute("adminMsg", "Wash service deleted successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/admin/services");
    }
}
