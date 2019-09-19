package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Estado;
import br.com.raptorslog.model.Message;
import io.opentracing.Tracer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.Random;

@Service
public class PedidoService {

    private Tracer tracer;
    private QueueSender queueSender;

    @Autowired
    public PedidoService(QueueSender queueSender,Tracer tracer) {
        this.queueSender = queueSender;
        this.tracer = tracer;
    }

    public Message create(Optional<Encomenda> encomenda) {
        long value = new Random().nextLong();;
        String uuid = String.format("%016x", value);

        tracer.activeSpan().setBaggageItem("user-preference", uuid);
        Encomenda valid = encomenda.or(() -> createFake(uuid)).get();
        valid.setId(uuid);
        queueSender.send(valid);
        return new Message("Message {0} sent to the Queue Successfully".replace("{0}", uuid));
    }

    private Optional<Encomenda> createFake(String uuid) {
        return Optional.of(new Encomenda(
                uuid,
                Estado.getRandomEstado(),
                "encomenda-".concat(uuid)));
    }
}
