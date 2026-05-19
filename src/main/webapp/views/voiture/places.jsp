<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cooperative.model.Voiture, java.util.List" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <%-- ═══════════ ANTI-FLASH ═══════════ --%>
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>Places libres | Coopérative</title>
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

            --shadow-sm:  0 1px 2px rgba(0,0,0,0.3);
            --shadow-md:  0 4px 6px -1px rgba(0,0,0,0.4);
            --shadow-lg:  0 10px 15px -3px rgba(0,0,0,0.5);
            --shadow-xl:  0 20px 25px -5px rgba(0,0,0,0.6);

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

            --shadow-sm:  0 1px 2px rgba(0,0,0,0.08);
            --shadow-md:  0 4px 6px -1px rgba(0,0,0,0.10);
            --shadow-lg:  0 10px 15px -3px rgba(0,0,0,0.12);
            --shadow-xl:  0 20px 25px -5px rgba(0,0,0,0.14);

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
            transition: background 0.3s ease, color 0.3s ease;
        }

        /* ══════════════════════════════════════════════
           LAYOUT
        ══════════════════════════════════════════════ */
        .app-container { display: flex; min-height: 100vh; }

        /* ══════════════════════════════════════════════
           SIDEBAR
        ══════════════════════════════════════════════ */
        .sidebar {
            width: 280px;
            background: var(--bg-primary);
            border-right: 1px solid var(--border);
            position: fixed;
            left: 0; top: 0; bottom: 0;
            z-index: 40;
            display: flex; flex-direction: column;
            transition: background 0.3s ease, border-color 0.3s ease, transform 0.3s ease;
        }

        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }

        .logo { display: flex; align-items: center; gap: 0.75rem; }

        .logo-icon {
            width: 2.25rem; height: 2.25rem;
            background: linear-gradient(135deg, var(--navy-400) 0%, var(--navy-600) 100%);
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
        }
        .logo-icon i { font-size: 1.1rem; color: white; }

        .logo-text h2 {
            font-family: 'Syne', sans-serif;
            font-size: 1.05rem; font-weight: 700; letter-spacing: -0.01em;
        }
        .logo-text p { font-size: 0.68rem; color: var(--text-muted); }

        .nav-menu {
            padding: 1.5rem;
            display: flex; flex-direction: column; gap: 0.375rem;
            flex: 1;
        }

        .nav-label {
            font-size: 0.63rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.08em;
            color: var(--text-muted);
            padding: 0.5rem 1rem 0.25rem;
        }

        .nav-item {
            display: flex; align-items: center; gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: var(--radius-lg);
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .nav-item i { width: 1.25rem; font-size: 0.95rem; }
        .nav-item:hover { background: var(--bg-hover); color: var(--text-primary); }
        .nav-item.active {
            background: var(--bg-card);
            color: var(--navy-300);
            border-left: 3px solid var(--navy-400);
        }

        .sidebar-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }

        /* ── Toggle thème ── */
        .theme-toggle-wrap {
            display: flex; align-items: center;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            padding: 0 0.25rem;
        }
        .theme-toggle-label {
            display: flex; align-items: center; gap: 0.5rem;
            font-size: 0.75rem; color: var(--text-secondary); font-weight: 500;
        }
        .theme-switch {
            position: relative;
            width: 2.75rem; height: 1.5rem;
            cursor: pointer;
        }
        .theme-switch input { opacity: 0; width: 0; height: 0; position: absolute; }
        .theme-track {
            position: absolute; inset: 0;
            background: var(--toggle-bg);
            border-radius: 9999px;
            border: 1px solid var(--border);
            transition: background 0.3s ease;
        }
        .theme-thumb {
            position: absolute;
            top: 0.2rem; left: 0.2rem;
            width: 1.1rem; height: 1.1rem;
            background: var(--toggle-thumb);
            border-radius: 50%;
            transition: transform 0.3s ease, background 0.3s ease;
        }
        .theme-switch input:checked ~ .theme-thumb { transform: translateX(1.25rem); }

        .sidebar-version { font-size: 0.65rem; color: var(--text-muted); text-align: center; }

        /* ══════════════════════════════════════════════
           MAIN CONTENT
        ══════════════════════════════════════════════ */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2rem 2.5rem;
            transition: margin-left 0.3s ease;
        }

        /* ── Top Bar ── */
        .top-bar {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1.25rem;
            border-bottom: 1px solid var(--border);
        }

        .page-title h1 {
            font-family: 'Syne', sans-serif;
            font-size: 1.6rem; font-weight: 700; letter-spacing: -0.03em;
        }
        .page-title p { font-size: 0.75rem; color: var(--text-muted); margin-top: 0.2rem; }

        .top-right { display: flex; align-items: center; gap: 0.75rem; }

        /* ── Bouton retour ── */
        .back-link {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 0.8125rem;
            transition: all 0.2s ease;
        }
        .back-link:hover {
            background: var(--bg-hover);
            border-color: var(--navy-500);
            color: var(--text-primary);
        }

        /* ══════════════════════════════════════════════
           FILTRE DATE
        ══════════════════════════════════════════════ */
        .date-filter {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex; align-items: center; gap: 1rem;
            flex-wrap: wrap;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .filter-label {
            font-size: 0.8125rem; color: var(--text-secondary);
            font-weight: 500; white-space: nowrap;
            display: flex; align-items: center; gap: 0.4rem;
        }
        .filter-label i { color: var(--navy-300); }

        .filter-form {
            display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap;
        }

        input[type="date"] {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 0.5rem 0.75rem;
            color: var(--text-primary);
            font-size: 0.875rem; font-family: inherit;
            outline: none;
            transition: border-color 0.2s, background 0.3s ease;
            color-scheme: dark;
        }
        [data-theme="light"] input[type="date"] {
            color-scheme: light;
            background: #ffffff;
        }
        input[type="date"]:focus { border-color: var(--navy-400); }

        .btn-filter {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.5rem 1.25rem;
            background: var(--navy-500); color: white;
            border: none; border-radius: var(--radius-md);
            font-size: 0.8125rem; font-weight: 500; font-family: inherit;
            cursor: pointer; transition: background 0.2s, transform 0.2s;
        }
        .btn-filter:hover { background: var(--navy-400); transform: translateY(-1px); }

        .btn-reset {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: transparent; color: var(--text-muted);
            border: 1px solid var(--border); border-radius: var(--radius-md);
            font-size: 0.8125rem; font-family: inherit;
            cursor: pointer; text-decoration: none;
            transition: all 0.2s;
        }
        .btn-reset:hover { background: var(--bg-hover); color: var(--text-secondary); }

        /* ══════════════════════════════════════════════
           NOTICE INFO
        ══════════════════════════════════════════════ */
        .notice {
            background: rgba(59,130,246,0.08);
            border: 1px solid rgba(59,130,246,0.25);
            border-radius: var(--radius-lg);
            padding: 0.875rem 1.125rem;
            color: #93c5fd;
            font-size: 0.8125rem;
            display: flex; align-items: center; gap: 0.625rem;
            margin-bottom: 1.5rem;
        }
        [data-theme="light"] .notice {
            background: rgba(37,99,235,0.06);
            border-color: rgba(37,99,235,0.2);
            color: #1d4ed8;
        }

        /* ══════════════════════════════════════════════
           INFO CARD VÉHICULE
        ══════════════════════════════════════════════ */
        .info-card {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .vehicle-header {
            display: flex; align-items: center; gap: 1rem;
            margin-bottom: 1rem;
        }

        .vehicle-icon {
            width: 3.5rem; height: 3.5rem;
            background: linear-gradient(135deg, var(--navy-500) 0%, var(--navy-600) 100%);
            border-radius: var(--radius-lg);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; color: white;
            flex-shrink: 0;
        }

        .vehicle-info h2 {
            font-family: 'Syne', sans-serif;
            font-size: 1.2rem; font-weight: 700; margin-bottom: 0.3rem;
        }

        .vehicle-meta {
            display: flex; gap: 1.5rem; flex-wrap: wrap;
            margin-top: 1rem; padding-top: 1rem;
            border-top: 1px solid var(--border);
        }

        .meta-item {
            display: flex; align-items: center; gap: 0.5rem;
            color: var(--text-secondary); font-size: 0.875rem;
        }
        .meta-item i { width: 1.25rem; color: var(--navy-300); font-size: 0.85rem; }
        .meta-item strong { color: var(--text-primary); }

        /* ── Badges ── */
        .badge {
            display: inline-flex; align-items: center; gap: 0.375rem;
            padding: 0.25rem 0.75rem;
            font-size: 0.75rem; font-weight: 600;
            border-radius: 9999px;
        }
        .badge-simple  { background: rgba(16,185,129,0.15); color: var(--success); }
        .badge-premium { background: rgba(245,158,11,0.15);  color: var(--warning); }
        .badge-vip     { background: rgba(139,92,246,0.15);  color: #8b5cf6; }

        /* ══════════════════════════════════════════════
           STATS BAR
        ══════════════════════════════════════════════ */
        .stats-bar {
            display: flex; justify-content: space-around; align-items: center;
            margin-bottom: 1.5rem;
            padding: 1.25rem 1.5rem;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            gap: 1rem; flex-wrap: wrap;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .stat {
            display: flex; flex-direction: column;
            align-items: center; gap: 0.25rem;
        }

        .stat-icon { font-size: 1.25rem; margin-bottom: 0.25rem; }
        .stat-value { font-family: 'Syne', sans-serif; font-size: 1.75rem; font-weight: 700; line-height: 1; }
        .stat-label { font-size: 0.7rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; }

        .stat-libre  .stat-value { color: var(--success); }
        .stat-libre  .stat-icon  { color: var(--success); }
        .stat-occupe .stat-value { color: var(--error); }
        .stat-occupe .stat-icon  { color: var(--error); }
        .stat-taux   .stat-value { color: var(--navy-300); }
        .stat-taux   .stat-icon  { color: var(--navy-300); }

        .stat-divider {
            width: 1px; height: 3rem;
            background: var(--border);
        }

        /* ══════════════════════════════════════════════
           LÉGENDE
        ══════════════════════════════════════════════ */
        .legend {
            display: flex; align-items: center; gap: 1.5rem;
            margin-bottom: 1.25rem;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex; align-items: center; gap: 0.5rem;
            font-size: 0.78rem; color: var(--text-secondary);
        }
        .legend-dot {
            width: 0.75rem; height: 0.75rem;
            border-radius: 50%;
        }
        .dot-libre  { background: var(--success); }
        .dot-occupe { background: var(--error); }

        /* ══════════════════════════════════════════════
           GRILLE DES PLACES
        ══════════════════════════════════════════════ */
        .places-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(90px, 1fr));
            gap: 0.875rem;
        }

        .place {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1rem 0.75rem;
            text-align: center;
            transition: all 0.2s ease;
            cursor: default;
        }
        .place:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); }

        .place.libre {
            border-color: var(--success);
            background: rgba(16,185,129,0.06);
        }
        [data-theme="light"] .place.libre {
            background: rgba(5,150,105,0.05);
        }

        .place.occupe {
            border-color: var(--error);
            background: rgba(239,68,68,0.05);
            opacity: 0.75;
        }
        [data-theme="light"] .place.occupe {
            background: rgba(220,38,38,0.04);
        }

        .place-num {
            font-family: 'Syne', sans-serif;
            font-size: 1.35rem; font-weight: 700;
            display: block; margin-bottom: 0.4rem;
            color: var(--text-primary);
        }

        .place-status {
            font-size: 0.68rem; font-weight: 500;
            display: flex; align-items: center;
            justify-content: center; gap: 0.25rem;
        }
        .place.libre  .place-status { color: var(--success); }
        .place.occupe .place-status { color: var(--error); }

        /* ── Barre de progression occupancy ── */
        .occupancy-bar {
            width: 100%; height: 6px;
            background: var(--bg-hover);
            border-radius: 9999px;
            margin-bottom: 1.25rem;
            overflow: hidden;
        }
        .occupancy-fill {
            height: 100%;
            border-radius: 9999px;
            background: linear-gradient(90deg, var(--success) 0%, var(--warning) 60%, var(--error) 100%);
            transition: width 0.8s cubic-bezier(0.34,1.2,0.64,1);
        }

        /* ── Section label ── */
        .section-label {
            font-size: 0.68rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.08em;
            color: var(--text-muted); margin-bottom: 1rem;
        }

        /* ── Animations ── */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .animate-in { animation: fadeInUp 0.4s ease-out; }

        /* ── Scrollbar ── */
        ::-webkit-scrollbar { width: .375rem; }
        ::-webkit-scrollbar-track { background: var(--bg-secondary); border-radius: 9999px; }
        ::-webkit-scrollbar-thumb { background: var(--navy-500); border-radius: 9999px; }

        /* ── Responsive ── */
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; padding: 1.25rem; }
            .places-grid { grid-template-columns: repeat(auto-fill, minmax(75px, 1fr)); }
            .stat-divider { display: none; }
        }
    </style>
