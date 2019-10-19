package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class QueueConsumer implements MessageListener {

    private static final Logger LOGGER = LoggerFactory.getLogger(QueueConsumer.class);

    private ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private EncomendaService encomendaService;

    public void onMessage(Message message, byte[] pattern) {
        try {
            Encomenda encomenda = objectMapper.readValue(message.toString(), Encomenda.class);
            encomendaService.send(encomenda);
            LOGGER.info("Message received: {}", encomenda);
        } catch (IOException e) {
            LOGGER.error(e.getMessage());
        }
    }
}
