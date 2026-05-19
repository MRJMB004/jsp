<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>Accueil | Coopérative de Transport</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">

    <%-- ═══════════════════════════════════════════════════════════════════
         SCRIPT DE THÈME : À copier dans <head> de chaque autre page JSP
         (reservation, voiture, client, rapport…) pour éviter le flash
    ════════════════════════════════════════════════════════════════════ --%>
    <script>
        (function() {
            var saved = localStorage.getItem('theme');
            if (saved === 'light') {
                document.documentElement.setAttribute('data-theme', 'light');
            }
        })();
    </script>

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

            /* toggle */
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

            /* toggle */
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

        /* ── Layout ── */
        .app-container { display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: 280px;
            background: var(--bg-primary);
            border-right: 1px solid var(--border);
            position: fixed;
            left: 0; top: 0; bottom: 0;
            z-index: 40;
            display: flex;
            flex-direction: column;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
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
            position: relative;
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
        }
        .sidebar-version { font-size: 0.65rem; color: var(--text-muted); text-align: center; }

        /* ══════════════════════════════════════════════
           TOGGLE THÈME
        ══════════════════════════════════════════════ */
        .theme-toggle-wrap {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            padding: 0 0.25rem;
        }

        .theme-toggle-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.75rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        /* Le switch lui-même */
        .theme-switch {
            position: relative;
            width: 2.75rem;
            height: 1.5rem;
            cursor: pointer;
        }
        .theme-switch input { opacity: 0; width: 0; height: 0; position: absolute; }

        .theme-track {
            position: absolute;
            inset: 0;
            background: var(--toggle-bg);
            border-radius: 9999px;
            transition: background 0.3s ease;
            border: 1px solid var(--border);
        }
        .theme-thumb {
            position: absolute;
            top: 0.2rem; left: 0.2rem;
            width: 1.1rem; height: 1.1rem;
            background: var(--toggle-thumb);
            border-radius: 50%;
            transition: transform 0.3s ease, background 0.3s ease;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.5rem; color: white;
        }
        /* quand activé (mode clair), on déplace le thumb */
        .theme-switch input:checked ~ .theme-track { background: var(--toggle-bg); }
        .theme-switch input:checked ~ .theme-thumb { transform: translateX(1.25rem); }

        .icon-theme {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        /* ── Main Content ── */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2rem 2.5rem;
        }

        /* ── Top Bar ── */
        .top-bar {
            display: flex;
            justify-content: space-between; align-items: center;
            margin-bottom: 2.5rem;
            padding-bottom: 1.25rem;
            border-bottom: 1px solid var(--border);
        }
        .page-title h1 {
            font-family: 'Syne', sans-serif;
            font-size: 1.6rem; font-weight: 700; letter-spacing: -0.03em;
        }
        .page-title p { font-size: 0.75rem; color: var(--text-muted); margin-top: 0.2rem; }

        .top-right { display: flex; align-items: center; gap: 0.75rem; }

        .recette-pill {
            display: flex; align-items: center; gap: 0.625rem;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 9999px;
            padding: 0.45rem 1rem 0.45rem 0.75rem;
            transition: background 0.3s ease;
        }
        .recette-pill .pill-icon {
            width: 1.6rem; height: 1.6rem;
            background: linear-gradient(135deg, rgba(16,185,129,.25), rgba(16,185,129,.1));
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: var(--success); font-size: 0.7rem;
        }
        .recette-pill .pill-label { font-size: 0.65rem; color: var(--text-muted); display: block; }
        .recette-pill .pill-value {
            font-family: 'Syne', sans-serif;
            font-size: 0.85rem; font-weight: 700; color: var(--success);
        }

        .user-avatar {
            width: 2.5rem; height: 2.5rem;
            background: linear-gradient(135deg, var(--navy-500), var(--navy-600));
            border-radius: var(--radius-lg);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.9rem; color: white;
        }

        /* ── Hero Banner ── */
        .hero-banner {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-2xl);
            padding: 2rem 2.5rem;
            margin-bottom: 2rem;
            display: flex; align-items: center;
            justify-content: space-between; gap: 2rem;
            overflow: hidden; position: relative;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .hero-banner::before {
            content: '';
            position: absolute;
            right: -80px; top: -80px;
            width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(58,91,140,.18) 0%, transparent 70%);
            pointer-events: none;
        }
        .hero-text h2 {
            font-family: 'Syne', sans-serif;
            font-size: 1.35rem; font-weight: 700; margin-bottom: 0.4rem;
        }
        .hero-text p { color: var(--text-secondary); font-size: 0.8125rem; max-width: 480px; }
        .hero-bus {
            font-size: 4rem; opacity: 0.6;
            filter: drop-shadow(0 4px 12px rgba(74,109,158,.4));
            animation: float 4s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50%       { transform: translateY(-8px); }
        }

        /* ── Menu Grid ── */
        .section-label {
            font-size: 0.68rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.08em;
            color: var(--text-muted); margin-bottom: 1rem;
        }
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.25rem; margin-bottom: 2rem;
        }
        @media (max-width: 900px) { .menu-grid { grid-template-columns: 1fr; } }

        .menu-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 1.5rem;
            text-decoration: none;
            color: var(--text-primary);
            transition: all 0.25s ease;
            display: flex; align-items: flex-start; gap: 1.125rem;
            position: relative; overflow: hidden;
            animation: fadeInUp 0.5s ease-out both;
        }
        .menu-card:nth-child(1) { animation-delay: .05s; }
        .menu-card:nth-child(2) { animation-delay: .10s; }
        .menu-card:nth-child(3) { animation-delay: .15s; }
        .menu-card:nth-child(4) { animation-delay: .20s; }

        .menu-card::after {
            content: '';
            position: absolute; inset: 0;
            border-radius: var(--radius-xl);
            background: linear-gradient(135deg, rgba(90,127,176,.07) 0%, transparent 60%);
            opacity: 0; transition: opacity 0.25s ease;
        }
        .menu-card:hover {
            transform: translateY(-3px);
            border-color: var(--navy-500);
            box-shadow: var(--shadow-xl);
        }
        .menu-card:hover::after { opacity: 1; }

        .card-icon-wrap {
            width: 2.75rem; height: 2.75rem;
            border-radius: var(--radius-lg);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0; font-size: 1.2rem;
        }
        .card-icon-wrap.blue  { background: rgba(58,91,140,.25);  color: var(--navy-300); }
        .card-icon-wrap.green { background: rgba(16,185,129,.18); color: var(--success);  }
        .card-icon-wrap.amber { background: rgba(245,158,11,.18); color: var(--warning);  }
        .card-icon-wrap.red   { background: rgba(239,68,68,.15);  color: var(--error);    }

        .card-body { flex: 1; }
        .card-title {
            font-family: 'Syne', sans-serif;
            font-size: 0.95rem; font-weight: 600; margin-bottom: 0.3rem;
        }
        .card-desc { font-size: 0.76rem; color: var(--text-secondary); line-height: 1.45; }

        .card-arrow {
            align-self: center; color: var(--text-muted);
            transition: transform 0.2s ease, color 0.2s ease;
        }
        .menu-card:hover .card-arrow { transform: translateX(4px); color: var(--navy-300); }

        /* ── Animations ── */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(18px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Scrollbar ── */
        ::-webkit-scrollbar { width: .375rem; }
        ::-webkit-scrollbar-track { background: var(--bg-secondary); border-radius: 9999px; }
        ::-webkit-scrollbar-thumb { background: var(--navy-500); border-radius: 9999px; }

        /* ── Responsive ── */
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; padding: 1.25rem; }
            .hero-bus { display: none; }
        }
    </style>
