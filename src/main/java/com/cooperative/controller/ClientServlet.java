package com.cooperative.controller;

import com.cooperative.dao.ClientDAO;
import com.cooperative.model.Client;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/client/*")
public class ClientServlet extends HttpServlet {

    private ClientDAO clientDAO = new ClientDAO();

    // ==================== HELPERS JSON ====================

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private static String jsonOk(String clientName, int clientId) {
        return "{\"success\":true"
                + ",\"clientName\":\"" + escapeJson(clientName) + "\""
                + ",\"clientId\":"    + clientId
                + "}";
    }

    private static String jsonError(String message) {
        return "{\"success\":false"
                + ",\"message\":\"" + escapeJson(message) + "\""
                + "}";
    }

    // ==================== ROUTING GET ====================

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null || action.equals("/")) action = "/list";

        switch (action) {
            case "/new":    showNewForm(request, response);      break;
            case "/edit":   showEditForm(request, response);     break;
            case "/delete": deleteClientGet(request, response);  break;
            case "/reset":  resetAndReindex(request, response);  break;
            default:        listClients(request, response);      break;
        }
    }

    // ==================== ROUTING POST ====================

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/client/");
            return;
        }
        switch (action) {
            case "/save":        saveClient(request, response);      break;
            case "/update":      updateClient(request, response);    break;
            case "/edit":        editClientAjax(request, response);  break;
            case "/delete":      deleteClientAjax(request, response);break;
            default:
                response.sendRedirect(request.getContextPath() + "/client/");
                break;
        }
    }

    // ==================== LISTE ====================

    private void listClients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tri = request.getParameter("tri");
        if (tri == null || tri.isEmpty()) tri = "id";

        List<Client> clients = clientDAO.findAll(tri);
        request.setAttribute("clients", clients);
        request.setAttribute("tri", tri);

        // Transfert des messages flash session → attributs request
        HttpSession session = request.getSession();
        String successMsg = (String) session.getAttribute("successMessage");
        String errorMsg   = (String) session.getAttribute("errorMessage");

        if (successMsg != null) {
            request.setAttribute("toastSuccess", successMsg);
            session.removeAttribute("successMessage");
        }
        if (errorMsg != null) {
            request.setAttribute("toastError", errorMsg);
            session.removeAttribute("errorMessage");
        }

        request.getRequestDispatcher("/views/client/liste.jsp").forward(request, response);
    }

    // ==================== FORMULAIRE NOUVEAU ====================

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/client/form.jsp").forward(request, response);
    }

    // ==================== FORMULAIRE ÉDITION ====================

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Client client = clientDAO.findById(id);
            if (client == null) {
                request.getSession().setAttribute("errorMessage",
                        "Client introuvable (ID=" + id + ").");
                response.sendRedirect(request.getContextPath() + "/client/");
                return;
            }
            request.setAttribute("client", client);
            request.getRequestDispatcher("/views/client/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/client/");
        }
    }

    // ==================== SUPPRESSION (GET classique) ====================

    private void deleteClientGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Client existing = clientDAO.findById(id);
            if (existing != null) {
                boolean ok = clientDAO.delete(id);
                if (ok) {
                    session.setAttribute("successMessage",
                            "Client \"" + existing.getNom() + "\" supprimé avec succès.");
                } else {
                    session.setAttribute("errorMessage", "Impossible de supprimer le client.");
                }
            } else {
                session.setAttribute("errorMessage", "Client introuvable.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Identifiant client invalide.");
        }
        response.sendRedirect(request.getContextPath() + "/client/");
    }

    // ==================== CRÉATION ====================

    private void saveClient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String nom    = request.getParameter("nom");
        String numtel = request.getParameter("numtel");
        HttpSession session = request.getSession();

        if (nom == null || nom.trim().isEmpty()
                || numtel == null || numtel.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Tous les champs sont obligatoires.");
            response.sendRedirect(request.getContextPath() + "/client/new");
            return;
        }

        String telClean = numtel.trim().replaceAll("\\s", "");
        if (!telClean.matches("\\d{10}")) {
            session.setAttribute("errorMessage",
                    "Le numéro de téléphone doit contenir exactement 10 chiffres.");
            response.sendRedirect(request.getContextPath() + "/client/new");
            return;
        }

        Client c = new Client();
        c.setNom(nom.trim());
        c.setNumtel(telClean);

        boolean ok = clientDAO.create(c);
        if (ok) {
            session.setAttribute("successMessage",
                    "Client \"" + nom.trim() + "\" ajouté avec succès ! (ID: " + c.getIdcli() + ")");
            response.sendRedirect(request.getContextPath() + "/client/");
        } else {
            session.setAttribute("errorMessage", "Erreur lors de la création du client.");
            response.sendRedirect(request.getContextPath() + "/client/new");
        }
    }

    // ==================== MISE À JOUR ====================

    private void updateClient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int    id     = Integer.parseInt(request.getParameter("idcli"));
            String nom    = request.getParameter("nom").trim();
            String numtel = request.getParameter("numtel").trim();

            String telClean = numtel.replaceAll("\\s", "");
            if (!telClean.matches("\\d{10}")) {
                session.setAttribute("errorMessage",
                        "Le numéro de téléphone doit contenir exactement 10 chiffres.");
                response.sendRedirect(request.getContextPath() + "/client/edit?id=" + id);
                return;
            }

            Client c = new Client();
            c.setIdcli(id);
            c.setNom(nom);
            c.setNumtel(telClean);

            boolean ok = clientDAO.update(c);
            if (ok) {
                session.setAttribute("successMessage",
                        "Client \"" + nom + "\" modifié avec succès !");
                response.sendRedirect(request.getContextPath() + "/client/");
            } else {
                session.setAttribute("errorMessage", "Erreur lors de la mise à jour du client.");
                response.sendRedirect(request.getContextPath() + "/client/edit?id=" + id);
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Identifiant client invalide.");
            response.sendRedirect(request.getContextPath() + "/client/");
        }
    }

    // ==================== ÉDITION AJAX ====================

    private void editClientAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int    id     = Integer.parseInt(request.getParameter("id"));
            String nom    = request.getParameter("nom");
            String numtel = request.getParameter("numtel");

            if (nom == null || nom.trim().isEmpty()
                    || numtel == null || numtel.trim().isEmpty()) {
                out.print(jsonError("Tous les champs sont obligatoires."));
                return;
            }

            String telClean = numtel.trim().replaceAll("\\s", "");
            if (!telClean.matches("\\d{10}")) {
                out.print(jsonError("Le numéro de téléphone doit contenir exactement 10 chiffres."));
                return;
            }

            Client c = new Client();
            c.setIdcli(id);
            c.setNom(nom.trim());
            c.setNumtel(telClean);

            boolean ok = clientDAO.update(c);
            out.print(ok
                    ? jsonOk(c.getNom(), c.getIdcli())
                    : jsonError("La mise à jour a échoué en base de données."));

        } catch (NumberFormatException e) {
            out.print(jsonError("Identifiant client invalide."));
        }
    }

    // ==================== SUPPRESSION AJAX ====================

    private void deleteClientAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            Client existing = clientDAO.findById(id);
            if (existing == null) {
                out.print(jsonError("Client introuvable."));
                return;
            }

            boolean ok = clientDAO.delete(id);
            if (ok) {
                out.print("{\"success\":true"
                        + ",\"clientName\":\"" + escapeJson(existing.getNom()) + "\""
                        + ",\"deletedId\":"    + id
                        + "}");
            } else {
                out.print(jsonError("La suppression a échoué en base de données."));
            }
        } catch (NumberFormatException e) {
            out.print(jsonError("Identifiant client invalide."));
        }
    }

    // ==================== RÉINDEXATION ====================

    private void resetAndReindex(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        boolean ok = clientDAO.resetAndReindex();
        if (ok) {
            session.setAttribute("successMessage",
                    "IDs réinitialisés avec succès — tous les clients sont maintenant numérotés à partir de 1.");
        } else {
            session.setAttribute("errorMessage",
                    "Erreur lors de la réinitialisation des IDs.");
        }
        response.sendRedirect(request.getContextPath() + "/client/");
    }
}