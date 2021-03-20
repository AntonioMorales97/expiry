package se.expiry.dumbledore.application;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.repository.StoreRepository;

import java.util.List;
import java.util.Random;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.sql.Timestamp;
import java.util.Optional;

@Service
public class AdminService {

    @Autowired
    StoreRepository storeRepo;

    public List<Store> createTestData(List<String> storeNames){
        List<Store> stores = new ArrayList<>();
        Random random = new Random();
        storeNames.forEach((storeName) -> {
            Optional<Store> opStore= storeRepo.findByName(storeName);
            Store store;
            int ammountofProducts = random.nextInt(4 - 1) + 1;
            if(opStore.isEmpty()){
                List<Product> products = new ArrayList<>();
                for(int i = 0; i<ammountofProducts; i++){
                    products.add(generateRandomProduct());
                }
               store = new Store(storeName, products); 
            }else{
                store = opStore.get();
                List<Product> products = store.getProducts();
                for(int i = 0; i<ammountofProducts; i++){
                    products.add(generateRandomProduct());
                }
            }
            stores.add(storeRepo.save(store));
        });
        return stores;
    }
    public Store addStore(String storeName){
        List<Product> products = new ArrayList<>();
        Optional<Store> opStore = storeRepo.findByName(storeName);
        Store store;
        if(opStore.isEmpty()){
            store = new Store(storeName, products);
            storeRepo.save(store);
        }else{
            store = opStore.get();
        }
        return store;
    }

    private Product generateRandomProduct(){
        return new Product(randomString(), randomQrCode(), randomDate());
    }
    private String randomString(){
        Random random = new Random();
        int aLimit = 97; 
        int zLimit = 122; 
        int targetStringLength = random.nextInt(10 - 5) + 1;
        return random.ints(aLimit, zLimit + 1)
        .limit(targetStringLength)
        .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
        .toString();
    }
    private String randomQrCode(){
        Random random = new Random();
        int qrCode = random.nextInt(1000 - 100) + 1;
        return Integer.toString(qrCode); 
    }
    private String randomDate(){
        Random random = new Random();
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        int startYear=2021;									
		int endYear=2021;									
		long start = Timestamp.valueOf(startYear+1+"-1-1 0:0:0").getTime();
		long end = Timestamp.valueOf(endYear+"-1-1 0:0:0").getTime();
		long ms=(long) ((end-start)*Math.random()+start);	
		Date date=new Date(ms);
		return dateFormat.format(date);

    }
}
