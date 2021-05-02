package se.expiry.dumbledore.config.mongo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import se.expiry.dumbledore.domain.Role;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.repository.role.RoleRepository;
import se.expiry.dumbledore.repository.store.StoreRepository;
import se.expiry.dumbledore.repository.user.UserRepository;
import se.expiry.dumbledore.util.Roles;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Configuration
@Profile("prod")
public class MongoProdInit {

    private StoreRepository storeRepo;

    private RoleRepository roleRepo;

    private UserRepository userRepo;

    private PasswordEncoder passwordEncoder;

    @Value("${admin.username}")
    private String username;
    @Value("${admin.password}")
    private String password;

    public MongoProdInit(StoreRepository storeRepo, RoleRepository roleRepo, UserRepository userRepo, PasswordEncoder passwordEncoder){
        this.storeRepo = storeRepo;
        this.roleRepo = roleRepo;
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
    }

    @Bean
    public CommandLineRunner preLoadMongo() {
        return args -> {

            // Adds all roles if they don't exist.
            List<Role> roles = roleRepo.findAll();
            if (roles.isEmpty()) {
                Role adminRole = new Role(Roles.ROLE_ADMIN);
                Role userRole = new Role(Roles.ROLE_USER);
                Role managerRole = new Role(Roles.ROLE_MANAGER);

                roleRepo.save(adminRole);
                roleRepo.save(userRole);
                roleRepo.save(managerRole);
            } else {
                //Check if roles exists
                Optional<Role> roleOpt = roleRepo.findByName(Roles.ROLE_ADMIN);
                if (roleOpt.isEmpty()) {
                    Role adminRole = new Role(Roles.ROLE_ADMIN);
                    roleRepo.save(adminRole);
                }

                roleOpt = roleRepo.findByName(Roles.ROLE_USER);
                if (roleOpt.isEmpty()) {
                    Role userRole = new Role(Roles.ROLE_USER);
                    roleRepo.save(userRole);
                }

                roleOpt = roleRepo.findByName(Roles.ROLE_MANAGER);
                if (roleOpt.isEmpty()) {
                    Role managerRole = new Role(Roles.ROLE_MANAGER);
                    roleRepo.save(managerRole);
                }
            }


            // Add admin if it does not exist
            Optional<User> adminOpt = userRepo.findByEmail(username);
            if (adminOpt.isEmpty()) {
                List<Role> rolesList = new ArrayList<>();
                List<Store> storeList = new ArrayList<>();
                rolesList.add(roleRepo.findByName(Roles.ROLE_ADMIN).get());

                User admin = new User("admin", "admin", username, passwordEncoder.encode(password), rolesList, storeList);

                userRepo.save(admin);
            }
        };
    }

}
