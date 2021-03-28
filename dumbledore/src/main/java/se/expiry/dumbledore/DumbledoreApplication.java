package se.expiry.dumbledore;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Role;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.repository.role.RoleRepository;
import se.expiry.dumbledore.repository.store.StoreRepository;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@SpringBootApplication
public class DumbledoreApplication {

    public static void main(String[] args) {
        SpringApplication.run(DumbledoreApplication.class, args);
    }

    @Autowired
    StoreRepository storeRepo;

    @Autowired
    RoleRepository roleRepository;

    @Bean
    CommandLineRunner preLoadMongo(){
        return args -> {
            List<Store> stores = storeRepo.findAll();
            if(stores == null || stores.isEmpty()){
                //TODO: Add new stores
                stores = new ArrayList<>();
                Store gallerian = new Store("Gallerian");
                Store nacka = new Store("Nacka");
                stores.add(gallerian);
                stores.add(nacka);
            }

            if(!doStoresHaveProducts(stores)){
                DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
                Date date = new Date();

                Product product1 = new Product("Milk", "123", dateFormat.format(date));
                Product product2 = new Product("Milk", "123", dateFormat.format(date));
                Product product3 = new Product("Milk", "123", dateFormat.format(date));

                Product product4 = new Product("Kex", "456", dateFormat.format(date));
                Product product5 = new Product("Milk", "123", dateFormat.format(date));

                List<Product> products = stores.get(0).getProducts();
                products.add(product1);
                products.add(product2);
                products.add(product3);
                if(stores.size() > 1) {
                    products = stores.get(1).getProducts();
                }

                products.add(product4);
                products.add(product5);
            }

            storeRepo.saveAll(stores);

            System.out.println("SAVED TO RON");

        };
    }

    private boolean doStoresHaveProducts(List<Store> stores){
        for(Store store : stores){
            if(store.getProducts().size() > 0){
                return true;
            }
        }
        return false;
    }
}

