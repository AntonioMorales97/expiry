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
    public void addAnonymousLog(String email, String logTrace, String timestamp) {
        Log log = new Log();
        log.setLog(logTrace);
        log.setTimestamp(timestamp);
        if(email != null){
            log.setEmail(email);
        }
        log.setType("Anonymous");
        logRepo.save(log);
    }
}
