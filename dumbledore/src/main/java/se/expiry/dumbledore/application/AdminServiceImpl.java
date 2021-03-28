package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.annotation.Id;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.presentation.request.admin.UpdateUserRequestModel;
import se.expiry.dumbledore.repository.StoreRepository;
import se.expiry.dumbledore.repository.UserRepository;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {
    private final StoreRepository storeRepo;

    private final UserRepository userRepo;

    private final PasswordEncoder passwordEncoder;

    @Override
    public User addUser(AddUserRequestModel newUser) {
        String hashedPassword = passwordEncoder.encode(newUser.getPassword());
        User savedUser = userRepo.save(new User(newUser.getFirstName(), newUser.getLastName(), newUser.getEmail(), hashedPassword));
        if (newUser.getStoreIds() != null) {

            UpdateResult updateResult = storeRepo.addUserToStores(savedUser, newUser.getStoreIds());

            if (newUser.getStoreIds().size() != updateResult.getMatchedCount()) {
                ExceptionDetail exceptionDetail = new ExceptionDetail(400, "Some stores could not be found.");
                throw new ExpiryException(exceptionDetail);
            }

            if (newUser.getStoreIds().size() != updateResult.getModifiedCount()) {
                ExceptionDetail exceptionDetail = new ExceptionDetail(500, "Some stores could not be updated. Please contact Hagrid.");
                throw new ExpiryException(exceptionDetail);
            }
        }

        return savedUser;
    }

    @Override
    public void createTestData(List<String> storeNames) {

        storeNames.forEach((storeName) -> {
            Random random = new Random();
            int amountOfProducts = random.nextInt(4 - 1) + 1;

            List<Product> products = new ArrayList<>();
            for (int i = 0; i < amountOfProducts; i++) {
                products.add(generateRandomProduct());
            }

            UpdateResult updateResult = storeRepo.addProductsToStore(storeName, products);

        });
    }

    @Override
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

    @Override
    public User getUser(String id) {
        Optional<User> user = userRepo.findById(id);
        if (user.isEmpty()) {
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "User could not be found.");
            throw new ExpiryException(exceptionDetail);
        }
        return user.get();
    }

    @Override
    public User updateUser(String id, UpdateUserRequestModel updateUserReq) {

        User user = new User(
                updateUserReq.getFirstName(),
                updateUserReq.getLastName(),
                updateUserReq.getEmail(),
                updateUserReq.getPassword()
                );

        return userRepo.updateUser(id, user);
    }

    @Override
    public Product generateRandomProduct() {
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
