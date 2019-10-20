package br.com.raptorslog.controller;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.service.PedidoService;
import io.opentracing.Tracer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping(value = "/v1/pedido")
public class PedidoController {

    private static final Logger LOGGER = LoggerFactory.getLogger(PedidoController.class);
    private PedidoService pedidoService;

    private Tracer tracer;
    private String applicationName;

    @Autowired
    public PedidoController(PedidoService pedidoService,
                            Tracer tracer,
                            @Value("${spring.application.name}") String applicationName) {
        this.pedidoService = pedidoService;
        this.tracer = tracer;
        this.applicationName = applicationName;
    }

    @PostMapping
    public ResponseEntity<String> producer(@RequestHeader("User-Agent") String userAgent,
                                           @RequestBody(required = false) Optional<Encomenda> encomenda) {
        tracer.activeSpan().setBaggageItem("user-agent", userAgent);
        LOGGER.info("User-Agent: {}", userAgent);
        ResponseEntity resp = pedidoService.create(encomenda);
        return ResponseEntity
                .status(resp.getStatusCode())
                .body(String.format("%s v1 => %s", applicationName, resp.getBody()));
    }
}
