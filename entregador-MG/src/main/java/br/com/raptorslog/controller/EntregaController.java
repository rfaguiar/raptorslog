package br.com.raptorslog.controller;

import br.com.raptorslog.model.Entrega;
import br.com.raptorslog.repository.EntregaRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EntregaController {

    private static final Logger LOGGER = LoggerFactory.getLogger(EntregaController.class);
    private EntregaRepository entregaRepository;
    private String applicationName;

    @Autowired
    public EntregaController(EntregaRepository entregaRepository,
                             @Value("${spring.application.name}") String applicationName) {
        this.entregaRepository = entregaRepository;
        this.applicationName = applicationName;
    }

    @PostMapping("/entregas")
    public ResponseEntity<String> create(@RequestHeader("User-Agent") String userAgent,
                                         @RequestBody Entrega entrega) {
        LOGGER.info("User-Agent: {}", userAgent);
        entregaRepository.save(entrega);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(String.format("%s v1 - id: %s", applicationName, entrega.getId()));
    }

}
