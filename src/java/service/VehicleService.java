package service;

import dao.VehicleDAO;
import model.Vehicle;
import java.util.List;

public class VehicleService {
    private static final String LICENSE_PLATE_PATTERN =
            "^[0-9]{2}[A-Z]{1,2}-([0-9]{4,5}|[0-9]{3}\\.[0-9]{2})$";

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    public void createVehicle(int userId, String licensePlate, String brand, String model, String color) {
        vehicleDAO.create(userId, licensePlate, brand, model, color);
    }

    public List<Vehicle> findByUserId(int userId) {
        return vehicleDAO.findByUserId(userId);
    }

    public Vehicle findById(int id) {
        return vehicleDAO.findById(id);
    }

    public Vehicle findOwnedVehicle(int vehicleId, int userId) {
        return vehicleDAO.findByIdAndUserId(vehicleId, userId);
    }

    public void createCustomerVehicle(int userId, String licensePlate,
            String brand, String model, String color) {
        String normalizedPlate = normalizeLicensePlate(licensePlate);
        String normalizedBrand = normalizeText(brand);
        String normalizedModel = normalizeText(model);
        String normalizedColor = normalizeText(color);
        validateVehicle(normalizedPlate, normalizedBrand, normalizedModel, normalizedColor);

        if (vehicleDAO.existsByPlate(normalizedPlate)) {
            throw new IllegalArgumentException("Biển số xe đã tồn tại.");
        }
        vehicleDAO.create(userId, normalizedPlate, normalizedBrand, normalizedModel, normalizedColor);
    }

    public void updateCustomerVehicle(int vehicleId, int userId, String licensePlate,
            String brand, String model, String color) {
        if (vehicleDAO.findByIdAndUserId(vehicleId, userId) == null) {
            throw new IllegalArgumentException("Không tìm thấy phương tiện thuộc tài khoản của bạn.");
        }

        String normalizedPlate = normalizeLicensePlate(licensePlate);
        String normalizedBrand = normalizeText(brand);
        String normalizedModel = normalizeText(model);
        String normalizedColor = normalizeText(color);
        validateVehicle(normalizedPlate, normalizedBrand, normalizedModel, normalizedColor);

        if (vehicleDAO.existsByPlateExceptId(normalizedPlate, vehicleId)) {
            throw new IllegalArgumentException("Biển số xe đã tồn tại.");
        }
        if (!vehicleDAO.updateForUser(vehicleId, userId, normalizedPlate,
                normalizedBrand, normalizedModel, normalizedColor)) {
            throw new IllegalArgumentException("Không thể cập nhật phương tiện.");
        }
    }

    public void deleteCustomerVehicle(int vehicleId, int userId) {
        if (!vehicleDAO.deleteForUser(vehicleId, userId)) {
            throw new IllegalArgumentException("Không tìm thấy phương tiện thuộc tài khoản của bạn.");
        }
    }

    public String normalizeLicensePlate(String licensePlate) {
        return licensePlate == null ? "" : licensePlate.trim().toUpperCase();
    }

    public String normalizeText(String value) {
        return value == null ? "" : value.trim();
    }

    public void validateVehicle(String licensePlate, String brand, String model, String color) {
        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            throw new IllegalArgumentException("Biển số xe không được để trống.");
        }
        if (!licensePlate.matches(LICENSE_PLATE_PATTERN)) {
            throw new IllegalArgumentException(
                    "Biển số xe không hợp lệ. Ví dụ: 29A-12345 hoặc 30A-123.45.");
        }
        if (brand != null && brand.length() > 50) {
            throw new IllegalArgumentException("Hãng xe không được vượt quá 50 ký tự.");
        }
        if (model != null && model.length() > 50) {
            throw new IllegalArgumentException("Dòng xe không được vượt quá 50 ký tự.");
        }
        if (color != null && color.length() > 30) {
            throw new IllegalArgumentException("Màu xe không được vượt quá 30 ký tự.");
        }
    }

    public boolean existsByPlate(String plate) {
        return vehicleDAO.existsByPlate(plate);
    }

    public boolean existsByPlateExceptId(String plate, int id) {
        return vehicleDAO.existsByPlateExceptId(plate, id);
    }
}
