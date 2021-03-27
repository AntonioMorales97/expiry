package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.presentation.request.product.UpdateProductRequestModel;
import se.expiry.dumbledore.repository.StoreRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final StoreRepository storeRepo;

    @Override
    public List<Product> getProducts(String id) {
        Optional<Store> optStore = storeRepo.findById(id);
        if (optStore.isEmpty()) {
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "No store with the given ID could be found.");
            throw new ExpiryException(exceptionDetail);
        }
        return optStore.get().getProducts();
    }

    @Override
    public void deleteProduct(String storeId, String productId) {
        storeRepo.deleteProductFromStore(storeId, productId);
    }

    @Override
    public Product addProduct(String storeId, String name, String qrCode, String date) {
        Product product = new Product(name, qrCode, date);
        UpdateResult res = storeRepo.addProductToStore(storeId, product);
        if (res.getMatchedCount() == 0) {
            ExceptionDetail exceptionDetail = new ExceptionDetail(404, "No store with the given ID could be found.");
            throw new ExpiryException(exceptionDetail);
        }
        return product;
    }

    @Override
    public void updateProduct(UpdateProductRequestModel product) {
        storeRepo.updateProduct(product.getStoreId(), product);
    }
}