</head>
<body>
<div class="app-container">

    <!-- Sidebar -->
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
            <a href="<%= request.getContextPath() %>/" class="nav-item active">
                <i class="fas fa-home"></i><span>Accueil</span>
            </a>
            <a href="<%= request.getContextPath() %>/voiture/" class="nav-item">
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
            <%-- ═══════════════════════════════════════════════════════════
                 TOGGLE THÈME — À copier dans le sidebar-footer de chaque
                 autre page JSP (reservation, voiture, client, rapport…)
            ════════════════════════════════════════════════════════════ --%>
            <div class="theme-toggle-wrap">
                <div class="theme-toggle-label">
                    <i class="fas fa-moon icon-theme" id="themeIcon"></i>
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

    <!-- Main Content -->
    <main class="main-content">
        <%
            com.cooperative.dao.ReservationDAO dao = new com.cooperative.dao.ReservationDAO();
            int recette = dao.getRecetteTotale();
        %>

        <!-- Top Bar -->
        <div class="top-bar">
            <div class="page-title">
                <h1>Tableau de bord</h1>
                <p>Bienvenue dans votre espace de gestion</p>
            </div>
            <div class="top-right">
                <div class="recette-pill">
                    <div class="pill-icon"><i class="fas fa-coins"></i></div>
                    <div>
                        <span class="pill-label">Recette totale</span>
                        <span class="pill-value"><%= String.format("%,d", recette) %> Ar</span>
                    </div>
                </div>
                <div class="user-avatar"><i class="fas fa-user"></i></div>
            </div>
        </div>

        <!-- Hero Banner -->
        <div class="hero-banner">
            <div class="hero-text">
                <h2>Gérez vos opérations en toute simplicité</h2>
                <p>Accédez à la gestion des voitures, clients et réservations depuis un seul endroit. Suivez vos recettes et optimisez votre activité.</p>
            </div>
            <div class="hero-bus">🚌</div>
        </div>

        <!-- Menu Cards -->
        <p class="section-label">Modules principaux</p>
        <div class="menu-grid">

            <a href="<%= request.getContextPath() %>/voiture/" class="menu-card">
                <div class="card-icon-wrap blue"><i class="fas fa-van-shuttle"></i></div>
                <div class="card-body">
                    <p class="card-title">Gestion des Voitures</p>
                    <p class="card-desc">Ajouter, modifier, supprimer et consulter le parc de véhicules disponibles.</p>
                </div>
                <i class="fas fa-chevron-right card-arrow"></i>
            </a>

            <a href="<%= request.getContextPath() %>/client/" class="menu-card">
                <div class="card-icon-wrap green"><i class="fas fa-users"></i></div>
                <div class="card-body">
                    <p class="card-title">Gestion des Clients</p>
                    <p class="card-desc">Gérer le portefeuille client, rechercher par nom ou numéro de téléphone.</p>
                </div>
                <i class="fas fa-chevron-right card-arrow"></i>
            </a>

            <a href="<%= request.getContextPath() %>/reservation/" class="menu-card">
                <div class="card-icon-wrap amber"><i class="fas fa-calendar-check"></i></div>
                <div class="card-body">
                    <p class="card-title">Gestion des Réservations</p>
                    <p class="card-desc">Créer et suivre les réservations de places pour chaque voyage.</p>
                </div>
                <i class="fas fa-chevron-right card-arrow"></i>
            </a>

            <a href="<%= request.getContextPath() %>/rapport/" class="menu-card">
                <div class="card-icon-wrap red"><i class="fas fa-chart-bar"></i></div>
                <div class="card-body">
                    <p class="card-title">Rapports &amp; Statistiques</p>
                    <p class="card-desc">Visualiser les statistiques de paiement et calculer la recette totale.</p>
                </div>
                <i class="fas fa-chevron-right card-arrow"></i>
            </a>

        </div>
    </main>
</div>

<%-- ═══════════════════════════════════════════════════════════════════════
     SCRIPT DU TOGGLE — À copier avant </body> dans chaque autre page JSP
════════════════════════════════════════════════════════════════════════ --%>
<script>
    (function () {
        var toggle   = document.getElementById('themeToggle');
        var label    = document.getElementById('themeLabel');
        var icon     = document.getElementById('themeIcon');
        var root     = document.documentElement;

        // Lire la préférence sauvegardée
        var saved = localStorage.getItem('theme') || 'dark';
        applyTheme(saved);

        toggle.addEventListener('change', function () {
            var next = toggle.checked ? 'light' : 'dark';
            localStorage.setItem('theme', next);
            applyTheme(next);
        });

        function applyTheme(theme) {
            if (theme === 'light') {
                root.setAttribute('data-theme', 'light');
                toggle.checked = true;
                label.textContent = 'Mode clair';
                icon.className = 'fas fa-sun icon-theme';
            } else {
                root.removeAttribute('data-theme');
                toggle.checked = false;
                label.textContent = 'Mode sombre';
                icon.className = 'fas fa-moon icon-theme';
            }
        }
    })();
</script>
</body>
</html>
