package br.com.raptorslog.repository;

import br.com.raptorslog.model.Encomenda;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name = "transportadora", url = "${client.transportadora.url}")
public interface Transportadora {

    @PostMapping(value = "/v1/pedido")
    ResponseEntity send(Encomenda encomenda);
}
