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
    private final LoyaltyService loyaltyService = new LoyaltyService();

    public List<Service> getAllServices() {
        return serviceRepo.findAll();
    }

    public List<Order> getOrdersForUser(int userId) {
        return orderRepo.findByUserId(userId);
    }

    public void bookOrder(int userId, int serviceId, String carPlate, String bookDateStr) {
        if (serviceId <= 0) {
            throw new ValidationException("Service", "Please select a valid service");
        }

        Service service = serviceRepo.findById(serviceId);
        if (service == null) {
            throw new ValidationException("Service", "Selected service does not exist");
        }

        if (carPlate == null || carPlate.trim().isEmpty()) {
            throw new ValidationException("License Plate", "License plate is required");
        }

        String cleanedPlate = carPlate.trim().toUpperCase();
        if (cleanedPlate.length() < 5) {
            throw new ValidationException("License Plate", "Invalid license plate format (must be at least 5 characters)");
        }

        if (bookDateStr == null || bookDateStr.trim().isEmpty()) {
            throw new ValidationException("Appointment Date", "Please select an appointment date and time");
        }

        Date bookDate;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            bookDate = sdf.parse(bookDateStr);
        } catch (Exception e) {
            try {
                SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                bookDate = sdf2.parse(bookDateStr);
            } catch (Exception ex) {
                throw new ValidationException("Appointment Date", "Invalid date and time format");
            }
        }

        Date now = new Date();
        if (bookDate.before(now)) {
            throw new ValidationException("Appointment Date", "Appointment date and time must be in the future");
        }

        orderRepo.createOrder(userId, serviceId, cleanedPlate, bookDate);
    }

    public void completeOrder(int orderId) {
        Order o = orderRepo.findById(orderId);
        if (o == null || "COMPLETED".equals(o.getStatus())) return;

        double basePrice = o.getServicePrice();
        double discount = (o.getDiscountPercent() > 0) ? (basePrice * o.getDiscountPercent() / 100.0) : 0.0;
        double finalPrice = basePrice - discount;
        if (finalPrice < 0) finalPrice = 0.0;

        orderRepo.updateStatus(orderId, "COMPLETED");

        loyaltyService.processOrderCompletion(o.getUserId(), finalPrice);
    }
}
