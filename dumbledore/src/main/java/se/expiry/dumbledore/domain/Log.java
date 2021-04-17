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

    private String firstName;
    private String lastName;

    @NotNull
    private String log;

    @NotNull
    private String type;

    @NotNull
    private String timestamp;

    public Log(){}
}
