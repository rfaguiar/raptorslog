package br.com.raptorslog.repository;

import br.com.raptorslog.model.Entrega;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name = "entregador-am", url = "${client.entregador-am.url}")
public interface EntregadorAM {

    @PostMapping(value = "/entregas")
    ResponseEntity send(Entrega entrega);
}
