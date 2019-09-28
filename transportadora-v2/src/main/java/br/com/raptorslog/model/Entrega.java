package br.com.raptorslog.model;

public class Entrega {

    private String id;
    private String name;

    public Entrega(Encomenda encomenda) {
        this.id = encomenda.getId();
        this.name = encomenda.getName();
    }

    public Entrega() {}

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
