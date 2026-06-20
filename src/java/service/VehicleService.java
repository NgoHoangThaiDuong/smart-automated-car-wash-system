package service;

import dao.VehicleDAO;
import model.Vehicle;
import java.util.List;

public class VehicleService {
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

    public void updateVehicle(int id, String licensePlate, String brand, String model, String color) {
        vehicleDAO.update(id, licensePlate, brand, model, color);
    }

    public void deleteVehicle(int id) {
        vehicleDAO.delete(id);
    }

    public boolean existsByPlate(String plate) {
        return vehicleDAO.existsByPlate(plate);
    }

    public boolean existsByPlateExceptId(String plate, int id) {
        return vehicleDAO.existsByPlateExceptId(plate, id);
    }
}
