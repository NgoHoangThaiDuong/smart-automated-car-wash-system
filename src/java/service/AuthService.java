package service;

import exception.AuthException;
import model.User;
import dao.UserDAO;
import java.security.MessageDigest;

public class AuthService {
    private final UserDAO userRepo = new UserDAO();

    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            throw new AuthException("Username is required");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new AuthException("Password is required");
        }

        User user = userRepo.findByUsername(username.trim());
        if (user == null) {
            throw new AuthException("Invalid username or password");
        }

        String hashed = hashMD5(password);
        if (!hashed.equals(user.getPassword())) {
            throw new AuthException("Invalid username or password");
        }

        return user;
    }

    public void register(String username, String password, String fullname, String phone) {
        if (username == null || username.trim().isEmpty()) {
            throw new AuthException("Username is required");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new AuthException("Password is required");
        }

        if (userRepo.findByUsername(username.trim()) != null) {
            throw new AuthException("Username already exists");
        }

        String hashedPassword = hashMD5(password);
        userRepo.create(username.trim(), hashedPassword, fullname != null ? fullname.trim() : null, phone != null ? phone.trim() : null, "CUSTOMER");
    }

    public static String hashMD5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("MD5 encryption error", e);
        }
    }
}
