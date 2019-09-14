package br.com.raptorslog.repository;

import br.com.raptorslog.model.Encomenda;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name = "transportadora-dispatcher", url = "${client.transportadora-dispatcher.url}")
public interface TransportadoraDispatcher {

    @PostMapping(value = "/v1/encomenda")
    ResponseEntity send(Encomenda encomenda);
}
