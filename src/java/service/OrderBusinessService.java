package service;

import exception.ValidationException;
import model.Order;
import model.Service;
import repository.OrderRepository;
import repository.ServiceRepository;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class OrderBusinessService {

    private final OrderRepository orderRepo = new OrderRepository();
    private final ServiceRepository serviceRepo = new ServiceRepository();

    public List<Service> getAllServices() {
        return serviceRepo.findAll();
    }

    public List<Order> getOrdersForUser(int userId) {
        return orderRepo.findByUserId(userId);
    }

    public void bookOrder(int userId, int serviceId, String carPlate, String bookDateStr) {
        if (serviceId <= 0) {
            throw new ValidationException("Dịch vụ", "Vui lòng chọn dịch vụ hợp lệ");
        }

        Service service = serviceRepo.findById(serviceId);
        if (service == null) {
            throw new ValidationException("Dịch vụ", "Dịch vụ đã chọn không tồn tại");
        }

        if (carPlate == null || carPlate.trim().isEmpty()) {
            throw new ValidationException("Biển số xe", "Không được để trống biển số xe");
        }

        String cleanedPlate = carPlate.trim().toUpperCase();
        if (cleanedPlate.length() < 5) {
            throw new ValidationException("Biển số xe", "Biển số xe không đúng định dạng (ít nhất 5 ký tự)");
        }

        if (bookDateStr == null || bookDateStr.trim().isEmpty()) {
            throw new ValidationException("Ngày đặt lịch", "Vui lòng chọn ngày giờ đặt lịch rửa xe");
        }

        Date bookDate;
        try {
            // HTML5 datetime-local thường có định dạng yyyy-MM-dd'T'HH:mm
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            bookDate = sdf.parse(bookDateStr);
        } catch (Exception e) {
            try {
                // Định dạng dự phòng
                SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                bookDate = sdf2.parse(bookDateStr);
            } catch (Exception ex) {
                throw new ValidationException("Ngày đặt lịch", "Định dạng ngày giờ không hợp lệ");
            }
        }

        Date now = new Date();
        if (bookDate.before(now)) {
            throw new ValidationException("Ngày đặt lịch", "Ngày giờ đặt lịch phải ở tương lai");
        }

        // Gọi xuống tầng Repository lưu dữ liệu
        orderRepo.createOrder(userId, serviceId, cleanedPlate, bookDate);
    }
}
