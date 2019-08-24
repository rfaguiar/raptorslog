package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class QueueConsumer {

    private static final Logger LOGGER = LoggerFactory.getLogger(QueueConsumer.class);
    private EncomendaService encomendaService;

    @Autowired
    public QueueConsumer(EncomendaService encomendaService) {
        this.encomendaService = encomendaService;
    }

    @RabbitListener(queues = "${raptorslog.rabbitmq.queue}")
    public void recievedMessage(Encomenda encomenda) {
        encomendaService.send(encomenda);
        LOGGER.info("Recieved Message From Queue: {}", encomenda);
    }
}
