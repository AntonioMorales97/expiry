package se.expiry.dumbledore.application;

import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.presentation.request.product.UpdateProductRequestModel;

import java.util.List;

public interface StoreService {
    List<Product> getProducts(String storeId);
     void deleteProduct(String storeId, String productId, String userId);
     Product addProduct(String storeId, String name, String qrCode, String date, String userId);
     void updateProduct(String storeId, UpdateProductRequestModel product, String userId);

    List<Store> getUserStoreProducts(String userId);

}
