package se.expiry.dumbledore;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.repository.StoreRepository;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@SpringBootApplication
public class DumbledoreApplication implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(DumbledoreApplication.class, args);
    }

    @Autowired
    StoreRepository repository;

    @Override
    public void run(String... args) throws Exception {

        repository.deleteAll();
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        Date date = new Date();

        Product product1 = new Product("Milk", "123", dateFormat.format(date));
        Product product2 = new Product("Milk", "123", dateFormat.format(date));
        Product product3 = new Product("Milk", "123", dateFormat.format(date));

        List<Product> products = new ArrayList<>();
        products.add(product1);
        products.add(product2);
        products.add(product3);
        Store store = new Store("Gallerian", products);
        List<Product> products1 = new ArrayList<>();
        products1.add(product1);
        products1.add(product2);

        Store store1 = new Store("Nacka", products1);

        // save a couple of customers
        repository.save(store);
        repository.save(store1);
        System.out.println("SAVED TO RON");
    }
}

