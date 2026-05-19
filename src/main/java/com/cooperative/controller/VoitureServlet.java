package com.cooperative.controller;

import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Voiture;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/voiture/*")
public class VoitureServlet extends HttpServlet {

    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null || action.equals("/")) {
            action = "/list";
        }

        switch (action) {
            case "/new":
                showNewForm(request, response);
                break;
            case "/edit":
                showEditForm(request, response);
                break;
            case "/delete":
                deleteVoiture(request, response);
                break;
            case "/places":
                showPlacesLibres(request, response);
                break;
            default:
                listVoitures(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/voiture/");
            return;
        }

        switch (action) {
            case "/save":
                saveVoiture(request, response);
                break;
            case "/update":
                updateVoiture(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/voiture/");
                break;
        }
    }

    private void listVoitures(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Voiture> voitures = voitureDAO.findAll();
        request.setAttribute("voitures", voitures);
        request.getRequestDispatcher("/views/voiture/liste.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/voiture/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        Voiture voiture = voitureDAO.findById(id);

        if (voiture == null) {
            request.getSession().setAttribute("errorMessage", "Voiture introuvable.");
            response.sendRedirect(request.getContextPath() + "/voiture/");
            return;
        }

        request.setAttribute("voiture", voiture);
        request.getRequestDispatcher("/views/voiture/form.jsp").forward(request, response);
    }

    private void saveVoiture(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Voiture v = new Voiture();
            v.setIdvoit(request.getParameter("idvoit"));
            v.setDesign(request.getParameter("design"));
            v.setType(request.getParameter("type"));
            v.setNbrplace(Integer.parseInt(request.getParameter("nbrplace")));
            v.setFrais(Integer.parseInt(request.getParameter("frais")));

            String result = voitureDAO.create(v);

            HttpSession session = request.getSession();
            // CORRECTION : utiliser "successMessage" et "errorMessage"
            if (result.startsWith("SUCCESS")) {
                session.setAttribute("successMessage", result.replace("SUCCESS: ", ""));
            } else {
                session.setAttribute("errorMessage", result.replace("ERROR: ", ""));
            }

            response.sendRedirect(request.getContextPath() + "/voiture/");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Veuillez entrer des nombres valides.");
            response.sendRedirect(request.getContextPath() + "/voiture/new");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/voiture/new");
        }
    }

    private void updateVoiture(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Voiture v = new Voiture();
            v.setIdvoit(request.getParameter("idvoit"));
            v.setDesign(request.getParameter("design"));
            v.setType(request.getParameter("type"));
            v.setNbrplace(Integer.parseInt(request.getParameter("nbrplace")));
            v.setFrais(Integer.parseInt(request.getParameter("frais")));

            String result = voitureDAO.update(v);

            HttpSession session = request.getSession();
            // CORRECTION : utiliser "successMessage" et "errorMessage"
            if (result.startsWith("SUCCESS")) {
                session.setAttribute("successMessage", result.replace("SUCCESS: ", ""));
            } else {
                session.setAttribute("errorMessage", result.replace("ERROR: ", ""));
            }

            response.sendRedirect(request.getContextPath() + "/voiture/");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Veuillez entrer des nombres valides.");
            response.sendRedirect(request.getContextPath() + "/voiture/edit?id=" +
                    request.getParameter("idvoit"));
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/voiture/edit?id=" +
                    request.getParameter("idvoit"));
        }
    }

    private void deleteVoiture(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String id = request.getParameter("id");
        String result = voitureDAO.delete(id);

        HttpSession session = request.getSession();
        // CORRECTION : utiliser "successMessage" et "errorMessage"
        if (result.startsWith("SUCCESS")) {
            session.setAttribute("successMessage", result.replace("SUCCESS: ", ""));
        } else {
            session.setAttribute("errorMessage", result.replace("ERROR: ", ""));
        }

        response.sendRedirect(request.getContextPath() + "/voiture/");
    }

    private void showPlacesLibres(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String dateStr = request.getParameter("date");

        Voiture voiture = voitureDAO.findById(id);

        if (voiture == null) {
            request.getSession().setAttribute("errorMessage", "Voiture introuvable.");
            response.sendRedirect(request.getContextPath() + "/voiture/");
            return;
        }

        List<Integer> placesLibres;
        if (dateStr != null && !dateStr.isEmpty()) {
            try {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.util.Date utilDate = sdf.parse(dateStr);
                java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
                placesLibres = voitureDAO.getPlacesLibres(id, sqlDate);
                request.setAttribute("date", dateStr);
            } catch (Exception e) {
                e.printStackTrace();
                placesLibres = voitureDAO.getPlacesLibres(id);
            }
        } else {
            placesLibres = voitureDAO.getPlacesLibres(id);
        }

        request.setAttribute("voiture", voiture);
        request.setAttribute("placesLibres", placesLibres);
        request.getRequestDispatcher("/views/voiture/places.jsp").forward(request, response);
    }
}