package se.expiry.hagrid.service;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import org.json.simple.JSONObject;
import se.expiry.hagrid.domain.Produkt;
import se.expiry.hagrid.repository.ProduktRepository;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.text.DateFormat;

@Component
public class SendExpireService {
    @Autowired
	private AmqpTemplate amqpTemplate;
    @Autowired
  	private ProduktRepository repository;
      
    //@Scheduled(cron="0 6 * * ?", zone="Europe/Stockholm")
    @Scheduled(cron="*/30 * * * * *")
    public void getExpiredItems(){
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		Date date = new Date(); 
        Produkt produkt = repository.findByDate(dateFormat.format(date));
        System.out.println(produkt.toString());
        //TODO for each item in db, run send to expired.
        /*JSONObject obj = new JSONObject();
        obj.put("name", "Gallerian");
        obj.put("id", 1);
        obj.put("hylla", 21);
        obj.put("produkt", "någon produkt");*/
        sendExpiredToRabbit(produkt);
    }
    public void sendExpiredToRabbit(Produkt produkt){
        
        amqpTemplate.convertAndSend("notification", produkt.getNamn(), produkt.toString());
    }

}