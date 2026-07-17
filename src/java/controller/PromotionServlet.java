package controller;

import model.Promotion;
import model.User;
import service.PromotionService;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet({
    "/admin/promotions",
    "/admin/promotions/*"
})
public class PromotionServlet extends HttpServlet {

    private final PromotionService promotionService
            = new PromotionService();

    private final UserService userService
            = new UserService();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse res)
            throws ServletException, IOException {

        User currentAdmin = getCurrentAdmin(req, res);

        if (currentAdmin == null) {
            return;
        }

        String path = req.getPathInfo();

        if (path == null || "/".equals(path)) {
            showPromotionList(req, res);
        } else if ("/new".equals(path)) {
            showCreateForm(req, res);
        } else if ("/edit".equals(path)) {
            showEditForm(req, res);
        } else {
            res.sendError(
                    HttpServletResponse.SC_NOT_FOUND
            );
        }
    }
private void showCreateForm(
        HttpServletRequest req,
        HttpServletResponse res)
        throws ServletException, IOException {

    Promotion promotion = new Promotion();

    promotion.setDiscountType("PERCENT");
    promotion.setStatus("ACTIVE");

    req.setAttribute(
            "promotion",
            promotion
    );

    req.setAttribute(
            "activePage",
            "promotions"
    );

    req.getRequestDispatcher(
            "/WEB-INF/view/admin/promotion-create.jsp"
    ).forward(req, res);
}
    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        User currentAdmin = getCurrentAdmin(req, res);

        if (currentAdmin == null) {
            return;
        }

        String path = req.getPathInfo();
        if ("/create".equals(path)) {
            createPromotion(req, res);
        } else if ("/update".equals(path)) {
            updatePromotion(req, res);
        } else if ("/delete".equals(path)) {
            deletePromotion(req, res);
        } else {
            res.sendError(
                    HttpServletResponse.SC_NOT_FOUND
            );
        }
    }
