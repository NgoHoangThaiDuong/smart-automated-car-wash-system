package model;

public class Vehicle {
    private int id;
    private int userId;
    private String licensePlate;
    private boolean isDefault;

    public Vehicle() {
    }

    public Vehicle(int id, int userId, String licensePlate, boolean isDefault) {
        this.id = id;
        this.userId = userId;
        this.licensePlate = licensePlate;
        this.isDefault = isDefault;
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

    public boolean isDefaultVehicle() {
        return isDefault;
    }

    public void setDefaultVehicle(boolean defaultVehicle) {
        this.isDefault = defaultVehicle;
    }

    @Override
    public String toString() {
        return "Vehicle{" +
                "id=" + id +
                ", userId=" + userId +
                ", licensePlate='" + licensePlate + '\'' +
                ", isDefault=" + isDefault +
                '}';
    }
}
