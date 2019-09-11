package br.com.raptorslog.model;

import java.util.Random;

public enum Estado {

    AM, MG, RS;

    public static Estado getRandomEstado() {
        return values()[new Random().nextInt(values().length)];
    }
}
