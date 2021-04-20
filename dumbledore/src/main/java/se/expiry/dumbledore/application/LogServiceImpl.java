package se.expiry.dumbledore.application;

import org.springframework.stereotype.Service;
import se.expiry.dumbledore.domain.Log;
import se.expiry.dumbledore.presentation.request.log.ErrorLogRequestModel;
import se.expiry.dumbledore.repository.log.LogRepository;

@Service
public class LogServiceImpl implements LogService {

    private LogRepository logRepo;

    public LogServiceImpl(LogRepository logRepository){
        this.logRepo = logRepository;
    }

    @Override
    public void addErrorLog(ErrorLogRequestModel errorLogRequest) {
        Log log = new Log();
        log.setEmail(errorLogRequest.getEmail());
        log.setError(errorLogRequest.getError());
        log.setStackTrace(errorLogRequest.getStackTrace());
        log.setDateTime(errorLogRequest.getDateTime());
        log.setPlatformType(errorLogRequest.getPlatformType());
        log.setDeviceParameters(errorLogRequest.getDeviceParameters());
        log.setApplicationParameters(errorLogRequest.getApplicationParameters());
        logRepo.save(log);
    }
}
