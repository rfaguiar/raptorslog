package br.com.raptorslog.controller;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Estado;
import br.com.raptorslog.model.Message;
import br.com.raptorslog.service.QueueSender;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping(value = "/v1/pedido")
public class PedidoController {

    private QueueSender queueSender;

    @Autowired
    public PedidoController(QueueSender queueSender) {
        this.queueSender = queueSender;
    }

    @PostMapping
    public ResponseEntity producer() {
        String uuid = UUID.randomUUID().toString();
        queueSender.send(new Encomenda(
                uuid,
                Estado.getRandomEstado(),
                "encomenda-".concat(uuid)));

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(new Message("Message {} sent to the Queue Successfully".replace("{}", uuid)));
    }
}
