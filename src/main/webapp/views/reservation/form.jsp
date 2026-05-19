<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cooperative.model.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>
    <title><%= request.getAttribute("reservation") == null ? "Nouvelle" : "Modifier" %> Réservation | Coopérative</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

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

            --radius-sm:  0.375rem;
            --radius-md:  0.5rem;
            --radius-lg:  0.75rem;
            --radius-xl:  1rem;
            --radius-2xl: 1.25rem;

            --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.6);
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

            --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.14);
        }

        body {
            background: var(--bg-deep);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 0.875rem;
            line-height: 1.5;
            color: var(--text-primary);
            min-height: 100vh;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .app-container { display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: 280px;
            background: var(--bg-primary);
            border-right: 1px solid var(--border);
            position: fixed; left: 0; top: 0; bottom: 0; z-index: 40;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }
        .logo { display: flex; align-items: center; gap: 0.75rem; }
        .logo-icon {
            width: 2.25rem; height: 2.25rem;
            background: linear-gradient(135deg, var(--navy-400), var(--navy-600));
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
        }
        .logo-icon i { font-size: 1.25rem; color: white; }
        .logo-text h2 { font-size: 1.125rem; font-weight: 600; color: var(--text-primary); }
        .logo-text p  { font-size: 0.7rem; color: var(--text-muted); }
        .nav-menu { padding: 1.5rem; display: flex; flex-direction: column; gap: 0.5rem; }
        .nav-item {
            display: flex; align-items: center; gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: var(--radius-lg);
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.2s;
        }
        .nav-item i { width: 1.25rem; font-size: 1rem; }
        .nav-item:hover { background: var(--bg-hover); color: var(--text-primary); }
        .nav-item.active { background: var(--bg-card); color: var(--navy-300); border-left: 3px solid var(--navy-400); }

        /* ── Main ── */
        .main-content { flex: 1; margin-left: 280px; padding: 1.5rem; }

        /* ── Top bar ── */
        .top-bar {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }
        .page-title h1 { font-size: 1.5rem; font-weight: 600; color: var(--text-primary); }
        .page-title p  { font-size: 0.75rem; color: var(--text-muted); margin-top: 0.25rem; }

        .top-right { display: flex; align-items: center; gap: 0.75rem; }

        /* ── Bouton toggle thème ── */
        .theme-btn {
            width: 2.5rem; height: 2.5rem;
            border-radius: var(--radius-lg);
            background: var(--bg-card);
            border: 1px solid var(--border);
            color: var(--text-muted);
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }
        .theme-btn:hover {
            background: var(--bg-hover);
            color: var(--text-primary);
            border-color: var(--navy-500);
        }

        .user-avatar {
            width: 2.5rem; height: 2.5rem;
            background: linear-gradient(135deg, var(--navy-500), var(--navy-600));
            border-radius: var(--radius-lg);
            display: flex; align-items: center; justify-content: center;
            font-weight: 600; color: white;
        }

        /* ── Form container ── */
        .form-container {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            padding: 2rem;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .form-row      { display: grid; grid-template-columns: repeat(2,1fr); gap: 1.5rem; margin-bottom: 1.5rem; }
        .form-row-full { margin-bottom: 1.5rem; }
        .form-group    { display: flex; flex-direction: column; gap: 0.5rem; }
        .form-group label {
            font-size: 0.75rem; font-weight: 500;
            text-transform: uppercase; letter-spacing: 0.05em;
            color: var(--text-muted);
        }
        .form-group select,
        .form-group input {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
            color: var(--text-primary);
            transition: all 0.2s;
            width: 100%;
        }
        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: var(--navy-400);
            box-shadow: 0 0 0 3px rgba(74,109,158,0.2);
        }
        .form-group select option { background: var(--bg-secondary); color: var(--text-primary); }

        /* Mode clair : fond blanc pour inputs */
        [data-theme="light"] .form-group select,
        [data-theme="light"] .form-group input {
            background: #ffffff;
        }

        /* ── Date picker ── */
        .date-picker-wrapper { position: relative; }
        .date-display {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 0.75rem 1rem;
            cursor: pointer;
            display: flex; align-items: center; justify-content: space-between;
            transition: all 0.2s;
            user-select: none;
        }
        [data-theme="light"] .date-display { background: #ffffff; }
        .date-display:hover,
        .date-display.open { border-color: var(--navy-400); box-shadow: 0 0 0 3px rgba(74,109,158,0.2); }
        .date-display span         { color: var(--text-primary); }
        .date-display span.placeholder { color: var(--text-muted); }
        .date-display i            { color: var(--navy-300); }

        .calendar-dropdown {
            position: absolute; top: calc(100% + 8px); left: 0; z-index: 100;
            background: var(--bg-card);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-xl);
            padding: 1rem; width: 320px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            display: none;
            transition: background 0.3s ease;
        }
        .calendar-dropdown.open { display: block; animation: fadeInDown 0.2s ease; }

        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .cal-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; }
        .cal-nav {
            background: var(--bg-hover); border: none; color: var(--text-primary);
            width: 2rem; height: 2rem; border-radius: var(--radius-md);
            cursor: pointer; display: flex; align-items: center; justify-content: center;
            transition: background 0.2s;
        }
        .cal-nav:hover { background: var(--navy-500); }
        .cal-month-year { font-weight: 600; font-size: 0.9rem; color: var(--text-primary); }

        .cal-days-header { display: grid; grid-template-columns: repeat(7,1fr); text-align: center; margin-bottom: 0.5rem; }
        .cal-days-header span { font-size: 0.65rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; padding: 0.25rem 0; }

        .cal-days { display: grid; grid-template-columns: repeat(7,1fr); gap: 2px; }
        .cal-day {
            aspect-ratio: 1; display: flex; align-items: center; justify-content: center;
            border-radius: var(--radius-md); cursor: pointer; font-size: 0.8rem;
            position: relative; transition: all 0.15s;
            border: none; background: transparent; color: var(--text-primary);
        }
        .cal-day:hover:not(.empty):not(.past) { background: var(--bg-hover); }
        .cal-day.empty { cursor: default; }
        .cal-day.past  { color: var(--text-muted); cursor: not-allowed; opacity: 0.4; }
        .cal-day.selected { background: var(--navy-500) !important; color: white !important; font-weight: 600; }
        .cal-day.today    { border: 1px solid var(--navy-400); color: var(--navy-300); font-weight: 600; }
        .cal-day .dot     { position: absolute; bottom: 3px; width: 4px; height: 4px; border-radius: 50%; }
        .cal-day.full .dot    { background: var(--error); }
        .cal-day.partial .dot { background: var(--warning); }
        .cal-day.free .dot    { background: var(--success); }

        .cal-legend {
            display: flex; gap: 0.75rem; margin-top: 0.75rem; padding-top: 0.75rem;
            border-top: 1px solid var(--border); justify-content: center;
        }
        .legend-item { display: flex; align-items: center; gap: 0.3rem; font-size: 0.65rem; color: var(--text-muted); }
        .legend-dot  { width: 6px; height: 6px; border-radius: 50%; }

        /* ── Nb places ── */
        .nb-places-selector { display: flex; align-items: center; gap: 0.75rem; }
        .nb-places-btn {
            background: var(--bg-hover); border: 1px solid var(--border);
            color: var(--text-primary); width: 2rem; height: 2rem;
            border-radius: var(--radius-md); cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem; transition: all 0.2s;
        }
        .nb-places-btn:hover { background: var(--navy-500); border-color: var(--navy-400); }
        .nb-places-value { min-width: 2rem; text-align: center; font-size: 1.1rem; font-weight: 700; color: var(--navy-300); }
        .nb-places-label { font-size: 0.75rem; color: var(--text-muted); }

        /* ── Places grid ── */
        .places-grid { display: grid; grid-template-columns: repeat(5,1fr); gap: 0.5rem; margin-top: 0.25rem; }
        .place-btn {
            background: var(--bg-secondary); border: 1px solid var(--border);
            border-radius: var(--radius-md); color: var(--text-primary);
            padding: 0.5rem 0.25rem; font-size: 0.75rem; cursor: pointer;
            transition: all 0.2s; text-align: center; user-select: none;
        }
        [data-theme="light"] .place-btn { background: #f0f4f8; }
        .place-btn:hover { background: var(--navy-500); border-color: var(--navy-400); color: white; }
        .place-btn.selected {
            background: var(--navy-500); border-color: var(--navy-300);
            color: white; font-weight: 600;
            box-shadow: 0 0 0 2px rgba(90,127,176,0.4);
        }
        .place-btn.disabled {
            background: var(--bg-deep); border-color: var(--border);
            color: var(--text-muted); cursor: not-allowed; opacity: 0.5;
        }
        .places-empty {
            color: var(--error); font-size: 0.8rem; padding: 0.75rem;
            text-align: center;
            background: rgba(239,68,68,0.1);
            border-radius: var(--radius-md);
            border: 1px solid rgba(239,68,68,0.2);
        }
        .places-loading { color: var(--text-muted); font-size: 0.8rem; padding: 0.75rem; text-align: center; }
        .places-counter { margin-top: 0.5rem; font-size: 0.75rem; color: var(--text-muted); }
        .places-counter strong { color: var(--success); }

        /* ── Boutons ── */
        .btn {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.625rem 1.25rem;
            font-size: 0.8125rem; font-weight: 500;
            border-radius: var(--radius-md); cursor: pointer;
            transition: all 0.2s; border: 1px solid transparent; text-decoration: none;
        }
        .btn-success { background: var(--success); color: white; }
        .btn-success:hover { background: #0d9668; transform: translateY(-1px); }
        .btn-secondary { background: transparent; border-color: var(--border); color: var(--text-secondary); }
        .btn-secondary:hover { background: var(--bg-hover); border-color: var(--navy-500); color: var(--text-primary); }

        .form-actions {
            display: flex; justify-content: flex-end; gap: 1rem;
            margin-top: 2rem; padding-top: 1rem;
            border-top: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }

        /* ── Recap paiement ── */
        #paiement_recap {
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        /* ══════════════════════════════════════════════
           TOAST SYSTEM
        ══════════════════════════════════════════════ */
        .toast-container {
            position: fixed; top: 1.5rem; right: 1.5rem;
            z-index: 9999;
            display: flex; flex-direction: column; gap: 0.75rem;
            max-width: 420px; width: 100%;
            pointer-events: none;
        }
        .toast {
            position: relative; overflow: hidden;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1rem 2.75rem 1rem 1.25rem;
            box-shadow: var(--shadow-xl), 0 0 0 1px rgba(255,255,255,0.04);
            display: flex; align-items: flex-start; gap: 0.875rem;
            pointer-events: auto;
            animation: toastSlideIn 0.38s cubic-bezier(0.34,1.56,0.64,1) both;
            transition: background 0.3s ease;
        }
        .toast.toast-hiding { animation: toastSlideOut 0.28s ease-in forwards; }
        .toast-success { border-left: 4px solid var(--success); }
        .toast-error   { border-left: 4px solid var(--error); }
        .toast-warning { border-left: 4px solid var(--warning); }
        .toast-info    { border-left: 4px solid var(--info); }

        .toast-icon {
            flex-shrink: 0; width: 2rem; height: 2rem;
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.9rem;
        }
        .toast-success .toast-icon { background: rgba(16,185,129,0.15); color: var(--success); }
        .toast-error   .toast-icon { background: rgba(239,68,68,0.15);  color: var(--error); }
        .toast-warning .toast-icon { background: rgba(245,158,11,0.15); color: var(--warning); }
        .toast-info    .toast-icon { background: rgba(59,130,246,0.15); color: var(--info); }

        .toast-body { flex: 1; min-width: 0; }
        .toast-title { font-weight: 600; font-size: 0.8125rem; line-height: 1.3; margin-bottom: 0.2rem; color: var(--text-primary); }
        .toast-msg   { font-size: 0.775rem; color: var(--text-secondary); line-height: 1.45; }

        .toast-close {
            position: absolute; top: 0.625rem; right: 0.625rem;
            background: none; border: none; color: var(--text-muted); cursor: pointer;
            padding: 0.25rem; border-radius: var(--radius-sm);
            font-size: 0.75rem; line-height: 1; transition: color 0.15s, background 0.15s;
            display: flex; align-items: center; justify-content: center;
        }
        .toast-close:hover { color: var(--text-primary); background: var(--bg-hover); }

        .toast-progress {
            position: absolute; bottom: 0; left: 0;
            height: 3px; border-radius: 0 0 0 var(--radius-lg);
            animation: toastProgress linear forwards;
        }
        .toast-success .toast-progress { background: var(--success); }
        .toast-error   .toast-progress { background: var(--error); }
        .toast-warning .toast-progress { background: var(--warning); }
        .toast-info    .toast-progress { background: var(--info); }

        @keyframes toastSlideIn  { from{opacity:0;transform:translateX(110%)} to{opacity:1;transform:translateX(0)} }
        @keyframes toastSlideOut { from{opacity:1;transform:translateX(0);max-height:120px} to{opacity:0;transform:translateX(110%);max-height:0;padding-top:0;padding-bottom:0;border-width:0} }
        @keyframes toastProgress { from{width:100%} to{width:0%} }
        @keyframes fadeInUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
        .animate-in { animation: fadeInUp 0.4s ease-out; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; }
            .form-row { grid-template-columns: 1fr; }
            .calendar-dropdown { width: 280px; }
            .toast-container { left: 1rem; right: 1rem; max-width: none; }
        }
    </style>
</head>
<body>
<%
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    List<Voiture> voitures  = (List<Voiture>) request.getAttribute("voitures");
    List<Client>  clients   = (List<Client>)  request.getAttribute("clients");
    boolean isEdit = (reservation != null);
    String action  = isEdit ? "update" : "save";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String existingDate   = isEdit ? sdf.format(reservation.getDateVoyage()) : "";
    String existingPlaces = isEdit ? reservation.getPlaces() : "";
    int existingNb        = isEdit ? reservation.getNombrePlaces() : 1;

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage   = (String) session.getAttribute("errorMessage");
    String warningMessage = (String) session.getAttribute("warningMessage");
    String infoMessage    = (String) session.getAttribute("infoMessage");
    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage   != null) session.removeAttribute("errorMessage");
    if (warningMessage != null) session.removeAttribute("warningMessage");
    if (infoMessage    != null) session.removeAttribute("infoMessage");
