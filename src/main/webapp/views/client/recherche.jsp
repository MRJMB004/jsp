<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cooperative.model.Reservation, com.cooperative.model.Voiture" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <%-- ══ ANTI-FLASH : doit être le premier script ══ --%>
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>Recherche Réservation | Coopérative</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        /* ══════════════════════════════════════════════
           VARIABLES — MODE SOMBRE (défaut)
        ══════════════════════════════════════════════ */
        :root {
            --bg-deep:      #07090f;
            --bg-primary:   #0c0f1c;
            --bg-card:      #161b2e;
            --bg-hover:     #1e2440;
            --border:       #242a42;
            --border-glow:  #3a4f82;
            --navy-300: #6d94cf;
            --navy-400: #5480be;
            --navy-500: #3a5b8c;
            --navy-600: #2a4470;
            --amber:    #f5a623;
            --teal:     #2dd4bf;
            --rose:     #f43f5e;
            --green:    #10b981;
            --text-primary:   #eef2f9;
            --text-secondary: #8a96b8;
            --text-muted:     #555e80;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --radius-xl: 1rem;
            --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.6);
        }

        /* ══════════════════════════════════════════════
           VARIABLES — MODE CLAIR
        ══════════════════════════════════════════════ */
        [data-theme="light"] {
            --bg-deep:      #f0f4f8;
            --bg-primary:   #ffffff;
            --bg-card:      #ffffff;
            --bg-hover:     #dce4f0;
            --border:       #c8d3e6;
            --border-glow:  #4a6d9e;
            --navy-300: #2a497a;
            --navy-400: #3a5b8c;
            --navy-500: #4a6d9e;
            --navy-600: #5a7fb0;
            --amber:    #d97706;
            --teal:     #0d9488;
            --rose:     #e11d48;
            --green:    #059669;
            --text-primary:   #0f1322;
            --text-secondary: #3a4560;
            --text-muted:     #6b7294;
            --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.14);
        }

        body {
            background: var(--bg-deep);
            font-family: 'Syne', sans-serif;
            font-size: 0.875rem;
            line-height: 1.5;
            min-height: 100vh;
            background-image:
                    linear-gradient(rgba(58,91,140,0.04) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(58,91,140,0.04) 1px, transparent 1px);
            background-size: 40px 40px;
            transition: background-color 0.3s ease, color 0.3s ease;
            color: var(--text-primary);
        }

        [data-theme="light"] body {
            background-image:
                    linear-gradient(rgba(74,109,158,0.06) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(74,109,158,0.06) 1px, transparent 1px);
        }

        .app-container { display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: 260px; background: var(--bg-primary);
            border-right: 1px solid var(--border);
            position: fixed; left: 0; top: 0; bottom: 0;
            z-index: 40; display: flex; flex-direction: column;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .sidebar-header {
            padding: 1.5rem; border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }
        .logo { display: flex; align-items: center; gap: 0.75rem; }
        .logo-icon {
            width: 2.25rem; height: 2.25rem;
            background: linear-gradient(135deg, var(--navy-400), var(--navy-600));
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 0 20px rgba(58,91,140,0.4);
        }
        .logo-icon i { font-size: 1.1rem; color: white; }
        .logo-text h2 { font-size: 1rem; font-weight: 700; color: var(--text-primary); }
        .logo-text p  { font-size: 0.65rem; color: var(--text-muted); font-family: 'DM Mono', monospace; }
        .nav-menu { padding: 1.5rem 1rem; display: flex; flex-direction: column; gap: 0.25rem; flex: 1; }
        .nav-item {
            display: flex; align-items: center; gap: 0.75rem;
            padding: 0.7rem 1rem; border-radius: var(--radius-lg);
            color: var(--text-secondary); text-decoration: none;
            transition: all 0.2s ease; font-size: 0.8125rem;
        }
        .nav-item i { width: 1.125rem; font-size: 0.875rem; }
        .nav-item:hover { background: var(--bg-hover); color: var(--text-primary); }
        .nav-item.active {
            background: var(--bg-card); color: var(--navy-300);
            border-left: 3px solid var(--navy-400);
            box-shadow: inset 0 0 20px rgba(58,91,140,0.1);
        }

        /* ── Main ── */
        .main-content { flex: 1; margin-left: 260px; padding: 2rem 1.75rem; }

        .top-bar {
            display: flex; justify-content: space-between; align-items: flex-start;
            margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;
        }
        .page-title h1 { font-size: 1.625rem; font-weight: 700; color: var(--text-primary); letter-spacing: -0.02em; }
        .page-title p  { font-size: 0.75rem; color: var(--text-muted); margin-top: 0.25rem; font-family: 'DM Mono', monospace; }

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

        /* ── Search Card ── */
        .search-card {
            background: var(--bg-card); border-radius: var(--radius-xl);
            border: 1px solid var(--border); padding: 1.75rem;
            margin-bottom: 2rem; position: relative; overflow: hidden;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .search-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
            background: linear-gradient(90deg, var(--navy-500), var(--teal), var(--navy-500));
        }

        .filter-label {
            font-size: 0.68rem; color: var(--text-muted);
            font-family: 'DM Mono', monospace;
            margin-bottom: 0.5rem;
            display: flex; align-items: center; gap: 0.5rem;
        }
        .filter-label::after { content: ''; flex: 1; height: 1px; background: var(--border); }

        /* ── Select voiture ── */
        .voiture-select-row {
            display: flex; gap: 0.5rem; flex-wrap: wrap;
            margin-bottom: 1rem;
        }
        .voiture-chip {
            display: flex; align-items: center; gap: 0.4rem;
            padding: 0.45rem 0.9rem;
            border-radius: 9999px;
            font-size: 0.72rem; font-weight: 600;
            cursor: pointer; border: 1px solid var(--border);
            background: var(--bg-primary); color: var(--text-muted);
            font-family: 'Syne', sans-serif;
            transition: all 0.2s ease;
            white-space: nowrap;
        }
        .voiture-chip:hover { border-color: var(--navy-400); color: var(--text-primary); background: var(--bg-hover); }
        .voiture-chip.active {
            background: linear-gradient(135deg, var(--navy-500), var(--navy-600));
            color: white; border-color: var(--navy-400);
            box-shadow: 0 2px 12px rgba(58,91,140,0.35);
        }
        .voiture-chip .badge-place {
            background: rgba(255,255,255,0.15);
            border-radius: 9999px;
            padding: 0.05rem 0.4rem;
            font-size: 0.62rem;
            font-family: 'DM Mono', monospace;
        }

        /* ── Tabs critère ── */
        .search-tabs {
            display: flex; gap: 0.5rem; margin-bottom: 1rem;
            background: var(--bg-primary); padding: 0.375rem;
            border-radius: var(--radius-lg); border: 1px solid var(--border);
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .tab-btn {
            flex: 1; display: flex; align-items: center; justify-content: center; gap: 0.5rem;
            padding: 0.6rem 0.75rem; border: none; border-radius: var(--radius-md);
            background: transparent; color: var(--text-muted); cursor: pointer;
            font-family: 'Syne', sans-serif; font-size: 0.75rem; font-weight: 500;
            transition: all 0.2s ease; white-space: nowrap;
        }
        .tab-btn i { font-size: 0.75rem; }
        .tab-btn:hover { color: var(--text-secondary); background: var(--bg-hover); }
        .tab-btn.active { color: white; box-shadow: 0 2px 12px rgba(58,91,140,0.4); }
        .tab-btn.active.all     { background: linear-gradient(135deg, var(--navy-500), var(--navy-600)); }
        .tab-btn.active.place   { background: linear-gradient(135deg, #0e7490, #0891b2); }
        .tab-btn.active.name    { background: linear-gradient(135deg, #065f46, #047857); }
        .tab-btn.active.invoice { background: linear-gradient(135deg, #92400e, #b45309); }

        /* ── Tabs paiement ── */
        .payment-tabs { display: flex; gap: 0.5rem; margin-bottom: 1.25rem; flex-wrap: wrap; }
        .payment-btn {
            display: flex; align-items: center; gap: 0.4rem;
            padding: 0.45rem 1rem; border-radius: 9999px;
            font-size: 0.72rem; font-weight: 600; cursor: pointer;
            border: 1px solid var(--border); background: var(--bg-primary); color: var(--text-muted);
            font-family: 'Syne', sans-serif; transition: all 0.2s ease;
        }
        .payment-btn:hover { border-color: var(--navy-400); color: var(--text-primary); }
        .payment-btn.active.p-all    { background: rgba(58,91,140,0.2);  color: var(--navy-300); border-color: var(--navy-400); }
        .payment-btn.active.p-avance { background: rgba(245,166,35,0.15); color: var(--amber);    border-color: var(--amber); }
        .payment-btn.active.p-sans   { background: rgba(244,63,94,0.15);  color: var(--rose);     border-color: var(--rose); }
        .payment-btn.active.p-paye   { background: rgba(16,185,129,0.15); color: var(--green);    border-color: var(--green); }

        /* ── Input ── */
        .search-input-area { position: relative; }
        .search-input-area i.icon-left {
            position: absolute; left: 1rem; top: 50%;
            transform: translateY(-50%); color: var(--text-muted); pointer-events: none;
        }
        .search-input {
            width: 100%; padding: 0.9rem 3rem; font-size: 0.9375rem;
            font-family: 'DM Mono', monospace; background: var(--bg-primary);
            border: 1px solid var(--border); border-radius: var(--radius-lg);
            color: var(--text-primary); transition: all 0.25s ease;
        }
        [data-theme="light"] .search-input { background: #ffffff; }
        .search-input:focus {
            outline: none; border-color: var(--navy-500);
            box-shadow: 0 0 0 3px rgba(58,91,140,0.2);
        }
        .clear-btn {
            position: absolute; right: 1rem; top: 50%; transform: translateY(-50%);
            background: none; border: none; color: var(--text-muted); cursor: pointer; padding: 0.25rem;
        }
        .clear-btn:hover { color: var(--rose); }

        .search-hint {
            margin-top: 0.75rem; font-size: 0.7rem; color: var(--text-muted);
            font-family: 'DM Mono', monospace; display: flex; align-items: center; gap: 0.4rem;
        }
        .search-hint .dot { width: 5px; height: 5px; border-radius: 50%; background: var(--navy-400); display: inline-block; }

        .search-actions {
            display: flex; justify-content: space-between; align-items: center;
            margin-top: 1.25rem; flex-wrap: wrap; gap: 0.75rem;
        }
        .suggestions { display: flex; gap: 0.375rem; flex-wrap: wrap; }
        .suggestion-chip {
            padding: 0.3rem 0.75rem; background: var(--bg-hover); border-radius: 9999px;
            font-size: 0.7rem; cursor: pointer; transition: all 0.2s ease;
            color: var(--text-secondary); font-family: 'DM Mono', monospace; border: 1px solid var(--border);
        }
        .suggestion-chip:hover { background: var(--navy-500); color: white; border-color: var(--navy-500); }

        .btn {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.6rem 1.25rem; font-size: 0.8125rem; font-weight: 600;
            border-radius: var(--radius-md); cursor: pointer; transition: all 0.2s ease;
            border: 1px solid transparent; text-decoration: none;
            font-family: 'Syne', sans-serif;
        }
        .btn-primary { background: var(--navy-500); color: white; box-shadow: 0 2px 12px rgba(58,91,140,0.3); }
        .btn-primary:hover { background: var(--navy-400); transform: translateY(-1px); }

        /* ── Results ── */
        .results-header {
            display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 1rem; margin-bottom: 1.25rem;
        }
        .result-badge {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.4rem 1rem; background: var(--bg-card); border-radius: 9999px;
            font-size: 0.75rem; border: 1px solid var(--border); font-family: 'DM Mono', monospace;
            color: var(--text-secondary);
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .result-badge .count { color: var(--teal); font-weight: 600; }
        .keyword { color: var(--navy-300); font-weight: 600; }

        .mode-badge, .pay-badge, .voit-badge {
            display: inline-flex; align-items: center; gap: 0.375rem;
            padding: 0.3rem 0.75rem; border-radius: 9999px;
            font-size: 0.7rem; font-family: 'DM Mono', monospace;
        }
        .mode-badge.all     { background: rgba(58,91,140,0.15); color: var(--navy-300); border: 1px solid rgba(58,91,140,0.3); }
        .mode-badge.place   { background: rgba(8,145,178,0.12); color: #22d3ee; border: 1px solid rgba(8,145,178,0.25); }
        .mode-badge.name    { background: rgba(16,185,129,0.12); color: #34d399; border: 1px solid rgba(16,185,129,0.25); }
        .mode-badge.invoice { background: rgba(245,166,35,0.12); color: var(--amber); border: 1px solid rgba(245,166,35,0.25); }
        .pay-badge.avance { background: rgba(245,166,35,0.15); color: var(--amber); border: 1px solid rgba(245,166,35,0.3); }
        .pay-badge.sans   { background: rgba(244,63,94,0.15);  color: var(--rose);  border: 1px solid rgba(244,63,94,0.3); }
        .pay-badge.paye   { background: rgba(16,185,129,0.15); color: var(--green); border: 1px solid rgba(16,185,129,0.3); }
        .voit-badge       { background: rgba(45,212,191,0.12); color: var(--teal);  border: 1px solid rgba(45,212,191,0.25); }

        .results-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 1rem; }

        .result-card {
            background: var(--bg-card); border-radius: var(--radius-lg); padding: 1.1rem;
            cursor: pointer; transition: all 0.2s ease; border: 1px solid var(--border);
            display: flex; align-items: center; gap: 1rem; position: relative; overflow: hidden;
        }
        .result-card::after {
            content: ''; position: absolute; left: 0; top: 0; bottom: 0;
            width: 3px; background: var(--navy-400); opacity: 0; transition: opacity 0.2s;
        }
        .result-card:hover { transform: translateY(-2px); border-color: var(--border-glow); box-shadow: 0 10px 30px rgba(0,0,0,0.25); }
        .result-card:hover::after { opacity: 1; }
        .result-card.pay-avance::after { background: var(--amber); }
        .result-card.pay-sans::after   { background: var(--rose); }
        .result-card.pay-paye::after   { background: var(--green); }

        .result-avatar {
            width: 2.75rem; height: 2.75rem;
            background: linear-gradient(135deg, var(--navy-500), var(--navy-600));
            border-radius: var(--radius-md); display: flex; align-items: center;
            justify-content: center; color: white; font-weight: 700; font-size: 1rem;
            flex-shrink: 0; box-shadow: 0 4px 12px rgba(58,91,140,0.3);
        }
        .result-avatar.pay-avance { background: linear-gradient(135deg, #92400e, #b45309); }
        .result-avatar.pay-sans   { background: linear-gradient(135deg, #9f1239, #be123c); }
        .result-avatar.pay-paye   { background: linear-gradient(135deg, #065f46, #047857); }

        .result-info { flex: 1; min-width: 0; }
        .result-name {
            font-weight: 600; font-size: 0.875rem; margin-bottom: 0.2rem;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: var(--text-primary);
        }
        .result-meta { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 0.25rem; }
        .meta-item {
            font-size: 0.68rem; color: var(--text-muted);
            font-family: 'DM Mono', monospace; display: flex; align-items: center; gap: 0.2rem;
        }
        .meta-item.invoice-num  { color: var(--amber); }
        .meta-item.place-name   { color: #22d3ee; }
        .meta-item.voiture-name { color: var(--teal); }
        .meta-item.pay-avance   { color: var(--amber); }
        .meta-item.pay-sans     { color: var(--rose); }
        .meta-item.pay-paye     { color: var(--green); }

        .result-actions { display: flex; gap: 0.25rem; opacity: 0; transition: opacity 0.2s ease; }
        .result-card:hover .result-actions { opacity: 1; }
        .action-btn {
            padding: 0.45rem 0.5rem; background: var(--bg-hover); border: 1px solid var(--border);
            border-radius: var(--radius-md); cursor: pointer; color: var(--text-secondary);
            transition: all 0.2s; font-size: 0.75rem; text-decoration: none;
            display: flex; align-items: center;
        }
        .action-btn.edit:hover   { background: var(--navy-500); border-color: var(--navy-400); color: white; }
        .action-btn.delete:hover { background: var(--rose); border-color: var(--rose); color: white; }

        .empty-state {
            background: var(--bg-card); border-radius: var(--radius-xl);
            border: 1px solid var(--border); text-align: center; padding: 3.5rem 2rem;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .empty-icon {
            width: 4.5rem; height: 4.5rem; background: var(--bg-hover); border-radius: var(--radius-xl);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 1.25rem; border: 1px solid var(--border);
        }
        .empty-icon i { font-size: 1.75rem; color: var(--text-muted); }
        .empty-state h3 { font-size: 1rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.5rem; }
        .empty-state p  { color: var(--text-muted); font-size: 0.8rem; margin-bottom: 1.5rem; }

        .hidden { display: none; }

        @keyframes fadeInUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeInUp 0.3s ease-out; }

        mark { background: rgba(90,127,176,0.25); color: var(--navy-300); padding: 0 0.15rem; border-radius: 0.2rem; }
        [data-theme="light"] mark { background: rgba(74,109,158,0.2); color: var(--navy-400); }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; padding: 1rem; }
        }
    </style>
</head>
<body>
<div class="app-container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon"><i class="fas fa-handshake"></i></div>
                <div class="logo-text"><h2>Coopérative</h2><p>GESTION · RÉSERVATION</p></div>
            </div>
        </div>
        <nav class="nav-menu">
            <a href="<%= request.getContextPath() %>/"             class="nav-item"><i class="fas fa-home"></i><span>Accueil</span></a>
            <a href="<%= request.getContextPath() %>/client/"      class="nav-item"><i class="fas fa-users"></i><span>Clients</span></a>
            <a href="<%= request.getContextPath() %>/reservation/"  class="nav-item"><i class="fas fa-calendar-check"></i><span>Réservations</span></a>
            <a href="<%= request.getContextPath() %>/reservation/search" class="nav-item active"><i class="fas fa-search"></i><span>Recherche</span></a>
        </nav>
    </aside>

    <!-- Main -->
    <main class="main-content">
        <%
            List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
            List<Voiture>     voitures     = (List<Voiture>)     request.getAttribute("voitures");
            String motCle  = (String) request.getAttribute("motCle");
            String critere = (String) request.getAttribute("critere");
            String payment = (String) request.getAttribute("payment");
            String idVoit  = (String) request.getAttribute("idVoit");
            if (critere == null || critere.isEmpty()) critere = "all";
            if (payment == null || payment.isEmpty()) payment = "all";
            if (idVoit  == null || idVoit.isEmpty())  idVoit  = "all";

            boolean hasResults = reservations != null && !reservations.isEmpty();
            boolean hasSearch  = (motCle != null && !motCle.isEmpty())
                    || !"all".equals(payment)
                    || !"all".equals(idVoit);
        %>

        <div class="top-bar">
            <div class="page-title">
                <h1>Rechercher une réservation</h1>
                <p>// voiture · place · nom · statut de paiement</p>
            </div>
            <!-- Bouton toggle thème -->
            <button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
                <i class="fas fa-moon" id="themeIcon"></i>
            </button>
        </div>

        <div class="search-card">
            <form action="<%= request.getContextPath() %>/reservation/search" method="get" id="searchForm">

                <input type="hidden" name="critere" id="critereInput" value="<%= critere %>">
                <input type="hidden" name="payment" id="paymentInput" value="<%= payment %>">
                <input type="hidden" name="idVoit"  id="idVoitInput"  value="<%= idVoit %>">

                <!-- ── Filtre Voiture ── -->
                <div class="filter-label"><i class="fas fa-car"></i> Filtrer par voiture</div>
                <div class="voiture-select-row">
                    <button type="button"
                            class="voiture-chip <%= "all".equals(idVoit) ? "active" : "" %>"
                            data-idvoit="all">
                        <i class="fas fa-list"></i> Toutes les voitures
                    </button>
                    <% if (voitures != null) {
                        for (Voiture v : voitures) { %>
                    <button type="button"
                            class="voiture-chip <%= v.getIdvoit().equals(idVoit) ? "active" : "" %>"
                            data-idvoit="<%= v.getIdvoit() %>">
                        <i class="fas fa-car-side"></i>
                        <%= v.getDesign() %>
                        <span class="badge-place"><%= v.getNbrplace() %> pl.</span>
                    </button>
                    <% } } %>
                </div>

                <!-- ── Filtre Critère ── -->
                <div class="filter-label"><i class="fas fa-filter"></i> Critère de recherche</div>
                <div class="search-tabs">
                    <button type="button" class="tab-btn all <%= "all".equals(critere) ? "active" : "" %>" data-critere="all">
                        <i class="fas fa-border-all"></i> Tous
                    </button>
                    <button type="button" class="tab-btn place <%= "place".equals(critere) ? "active" : "" %>" data-critere="place">
                        <i class="fas fa-map-marker-alt"></i> Place
                    </button>
                    <button type="button" class="tab-btn name <%= "nom".equals(critere) ? "active" : "" %>" data-critere="nom">
                        <i class="fas fa-user"></i> Nom
                    </button>
                    <button type="button" class="tab-btn invoice <%= "facture".equals(critere) ? "active" : "" %>" data-critere="facture">
                        <i class="fas fa-file-invoice"></i> N° Facture
                    </button>
                </div>

                <!-- ── Filtre Paiement ── -->
                <div class="filter-label"><i class="fas fa-credit-card"></i> Statut de paiement</div>
                <div class="payment-tabs">
                    <button type="button" class="payment-btn p-all    <%= "all"        .equals(payment) ? "active" : "" %>" data-payment="all">
                        <i class="fas fa-list"></i> Tous
                    </button>
                    <button type="button" class="payment-btn p-avance <%= "avec avance".equals(payment) ? "active" : "" %>" data-payment="avec avance">
                        <i class="fas fa-hourglass-half"></i> Avec avance
                    </button>
                    <button type="button" class="payment-btn p-sans   <%= "sans avance".equals(payment) ? "active" : "" %>" data-payment="sans avance">
                        <i class="fas fa-times-circle"></i> Sans avance
                    </button>
                    <button type="button" class="payment-btn p-paye   <%= "tout payé"  .equals(payment) ? "active" : "" %>" data-payment="tout payé">
                        <i class="fas fa-check-circle"></i> Tout payé
                    </button>
                </div>

                <!-- ── Input ── -->
                <div class="search-input-area">
                    <i class="fas fa-search icon-left" id="inputIcon"></i>
                    <input type="text" name="motCle" id="searchInput" class="search-input"
                           placeholder="Saisissez votre recherche..."
                           value="<%= motCle != null ? motCle : "" %>" autofocus>
                    <button type="button" id="clearBtn"
                            class="clear-btn <%= (motCle == null || motCle.isEmpty()) ? "hidden" : "" %>">
                        <i class="fas fa-times-circle"></i>
                    </button>
                </div>

                <div class="search-hint">
                    <span class="dot"></span>
                    <span id="hintText">Recherche sur tous les champs : place, nom client, numéro de réservation</span>
                </div>

                <div class="search-actions">
                    <div class="suggestions" id="suggestionsZone"></div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Rechercher
                    </button>
                </div>
            </form>
        </div>

        <!-- ═══ Résultats ═══ -->
        <% if (hasSearch) { %>
        <div class="results-header animate-in">
            <div style="display:flex; align-items:center; gap:0.75rem; flex-wrap:wrap;">
                <div class="result-badge">
                    <i class="fas fa-layer-group"></i>
                    <span class="count"><%= reservations != null ? reservations.size() : 0 %></span>
                    résultat<%= (reservations != null && reservations.size() > 1) ? "s" : "" %>
                    <% if (motCle != null && !motCle.isEmpty()) { %>
                    &nbsp;· "<span class="keyword"><%= motCle %></span>"
                    <% } %>
                </div>

                <%-- Badge voiture --%>
                <% if (!"all".equals(idVoit) && voitures != null) {
                    String vNom = idVoit;
                    for (Voiture v : voitures) { if (v.getIdvoit().equals(idVoit)) { vNom = v.getDesign(); break; } }
                %>
                <div class="voit-badge"><i class="fas fa-car-side"></i> <%= vNom %></div>
                <% } %>

                <%-- Badge critère --%>
                <%
                    String modeLbl="Tous les critères", modeIcon="border-all", modeCls="all";
                    if ("place"  .equals(critere)) { modeLbl="Place";      modeIcon="map-marker-alt"; modeCls="place";   }
                    if ("nom"    .equals(critere)) { modeLbl="Nom";        modeIcon="user";           modeCls="name";    }
                    if ("facture".equals(critere)) { modeLbl="N° Facture"; modeIcon="file-invoice";   modeCls="invoice"; }
                %>
                <div class="mode-badge <%= modeCls %>"><i class="fas fa-<%= modeIcon %>"></i> <%= modeLbl %></div>

                <%-- Badge paiement --%>
                <% if (!"all".equals(payment)) {
                    String payCls="avance", payIcon2="hourglass-half";
                    if ("sans avance".equals(payment)) { payCls="sans"; payIcon2="times-circle"; }
                    if ("tout payé" .equals(payment))  { payCls="paye"; payIcon2="check-circle"; }
                %>
                <div class="pay-badge <%= payCls %>"><i class="fas fa-<%= payIcon2 %>"></i> <%= payment %></div>
                <% } %>
            </div>
        </div>

        <% if (hasResults) { %>
        <div class="results-grid animate-in">
            <%
                for (Reservation r : reservations) {
                    String nomDisplay     = r.getNomClient() != null ? r.getNomClient() : "";
                    String placeDisplay   = String.valueOf(r.getPlace());
                    String factureDisplay = r.getIdreserv() != null ? r.getIdreserv() : "";
                    String voitDisplay    = r.getDesignVoiture() != null ? r.getDesignVoiture() : r.getIdvoit();

                    if (motCle != null && !motCle.isEmpty()) {
                        String escaped = motCle.replaceAll("([.*+?^=!:${}()|\\[\\]/\\\\])", "\\\\$1");
                        String regex   = "(?i)(" + escaped + ")";
                        nomDisplay     = nomDisplay    .replaceAll(regex, "<mark>$1</mark>");
                        placeDisplay   = placeDisplay  .replaceAll(regex, "<mark>$1</mark>");
                        factureDisplay = factureDisplay.replaceAll(regex, "<mark>$1</mark>");
                    }

                    String initial  = (r.getNomClient() != null && !r.getNomClient().isEmpty())
                            ? r.getNomClient().substring(0,1).toUpperCase() : "?";
                    String pay      = r.getPayment() != null ? r.getPayment() : "";
                    String cardCls  = "avec avance".equals(pay) ? "pay-avance"
                            : "sans avance".equals(pay) ? "pay-sans"
                              : "tout payé" .equals(pay) ? "pay-paye" : "";
                    String payIcon3 = "avec avance".equals(pay) ? "hourglass-half"
                            : "sans avance".equals(pay) ? "times-circle"
                              : "tout payé" .equals(pay) ? "check-circle" : "question-circle";
            %>
            <div class="result-card <%= cardCls %>"
                 onclick="window.location.href='<%= request.getContextPath() %>/reservation/edit?id=<%= r.getIdreserv() %>'">
                <div class="result-avatar <%= cardCls %>"><%= initial %></div>
                <div class="result-info">
                    <div class="result-name"><%= nomDisplay %></div>
                    <div class="result-meta">
                        <span class="meta-item voiture-name">
                            <i class="fas fa-car-side"></i> <%= voitDisplay %>
                        </span>
                        <span class="meta-item place-name">
                            <i class="fas fa-map-marker-alt"></i> Place <%= placeDisplay %>
                        </span>
                        <span class="meta-item invoice-num">
                            <i class="fas fa-file-invoice"></i> <%= factureDisplay %>
                        </span>
                        <span class="meta-item">
                            <i class="fas fa-calendar"></i> <%= r.getDateReserv() %>
                        </span>
                        <span class="meta-item <%= cardCls %>">
                            <i class="fas fa-<%= payIcon3 %>"></i> <%= pay.isEmpty() ? "—" : pay %>
                        </span>
                    </div>
                </div>
                <div class="result-actions">
                    <a href="<%= request.getContextPath() %>/reservation/edit?id=<%= r.getIdreserv() %>"
                       class="action-btn edit" onclick="event.stopPropagation()" title="Modifier">
                        <i class="fas fa-edit"></i>
                    </a>
                    <a href="<%= request.getContextPath() %>/reservation/delete?id=<%= r.getIdreserv() %>"
                       class="action-btn delete"
                       onclick="event.stopPropagation(); return confirm('Supprimer cette réservation ?')"
                       title="Supprimer">
                        <i class="fas fa-trash"></i>
                    </a>
                </div>
            </div>
            <% } %>
        </div>

        <% } else { %>
        <div class="empty-state animate-in">
            <div class="empty-icon"><i class="fas fa-calendar-times"></i></div>
            <h3>Aucune réservation trouvée</h3>
            <p>Aucun résultat pour les filtres sélectionnés</p>
            <a href="<%= request.getContextPath() %>/reservation/new" class="btn btn-primary">
                <i class="fas fa-plus"></i> Nouvelle réservation
            </a>
        </div>
        <% } %>

        <% } else { %>
        <div class="empty-state">
            <div class="empty-icon"><i class="fas fa-search"></i></div>
            <h3>Commencez votre recherche</h3>
            <p>Sélectionnez une voiture, un statut de paiement ou saisissez un mot-clé</p>
        </div>
        <% } %>
    </main>
</div>

<script>
    /* ================================================================
       1. TOGGLE THÈME — synchronisé avec localStorage
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

        applyTheme(localStorage.getItem('theme') || 'dark');

        btn.addEventListener('click', function () {
            var current = localStorage.getItem('theme') || 'dark';
            var next = current === 'dark' ? 'light' : 'dark';
            localStorage.setItem('theme', next);
            applyTheme(next);
        });
    })();

    /* ================================================================
       2. LOGIQUE DE RECHERCHE
    ================================================================ */
    const searchInputEl   = document.getElementById('searchInput');
    const clearBtn        = document.getElementById('clearBtn');
    const critereInput    = document.getElementById('critereInput');
    const paymentInput    = document.getElementById('paymentInput');
    const idVoitInput     = document.getElementById('idVoitInput');
    const hintText        = document.getElementById('hintText');
    const suggestionsZone = document.getElementById('suggestionsZone');
    const tabBtns         = document.querySelectorAll('.tab-btn');
    const paymentBtns     = document.querySelectorAll('.payment-btn');
    const voitureBtns     = document.querySelectorAll('.voiture-chip');

    const critereConfig = {
        all:     { placeholder: 'Nom, place ou numéro de réservation...', hint: 'Recherche sur tous les champs', suggestions: ['Jean','Marie','RES'], icon: 'fa-border-all' },
        place:   { placeholder: 'Ex : 1, 2, 3...', hint: 'Recherche sur le numéro de place', suggestions: ['1','2','3','4','5'], icon: 'fa-map-marker-alt' },
        nom:     { placeholder: 'Nom ou prénom du client...', hint: 'Recherche sur le nom du client', suggestions: ['Jean','Marie','Pierre','Sophie'], icon: 'fa-user' },
        facture: { placeholder: 'Ex : RES1234567890...', hint: 'Recherche sur le numéro de réservation', suggestions: ['RES'], icon: 'fa-file-invoice' }
    };

    function applyConfig(critere) {
        const cfg = critereConfig[critere] || critereConfig.all;
        searchInputEl.placeholder = cfg.placeholder;
        hintText.textContent      = cfg.hint;
        suggestionsZone.innerHTML = '';
        cfg.suggestions.forEach(s => {
            const chip = document.createElement('span');
            chip.className = 'suggestion-chip';
            chip.textContent = s;
            chip.addEventListener('click', () => {
                searchInputEl.value = s;
                clearBtn.classList.remove('hidden');
                document.getElementById('searchForm').submit();
            });
            suggestionsZone.appendChild(chip);
        });
        document.getElementById('inputIcon').className = `fas ${cfg.icon} icon-left`;
    }

    // Tabs critère
    tabBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            tabBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            critereInput.value = this.dataset.critere;
            applyConfig(this.dataset.critere);
            searchInputEl.focus();
        });
    });

    // Tabs paiement → soumet immédiatement
    paymentBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            paymentBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            paymentInput.value = this.dataset.payment;
            document.getElementById('searchForm').submit();
        });
    });

    // Chips voiture → soumet immédiatement
    voitureBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            voitureBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            idVoitInput.value = this.dataset.idvoit;
            document.getElementById('searchForm').submit();
        });
    });

    searchInputEl.addEventListener('input', function () {
        clearBtn.classList.toggle('hidden', this.value.length === 0);
    });

    clearBtn.addEventListener('click', function () {
        searchInputEl.value = '';
        searchInputEl.focus();
        this.classList.add('hidden');
    });

    document.addEventListener('keydown', e => {
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            searchInputEl?.focus();
        }
    });

    applyConfig(critereInput.value || 'all');
</script>
</body>
</html>
