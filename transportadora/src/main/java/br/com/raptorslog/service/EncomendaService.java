package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Entrega;
import br.com.raptorslog.repository.Entregador;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class EncomendaService {

    private static final Logger LOGGER = LoggerFactory.getLogger(EncomendaService.class);
    private Entregador entregador;

    @Autowired
    public EncomendaService(Entregador entregador) {
        this.entregador = entregador;
    }

    public void send(Encomenda encomenda) {
        ResponseEntity send = entregador.send(new Entrega(encomenda));
        LOGGER.info("Dispatched: {}\n{}\n{}",
                send.getBody(),
                send.getStatusCodeValue(),
                send.getHeaders().entrySet());
    }

}
