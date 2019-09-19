package br.com.raptorslog.repository;

import br.com.raptorslog.model.Entrega;
import org.springframework.http.ResponseEntity;

public interface EntregadorAM {

    ResponseEntity send(Entrega entrega);
}
