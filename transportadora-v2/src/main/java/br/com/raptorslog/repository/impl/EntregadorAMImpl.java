package br.com.raptorslog.repository.impl;

import br.com.raptorslog.model.Entrega;
import br.com.raptorslog.repository.EntregadorAM;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;

@Repository
public class EntregadorAMImpl implements EntregadorAM {

    private final RestTemplate restTemplate;

    @Value("${client.entregador-am.url}")
    private String remoteURL;

    @Autowired
    public EntregadorAMImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @Override
    public ResponseEntity send(Entrega entrega) {
        return restTemplate.postForEntity(remoteURL.concat("/entregas"), entrega, String.class);
    }
}
