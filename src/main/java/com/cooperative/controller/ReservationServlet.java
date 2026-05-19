package com.cooperative.controller;

import com.cooperative.dao.*;
import com.cooperative.model.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet("/reservation/*")
public class ReservationServlet extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAO();
    private VoitureDAO     voitureDAO     = new VoitureDAO();
    private ClientDAO      clientDAO      = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null || action.equals("/")) action = "/list";

        switch (action) {
            case "/new":       showNewForm(request, response);          break;
            case "/edit":      showEditForm(request, response);         break;
            case "/delete":    deleteReservation(request, response);    break;
            case "/recu":      generateRecu(request, response);         break;
            case "/getPlaces": getPlacesDisponibles(request, response); break;
            case "/search":    searchReservations(request, response);   break;
            default:           listReservations(request, response);     break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/reservation/");
            return;
        }
        switch (action) {
            case "/save":      saveReservation(request, response);      break;
            case "/update":    updateReservation(request, response);    break;
            case "/getPlaces": getPlacesDisponibles(request, response); break;
            default:
                response.sendRedirect(request.getContextPath() + "/reservation/");
        }
    }

    // ==================== LIST ====================
    private void listReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Reservation> reservations = reservationDAO.findAllWithDetails();
        List<Voiture>     voitures     = voitureDAO.findAll();
        request.setAttribute("reservations", reservations);
        request.setAttribute("voitures", voitures);
        request.getRequestDispatcher("/views/reservation/liste.jsp").forward(request, response);
    }

    // ==================== NEW FORM ====================
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("voitures", voitureDAO.findAll());
        request.setAttribute("clients",  clientDAO.findAll());
        request.getRequestDispatcher("/views/reservation/form.jsp").forward(request, response);
    }

    // ==================== EDIT FORM ====================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        Reservation reservation = reservationDAO.findByIdWithAllPlaces(id);
        request.setAttribute("reservation", reservation);
        request.setAttribute("voitures", voitureDAO.findAll());
        request.setAttribute("clients",  clientDAO.findAll());
        request.getRequestDispatcher("/views/reservation/form.jsp").forward(request, response);
    }

    // ==================== SAVE (CREATE MULTIPLE) ====================
    private void saveReservation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            String idvoit   = request.getParameter("idvoit");
            int    idcli    = Integer.parseInt(request.getParameter("idcli"));
            Date   dateVoyage = Date.valueOf(request.getParameter("date_voyage"));
            String payment  = request.getParameter("payment");

            // Récupérer les places sélectionnées (JSON array "[1,3,5]")
            String placesParam = request.getParameter("places");
            List<Integer> placesList = parsePlacesParam(placesParam);

            if (placesList.isEmpty()) {
                session.setAttribute("errorMessage", "Veuillez sélectionner au moins une place.");
                response.sendRedirect(request.getContextPath() + "/reservation/new");
                return;
            }

            int montantAvance = 0;
            String montantStr = request.getParameter("montant_avance");
            if (montantStr != null && !montantStr.isEmpty()) {
                montantAvance = Integer.parseInt(montantStr);
            }

            Voiture v = voitureDAO.findById(idvoit);
            int totalFrais = v.getFrais() * placesList.size();

            // Vérifier que l'avance ne dépasse pas le total
            if ("avec avance".equals(payment) && montantAvance > totalFrais) {
                session.setAttribute("errorMessage",
                        "L'avance ne peut pas dépasser " + String.format("%,d", totalFrais) + " Ar");
                response.sendRedirect(request.getContextPath() + "/reservation/new");
                return;
            }

            // Si tout payé, l'avance = total
            if ("tout payé".equals(payment)) {
                montantAvance = totalFrais;
            }

            // Si sans avance, l'avance = 0
            if ("sans avance".equals(payment)) {
                montantAvance = 0;
            }

            // Créer UNE réservation avec plusieurs places
            Reservation r = new Reservation();
            r.setIdvoit(idvoit);
            r.setIdcli(idcli);
            r.setPlacesList(placesList);
            r.setDateVoyage(dateVoyage);
            r.setPayment(payment);
            r.setMontantAvance(montantAvance);

            boolean ok = reservationDAO.createMultiple(r);
            if (ok) {
                session.setAttribute("successMessage",
                        String.format("✅ %d place(s) réservée(s) avec succès ! Total : %,d Ar",
                                placesList.size(), totalFrais));
                response.sendRedirect(request.getContextPath() + "/reservation/");
            } else {
                session.setAttribute("errorMessage", "Erreur lors de la réservation.");
                response.sendRedirect(request.getContextPath() + "/reservation/new");
            }

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Erreur : " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reservation/new");
        }
    }

    // ==================== UPDATE ====================
    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            String idReserv = request.getParameter("idreserv");
            String idvoit   = request.getParameter("idvoit");
            int idcli       = Integer.parseInt(request.getParameter("idcli"));
            Date dateVoyage = Date.valueOf(request.getParameter("date_voyage"));
            String payment  = request.getParameter("payment");

            // Récupérer les places sélectionnées
            String placesParam = request.getParameter("places");
            List<Integer> placesList = parsePlacesParam(placesParam);

            if (placesList.isEmpty()) {
                session.setAttribute("errorMessage", "Veuillez sélectionner au moins une place.");
                response.sendRedirect(request.getContextPath() + "/reservation/edit?id=" + idReserv);
                return;
            }

            // Convertir en String "1,2,3"
            String places = "";
            for (int i = 0; i < placesList.size(); i++) {
                if (i > 0) places += ",";
                places += placesList.get(i);
            }

            int montantAvance = 0;
            String montantStr = request.getParameter("montant_avance");
            if (montantStr != null && !montantStr.isEmpty()) {
                montantAvance = Integer.parseInt(montantStr);
            }

            Voiture v = voitureDAO.findById(idvoit);
            int totalFrais = v.getFrais() * placesList.size();

            // Ajuster l'avance selon le mode de paiement
            if ("tout payé".equals(payment)) {
                montantAvance = totalFrais;
            } else if ("sans avance".equals(payment)) {
                montantAvance = 0;
            } else if ("avec avance".equals(payment) && montantAvance > totalFrais) {
                session.setAttribute("errorMessage", "L'avance ne peut pas dépasser le total");
                response.sendRedirect(request.getContextPath() + "/reservation/edit?id=" + idReserv);
                return;
            }

            Reservation r = new Reservation();
            r.setIdreserv(idReserv);
            r.setIdvoit(idvoit);
            r.setIdcli(idcli);
            r.setPlaces(places);
            r.setDateVoyage(dateVoyage);
            r.setPayment(payment);
            r.setMontantAvance(montantAvance);

            boolean ok = reservationDAO.update(r);
            if (ok) {
                session.setAttribute("successMessage", "Réservation modifiée avec succès.");
            } else {
                session.setAttribute("errorMessage", "Erreur lors de la modification.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Erreur : " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/reservation/");
    }

    // ==================== DELETE ====================
    private void deleteReservation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            String id = request.getParameter("id");
            boolean ok = reservationDAO.delete(id);
            if (ok) {
                session.setAttribute("successMessage", "🗑️ Réservation supprimée avec succès !");
            } else {
                session.setAttribute("errorMessage", "❌ Erreur lors de la suppression.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "❌ Erreur : " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/reservation/");
    }

    // ==================== SEARCH ====================
    private void searchReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String motCle     = emptyToNull(request.getParameter("motCle"));
        String critere    = request.getParameter("critere");
        String idVoit     = emptyToNull(request.getParameter("idVoit"));
        String dateVoyage = emptyToNull(request.getParameter("dateVoyage"));

        String[] paiementsArr = request.getParameterValues("payment");
        List<String> paiements;
        if (paiementsArr != null && paiementsArr.length > 0) {
            paiements = new ArrayList<>();
            for (String p : paiementsArr) {
                if (p != null && !p.isEmpty() && !"all".equals(p)) paiements.add(p);
            }
        } else {
            paiements = Collections.emptyList();
        }

        if (critere == null || critere.isEmpty()) critere = "all";

        List<Reservation> reservations = reservationDAO.findWithFilters(
                idVoit, dateVoyage, paiements, motCle, critere);
        List<Voiture> voitures = voitureDAO.findAll();

        request.setAttribute("reservations", reservations);
        request.setAttribute("voitures",     voitures);
        request.setAttribute("motCle",       motCle   != null ? motCle   : "");
        request.setAttribute("critere",      critere);
        request.setAttribute("idVoit",       idVoit   != null ? idVoit   : "all");
        request.setAttribute("dateVoyage",   dateVoyage != null ? dateVoyage : "");
        request.setAttribute("paiementsSelectionnes", paiements);
        request.setAttribute("paiementToutPaye",   paiements.contains("tout payé"));
        request.setAttribute("paiementAvecAvance", paiements.contains("avec avance"));
        request.setAttribute("paiementSansAvance", paiements.contains("sans avance"));

        request.getRequestDispatcher("/views/reservation/liste.jsp").forward(request, response);
    }

    // ==================== PLACES DISPONIBLES ====================
    private void getPlacesDisponibles(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idvoit  = request.getParameter("idvoit");
        String dateStr = request.getParameter("date_voyage");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (idvoit != null && dateStr != null && !dateStr.isEmpty()) {
            try {
                Date dateVoyage = Date.valueOf(dateStr);
                List<Integer> places = reservationDAO.getPlacesLibresPourDate(idvoit, dateVoyage);
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < places.size(); i++) {
                    if (i > 0) json.append(",");
                    json.append(places.get(i));
                }
                json.append("]");
                response.getWriter().write(json.toString());
            } catch (Exception e) {
                response.getWriter().write("[]");
            }
        } else {
            response.getWriter().write("[]");
        }
    }

    // ==================== RECU ====================
    private void generateRecu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        Reservation reservation = reservationDAO.findByIdWithAllPlaces(id);
        if (reservation != null) {
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("/views/reservation/recu.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ==================== UTILITAIRES ====================

    private List<Integer> parsePlacesParam(String placesParam) {
        List<Integer> list = new ArrayList<>();
        if (placesParam == null || placesParam.isEmpty() || placesParam.equals("[]")) return list;
        placesParam = placesParam.trim();
        if (placesParam.startsWith("[") && placesParam.endsWith("]")) {
            String content = placesParam.substring(1, placesParam.length() - 1);
            if (!content.isEmpty()) {
                for (String p : content.split(",")) {
                    try { list.add(Integer.parseInt(p.trim())); }
                    catch (NumberFormatException ignored) {}
                }
            }
        }
        return list;
    }

    private String emptyToNull(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }
}