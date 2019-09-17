package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PedidoService {

    private EncomendaService encomendaService;

    @Autowired
    public PedidoService(EncomendaService encomendaService) {
        this.encomendaService = encomendaService;
    }

    public Message create(Encomenda encomenda) {
        encomendaService.send(encomenda);
        return new Message("Message {0} sent to the Queue Successfully".replace("{0}", "encomenda.getId()"));
    }
}
