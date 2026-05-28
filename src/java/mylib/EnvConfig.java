package mylib;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class EnvConfig {
    private static final Map<String, String> envMap = new HashMap<>();

    static {
        loadEnv();
    }

    private static void loadEnv() {
        try (InputStream in = EnvConfig.class.getClassLoader().getResourceAsStream(".env")) {
            if (in == null) {
                throw new RuntimeException("CRITICAL: Không tìm thấy file .env trong classpath (WEB-INF/classes hoặc thư mục build)!");
            }
            try (Scanner scanner = new Scanner(in, "UTF-8")) {
                while (scanner.hasNextLine()) {
                    String line = scanner.nextLine().trim();
                    if (line.isEmpty() || line.startsWith("#")) {
                        continue;
                    }
                    String[] parts = line.split("=", 2);
                    if (parts.length == 2) {
                        envMap.put(parts[0].trim(), parts[1].trim());
                    }
                }
            }
        } catch (Exception e) {
            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }
            throw new RuntimeException("CRITICAL: Lỗi khi đọc file .env: " + e.getMessage(), e);
        }
    }

    public static String get(String key) {
        String val = envMap.get(key);
        if (val == null) {
            throw new RuntimeException("CRITICAL: Biến môi trường không tồn tại trong .env: " + key);
        }
        return val;
    }
}
