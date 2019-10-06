package br.com.raptorslog.repository;

import br.com.raptorslog.model.Encomenda;
import org.springframework.http.ResponseEntity;

public interface Transportadora {

    ResponseEntity send(Encomenda encomenda, String userAgent);
}
