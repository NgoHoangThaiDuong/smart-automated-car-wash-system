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

    public String validate() {
        if (username == null || username.trim().isEmpty()) {
            return "Username is required";
        }
        if (username.trim().length() < 3 || username.trim().length() > 50) {
            return "Username must be between 3 and 50 characters";
        }
        if (password == null || password.trim().isEmpty()) {
            return "Password is required";
        }
        if (password.length() < 6) {
            return "Password must be at least 6 characters";
        }
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            return "Passwords do not match";
        }
        if (phone != null && !phone.trim().isEmpty() && !phone.trim().matches("^0\\d{9}$")) {
            return "Invalid phone number (must start with 0 and contain exactly 10 digits)";
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
