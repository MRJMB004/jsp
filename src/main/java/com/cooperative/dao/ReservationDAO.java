package com.cooperative.dao;

import com.cooperative.model.Reservation;
import com.cooperative.model.Client;
import com.cooperative.model.ReservationAvanceDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReservationDAO {

    private String generateId() {
        return "RES" + System.currentTimeMillis();
    }

    // ==================== CRUD - CREATE ====================
    public boolean create(Reservation r) {
        String sql = "INSERT INTO RESERVER(idreserv, idvoit, idcli, places, date_reserv, date_voyage, payment, montant_avance) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            String id = generateId();
            r.setIdreserv(id);
            r.setDateReserv(new Timestamp(System.currentTimeMillis()));

            ps.setString(1, id);
            ps.setString(2, r.getIdvoit());
            ps.setInt(3, r.getIdcli());
            ps.setString(4, r.getPlaces());          // varchar(255)
            ps.setTimestamp(5, r.getDateReserv());
            ps.setDate(6, r.getDateVoyage());
            ps.setString(7, r.getPayment());
            ps.setInt(8, r.getMontantAvance());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== RECETTE TOTALE ====================
    public int getRecetteTotale() {
        int total = 0;
        String sql = "SELECT SUM(montant_avance) AS total FROM RESERVER";
        try (
                Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    // ==================== CREATE MULTIPLE PLACES ====================
    public boolean createMultiple(Reservation r) {
        String sql =
                "INSERT INTO RESERVER(" +
                        "idreserv, idvoit, idcli, places, date_reserv, date_voyage, payment, montant_avance" +
                        ") VALUES(?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            String id = generateId();
            r.setIdreserv(id);
            r.setDateReserv(new Timestamp(System.currentTimeMillis()));

            ps.setString(1, id);
            ps.setString(2, r.getIdvoit());
            ps.setInt(3, r.getIdcli());
            ps.setString(4, r.getPlaces());          // "1,2,3" dans varchar(255)
            ps.setTimestamp(5, r.getDateReserv());
            ps.setDate(6, r.getDateVoyage());
            ps.setString(7, r.getPayment());
            ps.setInt(8, r.getMontantAvance());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== VÉRIFIER SI PLUSIEURS PLACES SONT LIBRES ====================
    public boolean arePlacesLibres(String idvoit, Date dateVoyage, List<Integer> places) {
        String sql =
                "SELECT places FROM RESERVER " +
                        "WHERE idvoit = ? AND date_voyage = ?";

        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, idvoit);
            ps.setDate(2, dateVoyage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String placesDb = rs.getString("places");
                if (placesDb != null) {
                    List<String> listeDb = Arrays.asList(placesDb.split(","));
                    for (String item : listeDb) {
                        try {
                            int p = Integer.parseInt(item.trim());
                            if (places.contains(p)) return false;
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== TROUVER RÉSERVATION AVEC TOUTES SES PLACES ====================
    public Reservation findByIdWithAllPlaces(String id) {
        String sql = "SELECT r.idreserv, r.idvoit, r.idcli, r.places, r.date_reserv, r.date_voyage, r.payment, " +
                "r.montant_avance, " +
                "c.nom, c.numtel, v.design, v.type, v.frais, v.nbrplace " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.idreserv = ?";

        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Reservation r = new Reservation();
                r.setIdreserv(rs.getString("idreserv"));
                r.setIdvoit(rs.getString("idvoit"));
                r.setIdcli(rs.getInt("idcli"));
                r.setDateReserv(rs.getTimestamp("date_reserv"));
                r.setDateVoyage(rs.getDate("date_voyage"));
                r.setPayment(rs.getString("payment"));
                r.setMontantAvance(rs.getInt("montant_avance"));
                r.setNomClient(rs.getString("nom"));
                r.setNumtelClient(rs.getString("numtel"));
                r.setDesignVoiture(rs.getString("design"));
                r.setTypeVoiture(rs.getString("type"));
                r.setFraisVoiture(rs.getInt("frais"));

                String placesStr = rs.getString("places");
                List<Integer> placesList = parsePlaces(placesStr);
                r.setPlacesList(placesList);
                r.setNombrePlaces(placesList.size());
                r.setPlaces(placesStr);

                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==================== CRUD - READ ALL ====================
    public List<Reservation> findAll() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.idreserv, r.idvoit, r.idcli, r.places, r.date_reserv, r.date_voyage, r.payment, r.montant_avance " +
                "FROM RESERVER r " +
                "ORDER BY r.date_reserv DESC";
        try (Statement st = DbConnection.getConnection().createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapReservationBasic(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Reservation> findAllWithDetails() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT " +
                "    r.idreserv, " +
                "    r.idvoit, " +
                "    r.idcli, " +
                "    r.places, " +
                "    r.date_reserv, " +
                "    r.date_voyage, " +
                "    r.payment, " +
                "    r.montant_avance, " +
                "    c.nom, " +
                "    c.numtel, " +
                "    v.design, " +
                "    v.type, " +
                "    v.frais, " +
                "    v.nbrplace " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "ORDER BY r.date_reserv DESC";
        try (Statement st = DbConnection.getConnection().createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapReservationFull(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== CRUD - READ ONE ====================
    public Reservation findById(String id) {
        String sql = "SELECT * FROM RESERVER WHERE idreserv = ? LIMIT 1";
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapReservationBasic(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Reservation findByIdWithDetails(String id) {
        String sql = "SELECT " +
                "    r.idreserv, r.idvoit, r.idcli, r.places, " +
                "    r.date_reserv, r.date_voyage, r.payment, r.montant_avance, " +
                "    c.nom, c.numtel, v.design, v.type, v.frais, v.nbrplace " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.idreserv = ?";
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapReservationFull(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==================== CRUD - UPDATE ====================
    public boolean update(Reservation r) {
        String sql =
                "UPDATE RESERVER SET " +
                        "idvoit=?, idcli=?, places=?, date_voyage=?, payment=?, montant_avance=? " +
                        "WHERE idreserv=?";

        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, r.getIdvoit());
            ps.setInt(2, r.getIdcli());
            ps.setString(3, r.getPlaces());          // varchar(255)
            ps.setDate(4, r.getDateVoyage());
            ps.setString(5, r.getPayment());
            ps.setInt(6, r.getMontantAvance());
            ps.setString(7, r.getIdreserv());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== CRUD - DELETE ====================
    public boolean delete(String id) {
        String sql = "DELETE FROM RESERVER WHERE idreserv = ?";
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) { return delete(String.valueOf(id)); }

    // ==================== RECHERCHE AVANCÉE ====================
    public List<Reservation> findWithFilters(
            String idVoit,
            String dateVoyage,
            List<String> paiements,
            String motCle,
            String critere) {

        List<Reservation> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT " +
                        "    r.idreserv, r.idvoit, r.idcli, r.places, " +
                        "    r.date_reserv, r.date_voyage, r.payment, r.montant_avance, " +
                        "    c.nom, c.numtel, v.design, v.type, v.frais, v.nbrplace " +
                        "FROM RESERVER r " +
                        "JOIN CLIENT c ON r.idcli = c.idcli " +
                        "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                        "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (notEmpty(idVoit) && !"all".equals(idVoit)) {
            sql.append("AND r.idvoit = ? ");
            params.add(idVoit);
        }

        if (notEmpty(dateVoyage)) {
            sql.append("AND r.date_voyage = ? ");
            params.add(java.sql.Date.valueOf(dateVoyage));
        }

        if (paiements != null && !paiements.isEmpty()) {
            sql.append("AND r.payment IN (");
            for (int i = 0; i < paiements.size(); i++) {
                sql.append(i > 0 ? ",?" : "?");
                params.add(paiements.get(i));
            }
            sql.append(") ");
        }

        if (notEmpty(motCle)) {
            if ("nom".equals(critere)) {
                sql.append("AND c.nom LIKE ? ");
                params.add("%" + motCle + "%");
            } else if ("numtel".equals(critere)) {
                sql.append("AND c.numtel LIKE ? ");
                params.add("%" + motCle + "%");
            } else if ("idreserv".equals(critere)) {
                sql.append("AND r.idreserv LIKE ? ");
                params.add("%" + motCle + "%");
            } else {
                sql.append("AND (c.nom LIKE ? OR c.numtel LIKE ? OR r.idreserv LIKE ?) ");
                params.add("%" + motCle + "%");
                params.add("%" + motCle + "%");
                params.add("%" + motCle + "%");
            }
        }

        sql.append("ORDER BY r.date_reserv DESC");

        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String) ps.setString(i + 1, (String) p);
                else if (p instanceof java.sql.Date) ps.setDate(i + 1, (java.sql.Date) p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapReservationFull(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== PLACES LIBRES ====================
    public List<Integer> getPlacesLibresPourDate(String idvoit, Date dateVoyage) {
        List<Integer> placesLibres = new ArrayList<>();

        String sqlTotal = "SELECT nbrplace FROM VOITURE WHERE idvoit = ?";
        int total = 0;
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sqlTotal)) {
            ps.setString(1, idvoit);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getInt("nbrplace");
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (total == 0) return placesLibres;

        String sqlOcc = "SELECT places FROM RESERVER WHERE idvoit = ? AND date_voyage = ?";
        List<Integer> occupees = new ArrayList<>();
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sqlOcc)) {
            ps.setString(1, idvoit);
            ps.setDate(2, dateVoyage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                occupees.addAll(parsePlaces(rs.getString("places")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        for (int i = 1; i <= total; i++) {
            if (!occupees.contains(i)) placesLibres.add(i);
        }
        return placesLibres;
    }

    // ==================== RECHERCHE PAR VOITURE ====================
    public List<Reservation> findByVoiture(String idVoiture) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT " +
                "    r.idreserv, r.idvoit, r.idcli, r.places, " +
                "    r.date_reserv, r.date_voyage, r.payment, r.montant_avance, " +
                "    c.nom, c.numtel, v.design, v.type, v.frais, v.nbrplace " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.idvoit = ? " +
                "ORDER BY r.date_voyage DESC";
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, idVoiture);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapReservationFull(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Reservation> findByDateVoyage(Date dateVoyage) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT " +
                "    r.idreserv, r.idvoit, r.idcli, r.places, " +
                "    r.date_reserv, r.date_voyage, r.payment, r.montant_avance, " +
                "    c.nom, c.numtel, v.design, v.type, v.frais, v.nbrplace " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.date_voyage = ? " +
                "ORDER BY r.idvoit, r.date_reserv";
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setDate(1, dateVoyage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapReservationFull(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Reservation> findByStatutPaiement(String payment) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT " +
                "    r.idreserv, r.idvoit, r.idcli, r.places, " +
                "    r.date_reserv, r.date_voyage, r.payment, r.montant_avance, " +
                "    c.nom, c.numtel, v.design, v.type, v.frais, v.nbrplace " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.payment = ? " +
                "ORDER BY r.date_voyage DESC";
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, payment);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapReservationFull(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== RECHERCHE PAR AVANCE (CORRIGÉE) ====================
    public List<ReservationAvanceDTO> findByAvanceWithReste(String idVoit) {
        List<ReservationAvanceDTO> resultats = new ArrayList<>();
        String sql = "SELECT " +
                "    r.idreserv, c.nom, c.numtel, r.places, " +
                "    DATE_FORMAT(r.date_voyage, '%d/%m/%Y') as date_voyage, " +
                "    v.frais, r.payment, r.montant_avance " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.idvoit = ? " +
                "ORDER BY CASE r.payment WHEN 'avec avance' THEN 1 WHEN 'sans avance' THEN 2 WHEN 'tout payé' THEN 3 ELSE 4 END";

        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, idVoit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReservationAvanceDTO dto = new ReservationAvanceDTO();
                dto.setIdReserv(rs.getString("idreserv"));
                dto.setNomClient(rs.getString("nom"));
                dto.setNumTel(rs.getString("numtel"));
                dto.setPlaces(rs.getString("places"));
                dto.setDateVoyage(rs.getString("date_voyage"));
                dto.setFrais(rs.getInt("frais"));
                dto.setPayment(rs.getString("payment"));
                dto.setMontantAvance(rs.getInt("montant_avance"));

                int total = dto.getFrais() * dto.getNombrePlaces();
                int reste;
                if ("tout payé".equals(dto.getPayment())) {
                    reste = 0;
                } else if ("avec avance".equals(dto.getPayment())) {
                    reste = total - dto.getMontantAvance();
                } else {
                    reste = total;
                }
                dto.setResteAPayer(reste);

                resultats.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultats;
    }

    // ==================== VOYAGEURS AVEC STATUT PAIEMENT (CORRIGÉE) ====================
    public List<Map<String, Object>> getVoyageursAvecStatutPaiement(String idVoit) {
        List<Map<String, Object>> resultats = new ArrayList<>();
        String sql = "SELECT " +
                "    r.idreserv, c.nom AS nomClient, c.numtel AS numTel, r.places, " +
                "    DATE_FORMAT(r.date_voyage, '%d/%m/%Y') AS dateVoyage, " +
                "    v.frais, r.payment, r.montant_avance " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.idvoit = ? " +
                "ORDER BY CASE r.payment WHEN 'avec avance' THEN 1 WHEN 'sans avance' THEN 2 WHEN 'tout payé' THEN 3 ELSE 4 END";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idVoit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("idReserv", rs.getString("idreserv"));
                row.put("nomClient", rs.getString("nomClient"));
                row.put("numTel", rs.getString("numTel"));

                String placesStr = rs.getString("places");
                row.put("places", placesStr);

                int nombrePlaces = 1;
                if (placesStr != null && !placesStr.trim().isEmpty()) {
                    nombrePlaces = placesStr.split(",").length;
                }

                int fraisParPlace = rs.getInt("frais");
                int total = fraisParPlace * nombrePlaces;
                int montantAvance = rs.getInt("montant_avance");
                String payment = rs.getString("payment");

                row.put("dateVoyage", rs.getString("dateVoyage"));
                row.put("frais", total);
                row.put("payment", payment);
                row.put("montantAvance", montantAvance);

                int reste;
                if ("tout payé".equals(payment)) {
                    reste = 0;
                } else if ("avec avance".equals(payment)) {
                    reste = total - montantAvance;
                } else {
                    reste = total;
                }
                row.put("resteAPayer", reste);

                String placesFormatted = "💺 " + placesStr.replace(",", ", 💺 ");
                row.put("placesFormatted", placesFormatted);

                resultats.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultats;
    }

    // ==================== MÉTHODES UTILITAIRES ====================
    public boolean exists(String id) {
        String sql = "SELECT COUNT(*) FROM RESERVER WHERE idreserv = ?";
        try (PreparedStatement ps = DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM RESERVER";
        try (Statement st = DbConnection.getConnection().createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Reservation> findUpcoming() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT " +
                "    r.idreserv, r.idvoit, r.idcli, r.places, " +
                "    r.date_reserv, r.date_voyage, r.payment, r.montant_avance, " +
                "    c.nom, c.numtel, v.design, v.type, v.frais, v.nbrplace " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idcli = c.idcli " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.date_voyage >= CURDATE() " +
                "ORDER BY r.date_voyage ASC";
        try (Statement st = DbConnection.getConnection().createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapReservationFull(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== MÉTHODES DE MAPPING ====================

    private Reservation mapReservationBasic(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setIdreserv(rs.getString("idreserv"));
        r.setIdvoit(rs.getString("idvoit"));
        r.setIdcli(rs.getInt("idcli"));
        r.setDateReserv(rs.getTimestamp("date_reserv"));
        r.setDateVoyage(rs.getDate("date_voyage"));
        r.setPayment(rs.getString("payment"));
        r.setMontantAvance(rs.getInt("montant_avance"));

        String placesStr = rs.getString("places");
        r.setPlaces(placesStr);
        List<Integer> placesList = parsePlaces(placesStr);
        r.setPlacesList(placesList);
        r.setNombrePlaces(placesList.size());
        return r;
    }

    private Reservation mapReservationFull(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setIdreserv(rs.getString("idreserv"));
        r.setIdvoit(rs.getString("idvoit"));
        r.setIdcli(rs.getInt("idcli"));
        r.setDateReserv(rs.getTimestamp("date_reserv"));
        r.setDateVoyage(rs.getDate("date_voyage"));
        r.setPayment(rs.getString("payment"));
        r.setMontantAvance(rs.getInt("montant_avance"));
        r.setNomClient(rs.getString("nom"));
        r.setNumtelClient(rs.getString("numtel"));
        r.setDesignVoiture(rs.getString("design"));
        r.setTypeVoiture(rs.getString("type"));
        r.setFraisVoiture(rs.getInt("frais"));

        String placesStr = rs.getString("places");
        r.setPlaces(placesStr);
        List<Integer> placesList = parsePlaces(placesStr);
        r.setPlacesList(placesList);
        r.setNombrePlaces(placesList.size());
        return r;
    }

    private List<Integer> parsePlaces(String placesStr) {
        List<Integer> places = new ArrayList<>();
        if (placesStr != null && !placesStr.trim().isEmpty()) {
            for (String p : placesStr.split(",")) {
                try {
                    places.add(Integer.parseInt(p.trim()));
                } catch (NumberFormatException ignored) {}
            }
        }
        return places;
    }

    private boolean notEmpty(String s) {
        return s != null && !s.trim().isEmpty();
    }
}