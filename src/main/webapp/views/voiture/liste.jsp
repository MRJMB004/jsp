<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cooperative.model.Voiture" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <%-- ═══════════ ANTI-FLASH : premier script absolu ═══════════ --%>
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>Voitures | Coopérative</title>
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
            --shadow-2xl: 0 25px 50px -12px rgba(0,0,0,0.8);

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
            --shadow-2xl: 0 25px 50px -12px rgba(0,0,0,0.18);

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

        /* ── Sidebar Footer avec toggle ── */
        .sidebar-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }

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
        }
        .theme-switch input:checked ~ .theme-thumb { transform: translateX(1.25rem); }

        .sidebar-version { font-size: 0.65rem; color: var(--text-muted); text-align: center; }

        /* ── Main Content ── */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 1.5rem 2rem;
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

        .user-avatar {
            width: 2.5rem; height: 2.5rem;
            background: linear-gradient(135deg, var(--navy-500), var(--navy-600));
            border-radius: var(--radius-lg);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.9rem; color: white;
        }

        /* ── Toolbar ── */
        .toolbar {
            display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem;
        }

        .toolbar-left { display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap; }

        /* ── Buttons ── */
        .btn {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.5rem 1rem;
            font-size: 0.8125rem; font-weight: 500;
            border-radius: var(--radius-lg);
            cursor: pointer; transition: all 0.2s ease;
            border: 1px solid transparent; text-decoration: none;
            font-family: inherit;
        }
        .btn-primary { background: var(--navy-500); color: white; }
        .btn-primary:hover { background: var(--navy-400); transform: translateY(-1px); box-shadow: var(--shadow-md); }

        .btn-ghost { background: transparent; color: var(--text-secondary); border: none; }
        .btn-ghost:hover { background: var(--bg-hover); color: var(--text-primary); }

        .btn-icon { padding: 0.45rem 0.6rem; border-radius: var(--radius-md); }

        .btn-danger { background: var(--error); color: white; }
        .btn-danger:hover { opacity: 0.9; transform: translateY(-1px); }

        .btn-secondary {
            background: var(--bg-hover);
            color: var(--text-secondary);
            border-color: var(--border);
        }
        .btn-secondary:hover { background: var(--border); color: var(--text-primary); }

        /* ── Stat pills ── */
        .stat-pill {
            display: flex; align-items: center; gap: 0.5rem;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 9999px;
            padding: 0.4rem 0.875rem;
            font-size: 0.75rem; font-weight: 500;
            color: var(--text-secondary);
            transition: background 0.3s ease;
        }
        .stat-pill i { color: var(--navy-400); font-size: 0.7rem; }

        /* ── Table ── */
        .table-container {
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            overflow-x: auto;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .table { width: 100%; border-collapse: collapse; }

        .table thead {
            background: var(--bg-secondary);
            border-bottom: 1px solid var(--border);
        }

        .table th {
            padding: 0.875rem 1rem;
            text-align: left;
            font-size: 0.68rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.07em;
            color: var(--text-muted);
            white-space: nowrap;
        }

        .table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            color: var(--text-primary);
            vertical-align: middle;
        }

        .table tbody tr {
            transition: background 0.15s ease;
        }
        .table tbody tr:hover { background: var(--bg-hover); }
        .table tbody tr:last-child td { border-bottom: none; }

        /* ── Badges ── */
        .badge {
            display: inline-flex; align-items: center; gap: 0.375rem;
            padding: 0.25rem 0.625rem;
            font-size: 0.7rem; font-weight: 600;
            border-radius: 9999px;
            white-space: nowrap;
        }
        .badge-id     { background: var(--bg-hover); color: var(--text-muted); font-family: monospace; }
        .badge-simple { background: rgba(16,185,129,0.15); color: var(--success); }
        .badge-premium{ background: rgba(245,158,11,0.15);  color: var(--warning); }
        .badge-vip    { background: rgba(139,92,246,0.15);  color: #8b5cf6; }

        /* ── Actions ── */
        .action-group { display: flex; gap: 0.25rem; align-items: center; }

        .btn-action {
            width: 2rem; height: 2rem;
            display: flex; align-items: center; justify-content: center;
            border-radius: var(--radius-md);
            border: none; background: transparent;
            cursor: pointer; transition: all 0.2s ease;
            font-size: 0.8rem;
        }
        .btn-action-view  { color: var(--navy-300); }
        .btn-action-view:hover  { background: rgba(90,127,176,0.15); }
        .btn-action-edit  { color: var(--warning); }
        .btn-action-edit:hover  { background: rgba(245,158,11,0.15); }
        .btn-action-del   { color: var(--error); }
        .btn-action-del:hover   { background: rgba(239,68,68,0.15); }

        /* ── Empty state ── */
        .empty-state { text-align: center; padding: 4rem 2rem; }
        .empty-icon {
            width: 5rem; height: 5rem;
            background: var(--bg-hover);
            border-radius: var(--radius-xl);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 1.25rem;
        }
        .empty-icon i { font-size: 2rem; color: var(--text-muted); }
        .empty-state h3 { font-size: 1rem; font-weight: 600; margin-bottom: 0.5rem; }
        .empty-state p { color: var(--text-muted); margin-bottom: 1.5rem; }

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
            animation: toastIn 0.35s cubic-bezier(0.34,1.56,0.64,1);
            transition: background 0.3s ease;
        }
        .toast.toast-hiding { animation: toastOut 0.3s ease-out forwards; }

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

        .toast-progress {
            position: absolute; bottom: 0; left: 0;
            height: 3px;
            border-radius: 0 0 var(--radius-lg) var(--radius-lg);
            animation: toastBar 5s linear forwards;
        }
        .toast-success .toast-progress { background: var(--success); }
        .toast-error   .toast-progress { background: var(--error); }
        .toast-warning .toast-progress { background: var(--warning); }
        .toast-info    .toast-progress { background: var(--info); }

        @keyframes toastIn  { from { opacity:0; transform:translateX(110%); } to { opacity:1; transform:translateX(0); } }
        @keyframes toastOut { from { opacity:1; transform:translateX(0); }   to { opacity:0; transform:translateX(110%); } }
        @keyframes toastBar { from { width:100%; } to { width:0%; } }

        /* ══════════════════════════════════════════════
           PANNEAUX SUCCÈS (modal centré)
        ══════════════════════════════════════════════ */
        .overlay {
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.6);
            backdrop-filter: blur(3px);
            z-index: 9999;
            animation: fadeInOv 0.3s ease-out;
        }
        .overlay.fade-out { animation: fadeOutOv 0.3s ease-out forwards; }

        @keyframes fadeInOv  { from { opacity:0; } to { opacity:1; } }
        @keyframes fadeOutOv { from { opacity:1; } to { opacity:0; } }

        /* Base commune des panneaux */
        .result-panel {
            position: fixed;
            top: 50%; left: 50%;
            transform: translate(-50%,-50%);
            border-radius: var(--radius-xl);
            padding: 2rem 2.5rem;
            text-align: center;
            z-index: 10000;
            min-width: 320px;
            box-shadow: 0 25px 40px -12px rgba(0,0,0,0.5);
            animation: panelIn 0.4s cubic-bezier(0.34,1.56,0.64,1);
        }
        .result-panel.fade-out { animation: panelOut 0.3s ease-out forwards; }

        @keyframes panelIn  { from { opacity:0; transform:translate(-50%,-50%) scale(0.8); } to { opacity:1; transform:translate(-50%,-50%) scale(1); } }
        @keyframes panelOut { from { opacity:1; transform:translate(-50%,-50%) scale(1); }   to { opacity:0; transform:translate(-50%,-50%) scale(0.9); } }

        .panel-add    { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
        .panel-update { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); }
        .panel-delete { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); }

        .panel-close {
            position: absolute; top: 0.75rem; right: 1rem;
            color: rgba(255,255,255,0.7); cursor: pointer; font-size: 1rem;
            transition: color 0.2s;
        }
        .panel-close:hover { color: white; }

        .panel-icon  { font-size: 3rem; color: white; margin-bottom: 0.75rem; }
        .panel-title {
            font-family: 'Syne', sans-serif;
            font-size: 1.25rem; font-weight: 700;
            color: white; margin-bottom: 0.5rem;
        }
        .panel-msg   { font-size: 0.875rem; color: rgba(255,255,255,0.9); }
        .panel-count { margin-top: 0.875rem; font-size: 0.75rem; color: rgba(255,255,255,0.8); }
        .panel-count span { font-weight: 700; font-size: 1rem; }

        /* ══════════════════════════════════════════════
           MODAL SUPPRESSION
        ══════════════════════════════════════════════ */
        .modal-overlay {
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.7);
            backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 9998;
            opacity: 0; visibility: hidden;
            transition: all 0.2s ease;
        }
        .modal-overlay.active { opacity: 1; visibility: visible; }

        .modal {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-2xl);
            width: 90%; max-width: 440px;
            box-shadow: var(--shadow-2xl);
            transform: scale(0.95); opacity: 0;
            transition: all 0.25s ease;
            transition: background 0.3s ease, border-color 0.3s ease, transform 0.25s ease, opacity 0.25s ease;
        }
        .modal-overlay.active .modal { transform: scale(1); opacity: 1; }

        .modal-header {
            padding: 1.5rem 1.5rem 0.75rem;
            display: flex; align-items: center; gap: 0.875rem;
            border-bottom: 1px solid var(--border);
        }
        .modal-icon {
            width: 2.75rem; height: 2.75rem;
            background: rgba(239,68,68,0.12);
            border-radius: var(--radius-lg);
            display: flex; align-items: center; justify-content: center;
            color: var(--error); font-size: 1.1rem;
            flex-shrink: 0;
        }
        .modal-header h3 {
            font-family: 'Syne', sans-serif;
            font-size: 1.05rem; font-weight: 700;
        }

        .modal-body { padding: 1.25rem 1.5rem 0.5rem; color: var(--text-secondary); line-height: 1.6; }
        .modal-body strong { color: var(--text-primary); }

        .modal-footer {
            padding: 1rem 1.5rem 1.5rem;
            display: flex; gap: 0.75rem; justify-content: flex-end;
        }

        /* ── Scrollbar ── */
        ::-webkit-scrollbar { width: .375rem; height: .375rem; }
        ::-webkit-scrollbar-track { background: var(--bg-secondary); border-radius: 9999px; }
        ::-webkit-scrollbar-thumb { background: var(--navy-500); border-radius: 9999px; }

        /* ── Animations ── */
        @keyframes fadeInUp {
            from { opacity:0; transform:translateY(16px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .animate-in { animation: fadeInUp 0.4s ease-out; }

        /* ── Responsive ── */
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; padding: 1.25rem; }
            .toast-container { top: 0.75rem; right: 0.75rem; left: 0.75rem; max-width: none; }
        }
    </style>
</head>
<body>

<%
    List<Voiture> voitures = (List<Voiture>) request.getAttribute("voitures");
    int totalVoitures = voitures != null ? voitures.size() : 0;

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage   = (String) session.getAttribute("errorMessage");
    String warningMessage = (String) session.getAttribute("warningMessage");
    String infoMessage    = (String) session.getAttribute("infoMessage");

    boolean isAddSuccess    = "success".equals(request.getParameter("add"));
    boolean isUpdateSuccess = "success".equals(request.getParameter("update"));
    boolean isDeleteSuccess = "success".equals(request.getParameter("delete"));

    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage   != null) session.removeAttribute("errorMessage");
    if (warningMessage != null) session.removeAttribute("warningMessage");
    if (infoMessage    != null) session.removeAttribute("infoMessage");
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
            <%-- ═══ TOGGLE THÈME ═══ --%>
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

        <!-- Top Bar -->
        <div class="top-bar">
            <div class="page-title">
                <h1>Gestion des véhicules</h1>
                <p>Consultez et gérez votre flotte de véhicules</p>
            </div>
            <div class="top-right">
                <div class="user-avatar"><i class="fas fa-user"></i></div>
            </div>
        </div>

        <!-- Toolbar -->
        <div class="toolbar">
            <div class="toolbar-left">
                <div class="stat-pill">
                    <i class="fas fa-car"></i>
                    <span><strong><%= totalVoitures %></strong> véhicule<%= totalVoitures > 1 ? "s" : "" %></span>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/voiture/new" class="btn btn-primary">
                <i class="fas fa-plus"></i> Nouveau véhicule
            </a>
        </div>

        <!-- Table -->
        <div class="table-container animate-in">
            <% if (voitures != null && !voitures.isEmpty()) { %>
            <table class="table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Désignation</th>
                    <th>Type</th>
                    <th>Places</th>
                    <th>Frais (Ar)</th>
                    <th style="text-align:center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Voiture v : voitures) {
                    String badgeClass, typeIcon, typeLabel;
                    if ("premium".equals(v.getType())) {
                        badgeClass = "badge-premium"; typeIcon = "fa-star"; typeLabel = "⭐ Premium";
                    } else if ("VIP".equals(v.getType())) {
                        badgeClass = "badge-vip"; typeIcon = "fa-crown"; typeLabel = "👑 VIP";
                    } else {
                        badgeClass = "badge-simple"; typeIcon = "fa-car"; typeLabel = "🚗 Simple";
                    }
                %>
                <tr>
                    <td>
                        <span class="badge badge-id">#<%= v.getIdvoit() %></span>
                    </td>
                    <td style="font-weight:500; color:var(--text-primary);">
                        <%= v.getDesign() %>
                    </td>
                    <td>
                        <span class="badge <%= badgeClass %>">
                            <i class="fas <%= typeIcon %>" style="font-size:.6rem;"></i>
                            <%= typeLabel %>
                        </span>
                    </td>
                    <td style="color:var(--text-secondary);">
                        <i class="fas fa-chair" style="color:var(--text-muted);margin-right:.4rem;font-size:.75rem;"></i>
                        <%= v.getNbrplace() %> places
                    </td>
                    <td style="font-weight:500;">
                        <%= String.format("%,d", v.getFrais()) %> Ar
                    </td>
                    <td>
                        <div class="action-group" style="justify-content:center;">
                            <a href="<%= request.getContextPath() %>/voiture/places?id=<%= v.getIdvoit() %>"
                               class="btn-action btn-action-view" title="Voir places libres">
                                <i class="fas fa-chair"></i>
                            </a>
                            <a href="<%= request.getContextPath() %>/voiture/edit?id=<%= v.getIdvoit() %>"
                               class="btn-action btn-action-edit" title="Modifier">
                                <i class="fas fa-pen"></i>
                            </a>
                            <button onclick="openDeleteModal('<%= v.getIdvoit() %>','<%= v.getDesign().replace("'","\\'") %>','<%= typeLabel %>')"
                                    class="btn-action btn-action-del" title="Supprimer">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-car-side"></i></div>
                <h3>Aucun véhicule enregistré</h3>
                <p>Commencez par ajouter votre premier véhicule à la flotte.</p>
                <a href="<%= request.getContextPath() %>/voiture/new" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Ajouter un véhicule
                </a>
            </div>
            <% } %>
        </div>
    </main>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<!-- ═══ Panneau AJOUT ═══ -->
