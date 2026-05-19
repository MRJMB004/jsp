<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cooperative.model.Voiture" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">

    <%-- ═══════════ ANTI-FLASH : doit être le premier script ═══════════ --%>
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>

    <title><%= request.getAttribute("voiture") == null ? "Ajouter" : "Modifier" %> une voiture | Coopérative</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        /* ══════════════════════════════════════════════
           VARIABLES — MODE SOMBRE (défaut)
        ══════════════════════════════════════════════ */
        :root {
            --bg-deep:      #0a0e1a;
            --bg-primary:   #0f1322;
            --bg-secondary: #151a2d;
            --bg-card:      #1a1f35;
            --bg-hover:     #222842;
            --border:       #2a2f4a;
            --border-light: #32385a;

            --navy-300: #5a7fb0;
            --navy-400: #4a6d9e;
            --navy-500: #3a5b8c;
            --navy-600: #2a497a;

            --text-primary:   #f0f4f8;
            --text-secondary: #9aa4bf;
            --text-muted:     #6b7294;

            --success: #10b981;
            --warning: #f59e0b;
            --error:   #ef4444;
            --info:    #3b82f6;

            --shadow-sm: 0 1px 2px rgba(0,0,0,0.3);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.4);
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.5);
            --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.6);

            --radius-sm:  0.375rem;
            --radius-md:  0.5rem;
            --radius-lg:  0.75rem;
            --radius-xl:  1rem;
            --radius-2xl: 1.25rem;

            --toggle-bg:    #222842;
            --toggle-thumb: #4a6d9e;
        }

        /* ══════════════════════════════════════════════
           VARIABLES — MODE CLAIR
        ══════════════════════════════════════════════ */
        [data-theme="light"] {
            --bg-deep:      #f0f4f8;
            --bg-primary:   #ffffff;
            --bg-secondary: #e8edf5;
            --bg-card:      #ffffff;
            --bg-hover:     #dce4f0;
            --border:       #c8d3e6;
            --border-light: #b8c6dd;

            --navy-300: #2a497a;
            --navy-400: #3a5b8c;
            --navy-500: #4a6d9e;
            --navy-600: #5a7fb0;

            --text-primary:   #0f1322;
            --text-secondary: #3a4560;
            --text-muted:     #6b7294;

            --success: #059669;
            --warning: #d97706;
            --error:   #dc2626;
            --info:    #2563eb;

            --shadow-sm: 0 1px 2px rgba(0,0,0,0.08);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.10);
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.12);
            --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.14);

            --toggle-bg:    #c8d3e6;
            --toggle-thumb: #3a5b8c;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: var(--bg-deep);
            font-family: 'DM Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            font-size: 0.875rem;
            line-height: 1.5;
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            transition: background 0.3s ease, color 0.3s ease;
        }

        @media (max-width: 640px) { body { padding: 1rem; align-items: flex-start; } }

        /* ── Card ── */
        .card {
            max-width: 560px; width: 100%;
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            animation: slideUp 0.4s ease-out;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .card-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            background: var(--bg-secondary);
            transition: background 0.3s ease, border-color 0.3s ease;
            position: relative;
        }

        .card-title {
            font-family: 'Syne', sans-serif;
            font-size: 1.25rem; font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .card-description { font-size: 0.75rem; color: var(--text-muted); }

        .card-content { padding: 1.5rem; }

        .card-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            background: var(--bg-secondary);
            display: flex; justify-content: space-between; align-items: center; gap: 0.75rem;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .footer-right { display: flex; gap: 0.75rem; }

        /* ── Theme Toggle (dans card-header) ── */
        .theme-btn {
            position: absolute;
            top: 1rem; right: 1rem;
            width: 2.25rem; height: 2.25rem;
            border-radius: var(--radius-lg);
            background: var(--bg-hover);
            border: 1px solid var(--border);
            color: var(--text-muted);
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }
        .theme-btn:hover {
            background: var(--bg-card);
            color: var(--text-primary);
            border-color: var(--navy-500);
        }

        /* ── Forms ── */
        .form-group { margin-bottom: 1.25rem; }

        .label {
            display: block; font-size: 0.8125rem; font-weight: 500;
            margin-bottom: 0.5rem; color: var(--text-secondary);
        }
        .label-required::after { content: "*"; color: var(--error); margin-left: 0.25rem; }

        .input-wrapper { position: relative; }
        .input-wrapper > i {
            position: absolute; left: 0.875rem; top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted); font-size: 0.875rem;
            pointer-events: none;
        }

        .input, .select {
            width: 100%; padding: 0.75rem 0.875rem;
            font-size: 0.875rem; font-family: inherit;
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            color: var(--text-primary);
            transition: all 0.2s ease;
        }
        .input-icon { padding-left: 2.5rem; }
        .input:focus, .select:focus {
            outline: none;
            border-color: var(--navy-500);
            box-shadow: 0 0 0 3px rgba(58,91,140,0.2);
        }

        /* Mode clair : fond blanc pour les inputs */
        [data-theme="light"] .input,
        [data-theme="light"] .select {
            background: #ffffff;
            border-color: var(--border);
        }
        [data-theme="light"] .input:focus,
        [data-theme="light"] .select:focus {
            border-color: var(--navy-500);
            box-shadow: 0 0 0 3px rgba(74,109,158,0.15);
        }

        .select {
            cursor: pointer; appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%239aa4bf'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.875rem center;
            background-size: 1rem;
            padding-right: 2.5rem;
        }

        .input-error { border-color: var(--error) !important; }

        .error-message {
            color: var(--error); font-size: 0.7rem;
            margin-top: 0.25rem;
            display: flex; align-items: center; gap: 0.25rem;
        }
        .help-text {
            font-size: 0.7rem; color: var(--text-muted);
            margin-top: 0.25rem;
            display: flex; align-items: center; gap: 0.25rem;
        }

        /* ── Preview Card ── */
        .preview-card {
            background: var(--bg-secondary);
            border-radius: var(--radius-lg);
            padding: 1rem; margin-top: 1.5rem;
            border: 1px solid var(--border);
            display: none;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .preview-card.show { display: block; animation: fadeIn 0.3s ease-out; }

        @keyframes fadeIn { from { opacity: 0; transform: scale(0.98); } to { opacity: 1; transform: scale(1); } }

        .preview-header { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.75rem; }
        .preview-icon {
            width: 2.5rem; height: 2.5rem;
            background: linear-gradient(135deg, var(--navy-500) 0%, var(--navy-600) 100%);
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            color: white;
        }
        .preview-info { flex: 1; }
        .preview-name { font-weight: 600; color: var(--text-primary); }
        .preview-details {
            font-size: 0.7rem; color: var(--text-muted);
            display: flex; gap: 1rem; margin-top: 0.25rem;
        }

        /* ── Buttons ── */
        .btn {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.5rem 1rem; font-size: 0.8125rem; font-weight: 500;
            border-radius: var(--radius-lg); cursor: pointer;
            transition: all 0.2s ease; border: 1px solid transparent;
            text-decoration: none; font-family: inherit;
        }
        .btn-primary { background: var(--navy-500); color: white; }
        .btn-primary:hover { background: var(--navy-400); transform: translateY(-1px); box-shadow: var(--shadow-md); }
        .btn-primary:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }

        .btn-outline {
            background: transparent;
            border-color: var(--border);
            color: var(--text-secondary);
        }
        .btn-outline:hover {
            background: var(--bg-hover);
            border-color: var(--navy-500);
            color: var(--text-primary);
        }

        /* ── Back link ── */
        .back-link {
            display: inline-flex; align-items: center; gap: 0.5rem;
            font-size: 0.8125rem; color: var(--text-muted);
            text-decoration: none; margin-bottom: 1rem;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--text-primary); }

        .hidden { display: none; }

        .fa-spinner { animation: spin 1s linear infinite; }
        @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }

        /* ══════════════════════════════════════════════
           TOAST SYSTEM
        ══════════════════════════════════════════════ */
        .toast-container {
            position: fixed; top: 1.5rem; right: 1.5rem;
            z-index: 9999;
            display: flex; flex-direction: column; gap: 0.75rem;
            max-width: 380px; width: 100%;
            pointer-events: none;
        }

        .toast {
            position: relative; overflow: hidden;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1rem 1.25rem;
            box-shadow: var(--shadow-xl);
            display: flex; align-items: flex-start; gap: 0.875rem;
            pointer-events: auto;
            animation: toastSlideIn 0.35s cubic-bezier(0.34,1.56,0.64,1);
            transition: background 0.3s ease;
        }
        .toast.toast-hiding {
            animation: toastSlideOut 0.3s ease-out forwards;
        }

        /* Barre colorée à gauche */
        .toast-success { border-left: 4px solid var(--success); }
        .toast-error   { border-left: 4px solid var(--error); }
        .toast-warning { border-left: 4px solid var(--warning); }
        .toast-info    { border-left: 4px solid var(--info); }

        .toast-icon {
            flex-shrink: 0;
            width: 2rem; height: 2rem;
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
        }
        .toast-success .toast-icon { background: rgba(16,185,129,0.15); color: var(--success); }
        .toast-error   .toast-icon { background: rgba(239,68,68,0.15);  color: var(--error); }
        .toast-warning .toast-icon { background: rgba(245,158,11,0.15); color: var(--warning); }
        .toast-info    .toast-icon { background: rgba(59,130,246,0.15); color: var(--info); }

        .toast-content { flex: 1; min-width: 0; }
        .toast-title   { font-weight: 600; font-size: 0.8125rem; margin-bottom: 0.2rem; color: var(--text-primary); }
        .toast-message { font-size: 0.75rem; color: var(--text-secondary); line-height: 1.4; }

        .toast-close {
            flex-shrink: 0;
            width: 1.25rem; height: 1.25rem;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; color: var(--text-muted);
            border-radius: var(--radius-sm);
            transition: all 0.2s; font-size: 0.7rem;
        }
        .toast-close:hover { background: var(--bg-hover); color: var(--text-primary); }

        /* Barre de progression */
        .toast-progress {
            position: absolute; bottom: 0; left: 0;
            height: 3px;
            border-radius: 0 0 var(--radius-lg) var(--radius-lg);
            animation: toastProgress 5s linear forwards;
        }
        .toast-success .toast-progress { background: var(--success); }
        .toast-error   .toast-progress { background: var(--error); }
        .toast-warning .toast-progress { background: var(--warning); }
        .toast-info    .toast-progress { background: var(--info); }

        @keyframes toastSlideIn {
            from { opacity: 0; transform: translateX(110%); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes toastSlideOut {
            from { opacity: 1; transform: translateX(0); }
            to   { opacity: 0; transform: translateX(110%); }
        }
        @keyframes toastProgress {
            from { width: 100%; }
            to   { width: 0%; }
        }

        /* ══════════════════════════════════════════════
           PANNEAU SUCCÈS (modal centré)
        ══════════════════════════════════════════════ */
        .overlay {
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.55);
            z-index: 9999;
            backdrop-filter: blur(2px);
            animation: fadeInOverlay 0.3s ease-out;
        }
        .overlay.fade-out { animation: fadeOutOverlay 0.3s ease-out forwards; }

        @keyframes fadeInOverlay  { from { opacity: 0; } to { opacity: 1; } }
        @keyframes fadeOutOverlay { from { opacity: 1; } to { opacity: 0; } }

        .success-panel {
            position: fixed;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            border-radius: var(--radius-xl);
            padding: 2rem 2.5rem;
            text-align: center;
            z-index: 10000;
            animation: popIn 0.4s cubic-bezier(0.34,1.56,0.64,1);
            box-shadow: 0 25px 40px -12px rgba(0,0,0,0.5);
            min-width: 320px;
        }
        .success-panel.fade-out { animation: popOut 0.3s ease-out forwards; }

        @keyframes popIn  {
            from { opacity: 0; transform: translate(-50%,-50%) scale(0.8); }
            to   { opacity: 1; transform: translate(-50%,-50%) scale(1); }
        }
        @keyframes popOut {
            from { opacity: 1; transform: translate(-50%,-50%) scale(1); }
            to   { opacity: 0; transform: translate(-50%,-50%) scale(0.9); }
        }

        .success-close {
            position: absolute; top: 0.75rem; right: 1rem;
            color: rgba(255,255,255,0.7);
            cursor: pointer; font-size: 1rem;
            transition: color 0.2s;
        }
        .success-close:hover { color: white; }

        .success-icon   { font-size: 3rem; color: white; margin-bottom: 0.75rem; }
        .success-title  { font-family: 'Syne', sans-serif; font-size: 1.25rem; font-weight: 700; color: white; margin-bottom: 0.5rem; }
        .success-msg    { font-size: 0.875rem; color: rgba(255,255,255,0.9); }
        .success-countdown { margin-top: 1rem; font-size: 0.75rem; color: rgba(255,255,255,0.8); }
        .success-countdown span { font-weight: 700; font-size: 1rem; }
    </style>
</head>
<body>

<%
    Voiture voiture = (Voiture) request.getAttribute("voiture");
    boolean isEdit  = (voiture != null);
    String action   = isEdit ? "update" : "save";

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage   = (String) session.getAttribute("errorMessage");
    String warningMessage = (String) session.getAttribute("warningMessage");
    String infoMessage    = (String) session.getAttribute("infoMessage");

    boolean isAddSuccess = "success".equals(request.getParameter("redirect")) && !isEdit;

    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage   != null) session.removeAttribute("errorMessage");
    if (warningMessage != null) session.removeAttribute("warningMessage");
    if (infoMessage    != null) session.removeAttribute("infoMessage");
