package se.expiry.dumbledore.domain;

import lombok.Data;

import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document
public class Product {
    private String name;
    private String qrCode;
    private String date;

    public Product(String name, String qrCode, String date) {
        this.name = name;
        this.qrCode = qrCode;
        this.date = date;
    }


}