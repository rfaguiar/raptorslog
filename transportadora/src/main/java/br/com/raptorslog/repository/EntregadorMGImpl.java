package br.com.raptorslog.repository;

import br.com.raptorslog.model.Entrega;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;

@Repository
public class EntregadorMGImpl implements EntregadorMG {

    private final RestTemplate restTemplate;

    @Value("${client.entregador-mg.url}")
    private String remoteURL;

    @Autowired
    public EntregadorMGImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @Override
    public ResponseEntity send(Entrega entrega, String userAgent) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("User-Agent", userAgent);
        HttpEntity<Entrega> entity = new HttpEntity(entrega, headers);
        return restTemplate.postForEntity(remoteURL.concat("/entregas"), entity, String.class);
    }
}
