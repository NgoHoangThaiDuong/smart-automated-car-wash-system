package model;

public class Vehicle {
    private int id;
    private int userId;
    private String licensePlate;
    private String vehicleType;
    private String color;

    public Vehicle() {
    }

    public Vehicle(int id, int userId, String licensePlate, String vehicleType, String color) {
        this.id = id;
        this.userId = userId;
        this.licensePlate = licensePlate;
        this.vehicleType = vehicleType;
        this.color = color;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
}
