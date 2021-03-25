package se.expiry.dumbledore.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data
@Document(collection = "store")
public class Store {

    @Id
    private String id;

    @Indexed(unique = true)
    private String name;

    private List<Product> products;

    @DBRef
    private List<User> users;

    public Store(String name, List<Product> products){
        this.name = name;
        this.products = products;
        this.users = new ArrayList<>();
    }
 
}
