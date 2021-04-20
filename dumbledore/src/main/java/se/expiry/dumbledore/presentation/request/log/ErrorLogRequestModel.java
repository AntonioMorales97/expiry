package se.expiry.dumbledore.presentation.request.log;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.util.Map;

@Data
public class ErrorLogRequestModel {

    private String email;

    @NotNull(message = "Error must be given")
    private String error;

    @NotNull(message = "Datetime must be given")
    private String dateTime;

    private String platformType;

    private Map<String, Object> deviceParameters;

    private Map<String, Object> applicationParameters;

    @NotNull
    private String stackTrace;

    public ErrorLogRequestModel(){}
}
