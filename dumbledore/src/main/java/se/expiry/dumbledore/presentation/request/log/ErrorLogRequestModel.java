package se.expiry.dumbledore.presentation.request.log;

import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
public class ErrorLogRequestModel {

    private String email;

    @NotNull(message = "Error must be given")
    private String error;

    @NotNull
    private String stackTrace;

    @NotNull(message = "Datetime must be given")
    private String dateTime;

    private String platformType;

    public ErrorLogRequestModel(){}
}
