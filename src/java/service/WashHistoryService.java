package service;

import dao.WashHistoryDAO;
import dto.PageResult;
import dto.WashHistoryDTO;

import java.util.List;

public class WashHistoryService {

    public static int PAGE_SIZE = 5;
    private WashHistoryDAO washHistoryDAO = new WashHistoryDAO();

    public PageResult<WashHistoryDTO> getPage(int userId, String search, String period,
            Integer serviceId, Integer vehicleId, int requestedPage) {
        String normalizedSearch = normalizeSearch(search);
        String normalizedPeriod = normalizePeriod(period);
        int totalEntries = washHistoryDAO.countByUser(
                userId, normalizedSearch, normalizedPeriod, serviceId, vehicleId);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalEntries / PAGE_SIZE));
        int currentPage = Math.min(Math.max(1, requestedPage), totalPages);
        int offset = (currentPage - 1) * PAGE_SIZE;
        List<WashHistoryDTO> rows = washHistoryDAO.findByUser(
                userId, normalizedSearch, normalizedPeriod,
                serviceId, vehicleId, offset, PAGE_SIZE);
        return new PageResult<>(rows, currentPage, PAGE_SIZE, totalEntries);
    }

    public String normalizePeriod(String period) {
        if ("7".equals(period) || "30".equals(period)
                || "90".equals(period) || "all".equals(period)) {
            return period;
        }
        return "30";
    }

    public String normalizeSearch(String search) {
        String value = search == null ? "" : search.trim();
        return value.replaceFirst("(?i)^#?SW-", "");
    }

    public int normalizePage(String page) {
        try {
            return Math.max(1, Integer.parseInt(page));
        } catch (Exception e) {
            return 1;
        }
    }

    public Integer parsePositiveId(String value) {
        try {
            int id = Integer.parseInt(value);
            return id > 0 ? id : null;
        } catch (Exception e) {
            return null;
        }
    }
}
