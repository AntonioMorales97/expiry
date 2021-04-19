package se.expiry.dumbledore.application;

public interface LogService {
    void addErrorLog(String email, String error, String stackTrace, String dateTime, String platformType);
}