%>

<!-- Conteneur des toasts -->
<div class="toast-container" id="toastContainer"></div>

<div class="app-container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon"><i class="fas fa-handshake"></i></div>
                <div class="logo-text"><h2>Coopérative</h2><p>Gestion Client</p></div>
            </div>
        </div>
        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/"            class="nav-item"><i class="fas fa-home"></i><span>Accueil</span></a>
            <a href="<%= request.getContextPath() %>/client/"     class="nav-item"><i class="fas fa-users"></i><span>Clients</span></a>
            <a href="<%= request.getContextPath() %>/reservation/" class="nav-item active"><i class="fas fa-ticket-alt"></i><span>Réservations</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="top-bar">
            <div class="page-title">
                <h1><%= isEdit ? "✏️ Modifier la Réservation" : "📝 Nouvelle Réservation" %></h1>
                <p><%= isEdit ? "Modifiez les informations de la réservation" : "Créez une nouvelle réservation" %></p>
            </div>
            <div class="top-right">
                <!-- Bouton toggle thème -->
                <button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
                    <i class="fas fa-moon" id="themeIcon"></i>
                </button>
                <div class="user-avatar"><i class="fas fa-user"></i></div>
            </div>
        </div>

        <div class="form-container animate-in">
            <form action="<%= request.getContextPath() %>/reservation/<%= action %>" method="post" id="reservForm">
                <% if (isEdit) { %>
                <input type="hidden" name="idreserv" value="<%= reservation.getIdreserv() %>">
                <% } %>
                <input type="hidden" id="date_voyage"   name="date_voyage" value="<%= existingDate %>">
                <input type="hidden" id="placesHidden"  name="places"      value="">

                <div class="form-row">
                    <div class="form-group">
                        <label><i class="fas fa-user"></i> Client</label>
                        <select id="idcli" name="idcli" required>
                            <option value="">-- Choisir un client --</option>
                            <% if (clients != null) for (Client c : clients) {
                                boolean sel = isEdit && reservation.getIdcli() == c.getIdcli(); %>
                            <option value="<%= c.getIdcli() %>" <%= sel ? "selected" : "" %>><%= c.getNom() %> - <%= c.getNumtel() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-calendar-alt"></i> Date du voyage</label>
                        <div class="date-picker-wrapper">
                            <div class="date-display" id="dateDisplay" onclick="toggleCalendar()">
                                <span id="dateDisplayText" class="placeholder">-- Choisir une date --</span>
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div class="calendar-dropdown" id="calendarDropdown">
                                <div class="cal-header">
                                    <button type="button" class="cal-nav" onclick="changeMonth(-1)"><i class="fas fa-chevron-left"></i></button>
                                    <span class="cal-month-year" id="calMonthYear"></span>
                                    <button type="button" class="cal-nav" onclick="changeMonth(1)"><i class="fas fa-chevron-right"></i></button>
                                </div>
                                <div class="cal-days-header">
                                    <span>Lun</span><span>Mar</span><span>Mer</span><span>Jeu</span><span>Ven</span><span>Sam</span><span>Dim</span>
                                </div>
                                <div class="cal-days" id="calDays"></div>
                                <div class="cal-legend">
                                    <div class="legend-item"><div class="legend-dot" style="background:var(--success)"></div> Libre</div>
                                    <div class="legend-item"><div class="legend-dot" style="background:var(--warning)"></div> Partiel</div>
                                    <div class="legend-item"><div class="legend-dot" style="background:var(--error)"></div> Complet</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label><i class="fas fa-bus"></i> Voiture</label>
                        <select id="idvoit" name="idvoit" onchange="onVoitureChange()" required>
                            <option value="">-- Choisir une voiture --</option>
                            <% if (voitures != null) for (Voiture v : voitures) {
                                boolean sel = isEdit && reservation.getIdvoit().equals(v.getIdvoit()); %>
                            <option value="<%= v.getIdvoit() %>"
                                    data-frais="<%= v.getFrais() %>"
                                    data-nbrplace="<%= v.getNbrplace() %>"
                                    <%= sel ? "selected" : "" %>>
                                <%= v.getDesign() %> - <%= String.format("%,d", v.getFrais()) %> Ar/place
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-hashtag"></i> Nombre de places</label>
                        <div class="nb-places-selector">
                            <button type="button" class="nb-places-btn" onclick="changeNbPlaces(-1)">−</button>
                            <span class="nb-places-value" id="nbPlacesDisplay"><%= existingNb %></span>
                            <button type="button" class="nb-places-btn" onclick="changeNbPlaces(1)">+</button>
                            <span class="nb-places-label">place(s)</span>
                        </div>
                    </div>
                </div>

                <div class="form-row-full">
                    <div class="form-group">
                        <label><i class="fas fa-chair"></i> Places disponibles</label>
                        <div id="placesContainer">
                            <div class="places-loading"><i class="fas fa-spinner fa-spin"></i> Chargement...</div>
                        </div>
                        <div class="places-counter" id="placesCounter" style="display:none">
                            Places sélectionnées : <strong id="selectedCount">0</strong> / <span id="maxCount"><%= existingNb %></span>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label><i class="fas fa-credit-card"></i> Mode de paiement</label>
                        <select id="payment" name="payment" onchange="toggleMontantAvance()" required>
                            <option value="sans avance" <%= isEdit && "sans avance".equals(reservation.getPayment()) ? "selected" : "" %>>Sans avance</option>
                            <option value="avec avance" <%= isEdit && "avec avance".equals(reservation.getPayment()) ? "selected" : "" %>>Avec avance</option>
                            <option value="tout payé"   <%= isEdit && "tout payé".equals(reservation.getPayment())   ? "selected" : "" %>>Tout payé</option>
                        </select>
                    </div>

                    <div class="form-group" id="montant_avance_div" style="display:none;">
                        <label><i class="fas fa-money-bill"></i> Montant avance (Ar)</label>
                        <select id="montant_avance_select" onchange="onAvanceChange()">
                            <option value="10000">10 000 Ar</option>
                            <option value="20000">20 000 Ar</option>
                            <option value="30000" selected>30 000 Ar</option>
                            <option value="40000">40 000 Ar</option>
                        </select>
                        <input type="hidden" id="montant_avance" name="montant_avance"
                               value="<%= isEdit ? reservation.getMontantAvance() : "0" %>">
                    </div>
                </div>

                <div id="paiement_recap" style="display:none;margin-bottom:1.5rem;padding:1rem;background:var(--bg-secondary);border-radius:var(--radius-lg);border:1px solid var(--border);">
                    <p style="font-weight:600;margin-bottom:.75rem;color:var(--navy-300);"><i class="fas fa-calculator"></i> Récapitulatif du paiement</p>
                    <div style="display:flex;flex-direction:column;gap:.4rem;">
                        <div style="display:flex;justify-content:space-between;"><span>Frais unitaire :</span><strong id="recap_frais">–</strong></div>
                        <div style="display:flex;justify-content:space-between;"><span>Nombre de places :</span><strong id="recap_nb_places">–</strong></div>
                        <div style="display:flex;justify-content:space-between;border-top:1px solid var(--border);padding-top:.4rem;"><span>Total :</span><strong id="recap_total_frais" style="color:var(--navy-300);">–</strong></div>
                        <div id="recap_avance_row" style="display:none;justify-content:space-between;"><span>Avance versée :</span><strong id="recap_avance" style="color:var(--warning);">–</strong></div>
                        <div id="recap_reste_row"  style="display:none;justify-content:space-between;"><span>Reste à payer :</span><strong id="recap_reste" style="color:var(--error);">–</strong></div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-success" onclick="return validateForm()">
                        <i class="fas fa-save"></i> Enregistrer
                    </button>
                    <a href="<%= request.getContextPath() %>/reservation/" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    /* ================================================================
       1. TOGGLE THÈME
    ================================================================ */
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

        // Synchroniser l'icône (l'attribut data-theme est déjà positionné par le script anti-flash)
        applyTheme(localStorage.getItem('theme') || 'dark');

        btn.addEventListener('click', function () {
            var current = localStorage.getItem('theme') || 'dark';
            var next = current === 'dark' ? 'light' : 'dark';
            localStorage.setItem('theme', next);
            applyTheme(next);
        });
    })();

    /* ================================================================
       2. TOAST MANAGER
    ================================================================ */
    const TOAST_ICONS = {
        success: 'fas fa-check',
        error:   'fas fa-times-circle',
        warning: 'fas fa-exclamation-triangle',
        info:    'fas fa-info-circle'
    };
    const TOAST_TITLES = {
        success: 'Succès',
        error:   'Erreur',
        warning: 'Attention',
        info:    'Information'
    };

    class ToastManager {
        constructor() { this.container = document.getElementById('toastContainer'); }

        _show(type, message, title, duration) {
            duration = duration || 4500;
            title    = title    || TOAST_TITLES[type];
            const toast = document.createElement('div');
            toast.className = 'toast toast-' + type;
            toast.innerHTML =
                '<div class="toast-icon"><i class="' + TOAST_ICONS[type] + '"></i></div>' +
                '<div class="toast-body">' +
                '<div class="toast-title">' + this._escape(title)   + '</div>' +
                '<div class="toast-msg">'   + this._escape(message) + '</div>' +
                '</div>' +
                '<button class="toast-close" onclick="toastManager._dismiss(this.parentElement)" title="Fermer"><i class="fas fa-times"></i></button>' +
                '<div class="toast-progress" style="animation-duration:' + duration + 'ms"></div>';
            this.container.appendChild(toast);
            setTimeout(() => this._dismiss(toast), duration);
            return toast;
        }

        _dismiss(toast) {
            if (!toast || toast.classList.contains('toast-hiding')) return;
            toast.classList.add('toast-hiding');
            setTimeout(() => { if (toast.parentElement) toast.parentElement.removeChild(toast); }, 300);
        }

        _escape(str) {
            const d = document.createElement('div');
            d.appendChild(document.createTextNode(str));
            return d.innerHTML;
        }

        success(message, title, duration) { return this._show('success', message, title, duration); }
        error(message,   title, duration) { return this._show('error',   message, title, duration); }
        warning(message, title, duration) { return this._show('warning', message, title, duration); }
        info(message,    title, duration) { return this._show('info',    message, title, duration); }
    }

    const toastManager = new ToastManager();

    /* ================================================================
       3. MESSAGES FLASH depuis la session Java
    ================================================================ */
    const _sessionSuccess = '<%= successMessage != null ? successMessage.replace("'", "\\'") : "" %>';
    const _sessionError   = '<%= errorMessage   != null ? errorMessage.replace("'", "\\'")   : "" %>';
    const _sessionWarning = '<%= warningMessage != null ? warningMessage.replace("'", "\\'") : "" %>';
    const _sessionInfo    = '<%= infoMessage    != null ? infoMessage.replace("'", "\\'")    : "" %>';

    /* ================================================================
       4. VARIABLES GLOBALES
    ================================================================ */
    const contextPath      = '<%= request.getContextPath() %>';
    const isEdit           = <%= isEdit %>;
    const editPlacesArray  = isEdit
        ? '<%= existingPlaces %>'.split(',').map(p => parseInt(p.trim())).filter(p => !isNaN(p))
        : [];

    let selectedPlaces     = [];
    let maxPlaces          = <%= existingNb %>;
    let allAvailablePlaces = [];

    /* ================================================================
       5. PLACES
    ================================================================ */
    function updatePlacesHidden() {
        document.getElementById('placesHidden').value = JSON.stringify(selectedPlaces);
    }

    function updatePlacesCounter() {
        const counter = document.getElementById('placesCounter');
        counter.style.display = 'block';
        document.getElementById('selectedCount').textContent = selectedPlaces.length;
        document.getElementById('maxCount').textContent      = maxPlaces;
    }

    function refreshButtons() {
        document.querySelectorAll('.place-btn').forEach(btn => {
            const num        = parseInt(btn.getAttribute('data-num'));
            const isSelected = selectedPlaces.includes(num);
            const isBlocked  = btn.classList.contains('disabled-by-other');
            btn.classList.toggle('selected', isSelected);
            if (!isSelected && selectedPlaces.length >= maxPlaces && !isBlocked) {
                btn.classList.add('disabled');
            } else if (!isBlocked) {
                btn.classList.remove('disabled');
            }
        });
    }

    function togglePlace(num, btn) {
        if (btn.classList.contains('disabled-by-other')) {
            toastManager.warning('Cette place est déjà réservée par un autre client.');
            return;
        }
        const idx = selectedPlaces.indexOf(num);
        if (idx >= 0) {
            selectedPlaces.splice(idx, 1);
        } else {
            if (selectedPlaces.length >= maxPlaces) {
                maxPlaces = selectedPlaces.length + 1;
                document.getElementById('nbPlacesDisplay').textContent = maxPlaces;
            }
            selectedPlaces.push(num);
        }
        selectedPlaces.sort((a, b) => a - b);
        updatePlacesHidden();
        updatePlacesCounter();
        refreshButtons();
        updateRecap();
    }

    function changeNbPlaces(delta) {
        const sel    = document.getElementById('idvoit');
        const maxCap = sel.selectedIndex > 0
            ? parseInt(sel.options[sel.selectedIndex].getAttribute('data-nbrplace') || '99')
            : 99;
        let newVal = maxPlaces + delta;
        if (newVal < 1) newVal = 1;
        if (newVal > maxCap) {
            toastManager.warning('Maximum ' + maxCap + ' places disponibles pour ce véhicule.');
            return;
        }
        if (delta < 0 && newVal < selectedPlaces.length) {
            toastManager.warning('Vous avez déjà ' + selectedPlaces.length + ' place(s) sélectionnée(s). Désélectionnez d\'abord.');
            return;
        }
        maxPlaces = newVal;
        document.getElementById('nbPlacesDisplay').textContent = maxPlaces;
        refreshButtons();
        updateRecap();
    }

    function loadPlaces() {
        const idvoit  = document.getElementById('idvoit').value;
        const dateVal = document.getElementById('date_voyage').value;
        if (!idvoit || !dateVal) return;

        const container = document.getElementById('placesContainer');
        container.innerHTML = '<div class="places-loading"><i class="fas fa-spinner fa-spin"></i> Chargement des places…</div>';

        fetch(contextPath + '/reservation/getPlaces?idvoit=' + encodeURIComponent(idvoit) + '&date_voyage=' + encodeURIComponent(dateVal))
            .then(r => r.json())
            .then(freePlaces => {
                let displayPlaces = [...freePlaces];
                if (isEdit && editPlacesArray.length > 0) {
                    editPlacesArray.forEach(p => { if (!displayPlaces.includes(p)) displayPlaces.push(p); });
                    displayPlaces.sort((a, b) => a - b);
                }
                allAvailablePlaces = displayPlaces;
                container.innerHTML = '';

                if (displayPlaces.length === 0) {
                    container.innerHTML = '<div class="places-empty"><i class="fas fa-ban"></i> Aucune place disponible pour cette date.</div>';
                    toastManager.info('Aucune place disponible pour la date sélectionnée.');
                    return;
                }

                const grid = document.createElement('div');
                grid.className = 'places-grid';

                displayPlaces.forEach(p => {
                    const btn = document.createElement('div');
                    btn.className = 'place-btn';
                    btn.setAttribute('data-num', p);
                    btn.textContent = 'N°' + p;

                    const isMyPlace = isEdit && editPlacesArray.includes(p);
                    const isFree    = freePlaces.includes(p);

                    if (!isFree && !isMyPlace) {
                        btn.classList.add('disabled', 'disabled-by-other');
                        btn.title = 'Réservée par un autre client';
                    } else {
                        btn.onclick = () => togglePlace(p, btn);
                    }
                    grid.appendChild(btn);
                });
                container.appendChild(grid);

                if (isEdit && editPlacesArray.length > 0) {
                    selectedPlaces = [...editPlacesArray];
                    maxPlaces = selectedPlaces.length;
                    document.getElementById('nbPlacesDisplay').textContent = maxPlaces;
                    updatePlacesHidden();
                    updatePlacesCounter();
                    refreshButtons();
                }
                updateRecap();
            })
            .catch(() => {
                container.innerHTML = '<div class="places-empty"><i class="fas fa-exclamation-triangle"></i> Erreur lors du chargement des places.</div>';
                toastManager.error('Impossible de charger les places disponibles. Veuillez réessayer.');
            });
    }

    /* ================================================================
       6. CALENDRIER
    ================================================================ */
    let currentDate     = new Date();
    let selectedDate    = '<%= existingDate %>' || null;
    let calendarOpen    = false;
    let occupationCache = {};

    if (selectedDate) {
        const parts = selectedDate.split('-');
        const d = new Date(parts[0], parts[1] - 1, parts[2]);
        document.getElementById('dateDisplayText').textContent = formatDateFr(d);
        document.getElementById('dateDisplayText').classList.remove('placeholder');
        currentDate = new Date(parts[0], parts[1] - 1, 1);
    }

    function toggleCalendar() {
        calendarOpen = !calendarOpen;
        document.getElementById('calendarDropdown').classList.toggle('open', calendarOpen);
        document.getElementById('dateDisplay').classList.toggle('open', calendarOpen);
        if (calendarOpen) renderCalendar();
    }

    function changeMonth(dir) {
        currentDate.setMonth(currentDate.getMonth() + dir);
        renderCalendar();
    }

    function renderCalendar() {
        const year  = currentDate.getFullYear();
        const month = currentDate.getMonth();
        const today = new Date(); today.setHours(0,0,0,0);
        const monthNames = ['Janvier','Février','Mars','Avril','Mai','Juin','Juillet','Août','Septembre','Octobre','Novembre','Décembre'];
        document.getElementById('calMonthYear').textContent = monthNames[month] + ' ' + year;

        const firstDay    = new Date(year, month, 1);
        let   startOffset = firstDay.getDay() - 1;
        if (startOffset < 0) startOffset = 6;
        const daysInMonth = new Date(year, month + 1, 0).getDate();

        const container = document.getElementById('calDays');
        container.innerHTML = '';

        for (let i = 0; i < startOffset; i++) {
            const e = document.createElement('div');
            e.className = 'cal-day empty';
            container.appendChild(e);
        }

        const idvoit = document.getElementById('idvoit').value;
        for (let d = 1; d <= daysInMonth; d++) {
            const dayEl = document.createElement('button');
            dayEl.type  = 'button';
            dayEl.className = 'cal-day';
            dayEl.textContent = d;
            const dateObj = new Date(year, month, d); dateObj.setHours(0,0,0,0);
            const dateStr = formatDateISO(dateObj);

            if (dateObj < today) {
                dayEl.classList.add('past');
            } else {
                dayEl.onclick = () => selectCalendarDate(dateStr, dateObj);
                if (dateObj.getTime() === today.getTime()) dayEl.classList.add('today');
                if (dateStr === selectedDate) dayEl.classList.add('selected');
                if (idvoit && occupationCache[idvoit] && occupationCache[idvoit][dateStr] !== undefined) {
                    const dot = document.createElement('span');
                    dot.className = 'dot';
                    const occ = occupationCache[idvoit][dateStr];
                    if      (occ.libres === 0)         dayEl.classList.add('full');
                    else if (occ.libres < occ.total)   dayEl.classList.add('partial');
                    else                               dayEl.classList.add('free');
                    dayEl.appendChild(dot);
                }
            }
            container.appendChild(dayEl);
        }
    }

    function selectCalendarDate(dateStr, dateObj) {
        selectedDate = dateStr;
        document.getElementById('date_voyage').value = dateStr;
        document.getElementById('dateDisplayText').textContent = formatDateFr(dateObj);
        document.getElementById('dateDisplayText').classList.remove('placeholder');
        toggleCalendar();
        loadPlaces();
        renderCalendar();
    }

    document.addEventListener('click', function(e) {
        const wrapper = document.querySelector('.date-picker-wrapper');
        if (wrapper && !wrapper.contains(e.target) && calendarOpen) {
            calendarOpen = false;
            document.getElementById('calendarDropdown').classList.remove('open');
            document.getElementById('dateDisplay').classList.remove('open');
        }
    });

    function loadMonthOccupation(idvoit) {
        const year = currentDate.getFullYear(), month = currentDate.getMonth();
        const daysInMonth = new Date(year, month + 1, 0).getDate();
        const today = new Date(); today.setHours(0,0,0,0);
        if (!occupationCache[idvoit]) occupationCache[idvoit] = {};
        let pending = 0;
        for (let d = 1; d <= daysInMonth; d++) {
            const dateObj = new Date(year, month, d);
            if (dateObj < today) continue;
            const dateStr = formatDateISO(dateObj);
            if (occupationCache[idvoit][dateStr] !== undefined) continue;
            pending++;
            fetch(contextPath + '/reservation/getPlaces?idvoit=' + encodeURIComponent(idvoit) + '&date_voyage=' + encodeURIComponent(dateStr))
                .then(r => r.json())
                .then(places => {
                    occupationCache[idvoit][dateStr] = { libres: places.length, total: null };
                    pending--;
                    if (pending === 0) renderCalendar();
                })
                .catch(() => { pending--; });
        }
    }

    function onVoitureChange() {
        const idvoit = document.getElementById('idvoit').value;
        if (idvoit && selectedDate) loadPlaces();
        if (idvoit) loadMonthOccupation(idvoit);
        updateRecap();
    }

    /* ================================================================
       7. RÉCAPITULATIF PAIEMENT
    ================================================================ */
    function getFraisVoiture() {
        const sel = document.getElementById('idvoit');
        if (!sel || !sel.value) return 0;
        return parseInt(sel.options[sel.selectedIndex].getAttribute('data-frais') || '0', 10);
    }

    function formatAriary(val) { return val.toLocaleString('fr-FR') + ' Ar'; }

    function toggleMontantAvance() {
        const payment   = document.getElementById('payment').value;
        const avanceDiv = document.getElementById('montant_avance_div');
        avanceDiv.style.display = (payment === 'avec avance') ? 'block' : 'none';
        if (payment !== 'avec avance') {
            document.getElementById('montant_avance').value = '0';
        } else {
            const hid = document.getElementById('montant_avance');
            if (hid.value && hid.value !== '0') {
                document.getElementById('montant_avance_select').value = hid.value;
            }
        }
        updateRecap();
    }

    function onAvanceChange() {
        const val        = document.getElementById('montant_avance_select').value;
        const totalFrais = getFraisVoiture() * (selectedPlaces.length || maxPlaces);
        const avance     = parseInt(val || '0', 10);
        if (avance > totalFrais && totalFrais > 0) {
            toastManager.warning('L\'avance ne peut pas dépasser le total de ' + formatAriary(totalFrais) + '.');
            return;
        }
        document.getElementById('montant_avance').value = val || '0';
        updateRecap();
    }

    function updateRecap() {
        const payment    = document.getElementById('payment').value;
        const fraisUnit  = getFraisVoiture();
        const nbSel      = selectedPlaces.length > 0 ? selectedPlaces.length : maxPlaces;
        const totalFrais = fraisUnit * nbSel;
        const recapDiv   = document.getElementById('paiement_recap');

        if (!payment || fraisUnit === 0) { recapDiv.style.display = 'none'; return; }
        recapDiv.style.display = 'block';

        document.getElementById('recap_frais').textContent      = formatAriary(fraisUnit);
        document.getElementById('recap_nb_places').textContent  = nbSel + ' place(s)';
        document.getElementById('recap_total_frais').textContent = formatAriary(totalFrais);

        const avRow = document.getElementById('recap_avance_row');
        const reRow = document.getElementById('recap_reste_row');
        avRow.style.display = reRow.style.display = 'none';

        const oldPayeRow = document.getElementById('recap_paye_row');
        if (oldPayeRow) oldPayeRow.remove();

        if (payment === 'avec avance') {
            const avance = parseInt(document.getElementById('montant_avance').value || '0', 10);
            if (avance > 0) {
                avRow.style.display = reRow.style.display = 'flex';
                document.getElementById('recap_avance').textContent = formatAriary(avance);
                document.getElementById('recap_reste').textContent  = formatAriary(Math.max(0, totalFrais - avance));
            }
        } else if (payment === 'tout payé') {
            const row = document.createElement('div');
            row.id = 'recap_paye_row';
            row.style.cssText = 'display:flex;justify-content:space-between;border-top:1px solid var(--border);padding-top:.4rem;';
            row.innerHTML = '<span>Montant payé :</span><strong style="color:var(--success);">' + formatAriary(totalFrais) + '</strong>';
            recapDiv.querySelector('div').appendChild(row);
        }
    }

    /* ================================================================
       8. VALIDATION
    ================================================================ */
    function validateForm() {
        if (!document.getElementById('idcli').value) {
            toastManager.warning('Veuillez choisir un client avant de continuer.');
            return false;
        }
        if (!document.getElementById('idvoit').value) {
            toastManager.warning('Veuillez choisir une voiture avant de continuer.');
            return false;
        }
        if (!document.getElementById('date_voyage').value) {
            toastManager.warning('Veuillez choisir une date de voyage.');
            return false;
        }
        if (selectedPlaces.length === 0) {
            toastManager.warning('Veuillez sélectionner au moins une place.');
            return false;
        }
        if (selectedPlaces.length !== maxPlaces) {
            toastManager.warning('Vous devez sélectionner exactement ' + maxPlaces + ' place(s). Actuellement : ' + selectedPlaces.length + '.');
            return false;
        }
        if (document.getElementById('payment').value === 'avec avance') {
            const avance = parseInt(document.getElementById('montant_avance').value || '0', 10);
            if (!avance || avance <= 0) {
                toastManager.warning('Veuillez choisir un montant d\'avance.');
                return false;
            }
        }
        toastManager.info(isEdit ? 'Modification en cours…' : 'Enregistrement de la réservation…');
        return true;
    }

    /* ================================================================
       9. UTILITAIRES
    ================================================================ */
    function formatDateISO(d) {
        const y = d.getFullYear();
        const m = String(d.getMonth() + 1).padStart(2, '0');
        const j = String(d.getDate()).padStart(2, '0');
        return y + '-' + m + '-' + j;
    }

    function formatDateFr(d) {
        const days   = ['Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi'];
        const months = ['janvier','février','mars','avril','mai','juin','juillet','août','septembre','octobre','novembre','décembre'];
        return days[d.getDay()] + ' ' + d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear();
    }

    /* ================================================================
       10. INITIALISATION
    ================================================================ */
    window.addEventListener('load', function () {
        if (_sessionSuccess) toastManager.success(_sessionSuccess, 'Succès', 6000);
        if (_sessionError)   toastManager.error(_sessionError,   'Erreur',  7000);
        if (_sessionWarning) toastManager.warning(_sessionWarning, 'Attention', 6000);
        if (_sessionInfo)    toastManager.info(_sessionInfo,    'Information', 5000);

        if (!isEdit) {
            toastManager.info('Remplissez le formulaire pour créer une nouvelle réservation.', 'Nouvelle réservation', 4000);
        } else {
            toastManager.info('Vous modifiez une réservation existante.', 'Mode édition', 4000);
        }

        if (selectedDate && document.getElementById('idvoit').value) {
            loadPlaces();
        } else if (document.getElementById('idvoit').value && !selectedDate) {
            document.getElementById('placesContainer').innerHTML =
                '<div class="places-empty"><i class="fas fa-calendar"></i> Choisissez une date d\'abord.</div>';
        }

        toggleMontantAvance();
        onAvanceChange();
        updateRecap();
    });
</script>
</body>
</html>