private void createPromotion(
        HttpServletRequest req,
        HttpServletResponse res)
        throws ServletException, IOException {

    Promotion promotion = null;

    try {
        promotion = readNewPromotionFromRequest(req);

        promotionService.create(promotion);

        req.getSession().setAttribute(
                "promotionMessage",
                "Thêm khuyến mãi thành công."
        );

        res.sendRedirect(
                req.getContextPath()
                + "/admin/promotions"
        );

    } catch (IllegalArgumentException e) {

        req.setAttribute(
                "promotionError",
                e.getMessage()
        );

        req.setAttribute(
                "promotion",
                promotion
        );

        req.setAttribute(
                "activePage",
                "promotions"
        );

        req.getRequestDispatcher(
                "/WEB-INF/view/admin/promotion-create.jsp"
        ).forward(req, res);

    } catch (Exception e) {

        log("Cannot create promotion", e);

        req.setAttribute(
                "promotionError",
                "Không thể thêm khuyến mãi lúc này."
        );

        req.setAttribute(
                "promotion",
                promotion
        );

        req.setAttribute(
                "activePage",
                "promotions"
        );

        req.getRequestDispatcher(
                "/WEB-INF/view/admin/promotion-create.jsp"
        ).forward(req, res);
    }
}
    private void showPromotionList(
            HttpServletRequest req,
            HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session != null) {
            moveFlashMessage(
                    session,
                    req,
                    "promotionMessage"
            );

            moveFlashMessage(
                    session,
                    req,
                    "promotionError"
            );
        }

        try {
            req.setAttribute(
                    "promotions",
                    promotionService.getAllPromotions()
            );

            req.setAttribute(
                    "activePage",
                    "promotions"
            );

            req.getRequestDispatcher(
                    "/WEB-INF/view/admin/promotion-list.jsp"
            ).forward(req, res);

        } catch (Exception e) {
            log("Cannot load promotion list", e);

            req.setAttribute(
                    "promotionError",
                    "Không thể tải danh sách khuyến mãi."
            );

            req.setAttribute(
                    "activePage",
                    "promotions"
            );

            req.getRequestDispatcher(
                    "/WEB-INF/view/admin/promotion-list.jsp"
            ).forward(req, res);
        }
    }

    private void showEditForm(
            HttpServletRequest req,
            HttpServletResponse res)
            throws ServletException, IOException {

        try {
            int promotionId = Integer.parseInt(
                    req.getParameter("id")
            );

            Promotion promotion
                    = promotionService.findById(promotionId);

            req.setAttribute(
                    "promotion",
                    promotion
            );

            req.setAttribute(
                    "activePage",
                    "promotions"
            );

            req.getRequestDispatcher(
                    "/WEB-INF/view/admin/promotion-edit.jsp"
            ).forward(req, res);

        } catch (NumberFormatException e) {
            setFlashError(
                    req,
                    "Mã khuyến mãi không hợp lệ."
            );

            res.sendRedirect(
                    req.getContextPath()
                    + "/admin/promotions"
            );

        } catch (IllegalArgumentException e) {
            setFlashError(
                    req,
                    e.getMessage()
            );

            res.sendRedirect(
                    req.getContextPath()
                    + "/admin/promotions"
            );

        } catch (Exception e) {
            log("Cannot load promotion edit form", e);

            setFlashError(
                    req,
                    "Không thể tải thông tin khuyến mãi."
            );

            res.sendRedirect(
                    req.getContextPath()
                    + "/admin/promotions"
            );
        }
    }

    private void updatePromotion(
            HttpServletRequest req,
            HttpServletResponse res)
            throws ServletException, IOException {

        Promotion promotion = null;

        try {
            promotion = readPromotionFromRequest(req);

            promotionService.update(promotion);

            HttpSession session = req.getSession();

            session.setAttribute(
                    "promotionMessage",
                    "Cập nhật khuyến mãi thành công."
            );

            res.sendRedirect(
                    req.getContextPath()
                    + "/admin/promotions"
            );

        } catch (IllegalArgumentException e) {
            req.setAttribute(
                    "promotionError",
                    e.getMessage()
            );

            req.setAttribute(
                    "promotion",
                    promotion
            );

            req.setAttribute(
                    "activePage",
                    "promotions"
            );

            req.getRequestDispatcher(
                    "/WEB-INF/view/admin/promotion-edit.jsp"
            ).forward(req, res);

        } catch (Exception e) {
            log("Cannot update promotion", e);

            req.setAttribute(
                    "promotionError",
                    "Không thể cập nhật khuyến mãi lúc này."
            );

            req.setAttribute(
                    "promotion",
                    promotion
            );

            req.setAttribute(
                    "activePage",
                    "promotions"
            );

            req.getRequestDispatcher(
                    "/WEB-INF/view/admin/promotion-edit.jsp"
            ).forward(req, res);
        }
    }

    private void deletePromotion(
            HttpServletRequest req,
            HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession();

        try {
            int promotionId = Integer.parseInt(
                    req.getParameter("id")
            );

            promotionService.delete(promotionId);

            session.setAttribute(
                    "promotionMessage",
                    "Xóa khuyến mãi thành công."
            );

        } catch (NumberFormatException e) {
            session.setAttribute(
                    "promotionError",
                    "Mã khuyến mãi không hợp lệ."
            );

        } catch (IllegalArgumentException e) {
            session.setAttribute(
                    "promotionError",
                    e.getMessage()
            );

        } catch (Exception e) {
            log("Cannot delete promotion", e);

            session.setAttribute(
                    "promotionError",
                    "Không thể xóa khuyến mãi lúc này."
            );
        }

        res.sendRedirect(
                req.getContextPath()
                + "/admin/promotions"
        );
    }

    private Promotion readPromotionFromRequest(
            HttpServletRequest req) {

        try {
            int id = Integer.parseInt(
                    req.getParameter("id")
            );

            String promotionName
                    = trim(req.getParameter(
                            "promotionName"
                    ));

            String description
                    = trim(req.getParameter(
                            "description"
                    ));

            String discountType
                    = trim(req.getParameter(
                            "discountType"
                    ));

            String discountValueText
                    = trim(req.getParameter(
                            "discountValue"
                    ));

            BigDecimal discountValue
                    = new BigDecimal(
                            discountValueText
                    );

            String tierValue
                    = trim(req.getParameter(
                            "targetTierId"
                    ));

            Integer targetTierId = null;

            if (tierValue != null
                    && !tierValue.isEmpty()) {

                targetTierId
                        = Integer.valueOf(tierValue);
            }

            Date startDate
                    = Date.valueOf(
                            req.getParameter(
                                    "startDate"
                            )
                    );

            Date endDate
                    = Date.valueOf(
                            req.getParameter(
                                    "endDate"
                            )
                    );

            String status
                    = trim(req.getParameter(
                            "status"
                    ));

            return new Promotion(
                    id,
                    promotionName,
                    description,
                    discountType,
                    discountValue,
                    targetTierId,
                    startDate,
                    endDate,
                    status
            );

        } catch (Exception e) {
            throw new IllegalArgumentException(
                    "Dữ liệu khuyến mãi không hợp lệ."
            );
        }
    }
