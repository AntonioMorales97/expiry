package se.expiry.dumbledore.application;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.repository.StoreRepository;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    StoreRepository storeRepo;

    public List<Product> getProducts(){
        Store store = storeRepo.findByName("Gallerian").get();
        return store.getProducts();
    }
}
