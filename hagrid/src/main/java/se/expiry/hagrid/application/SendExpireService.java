package se.expiry.hagrid.service;

import java.util.List;
import java.util.ArrayList;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


import se.expiry.hagrid.domain.Product;
import se.expiry.hagrid.domain.Store;
import se.expiry.hagrid.repository.StoreRepository;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.text.DateFormat;

@Component
public class SendExpireService {
    @Autowired
	private AmqpTemplate amqpTemplate;
    @Autowired
  	private StoreRepository storeRepo;
       
    //@Scheduled(cron="0 6 * * ?", zone="Europe/Stockholm")
    @Scheduled(cron="*/30 * * * * *")
    public void getExpiredItems() throws Exception {
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		Date date = new Date(); 
        GsonBuilder gsonBuilder = new GsonBuilder();
        Gson gson = gsonBuilder.create();
        List<Store> stores = storeRepo.findAll();
        stores.forEach((store) ->{
            List<Product> products =  store.getProducts();
            List<Product> productsToSend = new ArrayList();
            products.forEach((product) ->{
                try{
            
            System.out.println(product.getDate() + " || "+ dateFormat.format(date));
            if(product.getDate().equals(dateFormat.format(date))){
                productsToSend.add(product);
                System.out.println(product);
                System.out.println(productsToSend);
                
            } }
                catch(Exception e){
                    
                }
        });
           sendExpiredToRabbit(store.getName() ,gson.toJson(productsToSend));
        });
    
        
     
    }
    public void sendExpiredToRabbit(String name, String product){
        
        amqpTemplate.convertAndSend("notification", name, product);
    }

}