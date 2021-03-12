package se.expiry.hagrid;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;
import org.springframework.amqp.rabbit.listener.adapter.MessageListenerAdapter;

@SpringBootApplication
public class HagridApplication {
	 static final String topicExchangeName = "notification";

  static final String queueName = "";

  @Bean
  Queue queue() {
    return new Queue(queueName, false);
  }

  	@Bean
	DirectExchange exchange() {
		return new DirectExchange(topicExchangeName);
	}

  @Bean
  Binding binding(Queue queue, DirectExchange  exchange) {
    return BindingBuilder.bind(queue).to(exchange).with("notify");
  }



	public static void main(String[] args) {
		SpringApplication.run(HagridApplication.class, args);
	}

}
