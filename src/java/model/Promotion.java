package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Promotion {

    private int id;
    private String promotionName;
    private String description;
    private String discountType;
    private BigDecimal discountValue;

    private Integer targetTierId;
    private String targetTierName;

    private Date startDate;
    private Date endDate;

    private String status;
    private boolean deleted;

    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Promotion() {
    }

    public Promotion(
            int id,
            String promotionName,
            String description,
            String discountType,
            BigDecimal discountValue,
            Integer targetTierId,
            Date startDate,
            Date endDate,
            String status) {

        this.id = id;
        this.promotionName = promotionName;
        this.description = description;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.targetTierId = targetTierId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public Integer getTargetTierId() {
        return targetTierId;
    }

    public void setTargetTierId(Integer targetTierId) {
        this.targetTierId = targetTierId;
    }

    public String getTargetTierName() {
        return targetTierName;
    }

    public void setTargetTierName(String targetTierName) {
        this.targetTierName = targetTierName;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}