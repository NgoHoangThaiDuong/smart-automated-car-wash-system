package exception;

public class ValidationException extends AppException {
    public ValidationException(String field, String reason) {
        super("Trường " + field + ": " + reason);
    }
    
    public ValidationException(String message) {
        super(message);
    }
}
