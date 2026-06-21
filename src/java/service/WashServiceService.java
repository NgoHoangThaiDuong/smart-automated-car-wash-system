package service;

import dao.WashServiceDAO;
import model.WashService;

import java.util.List;

public class WashServiceService {

    private final WashServiceDAO washServiceDAO = new WashServiceDAO();

    public List<WashService> getAllServices() {
        return washServiceDAO.findAll();
    }

    public List<WashService> getActiveServices() {
        return washServiceDAO.findAllActive();
    }

    public List<WashService> getAllServicesWithBookingCount() {
        return washServiceDAO.findAllWithBookingCount();
    }

    public WashService getServiceById(int id) {
        return washServiceDAO.findById(id);
    }

    public void createService(WashService service) {
        validate(service);
        washServiceDAO.create(service);
    }

    public void updateService(WashService service) {
        validate(service);
        WashService existing = washServiceDAO.findById(service.getId());
        if (existing == null) {
            throw new IllegalArgumentException("Dịch vụ không tồn tại.");
        }
        washServiceDAO.update(service);
    }

    public void toggleServiceStatus(int id) {
        WashService existing = washServiceDAO.findById(id);
        if (existing == null) {
            throw new IllegalArgumentException("Dịch vụ không tồn tại.");
        }
        washServiceDAO.updateStatus(id, !existing.isActive());
    }

    public void deleteService(int id) {
        WashService existing = washServiceDAO.findById(id);
        if (existing == null) {
            throw new IllegalArgumentException("Dịch vụ không tồn tại.");
        }
        washServiceDAO.delete(id);
    }

    private void validate(WashService service) {
        if (service.getName() == null || service.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên dịch vụ không được để trống.");
        }
        if (service.getPrice() < 0) {
            throw new IllegalArgumentException("Giá dịch vụ không được âm.");
        }
        if (service.getDurationMinutes() <= 0) {
            throw new IllegalArgumentException("Thời lượng dịch vụ phải lớn hơn 0.");
        }
    }
}
