package service;

import model.User;
import dao.UserDAO;
import org.mindrot.jbcrypt.BCrypt;

public class AuthService {
    private final UserDAO userRepo = new UserDAO();

    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }

        User user = userRepo.findByUsername(username.trim());
        if (user == null) {
            throw new IllegalArgumentException("Invalid username or password");
        }

        if (!BCrypt.checkpw(password, user.getPassword())) {
            throw new IllegalArgumentException("Invalid username or password");
        }

        return user;
    }

    public void register(String username, String password, String fullname, String phone) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }

        if (userRepo.findByUsername(username.trim()) != null) {
            throw new IllegalArgumentException("Username already exists");
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        userRepo.create(username.trim(), hashedPassword, fullname != null ? fullname.trim() : null, phone != null ? phone.trim() : null, "CUSTOMER");
    }
}
