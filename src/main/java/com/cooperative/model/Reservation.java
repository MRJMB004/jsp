package com.cooperative.model;

import java.sql.Timestamp;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class Reservation {

    private String idreserv;
    private String idvoit;
    private int idcli;

    // Stockage DB : "1,3,5" (places séparées par virgule)
    private String places;

    private Timestamp dateReserv;
    private Date dateVoyage;
    private String payment;
    private int montantAvance;

    private int nombrePlaces;
    private List<Integer> placesList;

    // Affichage
    private String nomClient;
    private String designVoiture;
    private String typeVoiture;
    private int fraisVoiture;
    private String numtelClient;

    // ============================================================
    // CONSTRUCTEUR
    // ============================================================

    public Reservation() {
        this.placesList  = new ArrayList<>();
        this.nombrePlaces = 0;
    }

    // ============================================================
    // IDENTIFIANTS
    // ============================================================

    public String getIdreserv() { return idreserv; }
    public void setIdreserv(String idreserv) { this.idreserv = idreserv; }

    public String getIdvoit() { return idvoit; }
    public void setIdvoit(String idvoit) { this.idvoit = idvoit; }

    public int getIdcli() { return idcli; }
    public void setIdcli(int idcli) { this.idcli = idcli; }

    // ============================================================
    // PLACES (String "1,3,5")
    // ============================================================

    public String getPlaces() { return places; }

    public void setPlaces(String places) {
        this.places    = places;
        this.placesList = new ArrayList<>();
        if (places != null && !places.trim().isEmpty()) {
            for (String p : places.split(",")) {
                try { placesList.add(Integer.parseInt(p.trim())); }
                catch (Exception ignored) {}
            }
        }
        this.nombrePlaces = placesList.size();
    }

    // ============================================================
    // ALIAS COMPATIBILITÉ : setPlace(int) / getPlace()
    //   → utilisés par ReservationDAO (mapReservation, mapReservationBasic)
    //     ReservationServlet (update), recu.jsp, PDFGenerator, PdfReceiptServlet
    // ============================================================

    /** Alias pour une seule place (ex: mapping d'une ligne DB avec colonne "place"). */
    public void setPlace(int place) {
        this.places    = String.valueOf(place);
        this.placesList = new ArrayList<>();
        if (place > 0) placesList.add(place);
        this.nombrePlaces = placesList.size();
    }

    /**
     * Retourne la première place de la liste (ou 0 si aucune).
     * Utilisé par recu.jsp, PDFGenerator, PdfReceiptServlet pour afficher "N° de place".
     */
    public int getPlace() {
        if (placesList != null && !placesList.isEmpty()) return placesList.get(0);
        if (places != null && !places.trim().isEmpty()) {
            try { return Integer.parseInt(places.split(",")[0].trim()); }
            catch (Exception ignored) {}
        }
        return 0;
    }

    // ============================================================
    // LISTE JAVA
    // ============================================================

    public List<Integer> getPlacesList() { return placesList; }

    public void setPlacesList(List<Integer> placesList) {
        this.placesList = placesList;
        if (placesList != null) {
            this.nombrePlaces = placesList.size();
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < placesList.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(placesList.get(i));
            }
            this.places = sb.toString();
        } else {
            this.places       = "";
            this.nombrePlaces = 0;
        }
    }

    // ============================================================
    // NOMBRE DE PLACES
    // ============================================================

    public int getNombrePlaces() { return nombrePlaces; }
    public void setNombrePlaces(int nombrePlaces) { this.nombrePlaces = nombrePlaces; }

    // ============================================================
    // DATES
    // ============================================================

    public Timestamp getDateReserv() { return dateReserv; }
    public void setDateReserv(Timestamp dateReserv) { this.dateReserv = dateReserv; }

    public Date getDateVoyage() { return dateVoyage; }
    public void setDateVoyage(Date dateVoyage) { this.dateVoyage = dateVoyage; }

    // ============================================================
    // PAIEMENT
    // ============================================================

    public String getPayment() { return payment; }
    public void setPayment(String payment) { this.payment = payment; }

    public int getMontantAvance() { return montantAvance; }
    public void setMontantAvance(int montantAvance) { this.montantAvance = montantAvance; }

    // ============================================================
    // INFORMATIONS AFFICHAGE
    // ============================================================

    public String getNomClient() { return nomClient; }
    public void setNomClient(String nomClient) { this.nomClient = nomClient; }

    public String getDesignVoiture() { return designVoiture; }
    public void setDesignVoiture(String designVoiture) { this.designVoiture = designVoiture; }

    public String getTypeVoiture() { return typeVoiture; }
    public void setTypeVoiture(String typeVoiture) { this.typeVoiture = typeVoiture; }

    public int getFraisVoiture() { return fraisVoiture; }
    public void setFraisVoiture(int fraisVoiture) { this.fraisVoiture = fraisVoiture; }

    public String getNumtelClient() { return numtelClient; }
    public void setNumtelClient(String numtelClient) { this.numtelClient = numtelClient; }

    // ============================================================
    // CALCULS
    // ============================================================

    /** Frais total = frais unitaire × nombre de places */
    public int getTotalFrais() { return fraisVoiture * nombrePlaces; }

    /** Reste à payer */
    public int getReste() { return getTotalFrais() - montantAvance; }

    // ============================================================
    // AFFICHAGE PLACES
    // ============================================================

    /** Ex : "1, 3, 5" */
    public String getPlacesListeString() {
        if (placesList == null || placesList.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < placesList.size(); i++) {
            if (i > 0) sb.append(", ");
            sb.append(placesList.get(i));
        }
        return sb.toString();
    }
}