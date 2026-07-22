package mylib;

import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.UUID;

public class VehicleImageStorage {

    public static long MAX_FILE_SIZE = 5L * 1024L * 1024L;
    private static String URL_PREFIX = "/vehicle-images/";
    private static String FILE_PATTERN =
            "^[0-9a-fA-F-]{36}\\.(jpg|png|webp)$";

    private VehicleImageStorage() {
    }

    public static String save(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }
        if (imagePart.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("Ảnh không được vượt quá 5 MB.");
        }

        String extension = extensionForContentType(imagePart.getContentType());
        if (extension == null) {
            throw new IllegalArgumentException("Chỉ chấp nhận ảnh JPG, PNG hoặc WEBP.");
        }

        Path uploadDirectory = getUploadDirectory();
        Files.createDirectories(uploadDirectory);

        String filename = UUID.randomUUID().toString() + "." + extension;
        Path target = uploadDirectory.resolve(filename).normalize();
        if (!target.startsWith(uploadDirectory)) {
            throw new IllegalArgumentException("Tên file ảnh không hợp lệ.");
        }

        try (InputStream input = imagePart.getInputStream()) {
            Files.copy(input, target);
        } catch (IOException ex) {
            Files.deleteIfExists(target);
            throw ex;
        }
        return URL_PREFIX + filename;
    }

    public static void delete(String imagePath) {
        if (!isUploadedImagePath(imagePath)) {
            return;
        }
        try {
            Path file = resolveFile(imagePath.substring(URL_PREFIX.length()));
            if (file != null) {
                Files.deleteIfExists(file);
            }
        } catch (IOException ignored) {
        }
    }

    public static Path resolveFile(String filename) {
        if (filename == null || !filename.matches(FILE_PATTERN)) {
            return null;
        }
        Path uploadDirectory = getUploadDirectory();
        Path file = uploadDirectory.resolve(filename).normalize();
        return file.startsWith(uploadDirectory) ? file : null;
    }

    public static boolean isUploadedImagePath(String imagePath) {
        if (imagePath == null || !imagePath.startsWith(URL_PREFIX)) {
            return false;
        }
        return imagePath.substring(URL_PREFIX.length()).matches(FILE_PATTERN);
    }

    public static String extensionForContentType(String contentType) {
        if (contentType == null) {
            return null;
        }
        switch (contentType.toLowerCase(Locale.ENGLISH)) {
            case "image/jpeg":
                return "jpg";
            case "image/png":
                return "png";
            case "image/webp":
                return "webp";
            default:
                return null;
        }
    }

    public static String contentTypeForFilename(String filename) {
        if (filename == null) {
            return "application/octet-stream";
        }
        String lower = filename.toLowerCase(Locale.ENGLISH);
        if (lower.endsWith(".jpg")) {
            return "image/jpeg";
        }
        if (lower.endsWith(".png")) {
            return "image/png";
        }
        if (lower.endsWith(".webp")) {
            return "image/webp";
        }
        return "application/octet-stream";
    }

    public static Path getUploadDirectory() {
        String configuredRoot = System.getProperty("smartcarwash.upload.root");
        if (configuredRoot == null || configuredRoot.trim().isEmpty()) {
            configuredRoot = System.getenv("SMART_CAR_WASH_UPLOAD_ROOT");
        }

        Path root;
        if (configuredRoot == null || configuredRoot.trim().isEmpty()) {
            root = Paths.get(System.getProperty("user.home"), ".smart-car-wash", "uploads");
        } else {
            root = Paths.get(configuredRoot.trim());
        }
        return root.toAbsolutePath().normalize().resolve("vehicles").normalize();
    }
}
