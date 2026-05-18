package service;

import model.Tier;
import model.User;
import repository.LoyaltyHistoryRepository;
import repository.TierRepository;
import repository.UserRepository;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class LoyaltyService {
    private final UserRepository userRepo = new UserRepository();
    private final TierRepository tierRepo = new TierRepository();
    private final LoyaltyHistoryRepository historyRepo = new LoyaltyHistoryRepository();

    private static final double POINT_RATE = 1000.0;

    public int calculatePoints(double amountSpent) {
        return (int) Math.floor(amountSpent / POINT_RATE);
    }

    public synchronized void processOrderCompletion(int userId, double amountSpent) {
        User u = userRepo.findById(userId);
        if (u == null) return;

        int basePoints = calculatePoints(amountSpent);
        double multiplier = (u.getTier() != null && u.getTier().getPointMultiplier() > 0) ? u.getTier().getPointMultiplier() : 1.0;
        int finalPoints = (int) Math.round(basePoints * multiplier);

        int newBalance = u.getPointsBalance() + finalPoints;
        double newLifetime = u.getLifetimeSpent() + amountSpent;

        userRepo.updateLoyalty(userId, u.getTierId(), newBalance, newLifetime);

        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, 12);
        Date expiresAt = cal.getTime();

        historyRepo.recordHistory(userId, finalPoints, finalPoints, String.format("Tích điểm từ hóa đơn %,.0f VNĐ (Hệ số x%.2f)", amountSpent, multiplier), expiresAt);

        checkTierUpgrade(userId);
    }

    public synchronized void checkTierUpgrade(int userId) {
        User u = userRepo.findById(userId);
        if (u == null) return;

        List<Tier> allTiers = tierRepo.findAll(); // Đã sắp xếp theo min_spend ASC
        Tier targetTier = null;

        for (Tier t : allTiers) {
            if (u.getLifetimeSpent() >= t.getMinSpend()) {
                targetTier = t;
            }
        }

        if (targetTier != null && targetTier.getId() != u.getTierId() && (u.getTier() == null || targetTier.getMinSpend() > u.getTier().getMinSpend())) {
            userRepo.updateLoyalty(userId, targetTier.getId(), u.getPointsBalance(), u.getLifetimeSpent());
            historyRepo.recordHistory(userId, 0, 0, "Chúc mừng bạn thăng hạng thành viên lên: " + targetTier.getName(), null);
        }
    }
}
