package br.com.raptorslog;

import io.jaegertracing.Configuration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class TransportadoraApplication {

	public static void main(String[] args) {
		SpringApplication.run(TransportadoraApplication.class, args);
	}

	@Bean
	public io.opentracing.Tracer tracer() {
		return Configuration.fromEnv().getTracer();
	}
}
