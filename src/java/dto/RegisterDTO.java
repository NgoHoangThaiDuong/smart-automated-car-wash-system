package dto;

public class RegisterDTO {
    private String username;
    private String password;
    private String confirmPassword;
    private String fullname;
    private String phone;

    public RegisterDTO(String username, String password, String confirmPassword, String fullname, String phone) {
        this.username = username;
        this.password = password;
        this.confirmPassword = confirmPassword;
        this.fullname = fullname;
        this.phone = phone;
    }

    /**
     * Kiểm tra tính hợp lệ của dữ liệu form đăng ký.
     * @return null nếu hợp lệ, chuỗi thông báo lỗi nếu không hợp lệ
     */
    public String validate() {
        if (username == null || username.trim().isEmpty()) {
            return "Tên đăng nhập không được để trống";
        }
        if (username.trim().length() < 3 || username.trim().length() > 50) {
            return "Tên đăng nhập phải từ 3 đến 50 ký tự";
        }
        if (password == null || password.trim().isEmpty()) {
            return "Mật khẩu không được để trống";
        }
        if (password.length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự";
        }
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            return "Mật khẩu xác nhận không khớp";
        }
        if (phone != null && !phone.trim().isEmpty() && !phone.trim().matches("\\d{9,15}")) {
            return "Số điện thoại không hợp lệ (phải chứa từ 9-15 số)";
        }
        return null;
    }

    public String getUsername() {
        return username != null ? username.trim() : "";
    }

    public String getPassword() {
        return password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public String getFullname() {
        return fullname != null ? fullname.trim() : "";
    }

    public String getPhone() {
        return phone != null ? phone.trim() : "";
    }
}
