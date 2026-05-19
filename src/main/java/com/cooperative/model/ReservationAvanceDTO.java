package com.cooperative.model;

import java.util.ArrayList;
import java.util.List;

public class ReservationAvanceDTO {

    private String idReserv;
    private String nomClient;
    private String numTel;
    private String places;       // "1,2,3" — stocké tel quel depuis le varchar(255)
    private String dateVoyage;
    private int frais;           // prix par place
    private String payment;
    private int montantAvance;   // montant fixe, ne multiplie pas
    private int resteAPayer;

    public ReservationAvanceDTO() {}

    // ==================== GETTERS ====================

    public String getIdReserv()      { return idReserv; }
    public String getNomClient()     { return nomClient; }
    public String getNumTel()        { return numTel; }
    public String getPlaces()        { return places; }
    public String getDateVoyage()    { return dateVoyage; }
    public int    getFrais()         { return frais; }
    public String getPayment()       { return payment; }
    public int    getMontantAvance() { return montantAvance; }
    public int    getResteAPayer()   { return resteAPayer; }

    // ==================== SETTERS ====================

    public void setIdReserv(String idReserv)         { this.idReserv = idReserv; }
    public void setNomClient(String nomClient)       { this.nomClient = nomClient; }
    public void setNumTel(String numTel)             { this.numTel = numTel; }
    public void setPlaces(String places)             { this.places = places; }
    public void setDateVoyage(String dateVoyage)     { this.dateVoyage = dateVoyage; }
    public void setFrais(int frais)                  { this.frais = frais; }
    public void setPayment(String payment)           { this.payment = payment; }
    public void setMontantAvance(int montantAvance)  { this.montantAvance = montantAvance; }
    public void setResteAPayer(int resteAPayer)      { this.resteAPayer = resteAPayer; }

    // ==================== MÉTHODES UTILITAIRES ====================

    /**
     * Retourne la liste des numéros de places parsés depuis le varchar.
     * Exemple : "1,3,5" → [1, 3, 5]
     */
    public List<Integer> getPlacesList() {
        List<Integer> list = new ArrayList<>();
        if (places != null && !places.trim().isEmpty()) {
            for (String p : places.split(",")) {
                try { list.add(Integer.parseInt(p.trim())); }
                catch (NumberFormatException ignored) {}
            }
        }
        return list;
    }

    /**
     * Retourne le nombre de places réservées.
     * Exemple : "1,3,5" → 3
     */
    public int getNombrePlaces() {
        return getPlacesList().size();
    }

    /**
     * Retourne la première place (compatibilité avec l'ancien champ int place).
     * Retourne 0 si aucune place n'est définie.
     */
    public int getFirstPlace() {
        List<Integer> list = getPlacesList();
        return list.isEmpty() ? 0 : list.get(0);
    }

    /**
     * Retourne les places sous forme lisible pour affichage.
     * Exemple : "1,3,5" → "💺 1, 💺 3, 💺 5"
     */
    public String getPlacesFormatted() {
        if (places == null || places.trim().isEmpty()) return "—";
        return "💺 " + places.replace(",", ", 💺 ");
    }

    /**
     * Calcule le montant total dû (frais × nombre de places).
     */
    public int getMontantTotal() {
        return frais * getNombrePlaces();
    }

    /**
     * Calcule le reste à payer réel basé sur le montant total
     * L'avance reste FIXE (ne multiplie pas par le nombre de places)
     */
    public int calculerReste() {
        if ("tout payé".equals(payment)) return 0;
        if ("avec avance".equals(payment)) {
            // Total - avance (avance fixe, pas multipliée)
            return getMontantTotal() - montantAvance;
        }
        return getMontantTotal(); // sans avance
    }

    /**
     * Affiche le montant total formaté
     */
    public String getMontantTotalFormatted() {
        return String.format("%,d Ar", getMontantTotal());
    }

    /**
     * Affiche le reste à payer formaté
     */
    public String getResteAPayerFormatted() {
        return String.format("%,d Ar", calculerReste());
    }

    /**
     * Affiche l'avance formatée
     */
    public String getMontantAvanceFormatted() {
        return String.format("%,d Ar", montantAvance);
    }

    @Override
    public String toString() {
        return "ReservationAvanceDTO{" +
                "idReserv='" + idReserv + '\'' +
                ", nomClient='" + nomClient + '\'' +
                ", numTel='" + numTel + '\'' +
                ", places='" + places + '\'' +
                ", dateVoyage='" + dateVoyage + '\'' +
                ", frais=" + frais +
                ", payment='" + payment + '\'' +
                ", montantAvance=" + montantAvance +
                ", resteAPayer=" + resteAPayer +
                '}';
    }
}