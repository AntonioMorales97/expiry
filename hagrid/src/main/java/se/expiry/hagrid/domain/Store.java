package se.expiry.hagrid.domain;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Document(collection = "store")
public class Store {
    private String name;
    private List<Product> products;

    public Store(String name, List<Product> products){
        this.name = name;
        this.products = products;
    }
}
