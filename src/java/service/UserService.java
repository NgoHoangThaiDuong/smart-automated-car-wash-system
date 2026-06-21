package service;

import dao.UserDAO;
import dao.LoyaltyTierDAO;
import dao.CustomerDashboardDAO;
import dto.CustomerDashboardDTO;
import model.User;
import model.LoyaltyTier;
import java.util.List;

public class UserService {
    private final UserDAO userDAO = new UserDAO();
    private final LoyaltyTierDAO loyaltyTierDAO = new LoyaltyTierDAO();
    private final CustomerDashboardDAO dashboardDAO = new CustomerDashboardDAO();


    public dto.PageResult<User> getCustomersPage(String search, Integer tierId, String sortBy, int page, int pageSize) {
        int totalEntries = userDAO.countCustomers(search, tierId);
        int offset = (page - 1) * pageSize;
        List<User> list = userDAO.searchCustomersPaginated(search, tierId, sortBy, offset, pageSize);
        return new dto.PageResult<>(list, page, pageSize, totalEntries);
    }


    public int getCustomerCount() {
        return userDAO.countCustomers();
    }

    public int getRegisteredVehicleCount() {
        return userDAO.countRegisteredVehicles();
    }

    public double getLifetimeSpentSum() {
        return userDAO.sumLifetimeSpent();
    }

    public List<LoyaltyTier> getAllLoyaltyTiers() {
        return loyaltyTierDAO.findAll();
    }

    public User findById(int id) {
        return userDAO.findById(id);
    }

    public void updateProfile(int id, String fullname, String phone) {
        userDAO.updateProfile(id, fullname, phone);
    }

    public CustomerDashboardDTO getCustomerDashboard(int userId) {
        return dashboardDAO.getCustomerDashboard(userId);
    }
}
