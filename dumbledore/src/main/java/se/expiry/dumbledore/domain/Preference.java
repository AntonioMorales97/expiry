package se.expiry.dumbledore.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document
public class Preference {
    int sort;
    boolean reverse;

    public Preference(int sort, boolean reverse){
        this.sort = sort;
        this.reverse = reverse;
    }
    public Preference(){
    }

}