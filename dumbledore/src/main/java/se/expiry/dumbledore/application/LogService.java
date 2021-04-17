package se.expiry.dumbledore.application;

public interface LogService {
    void addAnonymousLog(String email, String log, String timestamp);
}
