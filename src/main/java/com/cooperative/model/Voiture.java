package com.cooperative.model;

public class Voiture {
    private String idvoit;
    private String design;
    private String type;
    private int nbrplace;
    private int frais;

    public Voiture() {}

    public Voiture(String idvoit, String design, String type, int nbrplace, int frais) {
        this.idvoit = idvoit;
        this.design = design;
        this.type = type;
        this.nbrplace = nbrplace;
        this.frais = frais;
    }

    // Getters et Setters
    public String getIdvoit() { return idvoit; }
    public void setIdvoit(String idvoit) { this.idvoit = idvoit; }

    public String getDesign() { return design; }
    public void setDesign(String design) { this.design = design; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getNbrplace() { return nbrplace; }
    public void setNbrplace(int nbrplace) { this.nbrplace = nbrplace; }

    public int getFrais() { return frais; }
    public void setFrais(int frais) { this.frais = frais; }
}