<% if (isAddSuccess) { %>
<div class="overlay" id="overlayAdd"></div>
<div class="result-panel panel-add" id="panelAdd">
    <div class="panel-close" onclick="closePanel('Add')"><i class="fas fa-times"></i></div>
    <div class="panel-icon"><i class="fas fa-check-circle"></i></div>
    <div class="panel-title">Voiture ajoutée !</div>
    <div class="panel-msg">La voiture a été enregistrée avec succès.</div>
    <div class="panel-count">Rafraîchissement dans <span id="cntAdd">3</span> s…</div>
</div>
<% } %>

<!-- ═══ Panneau MODIFICATION ═══ -->
<% if (isUpdateSuccess) { %>
<div class="overlay" id="overlayUpdate"></div>
<div class="result-panel panel-update" id="panelUpdate">
    <div class="panel-close" onclick="closePanel('Update')"><i class="fas fa-times"></i></div>
    <div class="panel-icon"><i class="fas fa-pen-circle"></i></div>
    <div class="panel-title">Véhicule modifié !</div>
    <div class="panel-msg">Les informations ont été mises à jour.</div>
    <div class="panel-count">Rafraîchissement dans <span id="cntUpdate">3</span> s…</div>
</div>
<% } %>

<!-- ═══ Panneau SUPPRESSION ═══ -->
<% if (isDeleteSuccess) { %>
<div class="overlay" id="overlayDelete"></div>
<div class="result-panel panel-delete" id="panelDelete">
    <div class="panel-close" onclick="closePanel('Delete')"><i class="fas fa-times"></i></div>
    <div class="panel-icon"><i class="fas fa-trash-alt"></i></div>
    <div class="panel-title">Véhicule supprimé !</div>
    <div class="panel-msg">La voiture a été retirée de la base de données.</div>
    <div class="panel-count">Rafraîchissement dans <span id="cntDelete">3</span> s…</div>
</div>
<% } %>

