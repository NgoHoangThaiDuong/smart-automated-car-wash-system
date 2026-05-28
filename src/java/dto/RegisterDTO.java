package dto;

import java.util.HashMap;
import java.util.Map;

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

    public Map<String, String> validate() {

        Map<String, String> errors = new HashMap<>();

        // username
        if (username == null || username.trim().isEmpty()) {

            errors.put("usernameError",
                    "Username is required");

        } else if (username.trim().length() < 3
                || username.trim().length() > 50) {

            errors.put("usernameError",
                    "Username must be 3-50 characters");
        }
        // password
        if (password == null || password.trim().isEmpty()) {

            errors.put("passwordError",
                    "Password is required");

        } else if (password.length() < 6) {

            errors.put("passwordError",
                    "Password must be at least 6 characters");
        }
        // confirm pass
        if (confirmPassword == null
                || !confirmPassword.equals(password)) {

            errors.put("confirmPasswordError",
                    "Passwords do not match");
        }
        // fullname
        if (fullname == null || fullname.trim().isEmpty()) {

            errors.put("fullnameError",
                    "Fullname is required");
        }

        // phone
        if (phone != null
                && !phone.trim().isEmpty()
                && !phone.trim().matches("^0\\d{9}$")) {

            errors.put("phoneError",
                    "Phone must contain exactly 10 digits");
        }

        return errors;

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
