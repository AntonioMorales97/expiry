package se.expiry.dumbledore.application;

import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.presentation.request.product.UpdateProductRequestModel;

import java.util.List;

public interface ProductService {
    List<Product> getProducts(String id);
     void deleteProduct(String storeId, String productId);
     Product addProduct(String storeId, String name, String qrCode, String date);
     void updateProduct(UpdateProductRequestModel product);
}
