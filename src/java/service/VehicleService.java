package service;

import dao.VehicleDAO;
import model.Vehicle;
import dto.VehicleDTO;
import java.util.List;

public class VehicleService {
    public static final String DEFAULT_IMAGE_PATH = "/images/vehicles/car-default.svg";

    private static final String LICENSE_PLATE_PATTERN =
            "^[0-9]{2}[A-Z]{1,2}-([0-9]{4,5}|[0-9]{3}\\.[0-9]{2})$";
    private static final String VEHICLE_IMAGE_PATTERN =
            "^(/images/vehicles/[A-Za-z0-9_-]+\\.(png|jpg|jpeg|webp|svg)"
            + "|/vehicle-images/[0-9a-fA-F-]{36}\\.(jpg|png|webp))$";

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    public List<Vehicle> findByUser(int userId) {
        List<Vehicle> vehicles = vehicleDAO.findByUserId(userId);
        for (Vehicle vehicle : vehicles) {
            vehicle.setImagePath(resolveImagePath(vehicle.getImagePath()));
        }
        return vehicles;
    }

    public Vehicle findById(int vehicleId, int userId) {
        return vehicleDAO.findById(vehicleId, userId);
    }

    public void create(int userId, VehicleDTO dto) {
        String error = dto.validate();
        if (error != null) {
            throw new IllegalArgumentException(error);
        }

        if (vehicleDAO.existsByPlate(dto.getLicensePlate())) {
            throw new IllegalArgumentException("Biển số xe đã tồn tại.");
        }
        vehicleDAO.create(userId, dto.getLicensePlate(), dto.getBrand(), dto.getModel(),
                dto.getColor(), resolveImagePath(dto.getImagePath()));
    }

    public void update(int userId, VehicleDTO dto) {
        if (vehicleDAO.findById(dto.getId(), userId) == null) {
            throw new IllegalArgumentException("Không tìm thấy phương tiện thuộc tài khoản của bạn.");
        }

        String error = dto.validate();
        if (error != null) {
            throw new IllegalArgumentException(error);
        }

        if (vehicleDAO.existsByPlate(dto.getLicensePlate(), dto.getId())) {
            throw new IllegalArgumentException("Biển số xe đã tồn tại.");
        }
        if (!vehicleDAO.update(dto.getId(), userId, dto.getLicensePlate(),
                dto.getBrand(), dto.getModel(), dto.getColor(), resolveImagePath(dto.getImagePath()))) {
            throw new IllegalArgumentException("Không thể cập nhật phương tiện.");
        }
    }

    public void delete(int vehicleId, int userId) {
        if (!vehicleDAO.delete(vehicleId, userId)) {
            throw new IllegalArgumentException("Không tìm thấy phương tiện thuộc tài khoản của bạn.");
        }
    }

    public String resolveImagePath(String imagePath) {
        if (imagePath == null || imagePath.trim().isEmpty()) {
            return DEFAULT_IMAGE_PATH;
        }
        String normalized = imagePath.trim().replace('\\', '/');
        if (normalized.matches(VEHICLE_IMAGE_PATTERN)) {
            return normalized;
        }
        return DEFAULT_IMAGE_PATH;
    }
}
