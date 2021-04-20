package se.expiry.dumbledore.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.validation.constraints.NotNull;
import java.util.Map;

@Data
@Document
public class Log {

    @Id
    private String id;

    private String email;

    @NotNull
    private String error;

    @NotNull
    private String dateTime;

    private String platformType;

    private Map<String, Object> deviceParameters;

    private Map<String, Object> applicationParameters;

    @NotNull
    private String stackTrace;

    public Log(){}
}
