package se.expiry.dumbledore.application;

import org.springframework.stereotype.Service;
import se.expiry.dumbledore.domain.Log;
import se.expiry.dumbledore.repository.log.LogRepository;

@Service
public class LogServiceImpl implements LogService {

    private LogRepository logRepo;

    public LogServiceImpl(LogRepository logRepository){
        this.logRepo = logRepository;
    }

    @Override
    public void addErrorLog(String email, String error, String stackTrace, String dateTime, String platformType) {
        Log log = new Log();
        log.setEmail(email);
        log.setError(error);
        log.setStackTrace(stackTrace);
        log.setDateTime(dateTime);
        log.setPlatformType(platformType);
        logRepo.save(log);
    }
}
