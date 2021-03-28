package se.expiry.dumbledore.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document
public class Role {

    @Id
    private String id;

    private String name;

    public Role(String name){
        this.name = name;
    }

}
