package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;
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
    public List<Product> getProducts(String id){
        Optional<Store> optStore = storeRepo.findById(id);
        if(optStore.isEmpty()){
            //throw exc
        }
        return optStore.get().getProducts();
    }
    @Override
    public void deleteProduct(String storeId, String productId){

        UpdateResult res = storeRepo.deleteProductFromStore(storeId, productId);
        System.out.println(res);
    }
    @Override
    public Product addProduct(String storeId, String name, String qrCode, String date) {
        Product product = new Product(name, qrCode, date);
        UpdateResult res = storeRepo.addProductToStore(storeId, product);
        if(res.getModifiedCount() == 0){
            //throw cant find store by id.
        }
        return product;
    }
    @Override
    public void updateProduct(UpdateProductRequestModel product) {
        Store res = storeRepo.updateProduct(product.getStoreId(), product);
        System.out.println(res);
    }
}