</head>
<body>

<%
    Voiture voiture         = (Voiture)       request.getAttribute("voiture");
    List<Integer> placesLibres = (List<Integer>) request.getAttribute("placesLibres");
    String dateVoyage       = (String)         request.getAttribute("date");

    int totalPlaces = 0, libres = 0, occupees = 0;
    int tauxOcc = 0;
    String badgeClass = "badge-simple", typeIcon = "fa-car", typeLabel = "Simple";

    if (voiture != null) {
        totalPlaces = voiture.getNbrplace();
        libres      = placesLibres != null ? placesLibres.size() : 0;
        occupees    = totalPlaces - libres;
        tauxOcc     = totalPlaces > 0 ? (int) Math.round((occupees * 100.0) / totalPlaces) : 0;

        if ("premium".equals(voiture.getType())) {
            badgeClass = "badge-premium"; typeIcon = "fa-star"; typeLabel = "⭐ Premium";
        } else if ("VIP".equals(voiture.getType())) {
            badgeClass = "badge-vip"; typeIcon = "fa-crown"; typeLabel = "👑 VIP";
        } else {
            typeLabel = "🚗 Simple";
        }
    }
%>

<div class="app-container">

    <!-- ═══════ SIDEBAR ═══════ -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon"><i class="fas fa-bus"></i></div>
                <div class="logo-text">
                    <h2>CoopTransport</h2>
                    <p>Gestion des Réservations</p>
                </div>
            </div>
        </div>

        <nav class="nav-menu">
            <span class="nav-label">Navigation</span>
            <a href="<%= request.getContextPath() %>/" class="nav-item">
                <i class="fas fa-home"></i><span>Accueil</span>
            </a>
            <a href="<%= request.getContextPath() %>/voiture/" class="nav-item active">
                <i class="fas fa-van-shuttle"></i><span>Voitures</span>
            </a>
            <a href="<%= request.getContextPath() %>/client/" class="nav-item">
                <i class="fas fa-users"></i><span>Clients</span>
            </a>
            <a href="<%= request.getContextPath() %>/reservation/" class="nav-item">
                <i class="fas fa-calendar-check"></i><span>Réservations</span>
            </a>
            <a href="<%= request.getContextPath() %>/rapport/" class="nav-item">
                <i class="fas fa-chart-bar"></i><span>Rapports</span>
            </a>
        </nav>

        <div class="sidebar-footer">
            <div class="theme-toggle-wrap">
                <div class="theme-toggle-label">
                    <i class="fas fa-moon" id="themeIcon" style="font-size:.8rem;color:var(--text-muted);"></i>
                    <span id="themeLabel">Mode sombre</span>
                </div>
                <label class="theme-switch" aria-label="Changer le thème">
                    <input type="checkbox" id="themeToggle">
                    <span class="theme-track"></span>
                    <span class="theme-thumb"></span>
                </label>
            </div>
            <p class="sidebar-version">v1.0.0 &mdash; Coopérative &copy; 2025</p>
        </div>
    </aside>

    <!-- ═══════ MAIN ═══════ -->
    <main class="main-content">

        <% if (voiture != null) { %>

        <!-- Top Bar -->
        <div class="top-bar">
            <div class="page-title">
                <h1>Places disponibles</h1>
                <p>Visualisez les places libres et occupées du véhicule</p>
            </div>
            <div class="top-right">
                <a href="<%= request.getContextPath() %>/voiture/" class="back-link">
                    <i class="fas fa-arrow-left"></i> Retour à la liste
                </a>
            </div>
        </div>

        <!-- Filtre par date -->
        <div class="date-filter animate-in">
            <div class="filter-label">
                <i class="fas fa-calendar-alt"></i>
                Date de voyage :
            </div>
            <form class="filter-form"
                  method="get"
                  action="<%= request.getContextPath() %>/voiture/places">
                <input type="hidden" name="id" value="<%= voiture.getIdvoit() %>">
                <input type="date" name="date"
                       value="<%= dateVoyage != null ? dateVoyage : "" %>">
                <button type="submit" class="btn-filter">
                    <i class="fas fa-search"></i> Filtrer
                </button>
                <% if (dateVoyage != null) { %>
                <a href="<%= request.getContextPath() %>/voiture/places?id=<%= voiture.getIdvoit() %>"
                   class="btn-reset">
                    <i class="fas fa-times"></i> Réinitialiser
                </a>
                <% } %>
            </form>
        </div>

        <!-- Notice sans date -->
        <% if (dateVoyage == null) { %>
        <div class="notice">
            <i class="fas fa-info-circle" style="flex-shrink:0;"></i>
            Sélectionnez une date pour voir les places réellement disponibles à ce voyage.
            Sans date, toutes les places sont affichées comme libres.
        </div>
        <% } %>

        <!-- Info card véhicule -->
        <div class="info-card animate-in">
            <div class="vehicle-header">
                <div class="vehicle-icon">
                    <i class="fas <%= typeIcon %>"></i>
                </div>
                <div class="vehicle-info">
                    <h2><%= voiture.getDesign() %></h2>
                    <span class="badge <%= badgeClass %>">
                        <i class="fas <%= typeIcon %>" style="font-size:.6rem;"></i>
                        <%= typeLabel %>
                    </span>
                </div>
            </div>
            <div class="vehicle-meta">
                <div class="meta-item">
                    <i class="fas fa-hashtag"></i>
                    <span>ID : <strong><%= voiture.getIdvoit() %></strong></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-chair"></i>
                    <span>Total : <strong><%= totalPlaces %> places</strong></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-money-bill-wave"></i>
                    <span>Frais : <strong><%= String.format("%,d", voiture.getFrais()) %> Ar</strong></span>
                </div>
                <% if (dateVoyage != null) { %>
                <div class="meta-item">
                    <i class="fas fa-calendar-check"></i>
                    <span>Date filtrée : <strong><%= dateVoyage %></strong></span>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Stats -->
        <div class="stats-bar animate-in">
            <div class="stat stat-libre">
                <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                <div class="stat-value"><%= libres %></div>
                <div class="stat-label">Places libres</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat stat-occupe">
                <div class="stat-icon"><i class="fas fa-times-circle"></i></div>
                <div class="stat-value"><%= occupees %></div>
                <div class="stat-label">Occupées</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat stat-taux">
                <div class="stat-icon"><i class="fas fa-chart-pie"></i></div>
                <div class="stat-value"><%= tauxOcc %>%</div>
                <div class="stat-label">Taux d'occupation</div>
            </div>
        </div>

        <!-- Barre de progression -->
        <div class="occupancy-bar">
            <div class="occupancy-fill" id="occFill" style="width: 0%;"></div>
        </div>

        <!-- Légende + grille -->
        <div class="legend">
            <div class="legend-item">
                <div class="legend-dot dot-libre"></div>
                <span>Place libre</span>
            </div>
            <div class="legend-item">
                <div class="legend-dot dot-occupe"></div>
                <span>Place occupée</span>
            </div>
        </div>

        <p class="section-label">Carte des places — <%= totalPlaces %> place<%= totalPlaces > 1 ? "s" : "" %> au total</p>

        <div class="places-grid animate-in">
            <% for (int i = 1; i <= totalPlaces; i++) {
                boolean isLibre = placesLibres != null && placesLibres.contains(i);
            %>
            <div class="place <%= isLibre ? "libre" : "occupe" %>">
                <span class="place-num"><%= i %></span>
                <span class="place-status">
                    <% if (isLibre) { %>
                    <i class="fas fa-check" style="font-size:.6rem;"></i> Libre
                    <% } else { %>
                    <i class="fas fa-times" style="font-size:.6rem;"></i> Occupée
                    <% } %>
                </span>
            </div>
            <% } %>
        </div>

        <% } else { %>
        <!-- Véhicule non trouvé -->
        <div class="top-bar">
            <div class="page-title">
                <h1>Places disponibles</h1>
            </div>
        </div>
        <div class="info-card" style="text-align:center; padding:3rem;">
            <i class="fas fa-exclamation-triangle"
               style="font-size:3rem; color:var(--warning); margin-bottom:1rem; display:block;"></i>
            <h2 style="font-family:'Syne',sans-serif; margin-bottom:.5rem;">Véhicule non trouvé</h2>
            <p style="color:var(--text-muted); margin-bottom:1.5rem;">
                Le véhicule demandé n'existe pas ou a été supprimé.
            </p>
            <a href="<%= request.getContextPath() %>/voiture/" class="back-link"
               style="display:inline-flex; margin:0 auto;">
                <i class="fas fa-arrow-left"></i> Retour à la liste
            </a>
        </div>
        <% } %>

    </main>
</div>

<script>
    /* ═══════════════════════════════════════════════════
       1. TOGGLE THÈME
    ═══════════════════════════════════════════════════ */
    (function () {
        var toggle = document.getElementById('themeToggle');
        var label  = document.getElementById('themeLabel');
        var icon   = document.getElementById('themeIcon');
        var root   = document.documentElement;

        function applyTheme(theme) {
            if (theme === 'light') {
                root.setAttribute('data-theme', 'light');
                toggle.checked    = true;
                label.textContent = 'Mode clair';
                icon.className    = 'fas fa-sun';
            } else {
                root.removeAttribute('data-theme');
                toggle.checked    = false;
                label.textContent = 'Mode sombre';
                icon.className    = 'fas fa-moon';
            }
        }

        applyTheme(localStorage.getItem('theme') || 'dark');

        toggle.addEventListener('change', function () {
            var next = toggle.checked ? 'light' : 'dark';
            localStorage.setItem('theme', next);
            applyTheme(next);
        });
    })();

    /* ═══════════════════════════════════════════════════
       2. BARRE D'OCCUPATION animée
    ═══════════════════════════════════════════════════ */
    (function () {
        var fill = document.getElementById('occFill');
        if (!fill) return;
        var taux = <%= tauxOcc %>;
        /* Petit délai pour que l'animation CSS soit visible */
        setTimeout(function () {
            fill.style.width = taux + '%';
        }, 300);
    })();
</script>
</body>
</html>
