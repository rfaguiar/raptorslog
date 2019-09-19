package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Estado;
import br.com.raptorslog.model.Message;
import br.com.raptorslog.repository.Transportadora;
import io.opentracing.Tracer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.Random;

@Service
public class PedidoService {

    private static final Logger LOGGER = LoggerFactory.getLogger(PedidoService.class);

    private Tracer tracer;
    private Transportadora transportadora;

    @Autowired
    public PedidoService(Tracer tracer, Transportadora transportadora) {
        this.tracer = tracer;
        this.transportadora = transportadora;
    }

    public Message create(Optional<Encomenda> encomenda) {
        long value = new Random().nextLong();;
        String uuid = String.format("%016x", value);

        tracer.activeSpan().setBaggageItem("user-preference", uuid);
        Encomenda valid = encomenda.or(() -> createFake(uuid)).get();
        valid.setId(uuid);
        LOGGER.info("Sended: {}", valid);
        transportadora.send(valid);
        return new Message("Encomenda {0} sent to transportadora".replace("{0}", uuid));
    }

    private Optional<Encomenda> createFake(String uuid) {
        return Optional.of(new Encomenda(
                uuid,
                Estado.getRandomEstado(),
                "encomenda-".concat(uuid)));
    }

}
