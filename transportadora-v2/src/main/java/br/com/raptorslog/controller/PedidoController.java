package br.com.raptorslog.controller;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Message;
import br.com.raptorslog.service.PedidoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/v1/pedido")
public class PedidoController {

    private PedidoService pedidoService;
    private String applicationName;

    @Autowired
    public PedidoController(PedidoService pedidoService,
                            @Value("${spring.application.name}") String applicationName) {
        this.pedidoService = pedidoService;
        this.applicationName = applicationName;
    }

    @PostMapping
    public ResponseEntity producer(@RequestBody Encomenda encomenda) {
        ResponseEntity resp = pedidoService.create(encomenda);
        return ResponseEntity
                .status(resp.getStatusCode())
                .body(String.format("%s v1 => %s", applicationName, resp.getBody()));
    }
}
