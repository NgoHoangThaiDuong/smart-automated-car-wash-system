package dto;

public class LoginDTO {
    private String username;
    private String password;

    public LoginDTO(String username, String password) {
        this.username = username;
        this.password = password;
    }

    /**
     * Kiểm tra tính hợp lệ của dữ liệu đầu vào.
     * @return null nếu hợp lệ, chuỗi thông báo lỗi nếu không hợp lệ
     */
    public String validate() {
        if (username == null || username.trim().isEmpty()) {
            return "Tên đăng nhập không được để trống";
        }
        if (password == null || password.trim().isEmpty()) {
            return "Mật khẩu không được để trống";
        }
        if (password.length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự";
        }
        return null; // Dữ liệu hợp lệ
    }

    public String getUsername() {
        return username != null ? username.trim() : "";
    }

    public String getPassword() {
        return password;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
