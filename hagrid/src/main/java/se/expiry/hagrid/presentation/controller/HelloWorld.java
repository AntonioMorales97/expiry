package se.expiry.hagrid.presentation.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;

@RestController
public class HelloWorld {

    @Autowired
	private AmqpTemplate amqpTemplate;
    @GetMapping("/hello")
    public String hej(){
        amqpTemplate.convertAndSend("notification", "notify", "Hello World");
        return "Message sent!";
    }
}
