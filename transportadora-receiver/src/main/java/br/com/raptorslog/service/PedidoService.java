package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PedidoService {

    private QueueSender queueSender;

    @Autowired
    public PedidoService(QueueSender queueSender) {
        this.queueSender = queueSender;
    }

    public Message create(Encomenda encomenda) {
        queueSender.send(encomenda);
        return new Message("Message {0} sent to the Queue Successfully".replace("{0}", "encomenda.getId()"));
    }
}
