package br.com.raptorslog.repository;

import br.com.raptorslog.model.Encomenda;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;

@Repository
public class TransportadoraImpl implements Transportadora {

    private final RestTemplate restTemplate;

    @Value("${client.transportadora.url}")
    private String remoteURL;

    @Autowired
    public TransportadoraImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @Override
    public ResponseEntity send(Encomenda encomenda, String userAgent) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("User-Agent", userAgent);
        HttpEntity<Encomenda> entity = new HttpEntity(encomenda, headers);
        return restTemplate.postForEntity(remoteURL.concat("/v1/pedido"), entity, String.class);
    }
}