%>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<!-- Overlay + Panneau succès (ajout réussi) -->
<% if (isAddSuccess) { %>
<div class="overlay" id="overlay"></div>
<div class="success-panel" id="successPanel">
    <div class="success-close" onclick="closeSuccessPanel()"><i class="fas fa-times"></i></div>
    <div class="success-icon"><i class="fas fa-check-circle"></i></div>
    <div class="success-title">Voiture ajoutée !</div>
    <div class="success-msg">La voiture a été enregistrée avec succès.</div>
    <div class="success-countdown">
        Redirection dans <span id="countdownNum">3</span> s…
    </div>
</div>
<% } %>

<!-- Card principale -->
<div class="card">
    <div class="card-header">
        <a href="<%= request.getContextPath() %>/voiture/" class="back-link">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="card-title">
            <%= isEdit ? "Modifier le véhicule" : "Nouveau véhicule" %>
        </h2>
        <p class="card-description">
            <%= isEdit ? "Mettez à jour les informations du véhicule." : "Ajoutez un nouveau véhicule à la flotte." %>
        </p>

        <%-- Bouton toggle thème (soleil / lune) --%>
        <button class="theme-btn" id="themeBtn" title="Changer le thème" type="button">
            <i class="fas fa-moon" id="themeIcon"></i>
        </button>
    </div>

    <form action="<%= request.getContextPath() %>/voiture/<%= action %>" method="post" id="voitureForm">
        <% if (isEdit) { %>
        <input type="hidden" name="idvoit" value="<%= voiture.getIdvoit() %>">
        <% } %>

        <div class="card-content">

            <!-- ID Voiture -->
            <% if (!isEdit) { %>
            <div class="form-group">
                <label for="idvoit" class="label label-required">
                    <i class="fas fa-hashtag" style="margin-right:.5rem"></i>ID Véhicule
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-qrcode"></i>
                    <input type="text" id="idvoit" name="idvoit"
                           class="input input-icon"
                           placeholder="Ex: V001" required>
                </div>
                <div class="error-message hidden" id="idError">
                    <i class="fas fa-exclamation-circle"></i> L'ID du véhicule est requis
                </div>
            </div>
            <% } else { %>
            <div class="form-group">
                <label class="label">
                    <i class="fas fa-hashtag" style="margin-right:.5rem"></i>ID Véhicule
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-qrcode"></i>
                    <input type="text" class="input input-icon"
                           value="<%= voiture.getIdvoit() %>" readonly>
                </div>
                <div class="help-text"><i class="fas fa-lock"></i> L'ID n'est pas modifiable</div>
            </div>
            <% } %>

            <!-- Désignation -->
            <div class="form-group">
                <label for="design" class="label label-required">
                    <i class="fas fa-tag" style="margin-right:.5rem"></i>Désignation
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-car"></i>
                    <input type="text" id="design" name="design"
                           class="input input-icon"
                           value="<%= isEdit ? voiture.getDesign() : "" %>"
                           placeholder="Ex: Toyota Hiace" required>
                </div>
                <div class="error-message hidden" id="designError">
                    <i class="fas fa-exclamation-circle"></i> La désignation est requise
                </div>
            </div>

            <!-- Type -->
            <div class="form-group">
                <label for="type" class="label label-required">
                    <i class="fas fa-star" style="margin-right:.5rem"></i>Type
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-crown"></i>
                    <select id="type" name="type" class="select" required>
                        <option value="simple"  <%= isEdit && "simple".equals(voiture.getType())  ? "selected" : "" %>>🚗 Simple</option>
                        <option value="premium" <%= isEdit && "premium".equals(voiture.getType()) ? "selected" : "" %>>⭐ Premium</option>
                        <option value="VIP"     <%= isEdit && "VIP".equals(voiture.getType())     ? "selected" : "" %>>👑 VIP</option>
                    </select>
                </div>
            </div>

            <!-- Nombre de places -->
            <div class="form-group">
                <label for="nbrplace" class="label label-required">
                    <i class="fas fa-chair" style="margin-right:.5rem"></i>Nombre de places
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-users"></i>
                    <input type="number" id="nbrplace" name="nbrplace"
                           class="input input-icon" min="1" max="50"
                           value="<%= isEdit ? voiture.getNbrplace() : "" %>" required>
                </div>
                <div class="help-text"><i class="fas fa-info-circle"></i> Entre 1 et 50 places</div>
                <div class="error-message hidden" id="placesError">
                    <i class="fas fa-exclamation-circle"></i> Nombre invalide (1–50)
                </div>
            </div>

            <!-- Frais -->
            <div class="form-group">
                <label for="frais" class="label label-required">
                    <i class="fas fa-money-bill-wave" style="margin-right:.5rem"></i>Frais (Ar)
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-arrow-trend-up"></i>
                    <input type="number" id="frais" name="frais"
                           class="input input-icon" min="0" step="1000"
                           value="<%= isEdit ? voiture.getFrais() : "" %>" required>
                </div>
                <div class="help-text"><i class="fas fa-info-circle"></i> Frais en Ariary (Ar)</div>
                <div class="error-message hidden" id="fraisError">
                    <i class="fas fa-exclamation-circle"></i> Montant invalide (≥ 0)
                </div>
            </div>

            <!-- Preview -->
            <div class="preview-card" id="previewCard">
                <div class="preview-header">
                    <div class="preview-icon" id="previewIcon"><i class="fas fa-car"></i></div>
                    <div class="preview-info">
                        <div class="preview-name"   id="previewName">Désignation</div>
                        <div class="preview-details">
                            <span id="previewType">Type</span>
                            <span id="previewPlaces">0 places</span>
                            <span id="previewFrais">0 Ar</span>
                        </div>
                    </div>
                </div>
            </div>
        </div><!-- /card-content -->

        <div class="card-footer">
            <a href="<%= request.getContextPath() %>/voiture/" class="btn btn-outline">
                <i class="fas fa-times"></i> Annuler
            </a>
            <div class="footer-right">
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <i class="fas fa-save"></i>
                    <span id="btnText"><%= isEdit ? "Mettre à jour" : "Enregistrer" %></span>
                    <i class="fas fa-spinner hidden" id="loadingSpinner"></i>
                </button>
            </div>
        </div>
    </form>
