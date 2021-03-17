package se.expiry.hagrid.service;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import org.json.simple.JSONObject;

@Component
public class SendExpireService {
    @Autowired
	private AmqpTemplate amqpTemplate;

    //@Scheduled(cron="0 6 * * ?", zone="Europe/Stockholm")
    @Scheduled(cron="*/30 * * * * *")
    public void getExpiredItems(){

        //TODO for each item in db, run send to expired.
        JSONObject obj = new JSONObject();
        obj.put("name", "Gallerian");
        obj.put("id", 1);
        obj.put("hylla", 21);
        obj.put("produkt", "någon produkt");
        sendExpiredToRabbit(obj);
    }
    public void sendExpiredToRabbit(JSONObject expiredItem){
        
        amqpTemplate.convertAndSend("notification", expiredItem.get("name").toString(), expiredItem.toString());
    }

}