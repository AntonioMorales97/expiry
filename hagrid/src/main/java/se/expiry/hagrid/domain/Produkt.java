package se.expiry.hagrid.domain;

import lombok.Data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "Produkter")
public class Produkt{
private String namn;

private String qrCode;

private String hylla;
//private int antal; eller en inviduell per??
private String date;

private String produkt;

public Produkt( String namn, String qrCode, String hylla, String produkt, String date) {
  
    this.namn = namn;
    this.qrCode = qrCode;
    this.hylla = hylla;
    this.produkt = produkt;
    this.date = date;
  }


}