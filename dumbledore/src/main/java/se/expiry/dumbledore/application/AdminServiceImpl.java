package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Role;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.presentation.request.admin.UpdateUserRequestModel;
import se.expiry.dumbledore.repository.role.RoleRepository;
import se.expiry.dumbledore.repository.store.StoreRepository;
import se.expiry.dumbledore.repository.user.UserRepository;
import se.expiry.dumbledore.util.Roles;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class AdminServiceImpl implements AdminService {

    private RoleRepository roleRepo;

    private StoreRepository storeRepo;

    private UserRepository userRepo;

    private PasswordEncoder passwordEncoder;

    public AdminServiceImpl(StoreRepository storeRepo, RoleRepository roleRepo, UserRepository userRepo, PasswordEncoder passwordEncoder) {
        this.storeRepo = storeRepo;
        this.roleRepo = roleRepo;
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public User addUser(AddUserRequestModel newUser) {
        String hashedPassword = passwordEncoder.encode(newUser.getPassword());

        List<Role> matchingRoles = null;

        if (newUser.getRoleIds() != null) {
            matchingRoles = roleRepo.getMatchingRolesForIds(newUser.getRoleIds());
            if (Objects.isNull(matchingRoles) || matchingRoles.size() == 0) {
                //TODO: Error handling
            }
        } else {
            Role userRole = roleRepo.findByName(Roles.ROLE_USER);
            //TODO: Error handling
            matchingRoles = new ArrayList<>();
            matchingRoles.add(userRole);
        }

        User savedUser = userRepo.save(new User(newUser.getFirstName(), newUser.getLastName(), newUser.getEmail(), hashedPassword, matchingRoles));
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
        List<Role> matchingRoles = null;
        if (updateUserReq.getRoleIds() != null) {
            matchingRoles = roleRepo.getMatchingRolesForIds(updateUserReq.getRoleIds());
        }

        String hashedPassword = passwordEncoder.encode(updateUserReq.getPassword());

        User user = new User(
                updateUserReq.getFirstName(),
                updateUserReq.getLastName(),
                updateUserReq.getEmail(),
                hashedPassword,
                matchingRoles
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
