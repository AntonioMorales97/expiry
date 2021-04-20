package se.expiry.dumbledore.application;

import se.expiry.dumbledore.presentation.request.log.ErrorLogRequestModel;

public interface LogService {
    void addErrorLog(ErrorLogRequestModel errorLogRequest);
}
