package dto;

import javax.servlet.http.HttpServletRequest;

public class VehicleDTO {
    private int id;
    private String licensePlate;
    private String brand;
    private String model;
    private String color;
    private String imagePath;

    public VehicleDTO() {}

    public VehicleDTO(int id, String licensePlate, String brand, String model, String color, String imagePath) {
        this.id = id;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.color = color;
        this.imagePath = imagePath;
    }

    public static VehicleDTO fromRequest(HttpServletRequest req) {
        VehicleDTO dto = new VehicleDTO();
        String idStr = req.getParameter("vehicleId");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                dto.setId(Integer.parseInt(idStr));
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        dto.setLicensePlate(req.getParameter("licensePlate"));
        dto.setBrand(req.getParameter("brand"));
        dto.setModel(req.getParameter("model"));
        dto.setColor(req.getParameter("color"));
        return dto;
    }

    private static String LICENSE_PLATE_PATTERN =
            "^[0-9]{2}[A-Z]{1,2}-([0-9]{4,5}|[0-9]{3}\\.[0-9]{2})$";

    public String validate() {
        String plate = getLicensePlate();
        String brandVal = getBrand();
        String modelVal = getModel();
        String colorVal = getColor();

        if (plate.isEmpty()) {
            return "Biển số xe không được để trống.";
        }
        if (!plate.matches(LICENSE_PLATE_PATTERN)) {
            return "Biển số xe không hợp lệ. Ví dụ: 29A-12345 hoặc 30A-123.45.";
        }
        if (brandVal.length() > 50) {
            return "Hãng xe không được vượt quá 50 ký tự.";
        }
        if (modelVal.length() > 50) {
            return "Dòng xe không được vượt quá 50 ký tự.";
        }
        if (colorVal.length() > 30) {
            return "Màu xe không được vượt quá 30 ký tự.";
        }
        return null;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLicensePlate() {
        return licensePlate != null ? licensePlate.trim().toUpperCase() : "";
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBrand() {
        return brand != null ? brand.trim() : "";
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model != null ? model.trim() : "";
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getColor() {
        return color != null ? color.trim() : "";
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
}
