package br.com.raptorslog.model;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import java.util.concurrent.TimeUnit;

@Entity
public class Entrega {

    private static final Logger LOGGER = LoggerFactory.getLogger(Entrega.class);

    @Id
    private String id;
    private String name;
    private long delay = 0;

    @PrePersist
    public void delayInsert() {
        try {
            LOGGER.info("Traveling {} to RS for {} {}", id, delay, "seconds");
            TimeUnit.SECONDS.sleep(delay);
        } catch (InterruptedException ie) {
            Thread.currentThread().interrupt();
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
