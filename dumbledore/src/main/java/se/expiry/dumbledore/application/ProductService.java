package se.expiry.dumbledore.application;

import com.mongodb.client.result.UpdateResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.repository.StoreRepository;

import java.util.List;
import java.util.Optional;

@Service
public class ProductService {

    @Autowired
    StoreRepository storeRepo;

    public List<Product> getProducts(String id){
        Optional<Store> optStore = storeRepo.findById(id);
        if(optStore.isEmpty()){
            //throw exc
        }

        return optStore.get().getProducts();
    }
    public void deleteProduct(String storeId, String productId){

        UpdateResult res = storeRepo.deleteProductFromStore(storeId, productId);
        System.out.println(res);
    }

}
