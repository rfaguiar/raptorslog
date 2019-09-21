package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class PedidoService {

    private EncomendaService encomendaService;

    @Autowired
    public PedidoService(EncomendaService encomendaService) {
        this.encomendaService = encomendaService;
    }

    public ResponseEntity create(Encomenda encomenda) {
        return encomendaService.send(encomenda);
    }
}
