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

    public dto.ProfileDTO getProfileContext(User user) {
        List<LoyaltyTier> allTiers = getAllLoyaltyTiers();
        LoyaltyTier nextTier = null;
        for (LoyaltyTier t : allTiers) {
            if (t.getMinSpend() > user.getLifetimeSpent()) {
                nextTier = t;
                break;
            }
        }
        double remaining = 0.0;
        double progress = 0.0;
        if (nextTier != null) {
            remaining = nextTier.getMinSpend() - user.getLifetimeSpent();
            progress = Math.min(100.0, (user.getLifetimeSpent() / nextTier.getMinSpend()) * 100.0);
        }
        return new dto.ProfileDTO(user, nextTier, remaining, progress);
    }

    public void updateProfile(int id, dto.ProfileDTO dto) {
        String error = dto.validate();
        if (error != null) {
            throw new IllegalArgumentException(error);
        }
        userDAO.updateProfile(id, dto.getFullname(), dto.getPhone());
    }

    public CustomerDashboardDTO getCustomerDashboard(int userId) {
        return dashboardDAO.getCustomerDashboard(userId);
    }

    public void banUser(int id, boolean ban) {
        userDAO.delete(id, ban);
    }

    public void changePassword(int userId, String oldPassword, String newPassword, String confirmPassword) {
        if (oldPassword == null || oldPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Tất cả các trường mật khẩu đều bắt buộc.");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("Mật khẩu mới và xác nhận mật khẩu không khớp.");
        }
        if (newPassword.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu mới phải từ 6 ký tự trở lên.");
        }
        
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Tài khoản không tồn tại.");
        }
        
        if (!org.mindrot.jbcrypt.BCrypt.checkpw(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không chính xác.");
        }
        
        String hashedNew = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt());
        userDAO.updatePassword(userId, hashedNew);
    }

    public void resetPassword(int userId, String newPassword) {
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu mới không được để trống.");
        }
        if (newPassword.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu mới phải từ 6 ký tự trở lên.");
        }
        
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Khách hàng không tồn tại.");
        }
        
        String hashedNew = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt());
        userDAO.updatePassword(userId, hashedNew);
    }
}

