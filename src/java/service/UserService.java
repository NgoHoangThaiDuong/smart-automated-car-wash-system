package service;

import dao.UserDAO;
import dao.LoyaltyTierDAO;
import model.User;
import model.LoyaltyTier;
import java.util.List;

public class UserService {
    private final UserDAO userDAO = new UserDAO();
    private final LoyaltyTierDAO loyaltyTierDAO = new LoyaltyTierDAO();

    public List<User> searchCustomers(String key, Integer tierId) {
        return userDAO.searchCustomers(key, tierId);
    }

    public List<LoyaltyTier> getAllLoyaltyTiers() {
        return loyaltyTierDAO.findAll();
    }
}
