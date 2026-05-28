package exception;

public class NotFoundException extends AppException {
    public NotFoundException(String resource) {
        super(resource + " không tồn tại");
    }
}
