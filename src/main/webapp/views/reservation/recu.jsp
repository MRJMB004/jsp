<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cooperative.model.Reservation, java.text.SimpleDateFormat, java.util.List" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>Reçu de Réservation | Coopérative</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <%-- ══ ANTI-FLASH : doit être le premier script ══ --%>
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>

    <style>
        * { margin:0; padding:0; box-sizing:border-box; }

        /* ══════════════════════════════════════════════
           VARIABLES — MODE SOMBRE (défaut)
        ══════════════════════════════════════════════ */
        :root {
            --bg-deep:#0a0e1a; --bg-primary:#0f1322; --bg-secondary:#151a2d;
            --bg-card:#1a1f35; --bg-hover:#222842; --border:#2a2f4a;
            --navy-300:#5a7fb0; --navy-400:#4a6d9e; --navy-500:#3a5b8c; --navy-600:#2a497a;
            --text-primary:#f0f4f8; --text-secondary:#9aa4bf; --text-muted:#6b7294;
            --success:#10b981; --warning:#f59e0b; --error:#ef4444; --info:#3b82f6;
            --radius-md:0.5rem; --radius-lg:0.75rem; --radius-xl:1rem;
            --shadow-lg:0 10px 15px -3px rgba(0,0,0,0.5);
        }

        /* ══════════════════════════════════════════════
           VARIABLES — MODE CLAIR
        ══════════════════════════════════════════════ */
        [data-theme="light"] {
            --bg-deep:#f0f4f8; --bg-primary:#ffffff; --bg-secondary:#e8edf5;
            --bg-card:#ffffff; --bg-hover:#dce4f0; --border:#c8d3e6;
            --navy-300:#2a497a; --navy-400:#3a5b8c; --navy-500:#4a6d9e; --navy-600:#5a7fb0;
            --text-primary:#0f1322; --text-secondary:#3a4560; --text-muted:#6b7294;
            --success:#059669; --warning:#d97706; --error:#dc2626; --info:#2563eb;
            --shadow-lg:0 10px 15px -3px rgba(0,0,0,0.14);
        }

        body {
            background:var(--bg-deep);
            font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;
            font-size:0.875rem; line-height:1.5;
            color:var(--text-primary);
            min-height:100vh;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .container { max-width:520px; margin:2rem auto; padding:0 1rem; }

        /* ── Barre d'actions haut ── */
        .top-bar {
            display:flex; align-items:center; justify-content:space-between;
            margin-bottom:1rem;
        }
        .btn-back {
            display:inline-flex; align-items:center; gap:0.5rem;
            background:var(--bg-hover); color:var(--text-secondary);
            padding:0.5rem 1rem; border-radius:var(--radius-md);
            text-decoration:none; font-size:0.75rem;
            transition:all 0.2s; border:1px solid transparent;
        }
        .btn-back:hover { background:var(--navy-500); color:white; }

        /* ── Bouton toggle thème ── */
        .theme-btn {
            width:2.25rem; height:2.25rem;
            border-radius:var(--radius-md);
            background:var(--bg-card);
            border:1px solid var(--border);
            color:var(--text-muted);
            cursor:pointer;
            display:flex; align-items:center; justify-content:center;
            font-size:0.95rem;
            transition:all 0.2s ease;
            flex-shrink:0;
        }
        .theme-btn:hover {
            background:var(--bg-hover);
            color:var(--text-primary);
            border-color:var(--navy-500);
        }

        /* ── Boutons d'action ── */
        .action-buttons { display:flex; justify-content:center; gap:1rem; margin-top:1.5rem; flex-wrap:wrap; }
        .btn { display:inline-flex; align-items:center; gap:0.5rem; padding:0.625rem 1.25rem; border-radius:var(--radius-md); text-decoration:none; font-size:0.75rem; font-weight:500; cursor:pointer; border:none; transition:all 0.2s; }
        .btn-primary { background:var(--navy-500); color:white; }
        .btn-primary:hover { background:var(--navy-400); transform:translateY(-1px); }
        .btn-success { background:var(--success); color:white; }
        .btn-success:hover { filter:brightness(0.9); transform:translateY(-1px); }
        .btn-outline { background:transparent; border:1px solid var(--border); color:var(--text-secondary); }
        .btn-outline:hover { background:var(--bg-hover); border-color:var(--navy-500); color:var(--text-primary); }

        /* ── Reçu ── */
        .recu-container {
            background:var(--bg-card); border-radius:var(--radius-xl);
            border:1px solid var(--border); overflow:hidden;
            box-shadow:var(--shadow-lg);
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .recu-header { background:linear-gradient(135deg,var(--navy-500),var(--navy-600)); padding:1.5rem; text-align:center; }
        .recu-header h1 { font-size:1.25rem; margin-bottom:0.25rem; color:#fff; }
        .recu-header .subtitle { font-size:0.7rem; opacity:0.85; color:#fff; }
        .recu-number {
            text-align:center; padding:1rem; border-bottom:1px solid var(--border);
            background:var(--bg-secondary);
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .recu-number h2 { font-size:1.1rem; color:var(--navy-300); }
        .recu-body { padding:1.5rem; }
        .recu-section { margin-bottom:1.5rem; padding-bottom:1rem; border-bottom:1px dashed var(--border); }
        .recu-section:last-of-type { border-bottom:none; }
        .recu-section h3 { font-size:0.75rem; text-transform:uppercase; letter-spacing:0.05em; color:var(--navy-300); margin-bottom:1rem; display:flex; align-items:center; gap:0.5rem; }
        .info-line { display:flex; margin-bottom:0.75rem; }
        .info-label { flex:0 0 120px; color:var(--text-muted); font-size:0.75rem; }
        .info-value { flex:1; font-weight:500; color:var(--text-primary); }

        /* Badges de places */
        .places-badges { display:flex; flex-wrap:wrap; gap:0.4rem; margin-top:0.25rem; }
        .place-badge { background:var(--navy-600); border:1px solid var(--navy-400); color:white; padding:0.2rem 0.6rem; border-radius:20px; font-size:0.7rem; font-weight:600; }

        /* Bloc montants */
        .amount-highlight {
            background:var(--bg-secondary); padding:1rem; border-radius:var(--radius-lg); margin-top:0.5rem;
            transition: background 0.3s ease;
        }
        .amount-line { display:flex; justify-content:space-between; margin-bottom:0.5rem; font-size:0.8rem; color:var(--text-primary); }
        .amount-line.total { font-size:1rem; font-weight:bold; color:var(--navy-300); margin-top:0.75rem; padding-top:0.75rem; border-top:1px solid var(--border); }
        .amount-line.reste { font-size:0.9rem; font-weight:bold; color:var(--error); }

        .payment-badge { display:inline-block; padding:0.25rem 0.75rem; border-radius:20px; font-size:0.7rem; font-weight:600; }
        .avec-avance { background:rgba(245,158,11,0.2); color:var(--warning); }
        .tout-paye   { background:rgba(16,185,129,0.2); color:var(--success); }
        .sans-avance { background:rgba(239,68,68,0.2); color:var(--error); }

        .confirmation-message { text-align:center; margin-top:1.5rem; padding-top:1rem; border-top:1px dashed var(--border); }

        .recu-footer {
            background:var(--bg-secondary); padding:1.5rem 1rem; text-align:center;
            border-top:1px solid var(--border);
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .recu-footer p { font-size:0.7rem; color:var(--text-muted); }

        .error-message { text-align:center; padding:3rem; background:var(--bg-card); border-radius:var(--radius-xl); border:1px solid var(--border); }
        .error-icon { font-size:3rem; color:var(--error); margin-bottom:1rem; }

        /* ── Toast ── */
        .toast-container { position:fixed; top:1.5rem; right:1.5rem; z-index:9999; display:flex; flex-direction:column; gap:0.75rem; max-width:380px; }
        .toast { background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-lg); padding:1rem 1.25rem; box-shadow:var(--shadow-lg); display:flex; align-items:center; gap:0.875rem; animation:slideInRight 0.3s ease-out; }
        .toast-success { border-left:4px solid var(--success); }
        .toast-error   { border-left:4px solid var(--error); }

        @keyframes slideInRight { from{opacity:0;transform:translateX(100%)} to{opacity:1;transform:translateX(0)} }
        @keyframes fadeInUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
        .animate-in { animation:fadeInUp 0.4s ease-out; }

        @media(max-width:600px){
            .action-buttons{flex-direction:column;align-items:stretch}
            .btn{justify-content:center}
            .info-line{flex-direction:column}
            .info-label{flex:none;margin-bottom:0.25rem}
        }

        @media print {
            body { background:white !important; color:black !important; }
            .no-print { display:none !important; }
            .recu-container { border:1px solid #ccc; box-shadow:none; background:white !important; }
            .recu-header { background:#2a497a !important; -webkit-print-color-adjust:exact; print-color-adjust:exact; }
            .recu-header h1, .recu-header .subtitle { color:white !important; }
            .recu-number, .amount-highlight, .recu-footer { background:#f5f5f5 !important; -webkit-print-color-adjust:exact; print-color-adjust:exact; }
            .info-label { color:#555 !important; }
            .info-value, .amount-line { color:#111 !important; }
            .recu-footer p { color:#555 !important; }
        }
    </style>
</head>
<body>
<div class="container">

    <!-- Barre haut : retour + toggle thème -->
    <div class="top-bar no-print">
        <a href="<%= request.getContextPath() %>/reservation/" class="btn-back">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
        <button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
            <i class="fas fa-moon" id="themeIcon"></i>
        </button>
    </div>

    <%
        Reservation reservation = (Reservation) request.getAttribute("reservation");

        // Fallback : charger depuis l'URL si besoin
        if (reservation == null) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    com.cooperative.dao.ReservationDAO dao = new com.cooperative.dao.ReservationDAO();
                    reservation = dao.findByIdWithDetails(idParam);
                } catch (Exception ignored) {}
            }
        }

        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage   = (String) session.getAttribute("errorMessage");
        if (successMessage != null) session.removeAttribute("successMessage");
        if (errorMessage   != null) session.removeAttribute("errorMessage");

        if (reservation != null) {
            SimpleDateFormat dateFmt     = new SimpleDateFormat("dd MMMM yyyy", java.util.Locale.FRENCH);
            SimpleDateFormat dateTimeFmt = new SimpleDateFormat("dd MMMM yyyy 'à' HH:mm", java.util.Locale.FRENCH);

            String dateReservStr  = dateTimeFmt.format(new java.util.Date(reservation.getDateReserv().getTime()));
            String dateVoyageStr  = dateFmt.format(reservation.getDateVoyage());

            // Calculs complets (toutes places)
            int nbPlaces   = reservation.getNombrePlaces();
            int fraisUnit  = reservation.getFraisVoiture();
            int totalFrais = reservation.getTotalFrais();     // fraisUnit * nbPlaces
            int avance     = reservation.getMontantAvance();  // total avance toutes places
            int reste      = totalFrais - avance;
            if (reste < 0) reste = 0;

            String paymentClass = "sans-avance";
            if ("avec avance".equals(reservation.getPayment())) paymentClass = "avec-avance";
            else if ("tout payé".equals(reservation.getPayment())) paymentClass = "tout-paye";

            List<Integer> placesList = reservation.getPlacesList();
    %>

    <!-- Boutons haut -->
    <div class="action-buttons no-print">
        <button onclick="window.print()" class="btn btn-primary"><i class="fas fa-print"></i> Imprimer</button>
        <a href="<%= request.getContextPath() %>/reservation/pdf?id=<%= reservation.getIdreserv() %>"
           class="btn btn-success" target="_blank"><i class="fas fa-file-pdf"></i> Télécharger PDF</a>
        <a href="<%= request.getContextPath() %>/reservation/edit?id=<%= reservation.getIdreserv() %>"
           class="btn btn-outline"><i class="fas fa-edit"></i> Modifier</a>
    </div>

    <!-- Reçu -->
    <div class="recu-container animate-in">
        <div class="recu-header">
            <h1><i class="fas fa-handshake"></i> COOPÉRATIVE DE TRANSPORT</h1>
            <p class="subtitle">Votre partenaire de voyage</p>
        </div>

        <div class="recu-number">
            <h2>Reçu N° <%= reservation.getIdreserv() %></h2>
        </div>

        <div class="recu-body">

            <!-- Informations de réservation -->
            <div class="recu-section">
                <h3><i class="fas fa-calendar-alt"></i> Informations de réservation</h3>
                <div class="info-line">
                    <span class="info-label">Date réservation :</span>
                    <span class="info-value"><%= dateReservStr %></span>
                </div>
                <div class="info-line">
                    <span class="info-label">Date du voyage :</span>
                    <span class="info-value"><strong><%= dateVoyageStr %></strong></span>
                </div>
            </div>

            <!-- Client -->
            <div class="recu-section">
                <h3><i class="fas fa-user"></i> Client</h3>
                <div class="info-line">
                    <span class="info-label">Nom :</span>
                    <span class="info-value"><%= reservation.getNomClient() %></span>
                </div>
                <div class="info-line">
                    <span class="info-label">Contact :</span>
                    <span class="info-value"><%= reservation.getNumtelClient() %></span>
                </div>
            </div>

            <!-- Voyage -->
            <div class="recu-section">
                <h3><i class="fas fa-bus"></i> Informations du voyage</h3>
                <div class="info-line">
                    <span class="info-label">Voiture :</span>
                    <span class="info-value"><%= reservation.getDesignVoiture() %></span>
                </div>
                <div class="info-line">
                    <span class="info-label">Type :</span>
                    <span class="info-value"><%= reservation.getTypeVoiture() != null ? reservation.getTypeVoiture() : "–" %></span>
                </div>
                <div class="info-line">
                    <span class="info-label">Nb de places :</span>
                    <span class="info-value"><strong><%= nbPlaces %> place(<%= nbPlaces > 1 ? "s" : "" %>)</strong></span>
                </div>
                <div class="info-line">
                    <span class="info-label">Place(s) N° :</span>
                    <span class="info-value">
                        <div class="places-badges">
                            <%
                                if (placesList != null && !placesList.isEmpty()) {
                                    for (int p : placesList) {
                            %>
                            <span class="place-badge">N°<%= p %></span>
                            <%      }
                            } else if (reservation.getPlaces() != null) { %>
                            <span class="place-badge">N°<%= reservation.getPlaces() %></span>
                            <% } %>
                        </div>
                    </span>
                </div>
            </div>

            <!-- Paiement -->
            <div class="recu-section">
                <h3><i class="fas fa-money-bill-wave"></i> Détails du paiement</h3>
                <div class="info-line">
                    <span class="info-label">Mode :</span>
                    <span class="info-value">
                        <span class="payment-badge <%= paymentClass %>"><%= reservation.getPayment() %></span>
                    </span>
                </div>

                <div class="amount-highlight">
                    <div class="amount-line">
                        <span>Frais / place :</span>
                        <span><strong><%= String.format("%,d", fraisUnit) %> Ar</strong></span>
                    </div>
                    <div class="amount-line">
                        <span>Nombre de places :</span>
                        <span><strong><%= nbPlaces %></strong></span>
                    </div>
                    <div class="amount-line total">
                        <span>Total :</span>
                        <span><%= String.format("%,d", totalFrais) %> Ar</span>
                    </div>

                    <% if ("avec avance".equals(reservation.getPayment())) { %>
                    <div class="amount-line" style="margin-top:0.5rem;">
                        <span>Avance versée :</span>
                        <span style="color:var(--warning);"><strong><%= String.format("%,d", avance) %> Ar</strong></span>
                    </div>
                    <div class="amount-line reste">
                        <span>Reste à payer :</span>
                        <span><%= String.format("%,d", reste) %> Ar</span>
                    </div>
                    <% } else if ("tout payé".equals(reservation.getPayment())) { %>
                    <div class="amount-line" style="color:var(--success);font-weight:bold;margin-top:0.5rem;border-top:1px solid var(--border);padding-top:0.5rem;">
                        <span>Montant payé :</span>
                        <span><%= String.format("%,d", totalFrais) %> Ar ✓</span>
                    </div>
                    <% } else { %>
                    <div class="amount-line" style="color:var(--error);font-weight:bold;margin-top:0.5rem;border-top:1px solid var(--border);padding-top:0.5rem;">
                        <span>À payer :</span>
                        <span><%= String.format("%,d", totalFrais) %> Ar</span>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Confirmation -->
            <div class="confirmation-message">
                <p style="color:var(--success);font-size:0.75rem;">
                    <i class="fas fa-check-circle"></i> Réservation confirmée
                </p>
                <p style="font-size:0.7rem;color:var(--text-muted);margin-top:0.75rem;">
                    Merci de votre confiance !<br>
                    Veuillez vous présenter 30 minutes avant le départ.
                </p>
            </div>
        </div>

        <div class="recu-footer">
            <p><strong>Coopérative de Transport</strong></p>
            <p style="margin-top:0.5rem;">Tel : +261 38 92 827 07 | Email : contact@cooperative.mg</p>
            <p style="margin-top:0.5rem;font-size:0.65rem;">
                Reçu généré le <%= new SimpleDateFormat("dd/MM/yyyy 'à' HH:mm").format(new java.util.Date()) %>
            </p>
        </div>
    </div>

    <!-- Boutons bas -->
    <div class="action-buttons no-print" style="margin-top:1rem;">
        <button onclick="window.print()" class="btn btn-primary"><i class="fas fa-print"></i> Imprimer</button>
        <a href="<%= request.getContextPath() %>/reservation/pdf?id=<%= reservation.getIdreserv() %>"
           class="btn btn-success" target="_blank"><i class="fas fa-file-pdf"></i> Télécharger PDF</a>
    </div>

    <%
    } else {
    %>
    <div class="error-message animate-in">
        <div class="error-icon"><i class="fas fa-exclamation-triangle"></i></div>
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;">Reçu introuvable</h2>
        <p style="color:var(--text-muted);margin-bottom:1.5rem;">La réservation demandée n'existe pas ou a été supprimée.</p>
        <a href="<%= request.getContextPath() %>/reservation/" class="btn btn-primary">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
    </div>
    <% } %>
</div>

<div class="toast-container" id="toastContainer"></div>

<script>
    /* ================================================================
       TOGGLE THÈME — synchronisé avec localStorage (même clé que la liste)
    ================================================================ */
    (function () {
        var btn  = document.getElementById('themeBtn');
        var icon = document.getElementById('themeIcon');
        var root = document.documentElement;

        if (!btn) return; // page d'erreur sans bouton

        function applyTheme(theme) {
            if (theme === 'light') {
                root.setAttribute('data-theme', 'light');
                icon.className = 'fas fa-sun';
                btn.title = 'Passer en mode sombre';
            } else {
                root.removeAttribute('data-theme');
                icon.className = 'fas fa-moon';
                btn.title = 'Passer en mode clair';
            }
        }

        applyTheme(localStorage.getItem('theme') || 'dark');

        btn.addEventListener('click', function () {
            var current = localStorage.getItem('theme') || 'dark';
            var next = current === 'dark' ? 'light' : 'dark';
            localStorage.setItem('theme', next);
            applyTheme(next);
        });
    })();

    /* ================================================================
       TOASTS SESSION
    ================================================================ */
    <% if (successMessage != null) { %>
    document.addEventListener('DOMContentLoaded', function(){
        var c = document.getElementById('toastContainer');
        var t = document.createElement('div');
        t.className = 'toast toast-success';
        t.innerHTML = '<i class="fas fa-check-circle" style="color:var(--success)"></i><span><%= successMessage.replace("'", "\\'") %></span>';
        c.appendChild(t);
        setTimeout(function(){ t.remove(); }, 5000);
    });
    <% } %>
    <% if (errorMessage != null) { %>
    document.addEventListener('DOMContentLoaded', function(){
        var c = document.getElementById('toastContainer');
        var t = document.createElement('div');
        t.className = 'toast toast-error';
        t.innerHTML = '<i class="fas fa-times-circle" style="color:var(--error)"></i><span><%= errorMessage.replace("'", "\\'") %></span>';
        c.appendChild(t);
        setTimeout(function(){ t.remove(); }, 5000);
    });
    <% } %>
</script>
</body>
</html>
