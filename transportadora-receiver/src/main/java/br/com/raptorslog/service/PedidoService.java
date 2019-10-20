package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PedidoService {

    private QueueSender queueSender;

    @Autowired
    public PedidoService(QueueSender queueSender) {
        this.queueSender = queueSender;
    }

    public String create(Encomenda encomenda) {
        queueSender.send(encomenda);
        return "Sended to Redis";
    }
}