private Promotion readNewPromotionFromRequest(
        HttpServletRequest req) {

    try {
        String promotionName =
                trim(req.getParameter(
                        "promotionName"
                ));

        String description =
                trim(req.getParameter(
                        "description"
                ));

        String discountType =
                trim(req.getParameter(
                        "discountType"
                ));

        BigDecimal discountValue =
                new BigDecimal(
                        trim(req.getParameter(
                                "discountValue"
                        ))
                );

        String tierValue =
                trim(req.getParameter(
                        "targetTierId"
                ));

        Integer targetTierId = null;

        if (tierValue != null
                && !tierValue.isEmpty()) {

            targetTierId =
                    Integer.valueOf(tierValue);
        }

        Date startDate =
                Date.valueOf(
                        req.getParameter(
                                "startDate"
                        )
                );

        Date endDate =
                Date.valueOf(
                        req.getParameter(
                                "endDate"
                        )
                );

        String status =
                trim(req.getParameter(
                        "status"
                ));

        return new Promotion(
                0,
                promotionName,
                description,
                discountType,
                discountValue,
                targetTierId,
                startDate,
                endDate,
                status
        );

    } catch (Exception e) {
        throw new IllegalArgumentException(
                "Dữ liệu khuyến mãi không hợp lệ."
        );
    }
}
    private User getCurrentAdmin(
            HttpServletRequest req,
            HttpServletResponse res)
            throws IOException {

        HttpSession session
                = req.getSession(false);

        User sessionUser
                = session == null
                        ? null
                        : (User) session.getAttribute(
                                "currentUser"
                        );

        if (sessionUser == null) {
            res.sendRedirect(
                    req.getContextPath()
                    + "/auth/login"
            );

            return null;
        }

        User currentUser
                = userService.findById(
                        sessionUser.getId()
                );

        if (currentUser == null) {
            session.invalidate();

            res.sendRedirect(
                    req.getContextPath()
                    + "/auth/login"
            );

            return null;
        }

        if (!"ADMIN".equals(currentUser.getRole())) {
            res.sendError(
                    HttpServletResponse.SC_FORBIDDEN
            );

            return null;
        }

        session.setAttribute(
                "currentUser",
                currentUser
        );

        return currentUser;
    }

    private void setFlashError(
            HttpServletRequest req,
            String message) {

        req.getSession().setAttribute(
                "promotionError",
                message
        );
    }

    private void moveFlashMessage(
            HttpSession session,
            HttpServletRequest req,
            String name) {

        Object value
                = session.getAttribute(name);

        if (value != null) {
            req.setAttribute(name, value);
            session.removeAttribute(name);
        }
    }

    private String trim(String value) {
        return value == null
                ? null
                : value.trim();
    }
}
