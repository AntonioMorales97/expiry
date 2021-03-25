package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.annotation.Id;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.presentation.request.admin.UpdateUserRequestModel;
import se.expiry.dumbledore.repository.StoreRepository;
import se.expiry.dumbledore.repository.UserRepository;

import java.util.List;
import java.util.Random;
import java.util.ArrayList;
import java.util.Optional;

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

    @Override
    public void createTestData(List<String> storeNames) {
        
        storeNames.forEach((storeName) -> {
            Random random = new Random();
            int ammountofProducts = random.nextInt(4 - 1) + 1;
            
                List<Product> products = new ArrayList<>();
                for (int i = 0; i < ammountofProducts; i++) {
                    products.add(generateRandomProduct());
                }
             
            UpdateResult updateResult = storeRepo.addProductsToStore(storeName,products);
          
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
    public User getUser(String email){
        Optional<User> user = userRepo.findByEmail(email);
        if(user.isEmpty()){
            //THROW exception user does not found.
        }
            return user.get();

    }
    @Override
    public User updateUser(UpdateUserRequestModel user){
        Optional<User> opUserToUpdate;
        String email;      
        if(user.getId()!= null){
            opUserToUpdate = userRepo.findById(user.getId());
        }else{
            email = user.getEmail();
            opUserToUpdate = userRepo.findByEmail(email);
        }
        if(opUserToUpdate.isEmpty()){
            //throw user does not exist..
        }
        User userToUpdate = opUserToUpdate.get();
        if(user.getFirstName() != null){
            userToUpdate.setFirstName(user.getFirstName());
        }
        if(user.getLastName() != null){
            userToUpdate.setLastName(user.getLastName());
        }
        if(user.getEmail() != null){
            userToUpdate.setEmail(user.getEmail());
        }
        if(user.getPassword() != null){
            String hashedPassword = passwordEncoder.encode(user.getPassword());
            userToUpdate.setPassword(hashedPassword);
        }

        return userRepo.save(userToUpdate);
    }
}
