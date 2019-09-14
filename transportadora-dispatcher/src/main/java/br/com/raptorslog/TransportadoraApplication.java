package br.com.raptorslog;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class TransportadoraApplication {

	public static void main(String[] args) {
		SpringApplication.run(TransportadoraApplication.class, args);
	}

}
