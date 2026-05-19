<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cooperative.model.Client" %>
<%
    List<Client> clients = (List<Client>) request.getAttribute("clients");
    int totalClients = clients != null ? clients.size() : 0;
    String triActuel = (String) request.getAttribute("tri");
    if (triActuel == null) triActuel = "id";

    // Messages flash — depuis request attributes (mis par ClientServlet) ET session (fallback)
    String toastSuccess = (String) request.getAttribute("toastSuccess");
    String toastError   = (String) request.getAttribute("toastError");
    // Fallback session
    if (toastSuccess == null) toastSuccess = (String) session.getAttribute("successMessage");
    if (toastError   == null) toastError   = (String) session.getAttribute("errorMessage");
    String toastWarning = (String) session.getAttribute("warningMessage");
    String toastInfo    = (String) session.getAttribute("infoMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
    session.removeAttribute("warningMessage");
    session.removeAttribute("infoMessage");

    // Échappement JS sécurisé
    String jsSuccess = toastSuccess != null ? toastSuccess.replace("\\","\\\\").replace("'","\\'").replace("\n"," ") : "";
    String jsError   = toastError   != null ? toastError  .replace("\\","\\\\").replace("'","\\'").replace("\n"," ") : "";
    String jsWarning = toastWarning != null ? toastWarning.replace("\\","\\\\").replace("'","\\'").replace("\n"," ") : "";
    String jsInfo    = toastInfo    != null ? toastInfo   .replace("\\","\\\\").replace("'","\\'").replace("\n"," ") : "";
%>
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
    <title>Clients | Coopérative</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

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
            --error:   #ef4444;
            --warning: #f59e0b;
            --info:    #3b82f6;
            --radius-sm: 0.25rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --radius-xl: 1rem;
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.4);
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
            --error:   #dc2626;
            --warning: #d97706;
            --info:    #2563eb;
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.1);
            --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.14);
        }

        body {
            background: var(--bg-deep);
            color: var(--text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            font-size: 0.875rem;
            line-height: 1.5;
            min-height: 100vh;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .app-container { display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: 280px; background: var(--bg-primary);
            border-right: 1px solid var(--border);
            position: fixed; left: 0; top: 0; bottom: 0; z-index: 40;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .sidebar-header {
            padding: 1.5rem; border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }
        .logo { display: flex; align-items: center; gap: .75rem; }
        .logo-icon {
            width: 2.25rem; height: 2.25rem;
            background: linear-gradient(135deg, var(--navy-400), var(--navy-600));
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
        }
        .logo-icon i { font-size: 1.25rem; color: white; }
        .logo-text h2 { font-size: 1.125rem; font-weight: 600; color: var(--text-primary); }
        .logo-text p  { font-size: .7rem; color: var(--text-muted); }
        .nav-menu { padding: 1.5rem; display: flex; flex-direction: column; gap: .5rem; }
        .nav-item {
            display: flex; align-items: center; gap: .75rem;
            padding: .75rem 1rem; border-radius: var(--radius-lg);
            color: var(--text-secondary); text-decoration: none; transition: all .2s;
        }
        .nav-item i { width: 1.25rem; font-size: 1rem; }
        .nav-item:hover  { background: var(--bg-hover); color: var(--text-primary); }
        .nav-item.active { background: var(--bg-card); color: var(--navy-300); border-left: 3px solid var(--navy-400); }

        /* ── Main ── */
        .main-content { flex: 1; margin-left: 280px; padding: 1.5rem; }
        .top-bar {
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 1rem; margin-bottom: 2rem;
            padding-bottom: 1rem; border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }
        .page-title    { font-size: 1.375rem; font-weight: 700; color: var(--text-primary); }
        .page-subtitle { font-size: .75rem; color: var(--text-muted); margin-top: .125rem; }

        .top-bar-right { display: flex; align-items: center; gap: .75rem; }

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

        .toolbar { display: flex; align-items: center; gap: .75rem; flex-wrap: wrap; margin-bottom: 1.5rem; }
        .search-box { position: relative; flex: 1; min-width: 200px; }
        .search-box i {
            position: absolute; left: .75rem; top: 50%;
            transform: translateY(-50%); color: var(--text-muted); font-size: .8rem; pointer-events: none;
        }
        .search-input {
            width: 100%; padding: .5rem .75rem .5rem 2.25rem;
            background: var(--bg-secondary); border: 1px solid var(--border);
            border-radius: var(--radius-lg); color: var(--text-primary);
            font-size: .8125rem; font-family: inherit;
            transition: border-color .2s, box-shadow .2s, background 0.3s ease;
        }
        .search-input:focus {
            outline: none; border-color: var(--navy-500);
            box-shadow: 0 0 0 3px rgba(58,91,140,.15);
        }
        [data-theme="light"] .search-input { background: #ffffff; }

        /* ── Buttons ── */
        .btn {
            display: inline-flex; align-items: center; gap: .4rem;
            padding: .5rem 1rem; font-size: .8125rem; font-weight: 500;
            border-radius: var(--radius-lg); cursor: pointer;
            transition: all .2s; border: 1px solid transparent;
            text-decoration: none; font-family: inherit;
        }
        .btn-primary   { background: var(--navy-500); color: white; }
        .btn-primary:hover   { background: var(--navy-400); transform: translateY(-1px); }
        .btn-primary:disabled { opacity: .6; cursor: not-allowed; transform: none; }
        .btn-secondary { background: var(--bg-secondary); color: var(--text-secondary); border-color: var(--border); }
        .btn-secondary:hover { background: var(--bg-hover); color: var(--text-primary); }
        .btn-danger    { background: rgba(239,68,68,.15); color: var(--error); border-color: rgba(239,68,68,.3); }
        .btn-danger:hover    { background: var(--error); color: white; }
        .btn-ghost     { background: transparent; border: none; padding: .4rem; }
        .btn-icon      { width: 2rem; height: 2rem; justify-content: center; padding: 0; }

        .badge {
            display: inline-flex; align-items: center;
            padding: .2rem .5rem; background: var(--bg-secondary);
            border: 1px solid var(--border); border-radius: var(--radius-sm);
            font-size: .7rem; font-weight: 600; color: var(--navy-300); font-family: monospace;
            transition: background 0.3s ease;
        }
        .avatar {
            width: 2rem; height: 2rem; min-width: 2rem;
            background: linear-gradient(135deg, var(--navy-500), var(--navy-600));
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: .75rem; color: white;
        }

        /* ── Table ── */
        .table-container {
            background: var(--bg-card); border: 1px solid var(--border);
            border-radius: var(--radius-xl); overflow: hidden;
            transition: background 0.3s ease, border-color 0.3s ease;
        }
        .table { width: 100%; border-collapse: collapse; }
        .table thead tr {
            background: var(--bg-secondary); border-bottom: 1px solid var(--border);
            transition: background 0.3s ease;
        }
        .table th {
            padding: .75rem 1rem; text-align: left;
            font-size: .7rem; font-weight: 600; text-transform: uppercase; color: var(--text-muted);
        }
        .table td { padding: .75rem 1rem; border-bottom: 1px solid rgba(42,47,74,.5); color: var(--text-primary); }
        [data-theme="light"] .table td { border-bottom: 1px solid var(--border); }
        .table tbody tr:last-child td { border-bottom: none; }
        .table tbody tr { transition: background .15s; }
        .table tbody tr:hover { background: var(--bg-hover); }

        .empty-state { text-align: center; padding: 3rem 2rem; color: var(--text-muted); }
        .empty-icon {
            width: 4rem; height: 4rem; background: var(--bg-secondary); border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; margin: 0 auto 1rem; color: var(--text-muted);
        }
        .stats-strip   { display: flex; gap: 1rem; align-items: center; }
        .stats-count {
            font-size: .75rem; color: var(--text-muted);
            background: var(--bg-secondary); border: 1px solid var(--border);
            border-radius: var(--radius-md); padding: .25rem .75rem;
            transition: background 0.3s ease;
        }
        .stats-count strong { color: var(--text-primary); }

        /* ── Modals ── */
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,.7);
            backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 1000; opacity: 0; pointer-events: none;
            transition: opacity .25s; padding: 1rem;
        }
        .modal-overlay.active { opacity: 1; pointer-events: auto; }
        .modal {
            background: var(--bg-card); border: 1px solid var(--border);
            border-radius: var(--radius-xl); width: 100%; max-width: 460px;
            transform: translateY(16px) scale(.97); transition: transform .25s, background 0.3s ease, border-color 0.3s ease;
            box-shadow: var(--shadow-xl); overflow: hidden;
        }
        .modal-overlay.active .modal { transform: translateY(0) scale(1); }
        .modal-header {
            padding: 1.25rem 1.5rem 0;
            display: flex; align-items: center; gap: .75rem;
        }
        .modal-header h3 { font-size: 1rem; font-weight: 600; color: var(--text-primary); }
        .modal-icon {
            width: 2.5rem; height: 2.5rem; min-width: 2.5rem;
            border-radius: var(--radius-lg); background: rgba(239,68,68,.15);
            display: flex; align-items: center; justify-content: center;
            color: var(--error); font-size: 1rem;
        }
        .modal-body { padding: 1rem 1.5rem; color: var(--text-secondary); font-size: .875rem; line-height: 1.6; }
        .modal-footer { padding: 1rem 1.5rem 1.25rem; display: flex; justify-content: flex-end; gap: .75rem; }
        .modal-field-label { display: block; font-size: .75rem; font-weight: 600; margin-bottom: .4rem; color: var(--text-secondary); }
        .modal-input {
            width: 100%; padding: .625rem .875rem; background: var(--bg-secondary);
            border: 1px solid var(--border); border-radius: var(--radius-md);
            color: var(--text-primary); font-size: .875rem; font-family: inherit;
            transition: border-color .2s, box-shadow .2s, background 0.3s ease;
        }
        [data-theme="light"] .modal-input { background: #ffffff; }
        .modal-input:focus { outline: none; border-color: var(--navy-500); box-shadow: 0 0 0 3px rgba(58,91,140,.15); }
        .modal-input.input-error { border-color: var(--error); box-shadow: 0 0 0 3px rgba(239,68,68,.15); }

        /* ============================================================
           TOAST SYSTEM
           ============================================================ */
        .toast-container {
            position: fixed;
            top: 1.5rem;
            right: 1.5rem;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 0.625rem;
            max-width: 400px;
            width: calc(100% - 3rem);
            pointer-events: none;
        }

        .toast {
            position: relative;
            overflow: hidden;
            background: var(--bg-card);
            border: 1px solid var(--border-light);
            border-radius: var(--radius-lg);
            padding: 0.875rem 2.75rem 0.875rem 1.125rem;
            box-shadow: var(--shadow-xl), 0 0 0 1px rgba(255,255,255,.04);
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            pointer-events: auto;
            animation: toastSlideIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) both;
            transition: background 0.3s ease;
        }
        .toast:hover .toast-progress { animation-play-state: paused; }
        .toast.toast-hiding {
            animation: toastSlideOut 0.3s cubic-bezier(0.4, 0, 1, 1) forwards;
        }

        .toast-success { border-left: 4px solid var(--success); }
        .toast-error   { border-left: 4px solid var(--error);   }
        .toast-warning { border-left: 4px solid var(--warning); }
        .toast-info    { border-left: 4px solid var(--info);    }

        .toast-icon {
            flex-shrink: 0;
            width: 2rem; height: 2rem;
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.875rem;
        }
        .toast-success .toast-icon { background: rgba(16,185,129,.18); color: var(--success); }
        .toast-error   .toast-icon { background: rgba(239,68,68,.18);  color: var(--error);   }
        .toast-warning .toast-icon { background: rgba(245,158,11,.18); color: var(--warning); }
        .toast-info    .toast-icon { background: rgba(59,130,246,.18); color: var(--info);    }

        .toast-body { flex: 1; min-width: 0; }
        .toast-title {
            font-weight: 700; font-size: 0.8rem;
            line-height: 1.3; margin-bottom: 0.15rem;
            color: var(--text-primary);
        }
        .toast-msg {
            font-size: 0.775rem; color: var(--text-secondary);
            line-height: 1.45; word-break: break-word;
        }

        .toast-close {
            position: absolute;
            top: 0.5rem; right: 0.5rem;
            width: 1.5rem; height: 1.5rem;
            background: none; border: none;
            color: var(--text-muted); cursor: pointer;
            border-radius: var(--radius-sm);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.7rem; transition: color .15s, background .15s;
        }
        .toast-close:hover { color: var(--text-primary); background: var(--bg-hover); }

        .toast-progress {
            position: absolute;
            bottom: 0; left: 0;
            height: 3px;
            border-radius: 0 0 0 var(--radius-lg);
            animation: toastProgress linear forwards;
            transform-origin: left;
        }
        .toast-success .toast-progress { background: linear-gradient(90deg, var(--success), #34d399); }
        .toast-error   .toast-progress { background: linear-gradient(90deg, var(--error),   #f87171); }
        .toast-warning .toast-progress { background: linear-gradient(90deg, var(--warning), #fbbf24); }
        .toast-info    .toast-progress { background: linear-gradient(90deg, var(--info),    #60a5fa); }

        @keyframes toastSlideIn {
            from { opacity: 0; transform: translateX(calc(100% + 1.5rem)); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes toastSlideOut {
            from { opacity: 1; transform: translateX(0);                    max-height: 120px; margin-bottom: 0; }
            to   { opacity: 0; transform: translateX(calc(100% + 1.5rem)); max-height: 0;     margin-bottom: -.625rem; padding: 0; border-width: 0; }
        }
        @keyframes toastProgress { from { width: 100%; } to { width: 0%; } }

        .animate-in { animation: fadeSlideUp .4s ease-out; }
        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @media(max-width:768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; }
            .toast-container { left: 1rem; right: 1rem; width: auto; max-width: none; }
        }
    </style>
</head>
<body>

<!-- Toast container -->
<div class="toast-container" id="toastContainer" role="region" aria-label="Notifications" aria-live="polite"></div>

<div class="app-container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon"><i class="fas fa-handshake"></i></div>
                <div class="logo-text"><h2>Coopérative</h2><p>Gestion de flotte</p></div>
            </div>
        </div>
        <nav class="nav-menu">
            <span class="nav-label">Navigation</span>
            <a href="<%= request.getContextPath() %>/" class="nav-item">
                <i class="fas fa-home"></i><span>Accueil</span>
            </a>
            <a href="<%= request.getContextPath() %>/voiture/" class="nav-item ">
                <i class="fas fa-van-shuttle"></i><span>Voitures</span>
            </a>
            <a href="<%= request.getContextPath() %>/client/" class="nav-item active">
                <i class="fas fa-users"></i><span>Clients</span>
            </a>
            <a href="<%= request.getContextPath() %>/reservation/" class="nav-item">
                <i class="fas fa-calendar-check"></i><span>Réservations</span>
            </a>
            <a href="<%= request.getContextPath() %>/rapport/" class="nav-item">
                <i class="fas fa-chart-bar"></i><span>Rapports</span>
            </a>

        </nav>
    </aside>

    <main class="main-content">
        <div class="top-bar">
            <div>
                <h1 class="page-title"><i class="fas fa-users" style="color:var(--navy-300);margin-right:.5rem;"></i>Clients</h1>
                <p class="page-subtitle">Gestion de la liste des clients de la coopérative</p>
            </div>
            <div class="top-bar-right">
                <!-- Bouton toggle thème -->
                <button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
                    <i class="fas fa-moon" id="themeIcon"></i>
                </button>
                <a href="<%= request.getContextPath() %>/client/new" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Nouveau client
                </a>
            </div>
        </div>

        <div class="toolbar">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" class="search-input" id="searchInput"
                       placeholder="Rechercher par nom ou téléphone…"
                       oninput="filterTable(this.value)">
            </div>
            <div class="stats-strip">
                <span class="stats-count">Total : <strong id="visibleCount"><%= totalClients %></strong></span>
                <a href="?tri=<%= "nom".equals(triActuel) ? "id" : "nom" %>" class="btn btn-secondary">
                    <i class="fas fa-sort"></i>
                    Trier par <%= "nom".equals(triActuel) ? "ID" : "nom" %>
                </a>
            </div>
        </div>

        <div class="table-container animate-in">
            <% if (clients != null && !clients.isEmpty()) { %>
            <table class="table" id="clientsTable">
                <thead>
                <tr>
                    <th style="width:80px">ID</th>
                    <th>Client</th>
                    <th>Téléphone</th>
                    <th style="width:100px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Client c : clients) {
                    String initial = c.getNom().substring(0, 1).toUpperCase();
                    String nomEsc  = c.getNom().replace("\\","\\\\").replace("'","\\'");
                %>
                <tr data-id="<%= c.getIdcli() %>">
                    <td><span class="badge">#<%= c.getIdcli() %></span></td>
                    <td>
                        <div style="display:flex;align-items:center;gap:.75rem;">
                            <div class="avatar"><%= initial %></div>
                            <span style="font-weight:500;"><%= c.getNom() %></span>
                        </div>
                    </td>
                    <td>
                        <div style="display:flex;align-items:center;gap:.4rem;">
                            <i class="fas fa-phone-alt" style="color:var(--text-muted);font-size:.7rem;"></i>
                            <span><%= c.getNumtel() %></span>
                        </div>
                    </td>
                    <td>
                        <div style="display:flex;gap:.25rem;">
                            <button onclick="openEditModal(<%= c.getIdcli() %>, '<%= nomEsc %>', '<%= c.getNumtel() %>')"
                                    class="btn btn-ghost btn-icon" title="Modifier"
                                    style="color:var(--navy-300);">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button onclick="openDeleteModal(<%= c.getIdcli() %>, '<%= nomEsc %>')"
                                    class="btn btn-ghost btn-icon" title="Supprimer"
                                    style="color:var(--error);">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <% } %>
                <tr id="noSearchResult" style="display:none;">
                    <td colspan="4" style="text-align:center;padding:2rem;color:var(--text-muted);">
                        <i class="fas fa-search" style="font-size:1.5rem;margin-bottom:.5rem;display:block;"></i>
                        Aucun client ne correspond à votre recherche.
                    </td>
                </tr>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-user-plus"></i></div>
                <h3 style="font-size:1rem;font-weight:500;margin-bottom:.5rem;">Aucun client</h3>
                <p style="color:var(--text-muted);margin-bottom:1.5rem;">Commencez par ajouter votre premier client.</p>
                <a href="<%= request.getContextPath() %>/client/new" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Ajouter un client
                </a>
            </div>
            <% } %>
        </div>
    </main>
</div>

<!-- ── Modal Modification ── -->
<div class="modal-overlay" id="editModal" role="dialog" aria-modal="true" aria-labelledby="editModalTitle">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-icon" style="background:rgba(59,130,246,.15);color:var(--info);">
                <i class="fas fa-edit"></i>
            </div>
            <h3 id="editModalTitle">Modifier le client</h3>
        </div>
        <div class="modal-body">
            <div style="margin-bottom:1rem;">
                <label class="modal-field-label"><i class="fas fa-user"></i> Nom complet</label>
                <input type="text" id="editNom" class="modal-input" placeholder="Nom du client" maxlength="100">
                <div style="font-size:.7rem;color:var(--error);margin-top:.25rem;display:none;" id="editNomErr">
                    <i class="fas fa-exclamation-circle"></i> Le nom est obligatoire.
                </div>
            </div>
            <div>
                <label class="modal-field-label"><i class="fas fa-phone"></i> Numéro de téléphone</label>
                <input type="tel" id="editNumtel" class="modal-input" placeholder="0341234567" maxlength="10">
                <div style="font-size:.7rem;color:var(--text-muted);margin-top:.25rem;">
                    <i class="fas fa-info-circle"></i> 10 chiffres sans espace
                </div>
                <div style="font-size:.7rem;color:var(--error);margin-top:.25rem;display:none;" id="editTelErr">
                    <i class="fas fa-exclamation-circle"></i> Numéro invalide (10 chiffres requis).
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeEditModal()">
                <i class="fas fa-times"></i> Annuler
            </button>
            <button type="button" class="btn btn-primary" id="editSaveBtn" onclick="submitEdit()">
                <i class="fas fa-save"></i> Enregistrer
            </button>
        </div>
    </div>
</div>

<!-- ── Modal Suppression ── -->
<div class="modal-overlay" id="deleteModal" role="dialog" aria-modal="true" aria-labelledby="deleteModalTitle">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-icon"><i class="fas fa-exclamation-triangle"></i></div>
            <h3 id="deleteModalTitle">Confirmer la suppression</h3>
        </div>
        <div class="modal-body">
            <p id="deleteModalMessage">Êtes-vous sûr de vouloir supprimer ce client ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeDeleteModal()">
                <i class="fas fa-times"></i> Annuler
            </button>
            <button class="btn btn-danger" id="confirmDeleteBtn" onclick="confirmDelete()">
                <i class="fas fa-trash"></i> Supprimer
            </button>
        </div>
    </div>
</div>

<script>
    const CTX = '<%= request.getContextPath() %>';
    let currentDeleteId   = null;
    let currentDeleteName = null;
    let currentEditId     = null;

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
       2. TOAST MANAGER
    ================================================================ */
    const TOAST_CFG = {
        success: { icon: 'fas fa-check',                title: 'Succès',      dur: 4500 },
        error:   { icon: 'fas fa-times-circle',         title: 'Erreur',      dur: 6000 },
        warning: { icon: 'fas fa-exclamation-triangle', title: 'Attention',   dur: 5000 },
        info:    { icon: 'fas fa-info-circle',          title: 'Information', dur: 4000 }
    };
    const MAX_TOASTS = 5;

    const toastManager = (() => {
        const container = document.getElementById('toastContainer');
        const active    = [];

        function _escape(s) {
            const d = document.createElement('div');
            d.appendChild(document.createTextNode(String(s)));
            return d.innerHTML;
        }

        function dismiss(entry) {
            if (!entry || entry.dismissed) return;
            entry.dismissed = true;
            clearTimeout(entry.timerId);
            entry.el.classList.add('toast-hiding');
            entry.el.addEventListener('animationend', () => {
                if (entry.el.parentElement) entry.el.parentElement.removeChild(entry.el);
                const idx = active.indexOf(entry);
                if (idx !== -1) active.splice(idx, 1);
            }, { once: true });
            setTimeout(() => {
                if (entry.el.parentElement) entry.el.parentElement.removeChild(entry.el);
            }, 400);
        }

        function show(type, message, customTitle, customDur) {
            const cfg   = TOAST_CFG[type] || TOAST_CFG.info;
            const title = customTitle || cfg.title;
            const dur   = customDur  || cfg.dur;

            if (active.length >= MAX_TOASTS) dismiss(active[0]);

            const el = document.createElement('div');
            el.className = 'toast toast-' + type;
            el.setAttribute('role', 'alert');
            el.setAttribute('aria-live', 'assertive');
            el.innerHTML =
                '<div class="toast-icon"><i class="' + cfg.icon + '"></i></div>' +
                '<div class="toast-body">' +
                '<div class="toast-title">' + _escape(title)   + '</div>' +
                '<div class="toast-msg">'   + _escape(message) + '</div>' +
                '</div>' +
                '<button class="toast-close" aria-label="Fermer"><i class="fas fa-times"></i></button>' +
                '<div class="toast-progress" style="animation-duration:' + dur + 'ms"></div>';

            const entry = { el, timerId: null, dismissed: false };
            el.querySelector('.toast-close').addEventListener('click', () => dismiss(entry));

            container.appendChild(el);
            active.push(entry);
            entry.timerId = setTimeout(() => dismiss(entry), dur);
            return entry;
        }

        return {
            success: (msg, title, dur) => show('success', msg, title, dur),
            error:   (msg, title, dur) => show('error',   msg, title, dur),
            warning: (msg, title, dur) => show('warning', msg, title, dur),
            info:    (msg, title, dur) => show('info',    msg, title, dur)
        };
    })();

    /* ================================================================
       3. MESSAGES FLASH DE SESSION
    ================================================================ */
    window.addEventListener('load', function () {
        <% if (!jsSuccess.isEmpty()) { %>
        toastManager.success('<%= jsSuccess %>', 'Succès', 6000);
        <% } %>
        <% if (!jsError.isEmpty()) { %>
        toastManager.error('<%= jsError %>', 'Erreur', 7000);
        <% } %>
        <% if (!jsWarning.isEmpty()) { %>
        toastManager.warning('<%= jsWarning %>', 'Attention', 6000);
        <% } %>
        <% if (!jsInfo.isEmpty()) { %>
        toastManager.info('<%= jsInfo %>', 'Information', 5000);
        <% } %>
    });

    /* ================================================================
       4. FILTRE TABLEAU
    ================================================================ */
    function filterTable(query) {
        const rows = document.querySelectorAll('#clientsTable tbody tr:not(#noSearchResult)');
        const q    = query.toLowerCase().trim();
        let visible = 0;
        rows.forEach(row => {
            const nom = (row.querySelector('td:nth-child(2) span') || {}).textContent || '';
            const tel = (row.querySelector('td:nth-child(3) span') || {}).textContent || '';
            const match = !q || nom.toLowerCase().includes(q) || tel.includes(q);
            row.style.display = match ? '' : 'none';
            if (match) visible++;
        });
        document.getElementById('visibleCount').textContent = visible;
        const noRes = document.getElementById('noSearchResult');
        if (noRes) noRes.style.display = (visible === 0 && q) ? '' : 'none';
    }

    /* ================================================================
       5. MODAL MODIFICATION
    ================================================================ */
    function openEditModal(id, nom, numtel) {
        currentEditId = id;
        const nomInput = document.getElementById('editNom');
        const telInput = document.getElementById('editNumtel');
        nomInput.value  = nom;
        telInput.value  = numtel;
        nomInput.classList.remove('input-error');
        telInput.classList.remove('input-error');
        document.getElementById('editNomErr').style.display = 'none';
        document.getElementById('editTelErr').style.display = 'none';
        document.getElementById('editModal').classList.add('active');
        document.body.style.overflow = 'hidden';
        setTimeout(() => nomInput.focus(), 250);
    }

    function closeEditModal() {
        document.getElementById('editModal').classList.remove('active');
        document.body.style.overflow = '';
        currentEditId = null;
    }

    document.getElementById('editNumtel').addEventListener('input', function () {
        let v = this.value.replace(/\D/g, '');
        if (v.length > 10) v = v.slice(0, 10);
        this.value = v;
    });

    function submitEdit() {
        const nomInput = document.getElementById('editNom');
        const telInput = document.getElementById('editNumtel');
        const nom    = nomInput.value.trim();
        const numtel = telInput.value.trim();

        let valid = true;
        if (!nom) {
            nomInput.classList.add('input-error');
            document.getElementById('editNomErr').style.display = 'block';
            valid = false;
        } else {
            nomInput.classList.remove('input-error');
            document.getElementById('editNomErr').style.display = 'none';
        }
        if (!/^[0-9]{10}$/.test(numtel)) {
            telInput.classList.add('input-error');
            document.getElementById('editTelErr').style.display = 'block';
            valid = false;
        } else {
            telInput.classList.remove('input-error');
            document.getElementById('editTelErr').style.display = 'none';
        }
        if (!valid) {
            toastManager.warning('Corrigez les erreurs avant d\'enregistrer.', 'Formulaire invalide');
            return;
        }

        const btn = document.getElementById('editSaveBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Enregistrement…';

        const body = new URLSearchParams({ id: currentEditId, nom, numtel });
        fetch(CTX + '/client/edit', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        })
            .then(r => r.json())
            .then(data => {
                closeEditModal();
                if (data.success) {
                    toastManager.success('Client "' + data.clientName + '" modifié avec succès.', 'Modification réussie');
                    updateTableRow(data.clientId, data.clientName, numtel);
                } else {
                    toastManager.error(data.message || 'La modification a échoué.', 'Erreur');
                }
            })
            .catch(() => {
                closeEditModal();
                toastManager.error('Erreur réseau. Vérifiez votre connexion.', 'Connexion perdue');
            })
            .finally(() => {
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-save"></i> Enregistrer';
            });
    }

    function updateTableRow(id, newNom, newNumtel) {
        const row = document.querySelector('#clientsTable tbody tr[data-id="' + id + '"]');
        if (!row) { window.location.reload(); return; }
        const avatar  = row.querySelector('.avatar');
        const nomSpan = row.querySelector('td:nth-child(2) span');
        const telSpan = row.querySelector('td:nth-child(3) span');
        if (avatar)  avatar.textContent  = newNom.charAt(0).toUpperCase();
        if (nomSpan) nomSpan.textContent = newNom;
        if (telSpan) telSpan.textContent = newNumtel;
        const nomEsc = newNom.replace(/\\/g,'\\\\').replace(/'/g,"\\'");
        const editBtn   = row.querySelector('button[title="Modifier"]');
        const deleteBtn = row.querySelector('button[title="Supprimer"]');
        if (editBtn)   editBtn.setAttribute('onclick',   'openEditModal('   + id + ", '" + nomEsc + "', '" + newNumtel + "')");
        if (deleteBtn) deleteBtn.setAttribute('onclick', 'openDeleteModal(' + id + ", '" + nomEsc + "')");
        row.style.transition = 'background .1s';
        row.style.background = 'rgba(59,130,246,.12)';
        setTimeout(() => { row.style.background = ''; }, 1600);
    }

    /* ================================================================
       6. MODAL SUPPRESSION
    ================================================================ */
    function openDeleteModal(id, nom) {
        currentDeleteId   = id;
        currentDeleteName = nom;
        document.getElementById('deleteModalMessage').innerHTML =
            'Êtes-vous sûr de vouloir supprimer le client <strong>' + nom + '</strong> ? Cette action est irréversible.';
        document.getElementById('deleteModal').classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.remove('active');
        document.body.style.overflow = '';
        currentDeleteId   = null;
        currentDeleteName = null;
    }

    function confirmDelete() {
        if (!currentDeleteId) return;
        const btn          = document.getElementById('confirmDeleteBtn');
        const idToRemove   = currentDeleteId;
        const nameToRemove = currentDeleteName;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Suppression…';

        fetch(CTX + '/client/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ id: idToRemove }).toString()
        })
            .then(r => r.json())
            .then(data => {
                closeDeleteModal();
                if (data.success) {
                    toastManager.success('Client "' + nameToRemove + '" supprimé avec succès.', 'Suppression réussie');
                    removeTableRow(idToRemove);
                } else {
                    toastManager.error(data.message || 'La suppression a échoué.', 'Erreur');
                }
            })
            .catch(() => {
                closeDeleteModal();
                toastManager.error('Erreur réseau. Vérifiez votre connexion.', 'Connexion perdue');
            })
            .finally(() => {
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-trash"></i> Supprimer';
            });
    }

    function removeTableRow(id) {
        const row = document.querySelector('#clientsTable tbody tr[data-id="' + id + '"]');
        if (!row) { window.location.reload(); return; }
        row.style.transition = 'opacity .35s, transform .35s';
        row.style.opacity    = '0';
        row.style.transform  = 'translateX(30px)';
        setTimeout(() => {
            row.remove();
            const countEl = document.getElementById('visibleCount');
            if (countEl) countEl.textContent = Math.max(0, parseInt(countEl.textContent) - 1);
            const remaining = document.querySelectorAll('#clientsTable tbody tr:not(#noSearchResult)').length;
            if (remaining === 0) window.location.reload();
        }, 380);
    }

    /* ================================================================
       7. CLAVIER & OVERLAY
    ================================================================ */
    document.addEventListener('keydown', e => {
        if (e.key !== 'Escape') return;
        if (document.getElementById('editModal').classList.contains('active'))   closeEditModal();
        if (document.getElementById('deleteModal').classList.contains('active')) closeDeleteModal();
    });
    document.getElementById('editModal').addEventListener('click',
        e => { if (e.target === document.getElementById('editModal'))   closeEditModal();   });
    document.getElementById('deleteModal').addEventListener('click',
        e => { if (e.target === document.getElementById('deleteModal')) closeDeleteModal(); });

    /* spin animation inline */
    const spinStyle = document.createElement('style');
    spinStyle.textContent = '.fa-spin{animation:fa-spin 1s linear infinite}@keyframes fa-spin{from{transform:rotate(0)}to{transform:rotate(360deg)}}';
    document.head.appendChild(spinStyle);
</script>
</body>
</html>