</div><!-- /card -->

<script>
    /* ═══════════════════════════════════════════════════
       1. TOGGLE THÈME
    ═══════════════════════════════════════════════════ */
    (function () {
        var btn  = document.getElementById('themeBtn');
        var icon = document.getElementById('themeIcon');
        var root = document.documentElement;

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

        // Initialiser depuis localStorage (anti-flash déjà fait, juste sync icône)
        applyTheme(localStorage.getItem('theme') || 'dark');

        btn.addEventListener('click', function () {
            var current = localStorage.getItem('theme') || 'dark';
            var next = current === 'dark' ? 'light' : 'dark';
            localStorage.setItem('theme', next);
            applyTheme(next);
        });
    })();

    /* ═══════════════════════════════════════════════════
       2. TOAST SYSTEM
    ═══════════════════════════════════════════════════ */
    var ToastManager = (function () {
        var container = document.getElementById('toastContainer');
        var toasts    = {};

        var ICONS = {
            success: 'fa-check-circle',
            error:   'fa-times-circle',
            warning: 'fa-exclamation-triangle',
            info:    'fa-info-circle'
        };
        var TITLES = {
            success: 'Succès',
            error:   'Erreur',
            warning: 'Attention',
            info:    'Information'
        };

        function show(type, message, duration) {
            duration = duration || 5000;
            var id   = 'toast-' + Date.now() + '-' + Math.random().toString(36).slice(2,6);

            var el = document.createElement('div');
            el.className = 'toast toast-' + type;
            el.id = id;
            el.innerHTML =
                '<div class="toast-icon"><i class="fas ' + ICONS[type] + '"></i></div>' +
                '<div class="toast-content">' +
                '<div class="toast-title">' + TITLES[type] + '</div>' +
                '<div class="toast-message">' + message + '</div>' +
                '</div>' +
                '<div class="toast-close" onclick="ToastManager.close(\'' + id + '\')"><i class="fas fa-times"></i></div>' +
                '<div class="toast-progress"></div>';

            container.appendChild(el);

            var timer = setTimeout(function () { close(id); }, duration);
            toasts[id] = { el: el, timer: timer };
        }

        function close(id) {
            var data = toasts[id];
            if (!data) return;
            clearTimeout(data.timer);
            data.el.classList.add('toast-hiding');
            setTimeout(function () {
                if (data.el.parentNode) data.el.remove();
                delete toasts[id];
            }, 300);
        }

        return {
            show:    show,
            close:   close,
            success: function (msg) { show('success', msg); },
            error:   function (msg) { show('error',   msg); },
            warning: function (msg) { show('warning', msg); },
            info:    function (msg) { show('info',    msg); }
        };
    })();

    /* ── Affichage des messages flash JSP ── */
    <% if (successMessage != null && !successMessage.isEmpty()) { %>
    ToastManager.success('<%= successMessage.replace("'", "\\'").replace("\n", " ") %>');
    <% } %>
    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    ToastManager.error('<%= errorMessage.replace("'", "\\'").replace("\n", " ") %>');
    <% } %>
    <% if (warningMessage != null && !warningMessage.isEmpty()) { %>
    ToastManager.warning('<%= warningMessage.replace("'", "\\'").replace("\n", " ") %>');
    <% } %>
    <% if (infoMessage != null && !infoMessage.isEmpty()) { %>
    ToastManager.info('<%= infoMessage.replace("'", "\\'").replace("\n", " ") %>');
    <% } %>

    /* ═══════════════════════════════════════════════════
       3. PANNEAU SUCCÈS — compte à rebours
    ═══════════════════════════════════════════════════ */
    <% if (isAddSuccess) { %>
    (function () {
        var count = 3;
        var numEl = document.getElementById('countdownNum');
        var iv = setInterval(function () {
            count--;
            if (numEl) numEl.textContent = count;
            if (count <= 0) {
                clearInterval(iv);
                window.location.href = '<%= request.getContextPath() %>/voiture/';
            }
        }, 1000);
    })();

    function closeSuccessPanel() {
        var overlay = document.getElementById('overlay');
        var panel   = document.getElementById('successPanel');
        if (panel) {
            panel.classList.add('fade-out');
            if (overlay) overlay.classList.add('fade-out');
            setTimeout(function () {
                if (panel.parentNode) panel.remove();
                if (overlay && overlay.parentNode) overlay.remove();
                window.location.href = '<%= request.getContextPath() %>/voiture/';
            }, 300);
        }
    }
    <% } %>

    /* ═══════════════════════════════════════════════════
       4. FORMULAIRE — validation + preview
    ═══════════════════════════════════════════════════ */
    (function () {
        var form         = document.getElementById('voitureForm');
        var designInput  = document.getElementById('design');
        var typeSelect   = document.getElementById('type');
        var placesInput  = document.getElementById('nbrplace');
        var fraisInput   = document.getElementById('frais');
        var submitBtn    = document.getElementById('submitBtn');
        var loadSpinner  = document.getElementById('loadingSpinner');
        var btnText      = document.getElementById('btnText');
        var previewCard  = document.getElementById('previewCard');

        /* Validation */
        function validateDesign() {
            var val = designInput.value.trim();
            var err = document.getElementById('designError');
            if (!val) { designInput.classList.add('input-error'); err.classList.remove('hidden'); return false; }
            designInput.classList.remove('input-error'); err.classList.add('hidden'); return true;
        }
        function validatePlaces() {
            var val = parseInt(placesInput.value);
            var err = document.getElementById('placesError');
            if (isNaN(val) || val < 1 || val > 50) { placesInput.classList.add('input-error'); err.classList.remove('hidden'); return false; }
            placesInput.classList.remove('input-error'); err.classList.add('hidden'); return true;
        }
        function validateFrais() {
            var val = parseInt(fraisInput.value);
            var err = document.getElementById('fraisError');
            if (isNaN(val) || val < 0) { fraisInput.classList.add('input-error'); err.classList.remove('hidden'); return false; }
            fraisInput.classList.remove('input-error'); err.classList.add('hidden'); return true;
        }

        /* Preview */
        function updatePreview() {
            var design = designInput.value.trim();
            var type   = typeSelect   ? typeSelect.value   : 'simple';
            var places = placesInput  ? placesInput.value  : '';
            var frais  = fraisInput   ? fraisInput.value   : '';

            if (design || places || frais) {
                previewCard.classList.add('show');
                document.getElementById('previewName').textContent   = design  || 'Désignation';
                document.getElementById('previewPlaces').textContent = (places || '0') + ' places';
                document.getElementById('previewFrais').textContent  = (frais  ? parseInt(frais).toLocaleString() : '0') + ' Ar';

                var typeMap = { simple: ['🚗 Simple','fa-car'], premium: ['⭐ Premium','fa-star'], VIP: ['👑 VIP','fa-crown'] };
                var tm = typeMap[type] || typeMap['simple'];
                document.getElementById('previewType').textContent = tm[0];
                document.getElementById('previewIcon').innerHTML   = '<i class="fas ' + tm[1] + '"></i>';
            } else {
                previewCard.classList.remove('show');
            }
        }

        /* Listeners */
        designInput.addEventListener('input',  function () { validateDesign(); updatePreview(); });
        placesInput.addEventListener('input',  function () { validatePlaces(); updatePreview(); });
        fraisInput.addEventListener('input',   function () { validateFrais();  updatePreview(); });
        if (typeSelect) typeSelect.addEventListener('change', updatePreview);

        /* Soumission */
        form.addEventListener('submit', function (e) {
            var ok = validateDesign() & validatePlaces() & validateFrais();

            <% if (!isEdit) { %>
            var idInput = document.getElementById('idvoit');
            if (idInput && !idInput.value.trim()) {
                idInput.classList.add('input-error');
                document.getElementById('idError').classList.remove('hidden');
                ok = false;
            }
            <% } %>

            if (!ok) {
                e.preventDefault();
                ToastManager.warning('Veuillez corriger les erreurs avant de soumettre.');
                return;
            }

            /* Feedback de chargement */
            submitBtn.disabled = true;
            loadSpinner.classList.remove('hidden');
            btnText.textContent = 'En cours…';
            ToastManager.info('<%= isEdit ? "Mise à jour en cours…" : "Enregistrement en cours…" %>');
        });

        /* Init preview en mode édition */
        <% if (isEdit) { %>
        setTimeout(updatePreview, 100);
        <% } %>
    })();
</script>
</body>
</html>
