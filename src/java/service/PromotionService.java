package service;

import dao.PromotionDAO;
import model.Promotion;

import java.util.List;

public class PromotionService {

    private final PromotionDAO promotionDAO = new PromotionDAO();

    public List<Promotion> getAllPromotions() {
        try {
            return promotionDAO.findAll();
        } catch (Exception e) {
            throw new RuntimeException(
                    "Không thể tải danh sách khuyến mãi.",
                    e
            );
        }
    }

    public Promotion findById(int promotionId) {
        if (promotionId <= 0) {
            throw new IllegalArgumentException(
                    "Mã khuyến mãi không hợp lệ."
            );
        }

        try {
            Promotion promotion =
                    promotionDAO.findById(promotionId);

            if (promotion == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy khuyến mãi."
                );
            }

            return promotion;

        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(
                    "Không thể tải thông tin khuyến mãi.",
                    e
            );
        }
    }
public void create(Promotion promotion) {

    validatePromotion(promotion);

    try {
        boolean inserted =
                promotionDAO.insert(promotion);

        if (!inserted) {
            throw new IllegalArgumentException(
                    "Không thể thêm khuyến mãi."
            );
        }

    } catch (IllegalArgumentException e) {
        throw e;
    } catch (Exception e) {
        throw new RuntimeException(
                "Có lỗi xảy ra khi thêm khuyến mãi.",
                e
        );
    }
}
    public void update(Promotion promotion) {

    if (promotion == null || promotion.getId() <= 0) {
        throw new IllegalArgumentException(
                "Mã khuyến mãi không hợp lệ."
        );
    }

    validatePromotion(promotion);

    try {
        Promotion existing =
                promotionDAO.findById(promotion.getId());

        if (existing == null) {
            throw new IllegalArgumentException(
                    "Khuyến mãi không tồn tại hoặc đã bị xóa."
            );
        }

        boolean updated =
                promotionDAO.update(promotion);

        if (!updated) {
            throw new IllegalArgumentException(
                    "Không thể cập nhật khuyến mãi."
            );
        }

    } catch (IllegalArgumentException e) {
        throw e;
    } catch (Exception e) {
        throw new RuntimeException(
                "Có lỗi xảy ra khi cập nhật khuyến mãi.",
                e
        );
    }
    }
    

    public void delete(int promotionId) {
        if (promotionId <= 0) {
            throw new IllegalArgumentException(
                    "Mã khuyến mãi không hợp lệ."
            );
        }

        try {
            Promotion existing =
                    promotionDAO.findById(promotionId);

            if (existing == null) {
                throw new IllegalArgumentException(
                        "Khuyến mãi không tồn tại hoặc đã bị xóa."
                );
            }

            boolean deleted =
                    promotionDAO.softDelete(promotionId);

            if (!deleted) {
                throw new IllegalArgumentException(
                        "Không thể xóa khuyến mãi."
                );
            }

        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(
                    "Có lỗi xảy ra khi xóa khuyến mãi.",
                    e
            );
        }
    }

    private void validatePromotion(Promotion promotion) {
        if (promotion == null) {
            throw new IllegalArgumentException(
                    "Dữ liệu khuyến mãi không hợp lệ."
            );
        }      

        if (promotion.getPromotionName() == null
                || promotion.getPromotionName().trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Tên khuyến mãi không được để trống."
            );
        }

        if (promotion.getPromotionName().trim().length() > 150) {
            throw new IllegalArgumentException(
                    "Tên khuyến mãi không được vượt quá 150 ký tự."
            );
        }

        if (promotion.getDescription() != null
                && promotion.getDescription().length() > 500) {

            throw new IllegalArgumentException(
                    "Mô tả không được vượt quá 500 ký tự."
            );
        }

        if (!"PERCENT".equals(promotion.getDiscountType())
                && !"FIXED".equals(promotion.getDiscountType())) {

            throw new IllegalArgumentException(
                    "Loại giảm giá không hợp lệ."
            );
        }

        if (promotion.getDiscountValue() == null
                || promotion.getDiscountValue().signum() <= 0) {

            throw new IllegalArgumentException(
                    "Giá trị giảm phải lớn hơn 0."
            );
        }

        if ("PERCENT".equals(promotion.getDiscountType())
                && promotion.getDiscountValue()
                        .compareTo(
                                new java.math.BigDecimal("100")
                        ) > 0) {

            throw new IllegalArgumentException(
                    "Giảm theo phần trăm không được vượt quá 100%."
            );
        }

        if (promotion.getStartDate() == null) {
            throw new IllegalArgumentException(
                    "Ngày bắt đầu không được để trống."
            );
        }

        if (promotion.getEndDate() == null) {
            throw new IllegalArgumentException(
                    "Ngày kết thúc không được để trống."
            );
        }

        if (promotion.getEndDate()
                .before(promotion.getStartDate())) {

            throw new IllegalArgumentException(
                    "Ngày kết thúc không được trước ngày bắt đầu."
            );
        }

        if (!"ACTIVE".equals(promotion.getStatus())
                && !"INACTIVE".equals(promotion.getStatus())) {

            throw new IllegalArgumentException(
                    "Trạng thái khuyến mãi không hợp lệ."
            );
        }
    }
}