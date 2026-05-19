package com.cooperative.controller;

import com.cooperative.dao.*;
import com.cooperative.model.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/rapport/*")
public class RapportServlet extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAO();
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null || action.equals("/")) {
            showMenu(request, response);
            return;
        }

        switch (action) {
            case "/paiements":
                showStatutPaiements(request, response);
                break;
            case "/recette":
                showRecetteTotale(request, response);
                break;
            default:
                showMenu(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null || action.equals("/paiements")) {
            rechercherParVoiture(request, response);
        } else {
            showMenu(request, response);
        }
    }

    private void showMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/rapport/menu.jsp").forward(request, response);
    }

    private void showStatutPaiements(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Voiture> voitures = voitureDAO.findAll();
        request.setAttribute("voitures", voitures);
        request.getRequestDispatcher("/views/rapport/paiements.jsp").forward(request, response);
    }

    private void rechercherParVoiture(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idVoit = request.getParameter("idVoit");

        List<Voiture> voitures = voitureDAO.findAll();
        request.setAttribute("voitures", voitures);
        request.setAttribute("idVoitChoisi", idVoit);

        if (idVoit != null && !idVoit.isEmpty()) {
            // ✅ Utilisation de la méthode existante dans ReservationDAO
            List<Map<String, Object>> resultats = reservationDAO.getVoyageursAvecStatutPaiement(idVoit);
            request.setAttribute("resultats", resultats);

            int nbAvecAvance = 0;
            int nbSansAvance = 0;
            int nbToutPaye = 0;

            for (Map<String, Object> r : resultats) {
                String payment = (String) r.get("payment");
                if ("avec avance".equals(payment)) {
                    nbAvecAvance++;
                } else if ("sans avance".equals(payment)) {
                    nbSansAvance++;
                } else if ("tout payé".equals(payment)) {
                    nbToutPaye++;
                }
            }

            request.setAttribute("nbAvecAvance", nbAvecAvance);
            request.setAttribute("nbSansAvance", nbSansAvance);
            request.setAttribute("nbToutPaye", nbToutPaye);
        }

        request.getRequestDispatcher("/views/rapport/paiements.jsp").forward(request, response);
    }

    private void showRecetteTotale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int recetteTotale = reservationDAO.getRecetteTotale();
        request.setAttribute("recetteTotale", recetteTotale);
        request.getRequestDispatcher("/views/rapport/recette.jsp").forward(request, response);
    }
}