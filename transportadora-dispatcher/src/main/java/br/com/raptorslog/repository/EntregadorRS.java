package br.com.raptorslog.repository;

import br.com.raptorslog.model.Entrega;
import org.springframework.http.ResponseEntity;

public interface EntregadorRS {
    ResponseEntity send(Entrega entrega);
}
