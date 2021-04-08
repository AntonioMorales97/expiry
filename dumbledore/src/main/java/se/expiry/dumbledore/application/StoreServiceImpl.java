package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.product.UpdateProductRequestModel;
import se.expiry.dumbledore.repository.store.StoreRepository;
import se.expiry.dumbledore.repository.user.UserRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class StoreServiceImpl implements StoreService {

    private final StoreRepository storeRepo;
    private final UserRepository userRepo;

    @Override
    public List<Product> getProducts(String storeId) {
        Optional<Store> optStore = storeRepo.findById(storeId);
        if (optStore.isEmpty()) {
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "No store with the given ID could be found.");
            throw new ExpiryException(exceptionDetail);
        }
        return optStore.get().getProducts();
    }

    @Override
    public void deleteProduct(String storeId, String productId, String userId) {
        checkIfUserOwnsStore(userId, storeId);
        storeRepo.deleteProductFromStore(storeId, productId);
    }
    @Override
    public Product addProduct(String storeId, String name, String qrCode, String date, String userId) {

        checkIfUserOwnsStore(userId, storeId);
        Product product = new Product(name, qrCode, date);
        UpdateResult res = storeRepo.addProductToStore(storeId, product);
        if (res.getMatchedCount() == 0) {
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "No store with the given ID could be found.");
            throw new ExpiryException(exceptionDetail);
        }
        return product;
    }

    @Override
    public Store updateProduct(String storeId, UpdateProductRequestModel product, String userId) {
        checkIfUserOwnsStore(userId, storeId);

        Store store = storeRepo.updateProduct(storeId, product);
        if(store == null){
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "Store could not be updated");
            throw new ExpiryException(exceptionDetail);
        }
        return store;
    }

    @Override

    public List<Store> getUserStoreProducts(String userId) {
        Optional<User> optUser= userRepo.findById(userId);
        if (optUser.isEmpty()) {
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "No User with the given ID could be found.");
            throw new ExpiryException(exceptionDetail);
        }
        List<Store> optStore = optUser.get().getStores();
        if (optStore.isEmpty()) {
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "The User with the given Email do not have any stores.");
            throw new ExpiryException(exceptionDetail);
        }

        return optUser.get().getStores();
    }


    /**
     * Helper function checks if user is allowed to modify store.
     * @param userId User
     * @param storeId The store to modify.
     */
    private void checkIfUserOwnsStore(String userId, String storeId){
        Optional<User> user = userRepo.findById(userId);
        if(user.isEmpty()){
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "No user with the given ID could be found.");
            throw new ExpiryException(exceptionDetail);
        }
        if(!user.get().getStores().stream().anyMatch(store -> store.getId().equals(storeId))){
            ExceptionDetail exceptionDetail = new ExceptionDetail(405, "User is not allowed to access store.");
            throw new ExpiryException(exceptionDetail);
        }
    }
}
