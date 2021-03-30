package se.expiry.dumbledore.repository.store;

import com.mongodb.client.result.UpdateResult;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.presentation.request.product.UpdateProductRequestModel;


import java.util.List;

public interface StoreRepositoryCustom {
    UpdateResult addUserToStores(User user, List<String> storeIds);

    UpdateResult addProductsToStore(String storeId, List<Product> products);

    UpdateResult deleteProductFromStore(String storeId, String productId);

    UpdateResult addProductToStore(String storeId, Product products);

    Store updateProduct(String storeId, UpdateProductRequestModel product);

    UpdateResult removeStoreUser(String storeId, String userId);
}
