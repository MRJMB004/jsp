package com.cooperative.dao;

import com.cooperative.model.Client;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des clients.
 * Toutes les opérations CRUD + réindexation des IDs.
 */
public class ClientDAO {

    // ==================== UTILITAIRE INTERNE ====================

    /**
     * Retourne le prochain ID disponible en cherchant le premier « trou »
     * dans la séquence des idcli. Si la table est vide, retourne 1.
     */
    private int getNextAvailableId() throws SQLException {
        String sql =
                "SELECT MIN(t1.idcli + 1) AS next_id " +
                        "FROM   CLIENT t1 " +
                        "LEFT JOIN CLIENT t2 ON t1.idcli + 1 = t2.idcli " +
                        "WHERE  t2.idcli IS NULL";
        try (Statement st = DbConnection.getConnection().createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next() && rs.getObject("next_id") != null) {
                return rs.getInt("next_id");
            }
        }
        return 1;
    }

    // ==================== CREATE ====================

    public boolean create(Client c) {
        String sql = "INSERT INTO CLIENT(idcli, nom, numtel) VALUES(?, ?, ?)";
        try {
            int nextId = getNextAvailableId();
            try (PreparedStatement ps =
                         DbConnection.getConnection().prepareStatement(sql)) {
                ps.setInt(1, nextId);
                ps.setString(2, c.getNom().trim());
                ps.setString(3, c.getNumtel().trim());
                boolean ok = ps.executeUpdate() > 0;
                if (ok) c.setIdcli(nextId);
                return ok;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== READ ====================

    public List<Client> findAll(String tri) {
        List<Client> list = new ArrayList<>();
        String orderBy = "nom".equalsIgnoreCase(tri)
                ? "ORDER BY nom ASC"
                : "ORDER BY idcli ASC";
        String sql = "SELECT * FROM CLIENT " + orderBy;
        try (Statement st = DbConnection.getConnection().createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Client> findAll() {
        return findAll("id");
    }

    public Client findById(int id) {
        String sql = "SELECT * FROM CLIENT WHERE idcli = ?";
        try (PreparedStatement ps =
                     DbConnection.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Client> rechercher(String motCle) {
        List<Client> list = new ArrayList<>();
        String sql =
                "SELECT * FROM CLIENT " +
                        "WHERE nom LIKE ? OR numtel LIKE ? " +
                        "ORDER BY nom ASC";
        try (PreparedStatement ps =
                     DbConnection.getConnection().prepareStatement(sql)) {
            String pattern = "%" + motCle.trim() + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== UPDATE ====================

    public boolean update(Client c) {
        String sql = "UPDATE CLIENT SET nom = ?, numtel = ? WHERE idcli = ?";
        try (PreparedStatement ps =
                     DbConnection.getConnection().prepareStatement(sql)) {
            ps.setString(1, c.getNom().trim());
            ps.setString(2, c.getNumtel().trim());
            ps.setInt(3, c.getIdcli());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== DELETE ====================

    public boolean delete(int id) {
        String sql = "DELETE FROM CLIENT WHERE idcli = ?";
        try (PreparedStatement ps =
                     DbConnection.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== RÉINDEXATION ====================

    /**
     * Réindexe tous les idcli pour qu'ils soient consécutifs à partir de 1,
     * en mettant à jour les références dans RESERVER de façon atomique.
     *
     * Algorithme en 2 passes :
     *  - Passe 1 : IDs temporaires négatifs  → évite les conflits de PK
     *  - Passe 2 : IDs définitifs consécutifs
     *
     * Tout est dans une seule transaction avec rollback automatique en cas d'erreur.
     */
    public boolean resetAndReindex() {
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);

            // Charger les paires [idActuel, idFutur]
            List<int[]> pairs = new ArrayList<>();
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(
                         "SELECT idcli FROM CLIENT ORDER BY idcli ASC")) {
                int newIndex = 1;
                while (rs.next()) {
                    pairs.add(new int[]{rs.getInt("idcli"), newIndex++});
                }
            }

            if (pairs.isEmpty()) {
                conn.setAutoCommit(true);
                return true; // rien à faire
            }

            // ── Passe 1 : IDs temporaires négatifs ──────────────────────────
            try (PreparedStatement psR = conn.prepareStatement(
                    "UPDATE RESERVER SET idcli = ? WHERE idcli = ?");
                 PreparedStatement psC = conn.prepareStatement(
                         "UPDATE CLIENT  SET idcli = ? WHERE idcli = ?")) {
                for (int[] p : pairs) {
                    int tmp = -p[0];
                    psR.setInt(1, tmp); psR.setInt(2, p[0]); psR.addBatch();
                    psC.setInt(1, tmp); psC.setInt(2, p[0]); psC.addBatch();
                }
                psR.executeBatch();
                psC.executeBatch();
            }

            // ── Passe 2 : IDs définitifs consécutifs ────────────────────────
            try (PreparedStatement psR = conn.prepareStatement(
                    "UPDATE RESERVER SET idcli = ? WHERE idcli = ?");
                 PreparedStatement psC = conn.prepareStatement(
                         "UPDATE CLIENT  SET idcli = ? WHERE idcli = ?")) {
                for (int[] p : pairs) {
                    int tmp = -p[0];
                    int nw  =  p[1];
                    psR.setInt(1, nw); psR.setInt(2, tmp); psR.addBatch();
                    psC.setInt(1, nw); psC.setInt(2, tmp); psC.addBatch();
                }
                psR.executeBatch();
                psC.executeBatch();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
        return false;
    }

    // ==================== MAPPING ====================

    private Client mapRow(ResultSet rs) throws SQLException {
        Client c = new Client();
        c.setIdcli(rs.getInt("idcli"));
        c.setNom(rs.getString("nom"));
        c.setNumtel(rs.getString("numtel"));
        return c;
    }
}