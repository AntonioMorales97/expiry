package se.expiry.dumbledore.common;

public class ExpiryException extends RuntimeException {

    private ExceptionDetail exceptionDetail;

    public ExpiryException(ExceptionDetail exceptionDetail) {
        this.exceptionDetail = exceptionDetail;
    }

    public ExceptionDetail getExceptionDetail() {
        return this.exceptionDetail;
    }
}
