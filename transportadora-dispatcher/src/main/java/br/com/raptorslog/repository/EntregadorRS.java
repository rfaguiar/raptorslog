package br.com.raptorslog.repository;

import br.com.raptorslog.model.Entrega;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name = "entregador-rs", url = "${client.entregador-rs.url}")
public interface EntregadorRS {

    @PostMapping(value = "/entregas")
    ResponseEntity send(Entrega entrega);
}
