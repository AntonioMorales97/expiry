package se.expiry.dumbledore.config.mongo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Role;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.repository.role.RoleRepository;
import se.expiry.dumbledore.repository.store.StoreRepository;
import se.expiry.dumbledore.repository.user.UserRepository;
import se.expiry.dumbledore.util.Roles;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Configuration
@Profile("dev")
public class MongoDevInit {

    private StoreRepository storeRepo;

    private RoleRepository roleRepo;

    private UserRepository userRepo;

    private PasswordEncoder passwordEncoder;

    public MongoDevInit(StoreRepository storeRepo, RoleRepository roleRepo, UserRepository userRepo, PasswordEncoder passwordEncoder){
        this.storeRepo = storeRepo;
        this.roleRepo = roleRepo;
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
    }

    @Bean
    public CommandLineRunner preLoadMongo(){
        return args -> {
            /**
             * Adds all roles if they dont exist.
             *  REMOVE BEFORE PROD
             */
            List<Role> roles = roleRepo.findAll();
            if(roles == null || roles.isEmpty()){
                Role adminRole = new Role(Roles.ROLE_ADMIN);
                Role userRole = new Role(Roles.ROLE_USER);
                Role managerRole = new Role(Roles.ROLE_MANAGER);

                roleRepo.save(adminRole);
                roleRepo.save(userRole);
                roleRepo.save(managerRole);
            }

            /**
             * Adds stores Nacka and Gallerian if they dont exist they dont exist.
             * REMOVE BEFORE PROD
             */
            List<Store> stores = storeRepo.findAll();
            if(stores == null || stores.isEmpty()){
                stores = new ArrayList<>();
                Store gallerian = new Store("Gallerian", new ArrayList<>(), new ArrayList<>());
                Store nacka = new Store("Nacka",new ArrayList<>(),new ArrayList<>());
                stores.add(gallerian);
                stores.add(nacka);
                storeRepo.saveAll(stores);
            }

            /**
             * Adds Admin if he don't exist they dont exist.
             * REMOVE BEFORE PROD
             */
            Optional<User> user = userRepo.findByEmail("admin@admin.se");
            if(user.isEmpty()){
                List<Role> rolesList = new ArrayList<>();
                List<Store> storeList = new ArrayList<>();
                storeList.add(stores.get(0));
                rolesList.add(roleRepo.findByName("ADMIN").get());

                User admin = new User("admin","admin", "admin@admin.se",passwordEncoder.encode("admin"), rolesList,storeList);

                userRepo.save(admin);
            }

            /**
             * Adds products Nacka and Gallerian if they dont have products.
             * REMOVE BEFORE PROD
             */
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
