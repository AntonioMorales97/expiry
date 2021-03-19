package se.expiry.hagrid;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.CommandLineRunner;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Date;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;
import org.springframework.amqp.rabbit.listener.adapter.MessageListenerAdapter;

import se.expiry.hagrid.domain.Product;
import se.expiry.hagrid.repository.ProductRepository;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.text.DateFormat;




@SpringBootApplication
public class HagridApplication /*implements CommandLineRunner*/ {

	/*@Autowired
  	private ProduktRepository repository;*/

	public static void main(String[] args) {
		SpringApplication.run(HagridApplication.class, args);
	}

	/*@Override
  	public void run(String... args) throws Exception {

    	repository.deleteAll();
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		Date date = new Date(); 	
    	// save a couple of customers
    	repository.save(new Produkt("Gallerian", "123423421", "2", "testProdukten", dateFormat.format(date)));
    	repository.save(new Produkt("Nacka", "483929102", "3", "test2Produkten", dateFormat.format(date)));
    	// fetch all customers
    	System.out.println("Produkter funna med findAll():");
    	System.out.println("-------------------------------");
    	for (Produkt produkt : repository.findAll()) {
      		System.out.println(produkt);
    	}
	}*/
}

