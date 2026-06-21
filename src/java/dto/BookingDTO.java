package dto;

import model.Vehicle;
import model.WashService;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

public class BookingDTO {
    private final List<Vehicle> vehicles;
    private final List<WashService> services;
    private final Integer selectedVehicleId;
    private final Integer selectedServiceId;
    private final Vehicle selectedVehicle;
    private final WashService selectedService;
    private final String selectedDate;
    private final String selectedTime;
    private final List<String> availableSlots;
    private final int bookingWindowDays;
    private final String minBookingDate;
    private final String maxBookingDate;

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

    public List<Vehicle> getVehicles() { return vehicles; }
    public List<WashService> getServices() { return services; }
    public Integer getSelectedVehicleId() { return selectedVehicleId; }
    public Integer getSelectedServiceId() { return selectedServiceId; }
    public Vehicle getSelectedVehicle() { return selectedVehicle; }
    public WashService getSelectedService() { return selectedService; }
    public String getSelectedDate() { return selectedDate; }
    public String getSelectedTime() { return selectedTime; }
    public List<String> getAvailableSlots() { return availableSlots; }
    public int getBookingWindowDays() { return bookingWindowDays; }
    public String getMinBookingDate() { return minBookingDate; }
    public String getMaxBookingDate() { return maxBookingDate; }
}

