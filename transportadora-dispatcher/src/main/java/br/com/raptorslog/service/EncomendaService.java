package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Entrega;
import br.com.raptorslog.model.Message;
import br.com.raptorslog.repository.EntregadorRS;
import br.com.raptorslog.repository.EntregadorAM;
import br.com.raptorslog.repository.EntregadorMG;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class EncomendaService {

    private static final Logger LOGGER = LoggerFactory.getLogger(EncomendaService.class);
    private EntregadorRS entregadorRS;
    private EntregadorAM entregadorAM;
    private EntregadorMG entregadorMG;

    @Autowired
    public EncomendaService(EntregadorRS entregadorRS,
                            EntregadorAM entregadorAM,
                            EntregadorMG entregadorMG) {
        this.entregadorRS = entregadorRS;
        this.entregadorAM = entregadorAM;
        this.entregadorMG = entregadorMG;
    }

    public Message send(Encomenda encomenda) {
        ResponseEntity send = sendToState(encomenda);
        LOGGER.info("Dispatched: {}\n{}\n{}",
                send.getBody(),
                send.getStatusCodeValue(),
                send.getHeaders().entrySet());
        return new Message("Encomenda {0} sent to the Dispatcher Successfully".replace("{0}", encomenda.getId()));
    }

    private ResponseEntity sendToState(Encomenda encomenda) {
        Entrega entrega = new Entrega(encomenda);
        switch (encomenda.getEstado()) {
            case MG: return entregadorMG.send(entrega);
            case AM: return entregadorAM.send(entrega);
            default: return entregadorRS.send(entrega);
        }
    }

}
