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
    public List<Store> getStores(){
        return storeRepo.findAll();
    }

    @Override
    public void removeUserFromStore(String storeId, String userId) {
        //TODO: Maybe check if store exists etc...
        UpdateResult storeResult = storeRepo.removeUserFromStore(storeId, userId);
        UpdateResult userResult = userRepo.removeStoreFromUser(userId, storeId);
        if(userResult.getModifiedCount() == 0 || storeResult.getModifiedCount() == 0){
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "Something went wrong, store not removed from user.");
            throw new ExpiryException(exceptionDetail);
        }

    }

    @Override
    public void deleteStore(String storeId){
        Store store = storeRepo.findById(storeId).orElseThrow(() -> new ExpiryException(new ExceptionDetail(404, "No store could be found.")));
        storeRepo.delete(store);
    }

    @Override
    public Store updateStore(String storeId, String newName){
        Store store = storeRepo.findById(storeId).orElseThrow(() -> new ExpiryException(new ExceptionDetail(404, "No store could be found.")));

        store.setName(newName);
        storeRepo.save(store);
        return store;
    }

    //TODO: case sensitivity

    @Override
    public List<User> getUsers(){
        return userRepo.findAll();
    }

    @Override
    public void addUserToStore(String storeId, String userId){
        User user = userRepo.findById(userId).orElseThrow(() -> new ExpiryException(new ExceptionDetail(404, "No user could be found.")));
        Store store = storeRepo.findById(storeId).orElseThrow(() -> new ExpiryException(new ExceptionDetail(404, "No store could be found.")));

        if(!store.getUsers().contains(user.getId())){
            store.getUsers().add(user.getId());
            storeRepo.save(store);
        }
        if(!user.getStores().contains(store)){
            user.getStores().add(store);
            userRepo.save(user);
        }
    }

    @Override
    public User addUser(AddUserRequestModel newUser) {
        String hashedPassword = passwordEncoder.encode(newUser.getPassword());

        List<Role> matchingRoles = null;

        if (newUser.getRoleIds() != null && newUser.getRoleIds().size() > 0) {
            matchingRoles = roleRepo.getMatchingRolesForIds(newUser.getRoleIds());
            if (Objects.isNull(matchingRoles) || matchingRoles.size() != newUser.getRoleIds().size()) {
                ExceptionDetail exceptionDetail = new ExceptionDetail(404, "Some roles could not be found.");
                throw new ExpiryException(exceptionDetail);
           }
        } else {
            Role userRole = roleRepo.findByName(Roles.ROLE_USER).orElseThrow(() -> new ExpiryException(new ExceptionDetail(500, "User role could not be found.")));
            matchingRoles = new ArrayList<>();
            matchingRoles.add(userRole);
        }

        User savedUser = userRepo.save(new User(newUser.getFirstName(), newUser.getLastName(), newUser.getEmail(), hashedPassword, matchingRoles));
        if (newUser.getStoreIds() != null) {

            List<Store> stores = (List<Store>) storeRepo.findAllById(newUser.getStoreIds());

            if(stores.size() != newUser.getStoreIds().size()){
                ExceptionDetail exceptionDetail = new ExceptionDetail(404, "Some stores could not be found.");
                throw new ExpiryException(exceptionDetail);
            }

            savedUser.setStores(stores);
            userRepo.save(savedUser);
        }

        return savedUser;
    }

    @Override
    public Store addStore(String storeName) {
        List<Product> products = new ArrayList<>();
        Optional<Store> optStore = storeRepo.findByName(storeName);
        Store store;
        if (optStore.isEmpty()) {
            store = new Store(storeName, products, null);
            storeRepo.save(store);
        } else {
            store = optStore.get();
        }
        return store;
    }

    @Override
    public User getUser(String id) {
       return userRepo.findById(id).orElseThrow(() -> new ExpiryException(new ExceptionDetail(404, "No user could be found.")));
    }

    @Override
    public User updateUser(String id, UpdateUserRequestModel updateUserReq) {
        List<Role> matchingRoles = null;
        if (updateUserReq.getRoleIds() != null && updateUserReq.getRoleIds().size() > 0) {
            matchingRoles = roleRepo.getMatchingRolesForIds(updateUserReq.getRoleIds());
            if(matchingRoles.size() != updateUserReq.getRoleIds().size())
                throw new ExpiryException(new ExceptionDetail(404, "Some roles could not be found."));
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
}
