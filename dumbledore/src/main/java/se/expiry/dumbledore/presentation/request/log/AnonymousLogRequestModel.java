package se.expiry.dumbledore.presentation.request.log;

import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
public class AnonymousLogRequestModel {
    private String email;

    @NotNull(message = "Log must be given")
    private String log;

    @NotNull(message = "Timestamp must be given")
    private String timestamp;

    public AnonymousLogRequestModel(){}
}
