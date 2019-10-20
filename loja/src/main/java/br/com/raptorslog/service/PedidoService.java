package br.com.raptorslog.service;

import br.com.raptorslog.model.Encomenda;
import br.com.raptorslog.model.Estado;
import br.com.raptorslog.repository.Transportadora;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.Random;

@Service
public class PedidoService {

    private static final Logger LOGGER = LoggerFactory.getLogger(PedidoService.class);

    private Transportadora transportadora;

    @Autowired
    public PedidoService(Transportadora transportadora) {
        this.transportadora = transportadora;
    }

    public ResponseEntity<String> create(Optional<Encomenda> encomenda) {
        long value = new Random().nextLong();
        String uuid = String.format("%016x", value);
        Encomenda valid = encomenda.or(() -> createFake(uuid)).get();
        valid.setId(uuid);
        LOGGER.info("Sended: {}", valid);
        return transportadora.send(valid);
    }

    private Optional<Encomenda> createFake(String uuid) {
        return Optional.of(new Encomenda(
                uuid,
                Estado.getRandomEstado(),
                "encomenda-".concat(uuid)));
    }
}
