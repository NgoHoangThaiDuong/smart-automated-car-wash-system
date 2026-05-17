package exception;

public class ValidationException extends AppException {
    public ValidationException(String field, String reason) {
        super("Field " + field + ": " + reason);
    }
    
    public ValidationException(String message) {
        super(message);
    }
}
