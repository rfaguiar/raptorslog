package br.com.raptorslog.model;

public class Encomenda {

    private String id;
    private String name;
    private Estado estado;

    public Encomenda(String id, Estado estado, String name) {
        this.id = id;
        this.estado = estado;
        this.name = name;
    }

    public Encomenda() {}

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

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "Encomenda{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", estado='" + estado + '\'' +
                '}';
    }
}
