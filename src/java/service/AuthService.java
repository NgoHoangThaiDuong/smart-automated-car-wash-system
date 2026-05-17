package service;

import exception.AuthException;
import model.User;
import repository.UserRepository;
import java.security.MessageDigest;

public class AuthService {
    private final UserRepository userRepo = new UserRepository();

    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            throw new AuthException("Tên đăng nhập không được để trống");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new AuthException("Mật khẩu không được để trống");
        }

        User user = userRepo.findByUsername(username.trim());
        if (user == null) {
            throw new AuthException("Tên đăng nhập không tồn tại");
        }

        String hashed = hashMD5(password);
        if (!hashed.equals(user.getPassword())) {
            throw new AuthException("Mật khẩu không đúng");
        }

        return user;
    }

    public void register(String username, String password, String fullname, String phone) {
        if (username == null || username.trim().isEmpty()) {
            throw new AuthException("Tên đăng nhập không được để trống");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new AuthException("Mật khẩu không được để trống");
        }

        // Kiểm tra xem username đã tồn tại chưa
        if (userRepo.findByUsername(username.trim()) != null) {
            throw new AuthException("Tên đăng nhập đã tồn tại trong hệ thống");
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
            throw new RuntimeException("Lỗi mã hóa MD5", e);
        }
    }
}
