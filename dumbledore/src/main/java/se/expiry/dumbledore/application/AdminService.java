package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.repository.StoreRepository;
import se.expiry.dumbledore.repository.UserRepository;

import java.util.List;
import java.util.Random;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.sql.Timestamp;
import java.util.Optional;

@Service
public class AdminService {

    @Autowired
    StoreRepository storeRepo;

    @Autowired
    UserRepository userRepo;

    @Autowired
    PasswordEncoder passwordEncoder;

    public User addUser(AddUserRequestModel newUser) {
        String hashedPassword = passwordEncoder.encode(newUser.getPassword());
        User savedUser = userRepo.save(new User(newUser.getFirstName(), newUser.getLastName(), newUser.getEmail(), hashedPassword));
        if (newUser.getStores() != null) {

            UpdateResult updateResult = storeRepo.addUserToStores(savedUser, newUser.getStores());

            if (newUser.getStores().size() == updateResult.getMatchedCount()) {

                ExceptionDetail exceptionDetail = new ExceptionDetail(400, "Some stores could not be found!");
                throw new ExpiryException(exceptionDetail);
            }

            if (newUser.getStores().size() != updateResult.getModifiedCount()) {
                ExceptionDetail exceptionDetail = new ExceptionDetail(500, "Some stores could not be updated. Please contact Hagrid.");
                throw new ExpiryException(exceptionDetail);
            }


        }

        return savedUser;
    }


    public void createTestData(List<String> storeNames) {
        
        storeNames.forEach((storeName) -> {
            Random random = new Random();
            int ammountofProducts = random.nextInt(4 - 1) + 1;
            
                List<Product> products = new ArrayList<>();
                for (int i = 0; i < ammountofProducts; i++) {
                    products.add(generateRandomProduct());
                }
             
            UpdateResult updateResult = storeRepo.addTestData(storeName,products);
          
        });
    }

    public Store addStore(String storeName) {
        List<Product> products = new ArrayList<>();
        Optional<Store> opStore = storeRepo.findByName(storeName);
        Store store;
        if (opStore.isEmpty()) {
            store = new Store(storeName, products);
            storeRepo.save(store);
        } else {
            store = opStore.get();
        }
        return store;
    }

    private Product generateRandomProduct() {
        return new Product(randomString(), randomQrCode(), randomDate());
    }

    private String randomString() {
        Random random = new Random();
        int aLimit = 97;
        int zLimit = 122;
        int targetStringLength = random.nextInt(10 - 5) + 1;
        return random.ints(aLimit, zLimit + 1)
                .limit(targetStringLength)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
    }

    private String randomQrCode() {
        Random random = new Random();
        int qrCode = random.nextInt(1000 - 100) + 1;
        return Integer.toString(qrCode);
    }

    private String randomDate() {
        Random random = new Random();
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        int startYear = 2021;
        int endYear = 2021;
        long start = Timestamp.valueOf(startYear + 1 + "-1-1 0:0:0").getTime();
        long end = Timestamp.valueOf(endYear + "-1-1 0:0:0").getTime();
        long ms = (long) ((end - start) * Math.random() + start);
        Date date = new Date(ms);
        return dateFormat.format(date);

    }
}
