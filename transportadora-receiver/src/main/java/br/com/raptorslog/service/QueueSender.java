package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Service;

@Service
public class QueueSender {

    private static final Logger LOGGER = LoggerFactory.getLogger(QueueSender.class);

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private ChannelTopic topic;

    public void send(Encomenda encomenda) {
        redisTemplate.convertAndSend(topic.getTopic(), encomenda);
        LOGGER.info("Sended: {}", encomenda);
    }
}
