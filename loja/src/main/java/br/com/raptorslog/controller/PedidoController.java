package br.com.raptorslog.controller;

import io.opentracing.Tracer;
import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.service.PedidoService;
import org.springframework.beans.factory.annotation.Autowired;
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

    private PedidoService pedidoService;

    private Tracer tracer;

    @Autowired
    public PedidoController(PedidoService pedidoService, Tracer tracer) {
        this.pedidoService = pedidoService;
        this.tracer = tracer;
    }

    @PostMapping
    public ResponseEntity producer(@RequestHeader("User-Agent") String userAgent, @RequestBody(required = false) Optional<Encomenda> encomenda) {

        tracer.activeSpan().setBaggageItem("User-Agent", userAgent);
        if (encomenda.isPresent()) {
            tracer.activeSpan().setBaggageItem("encomenda", encomenda.get().getId());
        }
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(pedidoService.create(encomenda));
    }
}
