package com.cooperative.dao;

import com.cooperative.model.Voiture;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoitureDAO {

    // ==========================================
    // CRUD - Create
    // ==========================================
    public String create(Voiture v) {
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);

            // ✅ Utilise la même connexion pour éviter le conflit de transaction
            if (findById(conn, v.getIdvoit()) != null) {
                conn.rollback();
                return "ERROR: Une voiture avec cet ID existe déjà";
            }

            String sql = "INSERT INTO voiture(idvoit, design, type, nbrplace, frais) VALUES(?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, v.getIdvoit());
                ps.setString(2, v.getDesign());
                ps.setString(3, v.getType());
                ps.setInt(4, v.getNbrplace());
                ps.setInt(5, v.getFrais());

                if (ps.executeUpdate() > 0) {
                    String resultPlaces = createPlacesForVoiture(conn, v.getIdvoit(), v.getNbrplace());
                    if (resultPlaces.startsWith("ERROR")) {
                        conn.rollback();
                        return resultPlaces;
                    }
                    conn.commit();
                    return "SUCCESS: Voiture '" + v.getDesign() + "' créée avec succès avec "
                            + v.getNbrplace() + " places";
                } else {
                    conn.rollback();
                    return "ERROR: Échec de la création de la voiture";
                }
            }

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return "ERROR: Erreur SQL - " + e.getMessage();
        } finally {
            // ✅ Fermer la connexion après chaque opération
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ==========================================
    // Créer les places
    // ==========================================
    private String createPlacesForVoiture(Connection conn, String idvoit, int nbrplace) {
        String sql = "INSERT INTO place(idvoit, place) VALUES(?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 1; i <= nbrplace; i++) {
                ps.setString(1, idvoit);
                ps.setInt(2, i);
                ps.addBatch();
            }
            ps.executeBatch();
            return "SUCCESS: " + nbrplace + " places créées";
        } catch (SQLException e) {
            e.printStackTrace();
            return "ERROR: Erreur lors de la création des places - " + e.getMessage();
        }
    }

    // ==========================================
    // CRUD - Read All
    // ==========================================
    public List<Voiture> findAll() {
        List<Voiture> list = new ArrayList<>();
        String sql = "SELECT * FROM voiture ORDER BY idvoit";
        try (Connection conn = DbConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==========================================
    // CRUD - Read One (public, ouvre sa propre connexion)
    // ==========================================
    public Voiture findById(String id) {
        try (Connection conn = DbConnection.getConnection()) {
            return findById(conn, id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Surcharge privée qui réutilise une connexion existante (pour les transactions)
    private Voiture findById(Connection conn, String id) {
        String sql = "SELECT * FROM voiture WHERE idvoit = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Voiture mapRow(ResultSet rs) throws SQLException {
        Voiture v = new Voiture();
        v.setIdvoit(rs.getString("idvoit"));
        v.setDesign(rs.getString("design"));
        v.setType(rs.getString("type"));
        v.setNbrplace(rs.getInt("nbrplace"));
        v.setFrais(rs.getInt("frais"));
        return v;
    }

    // ==========================================
    // CRUD - Update
    // ==========================================
    public String update(Voiture v) {
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);

            // ✅ Même connexion
            Voiture oldVoiture = findById(conn, v.getIdvoit());
            if (oldVoiture == null) {
                conn.rollback();
                return "ERROR: La voiture avec l'ID '" + v.getIdvoit() + "' n'existe pas";
            }

            int oldNbrPlace = oldVoiture.getNbrplace();
            int newNbrPlace = v.getNbrplace();

            String sqlUpdate = "UPDATE voiture SET design=?, type=?, nbrplace=?, frais=? WHERE idvoit=?";
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setString(1, v.getDesign());
                ps.setString(2, v.getType());
                ps.setInt(3, newNbrPlace);
                ps.setInt(4, v.getFrais());
                ps.setString(5, v.getIdvoit());
                ps.executeUpdate();
            }

            String message;
            if (oldNbrPlace != newNbrPlace) {
                String resultPlaces = updatePlaces(conn, v.getIdvoit(), oldNbrPlace, newNbrPlace);
                if (resultPlaces.startsWith("ERROR")) {
                    conn.rollback();
                    return resultPlaces;
                }
                if (newNbrPlace > oldNbrPlace) {
                    message = "SUCCESS: Voiture '" + v.getDesign() + "' modifiée — "
                            + (newNbrPlace - oldNbrPlace) + " place(s) ajoutée(s)";
                } else {
                    message = "SUCCESS: Voiture '" + v.getDesign() + "' modifiée — "
                            + (oldNbrPlace - newNbrPlace) + " place(s) supprimée(s)";
                }
            } else {
                message = "SUCCESS: Voiture '" + v.getDesign() + "' modifiée avec succès";
            }

            conn.commit();
            return message;

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return "ERROR: Erreur SQL - " + e.getMessage();
        } finally {
            // ✅ Fermer la connexion
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ==========================================
    // Mise à jour des places
    // ==========================================
    private String updatePlaces(Connection conn, String idvoit, int oldNbrPlace, int newNbrPlace) {
        try {
            if (newNbrPlace > oldNbrPlace) {
                String sqlInsert = "INSERT INTO place(idvoit, place) VALUES(?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                    for (int i = oldNbrPlace + 1; i <= newNbrPlace; i++) {
                        ps.setString(1, idvoit);
                        ps.setInt(2, i);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
                return "SUCCESS: " + (newNbrPlace - oldNbrPlace) + " place(s) ajoutée(s)";

            } else {
                String sqlCheck =
                        "SELECT COUNT(*) AS cnt FROM reserver " +
                                "WHERE idvoit = ? AND place > ? AND date_voyage >= CURDATE()";
                int futureCount = 0;
                try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                    ps.setString(1, idvoit);
                    ps.setInt(2, newNbrPlace);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) futureCount = rs.getInt("cnt");
                    }
                }

                if (futureCount > 0) {
                    return "ERROR: Impossible de réduire — " + futureCount
                            + " réservation(s) future(s) sur ces places";
                }

                String sqlDelResv =
                        "DELETE FROM reserver WHERE idvoit = ? AND place > ? AND date_voyage < CURDATE()";
                try (PreparedStatement ps = conn.prepareStatement(sqlDelResv)) {
                    ps.setString(1, idvoit);
                    ps.setInt(2, newNbrPlace);
                    ps.executeUpdate();
                }

                String sqlDelPlace = "DELETE FROM place WHERE idvoit = ? AND place > ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlDelPlace)) {
                    ps.setString(1, idvoit);
                    ps.setInt(2, newNbrPlace);
                    ps.executeUpdate();
                }

                return "SUCCESS: " + (oldNbrPlace - newNbrPlace) + " place(s) supprimée(s)";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "ERROR: Erreur lors de la mise à jour des places - " + e.getMessage();
        }
    }

    // ==========================================
    // CRUD - Delete
    // ==========================================
    public String delete(String id) {
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);

            // ✅ Même connexion
            Voiture voiture = findById(conn, id);
            if (voiture == null) {
                conn.rollback();
                return "ERROR: La voiture avec l'ID '" + id + "' n'existe pas";
            }

            String sqlCheck =
                    "SELECT COUNT(*) AS cnt FROM reserver WHERE idvoit = ? AND date_voyage >= CURDATE()";
            int futureCount = 0;
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setString(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) futureCount = rs.getInt("cnt");
                }
            }

            if (futureCount > 0) {
                conn.rollback();
                return "ERROR: Impossible de supprimer — " + futureCount
                        + " réservation(s) future(s) existent pour cette voiture";
            }

            String sqlDelResv = "DELETE FROM reserver WHERE idvoit = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlDelResv)) {
                ps.setString(1, id);
                ps.executeUpdate();
            }

            String sqlDelPlace = "DELETE FROM place WHERE idvoit = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlDelPlace)) {
                ps.setString(1, id);
                ps.executeUpdate();
            }

            String sqlDelVoit = "DELETE FROM voiture WHERE idvoit = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlDelVoit)) {
                ps.setString(1, id);
                int result = ps.executeUpdate();
                if (result > 0) {
                    conn.commit();
                    return "SUCCESS: Voiture '" + voiture.getDesign() + "' supprimée avec succès";
                } else {
                    conn.rollback();
                    return "ERROR: Échec de la suppression";
                }
            }

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return "ERROR: Erreur SQL - " + e.getMessage();
        } finally {
            // ✅ Fermer la connexion
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ==========================================
    // Places libres sans filtre de date
    // ==========================================
    public List<Integer> getPlacesLibres(String idvoit) {
        List<Integer> places = new ArrayList<>();
        String sql = "SELECT p.place FROM place p " +
                "WHERE p.idvoit = ? " +
                "AND p.place NOT IN (" +
                "  SELECT r.place FROM reserver r " +
                "  WHERE r.idvoit = ? AND r.date_voyage >= CURDATE()" +
                ") ORDER BY p.place";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idvoit);
            ps.setString(2, idvoit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    places.add(rs.getInt("place"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return places;
    }

    // ==========================================
    // Places libres pour une date donnée
    // ==========================================
    public List<Integer> getPlacesLibres(String idvoit, Date date) {
        ReservationDAO reservationDAO = new ReservationDAO();
        return reservationDAO.getPlacesLibresPourDate(idvoit, date);
    }

    // ==========================================
    // Nombre total de places
    // ==========================================
    public int getNombrePlacesTotales(String idvoit) {
        String sql = "SELECT COUNT(*) AS cnt FROM place WHERE idvoit = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, idvoit);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==========================================
    // Nombre de places libres pour une date
    // ==========================================
    public int getNombrePlacesLibres(String idvoit, Date date) {
        ReservationDAO reservationDAO = new ReservationDAO();
        return reservationDAO.getPlacesLibresPourDate(idvoit, date).size();
    }
}