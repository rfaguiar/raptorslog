package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class QueueSender {

    private static final Logger LOGGER = LoggerFactory.getLogger(QueueSender.class);

    @Autowired
    private AmqpTemplate amqpTemplate;

    @Value("${raptorslog.rabbitmq.exchange}")
    private String exchange;

    @Value("${raptorslog.rabbitmq.routingkey}")
    private String routingkey;

    public void send(Encomenda encomenda) {
        LOGGER.info("Send: {}", encomenda);
        amqpTemplate.convertAndSend(exchange, routingkey, encomenda);
    }
}
