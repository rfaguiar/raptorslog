package br.com.raptorslog.repository;

import br.com.raptorslog.model.Encomenda;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;

@Repository
public class TransportadoraDispatcherImpl implements TransportadoraDispatcher {

    private final RestTemplate restTemplate;

    @Value("${client.transportadora-dispatcher.url}")
    private String remoteURL;

    @Autowired
    public TransportadoraDispatcherImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public ResponseEntity send(Encomenda encomenda) {
        return restTemplate.postForEntity(remoteURL.concat("/v1/encomenda"), encomenda, String.class);
    }
}
