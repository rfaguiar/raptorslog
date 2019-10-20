package br.com.raptorslog.controller;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.service.EncomendaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/v1/encomenda")
public class EncomendaController {

    private EncomendaService encomendaService;
    private String applicationName;

    @Autowired
    public EncomendaController(EncomendaService encomendaService,
                               @Value("${spring.application.name}") String applicationName) {
        this.encomendaService = encomendaService;
        this.applicationName = applicationName;
    }

    @PostMapping
    public ResponseEntity producer(@RequestBody Encomenda encomenda) {
        ResponseEntity resp = encomendaService.send(encomenda);
        return ResponseEntity
                .status(resp.getStatusCode())
                .body(String.format("%s v1 => %s", applicationName, resp.getBody()));
    }
}
