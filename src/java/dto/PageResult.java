package dto;

import java.util.List;

public class PageResult<T> {
    private final List<T> data;
    private final int currentPage;
    private final int totalPages;
    private final int pageSize;
    private final int totalEntries;

    public PageResult(List<T> data, int currentPage, int pageSize, int totalEntries) {
        this.data = data;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalEntries = totalEntries;
        int calculatedPages = (int) Math.ceil((double) totalEntries / pageSize);
        this.totalPages = calculatedPages == 0 ? 1 : calculatedPages;
    }

    public List<T> getData() {
        return data;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalEntries() {
        return totalEntries;
    }

    public int getStartEntry() {
        return totalEntries == 0 ? 0 : (currentPage - 1) * pageSize + 1;
    }

    public int getEndEntry() {
        return Math.min(currentPage * pageSize, totalEntries);
    }
}
