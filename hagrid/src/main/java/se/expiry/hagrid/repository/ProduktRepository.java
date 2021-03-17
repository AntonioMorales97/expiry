package se.expiry.hagrid.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.hagrid.domain.Produkt;

public interface ProduktRepository extends MongoRepository<Produkt, String>{

    public Produkt findByDate(String date);
}