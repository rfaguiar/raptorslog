package br.com.raptorslog.controller;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.service.EncomendaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/v1/encomenda")
public class EncomendaController {

    private EncomendaService encomendaService;

    @Autowired
    public EncomendaController(EncomendaService encomendaService) {
        this.encomendaService = encomendaService;
    }

    @PostMapping
    public ResponseEntity producer(@RequestBody Encomenda encomenda) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(encomendaService.send(encomenda));
    }
}
