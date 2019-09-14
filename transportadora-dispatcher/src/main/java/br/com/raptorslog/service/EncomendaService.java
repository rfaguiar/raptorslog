package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Entrega;
import br.com.raptorslog.model.Estado;
import br.com.raptorslog.repository.Entregador;
import br.com.raptorslog.repository.EntregadorAM;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class EncomendaService {

    private static final Logger LOGGER = LoggerFactory.getLogger(EncomendaService.class);
    private Entregador entregador;
    private EntregadorAM entregadorAM;

    @Autowired
    public EncomendaService(Entregador entregador, EntregadorAM entregadorAM) {
        this.entregador = entregador;
        this.entregadorAM = entregadorAM;
    }

    public void send(Encomenda encomenda) {
        ResponseEntity send = sendEncomenda(encomenda);
        LOGGER.info("Dispatched: {}\n{}\n{}",
                send.getBody(),
                send.getStatusCodeValue(),
                send.getHeaders().entrySet());
    }

    private ResponseEntity sendEncomenda(Encomenda encomenda) {
        Entrega entrega = new Entrega(encomenda);
        if (Estado.AM.equals(encomenda.getEstado())) {
            return entregadorAM.send(entrega);
        }
        return entregador.send(entrega);
    }

}
