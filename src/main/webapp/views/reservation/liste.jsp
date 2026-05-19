<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg   = (String) session.getAttribute("errorMessage");
    String warningMsg = (String) session.getAttribute("warningMessage");
    String infoMsg    = (String) session.getAttribute("infoMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
    session.removeAttribute("warningMessage");
    session.removeAttribute("infoMessage");

    String safeSuccess = successMsg != null ? successMsg.replace("\\", "\\\\").replace("'", "\\'").replace("\n", " ") : "";
    String safeError   = errorMsg   != null ? errorMsg  .replace("\\", "\\\\").replace("'", "\\'").replace("\n", " ") : "";
    String safeWarning = warningMsg != null ? warningMsg.replace("\\", "\\\\").replace("'", "\\'").replace("\n", " ") : "";
    String safeInfo    = infoMsg    != null ? infoMsg   .replace("\\", "\\\\").replace("'", "\\'").replace("\n", " ") : "";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Réservations — Coopérative</title>

    <%-- ══ ANTI-FLASH : doit être le premier script ══ --%>
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

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

            --radius-sm: 0.375rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;

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
            font-family: 'Segoe UI', 'Inter', sans-serif;
            background: var(--bg-deep);
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
            overflow-y: auto;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }
        .logo { display: flex; align-items: center; gap: .75rem; }
        .logo-icon {
            width: 2.25rem; height: 2.25rem;
            background: linear-gradient(135deg, var(--navy-400), var(--navy-600));
            border-radius: .5rem;
            display: flex; align-items: center; justify-content: center;
        }
        .logo-icon i { font-size: 1.25rem; color: #fff; }
        .logo-text h2 { font-size: 1.125rem; font-weight: 600; color: var(--text-primary); }
        .logo-text p  { font-size: .7rem; color: var(--text-muted); }
        .nav-menu { padding: 1.5rem; display: flex; flex-direction: column; gap: .5rem; }
        .nav-item {
            display: flex; align-items: center; gap: .75rem;
            padding: .75rem 1rem; border-radius: .75rem;
            color: var(--text-secondary); text-decoration: none; transition: all .2s;
        }
        .nav-item i { width: 1.25rem; font-size: 1rem; }
        .nav-item:hover  { background: var(--bg-hover); color: var(--text-primary); }
        .nav-item.active { background: var(--bg-card); color: var(--navy-300); border-left: 3px solid var(--navy-400); }

        /* ── Main ── */
        .main-content { flex: 1; margin-left: 280px; padding: 2rem; }

        /* ── Page header ── */
        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 1.5rem;
        }
        .page-title { font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; gap: .5rem; color: var(--text-primary); }
        .page-title i { color: var(--navy-400); }
        .page-subtitle { color: var(--text-muted); font-size: .85rem; margin-top: 4px; }

        .header-right { display: flex; align-items: center; gap: .75rem; }

        /* ── Bouton toggle thème ── */
        .theme-btn {
            width: 2.5rem; height: 2.5rem;
            border-radius: .75rem;
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

        .btn-new {
            display: inline-flex; align-items: center; gap: .5rem;
            padding: .6rem 1.25rem;
            background: var(--navy-500); color: #fff;
            border-radius: 8px; text-decoration: none;
            font-weight: 600; font-size: .875rem;
            transition: background .2s;
        }
        .btn-new:hover { background: var(--navy-400); }

        /* ── Search panel ── */
        .search-panel {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.25rem;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .search-panel form { display: flex; flex-wrap: wrap; gap: .75rem; align-items: flex-end; }
        .sf { display: flex; flex-direction: column; gap: 4px; }
        .sf label { font-size: .75rem; font-weight: 600; color: var(--text-secondary); }
        .sf select,
        .sf input[type="text"],
        .sf input[type="date"] {
            height: 38px; padding: 0 12px;
            border: 1.5px solid var(--border); border-radius: 8px;
            font-size: .85rem;
            background: var(--bg-secondary);
            color: var(--text-primary);
            outline: none; transition: border-color .2s, background 0.3s ease;
        }
        [data-theme="light"] .sf select,
        [data-theme="light"] .sf input[type="text"],
        [data-theme="light"] .sf input[type="date"] {
            background: #ffffff;
        }
        .sf select:focus, .sf input:focus { border-color: var(--navy-400); }
        .sf.grow { flex: 1; min-width: 180px; }

        /* Checkboxes paiement */
        .pay-group { display: flex; align-items: center; gap: .4rem; flex-wrap: wrap; padding-top: 4px; }
        .pay-item {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 5px 11px;
            border: 1.5px solid var(--border); border-radius: 8px;
            cursor: pointer; font-size: .8rem; font-weight: 500;
            background: var(--bg-secondary); color: var(--text-secondary);
            transition: all .15s; user-select: none;
        }
        .pay-item:hover { border-color: var(--navy-400); }
        .pay-item input { width: 14px; height: 14px; accent-color: var(--navy-400); cursor: pointer; }
        .pay-item.ck-green { border-color: var(--success); background: rgba(16,185,129,.15);  color: var(--success); }
        .pay-item.ck-amber { border-color: var(--warning); background: rgba(245,158,11,.15);  color: var(--warning); }
        .pay-item.ck-gray  { border-color: #888;           background: rgba(153,153,153,.1);  color: var(--text-muted); }

        .btn-search {
            height: 38px; padding: 0 20px;
            background: var(--navy-500); color: #fff;
            border: none; border-radius: 8px;
            font-weight: 700; font-size: .875rem;
            cursor: pointer; display: inline-flex; align-items: center; gap: 6px;
            transition: background .2s;
        }
        .btn-search:hover { background: var(--navy-400); }

        .btn-reset {
            height: 38px; padding: 0 16px;
            background: var(--bg-secondary); color: var(--text-secondary);
            border: 1.5px solid var(--border); border-radius: 8px;
            font-size: .85rem; cursor: pointer; text-decoration: none;
            display: inline-flex; align-items: center; gap: 5px;
            transition: all .2s;
        }
        .btn-reset:hover { background: var(--bg-hover); color: var(--text-primary); }

        .active-filters { display: flex; flex-wrap: wrap; gap: 6px; margin-top: .75rem; }
        .filter-tag {
            display: inline-flex; align-items: center; gap: 5px;
            background: var(--bg-secondary); color: var(--navy-300);
            font-size: .75rem; font-weight: 600; padding: 3px 11px;
            border-radius: 99px; border: 1px solid var(--border);
        }

        /* ── Stats ── */
        .stats-bar { display: flex; gap: .75rem; margin-bottom: 1.25rem; flex-wrap: wrap; }
        .stat-card {
            background: var(--bg-card); border: 1px solid var(--border); border-radius: 10px;
            padding: .75rem 1.25rem; display: flex; align-items: center; gap: .75rem;
            flex: 1; min-width: 140px;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .stat-icon {
            width: 2rem; height: 2rem; border-radius: 8px;
            display: flex; align-items: center; justify-content: center; font-size: .9rem;
        }
        .stat-icon.blue  { background: rgba(74,109,158,.2); color: var(--navy-300); }
        .stat-icon.green { background: rgba(16,185,129,.2); color: var(--success); }
        .stat-icon.amber { background: rgba(245,158,11,.2); color: var(--warning); }
        .stat-icon.red   { background: rgba(239,68,68,.2);  color: var(--error); }
        .stat-info p      { font-size: .7rem; color: var(--text-muted); }
        .stat-info strong { font-size: 1.1rem; font-weight: 700; color: var(--text-primary); }

        /* ── Table ── */
        .table-card {
            background: var(--bg-card); border: 1px solid var(--border); border-radius: 12px;
            overflow: hidden;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .table-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 1rem 1.5rem; border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }
        .table-title { font-weight: 700; font-size: 1rem; color: var(--text-primary); }
        .badge {
            background: var(--bg-secondary); color: var(--navy-300);
            font-size: .75rem; font-weight: 700; padding: 3px 12px; border-radius: 99px;
        }
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; font-size: .875rem; }
        thead th {
            background: var(--bg-secondary); color: var(--text-primary); font-weight: 700;
            padding: 10px 14px; text-align: left;
            border-bottom: 2px solid var(--border); white-space: nowrap;
            transition: background 0.3s ease;
        }
        tbody tr { border-bottom: 1px solid var(--border); transition: background .15s; }
        tbody tr:hover { background: var(--bg-hover); }
        tbody td { padding: 9px 14px; vertical-align: middle; color: var(--text-primary); }

        .pill { display: inline-block; padding: 2px 10px; border-radius: 99px; font-size: .75rem; font-weight: 700; }
        .pill-green { background: rgba(16,185,129,.15); color: var(--success); }
        .pill-amber { background: rgba(245,158,11,.15);  color: var(--warning); }
        .pill-gray  { background: rgba(153,153,153,.15); color: var(--text-muted); }

        .id-badge {
            font-family: monospace; font-size: .75rem;
            background: var(--bg-secondary); padding: 2px 8px;
            border-radius: 6px; color: var(--navy-300);
        }

        .actions { display: flex; gap: 6px; }
        .btn-icon {
            width: 30px; height: 30px; border: none; border-radius: 6px;
            cursor: pointer; display: flex; align-items: center; justify-content: center;
            font-size: .85rem; transition: all .15s; text-decoration: none;
        }
        .btn-icon.print { background: rgba(74,109,158,.15); color: var(--navy-300); }
        .btn-icon.edit  { background: rgba(245,158,11,.15); color: var(--warning); }
        .btn-icon.del   { background: rgba(239,68,68,.15);  color: var(--error); }
        .btn-icon:hover { opacity: .8; transform: scale(1.1); }

        .empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
        .empty-state i { font-size: 2.5rem; margin-bottom: .75rem; display: block; }

        /* ── Toast ── */
        .toast-container {
            position: fixed; top: 1.5rem; right: 1.5rem;
            z-index: 9999;
            display: flex; flex-direction: column; gap: 0.75rem;
            max-width: 420px; width: 100%;
            pointer-events: none;
        }
        .toast {
            position: relative; overflow: hidden;
            background: var(--bg-card); border: 1px solid var(--border);
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
            display: flex; align-items: center; justify-content: center; font-size: 0.9rem;
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
            padding: 0.25rem; border-radius: var(--radius-sm); font-size: 0.75rem; line-height: 1;
            transition: color .15s, background .15s;
            display: flex; align-items: center; justify-content: center;
        }
        .toast-close:hover { color: var(--text-primary); background: var(--bg-hover); }
        .toast-progress {
            position: absolute; bottom: 0; left: 0; height: 3px;
            border-radius: 0 0 0 var(--radius-lg);
            animation: toastProgress linear forwards;
        }
        .toast-success .toast-progress { background: var(--success); }
        .toast-error   .toast-progress { background: var(--error); }
        .toast-warning .toast-progress { background: var(--warning); }
        .toast-info    .toast-progress { background: var(--info); }

        @keyframes toastSlideIn  { from{opacity:0;transform:translateX(110%)} to{opacity:1;transform:translateX(0)} }
        @keyframes toastSlideOut { from{opacity:1;transform:translateX(0);max-height:120px} to{opacity:0;transform:translateX(110%);max-height:0;padding-top:0;padding-bottom:0;border-width:0} }
        @keyframes toastProgress { from{width:100%} to{width:0%} }

        /* ── Modal suppression ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.7);
            z-index: 1000; align-items: center; justify-content: center;
        }
        .modal-overlay.open { display: flex; animation: fadeIn .2s ease; }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        .modal-box {
            background: var(--bg-card); border: 1px solid var(--border); border-radius: 12px;
            padding: 2rem; max-width: 400px; width: 90%; text-align: center;
            box-shadow: var(--shadow-xl);
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .modal-icon  { font-size: 2.5rem; margin-bottom: 1rem; color: var(--error); }
        .modal-title { font-size: 1.1rem; font-weight: 700; margin-bottom: .5rem; color: var(--text-primary); }
        .modal-msg   { font-size: .875rem; color: var(--text-secondary); margin-bottom: 1.5rem; }
        .modal-actions { display: flex; gap: .75rem; justify-content: center; }
        .modal-btn { padding: .6rem 1.5rem; border-radius: 8px; font-weight: 600; font-size: .875rem; cursor: pointer; border: none; transition: all .2s; }
        .modal-btn-cancel  { background: var(--bg-secondary); color: var(--text-secondary); border: 1px solid var(--border); }
        .modal-btn-cancel:hover  { background: var(--bg-hover); color: var(--text-primary); }
        .modal-btn-confirm { background: var(--error); color: #fff; }
        .modal-btn-confirm:hover { background: #dc2626; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; }
            .toast-container { left: 1rem; right: 1rem; max-width: none; }
        }
    </style>
</head>
<body>

<!-- Toast container -->
<div class="toast-container" id="toastContainer"></div>

<!-- Modal confirmation suppression -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal-box">
        <div class="modal-icon"><i class="fas fa-trash-alt"></i></div>
        <div class="modal-title">Confirmer la suppression</div>
        <div class="modal-msg">Êtes-vous sûr de vouloir supprimer cette réservation ? Cette action est irréversible.</div>
        <div class="modal-actions">
            <button class="modal-btn modal-btn-cancel" onclick="closeDeleteModal()">
                <i class="fas fa-times"></i> Annuler
            </button>
            <a id="deleteConfirmLink" href="#" class="modal-btn modal-btn-confirm">
                <i class="fas fa-trash"></i> Supprimer
            </a>
        </div>
    </div>
</div>

<div class="app-container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon"><i class="fas fa-handshake"></i></div>
                <div class="logo-text"><h2>Coopérative</h2><p>Gestion Client</p></div>
            </div>
        </div>
        <nav class="nav-menu">
            <span class="nav-label">Navigation</span>
            <a href="<%= request.getContextPath() %>/" class="nav-item">
                <i class="fas fa-home"></i><span>Accueil</span>
            </a>
            <a href="<%= request.getContextPath() %>/voiture/" class="nav-item">
                <i class="fas fa-van-shuttle"></i><span>Voitures</span>
            </a>
            <a href="<%= request.getContextPath() %>/client/" class="nav-item">
                <i class="fas fa-users"></i><span>Clients</span>
            </a>
            <a href="<%= request.getContextPath() %>/reservation/" class="nav-item active">
                <i class="fas fa-calendar-check"></i><span>Réservations</span>
            </a>
            <a href="<%= request.getContextPath() %>/rapport/" class="nav-item">
                <i class="fas fa-chart-bar"></i><span>Rapports</span>
            </a>

        </nav>
    </aside>

    <main class="main-content">

        <!-- En-tête -->
        <div class="page-header">
            <div>
                <div class="page-title"><i class="fas fa-calendar-check"></i> Réservations</div>
                <p class="page-subtitle">Gérez et suivez toutes les réservations</p>
            </div>
            <div class="header-right">
                <!-- Bouton toggle thème -->
                <button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
                    <i class="fas fa-moon" id="themeIcon"></i>
                </button>
                <a href="${pageContext.request.contextPath}/reservation/new" class="btn-new">
                    <i class="fas fa-plus"></i> Nouvelle réservation
                </a>
            </div>
        </div>

        <!-- Barre de recherche avancée -->
        <div class="search-panel">
            <form method="get" action="${pageContext.request.contextPath}/reservation/search">

                <div class="sf">
                    <label>🚐 Véhicule</label>
                    <select name="idVoit">
                        <option value="all">— Tous —</option>
                        <c:forEach var="v" items="${voitures}">
                            <option value="${v.idvoit}" <c:if test="${idVoit == v.idvoit}">selected</c:if>>
                                    ${v.design}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="sf">
                    <label>📅 Date départ</label>
                    <input type="date" name="dateVoyage" value="${dateVoyage}" />
                </div>

                <div class="sf">
                    <label>🔎 Rechercher par</label>
                    <select name="critere" id="critere" onchange="majPlaceholder()">
                        <option value="all"     <c:if test="${critere=='all' || empty critere}">selected</c:if>>— Tous champs —</option>
                        <option value="nom"     <c:if test="${critere=='nom'}">selected</c:if>>👤 Nom client</option>
                        <option value="facture" <c:if test="${critere=='facture'}">selected</c:if>>🧾 N° Facture</option>
                        <option value="place"   <c:if test="${critere=='place'}">selected</c:if>> N° Place</option>
                    </select>
                </div>

                <div class="sf grow">
                    <label id="lbl-motcle">Valeur</label>
                    <input type="text" name="motCle" id="motCle" value="${motCle}"
                           placeholder="Nom, numéro de réservation, place…" />
                </div>

                <div class="sf">
                    <label>💳 Paiement</label>
                    <div class="pay-group">
                        <label class="pay-item ${paiementToutPaye   ? 'ck-green' : ''}" id="lbl-green">
                            <input type="checkbox" name="payment" value="tout payé"
                            ${paiementToutPaye   ? 'checked' : ''}
                                   onchange="toggleCk(this,'lbl-green','ck-green')" />
                            ✅ Tout payé
                        </label>
                        <label class="pay-item ${paiementAvecAvance ? 'ck-amber' : ''}" id="lbl-amber">
                            <input type="checkbox" name="payment" value="avec avance"
                            ${paiementAvecAvance ? 'checked' : ''}
                                   onchange="toggleCk(this,'lbl-amber','ck-amber')" />
                            ⚠️ Avec avance
                        </label>
                        <label class="pay-item ${paiementSansAvance ? 'ck-gray'  : ''}" id="lbl-gray">
                            <input type="checkbox" name="payment" value="sans avance"
                            ${paiementSansAvance ? 'checked' : ''}
                                   onchange="toggleCk(this,'lbl-gray','ck-gray')" />
                            ❌ Sans avance
                        </label>
                    </div>
                </div>

                <div class="sf" style="flex-direction:row;gap:8px;align-items:flex-end;">
                    <button type="submit" class="btn-search"><i class="fas fa-search"></i> Rechercher</button>
                    <a href="${pageContext.request.contextPath}/reservation/" class="btn-reset">✕ Réinitialiser</a>
                </div>
            </form>

            <!-- Filtres actifs -->
            <c:if test="${(not empty idVoit && idVoit != 'all') || not empty dateVoyage || not empty motCle || paiementToutPaye || paiementAvecAvance || paiementSansAvance}">
                <div class="active-filters">
                    <c:if test="${not empty idVoit && idVoit != 'all'}">
                        <div class="filter-tag">🚐 Voiture : <strong>${idVoit}</strong></div>
                    </c:if>
                    <c:if test="${not empty dateVoyage}">
                        <div class="filter-tag">📅 Départ : <strong>${dateVoyage}</strong></div>
                    </c:if>
                    <c:if test="${not empty motCle}">
                        <div class="filter-tag">🔎 <strong>${motCle}</strong></div>
                    </c:if>
                    <c:if test="${paiementToutPaye}">
                        <div class="filter-tag">✅ Tout payé</div>
                    </c:if>
                    <c:if test="${paiementAvecAvance}">
                        <div class="filter-tag">⚠️ Avec avance</div>
                    </c:if>
                    <c:if test="${paiementSansAvance}">
                        <div class="filter-tag">❌ Sans avance</div>
                    </c:if>
                </div>
            </c:if>
        </div>

        <!-- Stats -->
        <div class="stats-bar">
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-list"></i></div>
                <div class="stat-info"><p>Total affiché</p><strong>${reservations.size()}</strong></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                <div class="stat-info"><p>Tout payé</p>
                    <strong>
                        <c:set var="cntTout" value="0"/>
                        <c:forEach var="r" items="${reservations}">
                            <c:if test="${r.payment == 'tout payé'}"><c:set var="cntTout" value="${cntTout + 1}"/></c:if>
                        </c:forEach>
                        ${cntTout}
                    </strong>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon amber"><i class="fas fa-hourglass-half"></i></div>
                <div class="stat-info"><p>Avec avance</p>
                    <strong>
                        <c:set var="cntAvance" value="0"/>
                        <c:forEach var="r" items="${reservations}">
                            <c:if test="${r.payment == 'avec avance'}"><c:set var="cntAvance" value="${cntAvance + 1}"/></c:if>
                        </c:forEach>
                        ${cntAvance}
                    </strong>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon red"><i class="fas fa-times-circle"></i></div>
                <div class="stat-info"><p>Sans avance</p>
                    <strong>
                        <c:set var="cntSans" value="0"/>
                        <c:forEach var="r" items="${reservations}">
                            <c:if test="${r.payment == 'sans avance'}"><c:set var="cntSans" value="${cntSans + 1}"/></c:if>
                        </c:forEach>
                        ${cntSans}
                    </strong>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="table-card">
            <div class="table-header">
                <span class="table-title">Liste des réservations</span>
                <span class="badge">${reservations.size()} réservation(s)</span>
            </div>
            <div class="table-wrap">
                <c:choose>
                    <c:when test="${not empty reservations}">
                        <table>
                            <thead>
                            <tr>
                                <th>N° RÉSERVATION</th>
                                <th>CLIENT</th>
                                <th>VOITURE</th>
                                <th>PLACE</th>
                                <th>DATE VOYAGE</th>
                                <th>PAIEMENT</th>
                                <th>AVANCE</th>
                                <th>ACTIONS</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="r" items="${reservations}">
                                <tr>
                                    <td><span class="id-badge">${r.idreserv}</span></td>
                                    <td><strong>${r.nomClient}</strong></td>
                                    <td>${r.designVoiture}</td>
                                    <td>
                                        <c:set var="placesStr" value="${r.places}" />
                                        <c:if test="${not empty placesStr}">
                                             ${placesStr.replace(",", " &nbsp; ")}
                                        </c:if>
                                        <c:if test="${empty placesStr}">
                                             ${r.place}
                                        </c:if>
                                    </td>
                                    <td>${r.dateVoyage}</td>
                                    <td>
                                        <span class="pill
                                            <c:choose>
                                                <c:when test="${r.payment == 'tout payé'}">pill-green</c:when>
                                                <c:when test="${r.payment == 'avec avance'}">pill-amber</c:when>
                                                <c:otherwise>pill-gray</c:otherwise>
                                            </c:choose>">
                                                ${r.payment}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.payment == 'tout payé'}">
                                                ${r.montantAvance} Ar <span style="color:var(--text-muted);font-size:.75rem;">(Total)</span>
                                            </c:when>
                                            <c:when test="${r.payment == 'avec avance'}">
                                                ${r.montantAvance} Ar
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:var(--text-muted);">--</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/reservation/recu?id=${r.idreserv}"
                                               class="btn-icon print" title="Imprimer reçu">
                                                <i class="fas fa-print"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/reservation/edit?id=${r.idreserv}"
                                               class="btn-icon edit" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button
                                                    class="btn-icon del" title="Supprimer"
                                                    onclick="openDeleteModal('${pageContext.request.contextPath}/reservation/delete?id=${r.idreserv}')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-search"></i>
                            Aucune réservation ne correspond à cette recherche.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
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

    const toastManager = {
        container: document.getElementById('toastContainer'),

        _show(type, message, title, duration) {
            duration = duration || 5000;
            title    = title || TOAST_TITLES[type];
            const toast = document.createElement('div');
            toast.className = 'toast toast-' + type;
            toast.innerHTML =
                '<div class="toast-icon"><i class="' + TOAST_ICONS[type] + '"></i></div>' +
                '<div class="toast-body">' +
                '<div class="toast-title">' + title   + '</div>' +
                '<div class="toast-msg">'   + message + '</div>' +
                '</div>' +
                '<button class="toast-close" onclick="toastManager._dismiss(this.parentElement)" title="Fermer"><i class="fas fa-times"></i></button>' +
                '<div class="toast-progress" style="animation-duration:' + duration + 'ms"></div>';
            this.container.appendChild(toast);
            setTimeout(() => this._dismiss(toast), duration);
        },

        _dismiss(toast) {
            if (!toast || toast.classList.contains('toast-hiding')) return;
            toast.classList.add('toast-hiding');
            setTimeout(() => { if (toast.parentElement) toast.parentElement.removeChild(toast); }, 300);
        },

        success(msg, title, duration) { this._show('success', msg, title, duration); },
        error(msg,   title, duration) { this._show('error',   msg, title, duration); },
        warning(msg, title, duration) { this._show('warning', msg, title, duration); },
        info(msg,    title, duration) { this._show('info',    msg, title, duration); }
    };

    /* ================================================================
       3. MESSAGES FLASH DE SESSION
    ================================================================ */
    window.addEventListener('load', function () {
        <% if (!safeSuccess.isEmpty()) { %>
        toastManager.success('<%= safeSuccess %>', 'Succès', 6000);
        <% } %>
        <% if (!safeError.isEmpty()) { %>
        toastManager.error('<%= safeError %>', 'Erreur', 7000);
        <% } %>
        <% if (!safeWarning.isEmpty()) { %>
        toastManager.warning('<%= safeWarning %>', 'Attention', 6000);
        <% } %>
        <% if (!safeInfo.isEmpty()) { %>
        toastManager.info('<%= safeInfo %>', 'Information', 5000);
        <% } %>
    });

    /* ================================================================
       4. MODAL SUPPRESSION
    ================================================================ */
    function openDeleteModal(deleteUrl) {
        document.getElementById('deleteConfirmLink').href = deleteUrl;
        document.getElementById('deleteModal').classList.add('open');
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.remove('open');
    }

    document.getElementById('deleteModal').addEventListener('click', function (e) {
        if (e.target === this) closeDeleteModal();
    });

    /* ================================================================
       5. RECHERCHE — PLACEHOLDER DYNAMIQUE
    ================================================================ */
    const placeholders = {
        nom:     'Ex : Rakoto, Jean…',
        facture: 'Ex : RES1234…',
        place:   'Ex : 3, 12…',
        all:     'Nom, numéro de réservation, place…'
    };

    function majPlaceholder() {
        const critere = document.getElementById('critere').value;
        const input   = document.getElementById('motCle');
        const lbl     = document.getElementById('lbl-motcle');
        input.placeholder = placeholders[critere] || placeholders['all'];
        const labels  = { nom: '👤 Nom client', facture: '🧾 N° Facture', place: ' N° Place', all: 'Valeur' };
        lbl.textContent = labels[critere] || 'Valeur';
    }

    function toggleCk(cb, lblId, cls) {
        document.getElementById(lblId).classList.toggle(cls, cb.checked);
    }

    majPlaceholder();
</script>
</body>
</html>
