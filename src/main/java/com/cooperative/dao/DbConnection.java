package com.cooperative.dao;

import java.sql.*;

public class DbConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/cooperative_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    // ✅ Suppression de : private static Connection connection = null;
    // Le singleton était la cause du bug — une seule connexion partagée
    // causait des conflits quand autoCommit=false était actif

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    // ✅ Chaque appel retourne une NOUVELLE connexion indépendante
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // ✅ closeConnection() gardée pour compatibilité mais gérée en dehors désormais
    public static void closeConnection(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}