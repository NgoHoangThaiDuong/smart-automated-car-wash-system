package dto;

import model.Vehicle;
import model.WashService;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

public class BookingDTO {
    // 1. Data for rendering booking form & list
    private List<Vehicle> vehicles;
    private List<WashService> services;
    private Integer selectedVehicleId;
    private Integer selectedServiceId;
    private Vehicle selectedVehicle;
    private WashService selectedService;
    private String selectedDate;
    private String selectedTime;
    private List<String> availableSlots;
    private int bookingWindowDays;
    private String minBookingDate;
    private String maxBookingDate;

    // 2. Data from submitting booking form
    private Integer vehicleId;
    private Integer serviceId;
    private String bookingDate;
    private String time;

    public BookingDTO() {}

    // Constructor for rendering view
    public BookingDTO(List<Vehicle> vehicles, List<WashService> services,
                      Integer selectedVehicleId, Integer selectedServiceId,
                      Vehicle selectedVehicle, WashService selectedService,
                      String selectedDate, String selectedTime,
                      List<String> availableSlots, int bookingWindowDays,
                      String minBookingDate, String maxBookingDate) {
        this.vehicles = vehicles;
        this.services = services;
        this.selectedVehicleId = selectedVehicleId;
        this.selectedServiceId = selectedServiceId;
        this.selectedVehicle = selectedVehicle;
        this.selectedService = selectedService;
        this.selectedDate = selectedDate;
        this.selectedTime = selectedTime;
        this.availableSlots = availableSlots;
        this.bookingWindowDays = bookingWindowDays;
        this.minBookingDate = minBookingDate;
        this.maxBookingDate = maxBookingDate;
    }

    public static BookingDTO fromRequest(HttpServletRequest req) {
        BookingDTO dto = new BookingDTO();
        String vehicleIdStr = req.getParameter("vehicleId");
        String serviceIdStr = req.getParameter("serviceId");
        
        if (vehicleIdStr != null && !vehicleIdStr.trim().isEmpty()) {
            try {
                dto.setVehicleId(Integer.parseInt(vehicleIdStr.trim()));
            } catch (NumberFormatException e) {
                // Keep null to trigger validation
            }
        }
        if (serviceIdStr != null && !serviceIdStr.trim().isEmpty()) {
            try {
                dto.setServiceId(Integer.parseInt(serviceIdStr.trim()));
            } catch (NumberFormatException e) {
                // Keep null to trigger validation
            }
        }
        
        dto.setBookingDate(req.getParameter("bookingDate") == null ? "" : req.getParameter("bookingDate").trim());
        dto.setTime(req.getParameter("time") == null ? "" : req.getParameter("time").trim());
        return dto;
    }

    public String validate() {
        if (vehicleId == null || vehicleId <= 0) {
            return "Vui lòng chọn phương tiện.";
        }
        if (serviceId == null || serviceId <= 0) {
            return "Vui lòng chọn dịch vụ rửa xe.";
        }
        if (bookingDate == null || bookingDate.trim().isEmpty()) {
            return "Vui lòng chọn ngày đặt lịch.";
        }
        if (time == null || time.trim().isEmpty()) {
            return "Vui lòng chọn giờ đặt lịch.";
        }
        return null;
    }

    public void putIntoRequest(HttpServletRequest req) {
        req.setAttribute("vehicles", vehicles);
        req.setAttribute("services", services);
        req.setAttribute("selectedVehicleId", selectedVehicleId);
        req.setAttribute("selectedServiceId", selectedServiceId);
        req.setAttribute("selectedVehicle", selectedVehicle);
        req.setAttribute("selectedService", selectedService);
        req.setAttribute("selectedDate", selectedDate);
        req.setAttribute("selectedTime", selectedTime);
        req.setAttribute("availableSlots", availableSlots);
        req.setAttribute("bookingWindowDays", bookingWindowDays);
        req.setAttribute("minBookingDate", minBookingDate);
        req.setAttribute("maxBookingDate", maxBookingDate);
    }

    // Getters & Setters
    public List<Vehicle> getVehicles() { return vehicles; }
    public void setVehicles(List<Vehicle> vehicles) { this.vehicles = vehicles; }

    public List<WashService> getServices() { return services; }
    public void setServices(List<WashService> services) { this.services = services; }

    public Integer getSelectedVehicleId() { return selectedVehicleId; }
    public void setSelectedVehicleId(Integer selectedVehicleId) { this.selectedVehicleId = selectedVehicleId; }

    public Integer getSelectedServiceId() { return selectedServiceId; }
    public void setSelectedServiceId(Integer selectedServiceId) { this.selectedServiceId = selectedServiceId; }

    public Vehicle getSelectedVehicle() { return selectedVehicle; }
    public void setSelectedVehicle(Vehicle selectedVehicle) { this.selectedVehicle = selectedVehicle; }

    public WashService getSelectedService() { return selectedService; }
    public void setSelectedService(WashService selectedService) { this.selectedService = selectedService; }

    public String getSelectedDate() { return selectedDate; }
    public void setSelectedDate(String selectedDate) { this.selectedDate = selectedDate; }

    public String getSelectedTime() { return selectedTime; }
    public void setSelectedTime(String selectedTime) { this.selectedTime = selectedTime; }

    public List<String> getAvailableSlots() { return availableSlots; }
    public void setAvailableSlots(List<String> availableSlots) { this.availableSlots = availableSlots; }

    public int getBookingWindowDays() { return bookingWindowDays; }
    public void setBookingWindowDays(int bookingWindowDays) { this.bookingWindowDays = bookingWindowDays; }

    public String getMinBookingDate() { return minBookingDate; }
    public void setMinBookingDate(String minBookingDate) { this.minBookingDate = minBookingDate; }

    public String getMaxBookingDate() { return maxBookingDate; }
    public void setMaxBookingDate(String maxBookingDate) { this.maxBookingDate = maxBookingDate; }

    public Integer getVehicleId() { return vehicleId; }
    public void setVehicleId(Integer vehicleId) { this.vehicleId = vehicleId; }

    public Integer getServiceId() { return serviceId; }
    public void setServiceId(Integer serviceId) { this.serviceId = serviceId; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
}

