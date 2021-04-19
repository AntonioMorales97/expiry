package se.expiry.dumbledore.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.validation.constraints.NotNull;

@Data
@Document
public class Log {

    @Id
    private String id;

    private String email;

    @NotNull
    private String stackTrace;

    @NotNull
    private String error;

    private String platformType;

    @NotNull
    private String dateTime;

    public Log(){}
}
