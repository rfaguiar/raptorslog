package br.com.raptorslog.controller;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.service.PedidoService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/v1/pedido")
public class PedidoController {

    private static final Logger LOGGER = LoggerFactory.getLogger(PedidoController.class);
    private PedidoService pedidoService;
    private String applicationName;

    @Autowired
    public PedidoController(PedidoService pedidoService,
                            @Value("${spring.application.name}") String applicationName) {
        this.pedidoService = pedidoService;
        this.applicationName = applicationName;
    }

    @PostMapping
    public ResponseEntity producer(@RequestHeader("User-Agent") String userAgent,
                                   @RequestHeader(value = "baggage-user-agent", required = false) String baggageUserAgent,
                                   @RequestHeader(value = "user-agent", required = false) String useragent,
                                   @RequestBody Encomenda encomenda) {
        LOGGER.info("User-Agent: {}", userAgent);
        LOGGER.info("baggage-user-agent: {}", baggageUserAgent);
        LOGGER.info("user-agent: {}", useragent);
        ResponseEntity resp = pedidoService.create(encomenda, userAgent);
        return ResponseEntity
                .status(resp.getStatusCode())
                .body(String.format("%s v2 => %s", applicationName, resp.getBody()));
    }
}