<!-- ═══ Modal suppression ═══ -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-icon"><i class="fas fa-exclamation-triangle"></i></div>
            <h3>Confirmer la suppression</h3>
        </div>
        <div class="modal-body" id="deleteModalBody">
            Êtes-vous sûr de vouloir supprimer ce véhicule ?
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeDeleteModal()">
                <i class="fas fa-times"></i> Annuler
            </button>
            <button class="btn btn-danger" onclick="confirmDelete()">
                <i class="fas fa-trash"></i> Supprimer
            </button>
        </div>
    </div>
</div>

<script>
    var CTX = '<%= request.getContextPath() %>';
    var currentDeleteId = null;

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
       2. TOAST SYSTEM
    ═══════════════════════════════════════════════════ */
    var Toast = (function () {
        var container = document.getElementById('toastContainer');
        var store = {};

        var ICONS  = { success:'fa-check-circle', error:'fa-times-circle', warning:'fa-exclamation-triangle', info:'fa-info-circle' };
        var TITLES = { success:'Succès', error:'Erreur', warning:'Attention', info:'Information' };

        function show(type, message, duration) {
            duration = duration || 5000;
            var id = 'toast-' + Date.now();
            var el = document.createElement('div');
            el.className = 'toast toast-' + type;
            el.id = id;
            el.innerHTML =
                '<div class="toast-icon"><i class="fas ' + ICONS[type] + '"></i></div>' +
                '<div class="toast-content"><div class="toast-title">' + TITLES[type] + '</div>' +
                '<div class="toast-message">' + message + '</div></div>' +
                '<div class="toast-close" onclick="Toast.close(\'' + id + '\')"><i class="fas fa-times"></i></div>' +
                '<div class="toast-progress"></div>';
            container.appendChild(el);
            var t = setTimeout(function () { close(id); }, duration);
            store[id] = { el: el, timer: t };
        }

        function close(id) {
            var d = store[id];
            if (!d) return;
            clearTimeout(d.timer);
            d.el.classList.add('toast-hiding');
            setTimeout(function () {
                if (d.el.parentNode) d.el.remove();
                delete store[id];
            }, 300);
        }

        return {
            show: show, close: close,
            success: function(m){ show('success',m); },
            error:   function(m){ show('error',m); },
            warning: function(m){ show('warning',m); },
            info:    function(m){ show('info',m); }
        };
    })();

    /* ── Messages flash JSP ── */
    <% if (successMessage != null && !successMessage.isEmpty()) { %>
    Toast.success('<%= successMessage.replace("'","\\'").replace("\n"," ") %>');
    <% } %>
    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    Toast.error('<%= errorMessage.replace("'","\\'").replace("\n"," ") %>');
    <% } %>
    <% if (warningMessage != null && !warningMessage.isEmpty()) { %>
    Toast.warning('<%= warningMessage.replace("'","\\'").replace("\n"," ") %>');
    <% } %>
    <% if (infoMessage != null && !infoMessage.isEmpty()) { %>
    Toast.info('<%= infoMessage.replace("'","\\'").replace("\n"," ") %>');
    <% } %>

    /* ═══════════════════════════════════════════════════
       3. PANNEAUX SUCCÈS — helper générique
    ═══════════════════════════════════════════════════ */
    function closePanel(suffix) {
        var overlay = document.getElementById('overlay' + suffix);
        var panel   = document.getElementById('panel'   + suffix);
        if (!panel) return;
        panel.classList.add('fade-out');
        if (overlay) overlay.classList.add('fade-out');
        setTimeout(function () {
            if (panel.parentNode)   panel.remove();
            if (overlay && overlay.parentNode) overlay.remove();
            window.location.href = CTX + '/voiture/';
        }, 300);
    }

    function startCountdown(suffix, seconds) {
        var el = document.getElementById('cnt' + suffix);
        var iv = setInterval(function () {
            seconds--;
            if (el) el.textContent = seconds;
            if (seconds <= 0) {
                clearInterval(iv);
                window.location.href = CTX + '/voiture/';
            }
        }, 1000);
    }

    <% if (isAddSuccess)    { %> startCountdown('Add',    3); <% } %>
    <% if (isUpdateSuccess) { %> startCountdown('Update', 3); <% } %>
    <% if (isDeleteSuccess) { %> startCountdown('Delete', 3); <% } %>

    /* ═══════════════════════════════════════════════════
       4. MODAL SUPPRESSION
    ═══════════════════════════════════════════════════ */
    var deleteModal = document.getElementById('deleteModal');

    function openDeleteModal(id, designation, type) {
        currentDeleteId = id;
        document.getElementById('deleteModalBody').innerHTML =
            'Voulez-vous vraiment supprimer le véhicule <strong>' + designation + '</strong> (' + type + ') ?<br><br>' +
            '<span style="color:var(--error);font-size:.8rem;">' +
            '<i class="fas fa-exclamation-circle"></i> Cette action est irréversible.' +
            '</span>';
        deleteModal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeDeleteModal() {
        deleteModal.classList.remove('active');
        document.body.style.overflow = '';
        currentDeleteId = null;
    }

    function confirmDelete() {
        if (!currentDeleteId) return;
        Toast.info('Suppression en cours…');
        setTimeout(function () {
            window.location.href = CTX + '/voiture/delete?id=' + currentDeleteId;
        }, 500);
    }

    /* Fermeture clavier / clic hors modal */
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && deleteModal.classList.contains('active')) closeDeleteModal();
    });
    deleteModal.addEventListener('click', function (e) {
        if (e.target === deleteModal) closeDeleteModal();
    });
</script>
</body>
</html>
