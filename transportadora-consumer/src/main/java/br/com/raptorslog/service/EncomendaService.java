package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.repository.TransportadoraDispatcher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class EncomendaService {

    private static final Logger LOGGER = LoggerFactory.getLogger(EncomendaService.class);
    private TransportadoraDispatcher transportadoraDispatcher;

    @Autowired
    public EncomendaService(TransportadoraDispatcher transportadoraDispatcher) {
        this.transportadoraDispatcher = transportadoraDispatcher;
    }

    public void send(Encomenda encomenda) {
        ResponseEntity send = transportadoraDispatcher.send(encomenda);
        LOGGER.info("Send to Dispatcher: {}\n{}\n{}",
                send.getBody(),
                send.getStatusCodeValue(),
                send.getHeaders().entrySet());
    }

}
