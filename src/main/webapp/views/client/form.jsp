<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cooperative.model.Client" %>
<%
    Client client = (Client) request.getAttribute("client");
    boolean isEdit = (client != null);
    String formAction = isEdit ? "update" : "save";

    // Messages flash depuis la session
    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg   = (String) session.getAttribute("errorMessage");
    String warningMsg = (String) session.getAttribute("warningMessage");
    String infoMsg    = (String) session.getAttribute("infoMessage");
    if (successMsg != null) session.removeAttribute("successMessage");
    if (errorMsg   != null) session.removeAttribute("errorMessage");
    if (warningMsg != null) session.removeAttribute("warningMessage");
    if (infoMsg    != null) session.removeAttribute("infoMessage");

    // Échappement JS sécurisé
    String jsSuccess = successMsg != null ? successMsg.replace("\\","\\\\").replace("'","\\'").replace("\n"," ") : "";
    String jsError   = errorMsg   != null ? errorMsg  .replace("\\","\\\\").replace("'","\\'").replace("\n"," ") : "";
    String jsWarning = warningMsg != null ? warningMsg.replace("\\","\\\\").replace("'","\\'").replace("\n"," ") : "";
    String jsInfo    = infoMsg    != null ? infoMsg   .replace("\\","\\\\").replace("'","\\'").replace("\n"," ") : "";
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
    <title><%= isEdit ? "Modifier le client" : "Ajouter un client" %> | Coopérative</title>
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
            --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.14);
        }

        body {
            background: var(--bg-deep);
            color: var(--text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            font-size: 0.875rem;
            line-height: 1.5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
            transition: background 0.3s ease, color 0.3s ease;
        }

        /* ── Bouton toggle thème — positionné en haut à droite ── */
        .theme-btn {
            position: fixed;
            top: 1.25rem;
            right: 1.25rem;
            z-index: 100;
            width: 2.5rem;
            height: 2.5rem;
            border-radius: var(--radius-lg);
            background: var(--bg-card);
            border: 1px solid var(--border);
            color: var(--text-muted);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            transition: all 0.2s ease;
        }
        .theme-btn:hover {
            background: var(--bg-hover);
            color: var(--text-primary);
            border-color: var(--navy-500);
        }

        .card {
            max-width: 520px;
            width: 100%;
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
        }
        .card-title       { font-size: 1.25rem; font-weight: 600; color: var(--text-primary); margin-bottom: .25rem; }
        .card-description { font-size: .75rem; color: var(--text-muted); }

        .card-content { padding: 1.5rem; }
        .card-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            background: var(--bg-secondary);
            display: flex;
            justify-content: flex-end;
            gap: .75rem;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .form-group { margin-bottom: 1.25rem; }
        .label {
            display: block;
            font-size: .8125rem;
            font-weight: 500;
            margin-bottom: .5rem;
            color: var(--text-secondary);
        }
        .label-required::after { content: "*"; color: var(--error); margin-left: .25rem; }

        .input-wrapper { position: relative; }
        .input-wrapper i {
            position: absolute;
            left: .875rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: .875rem;
            pointer-events: none;
        }
        .input {
            width: 100%;
            padding: .75rem .875rem .75rem 2.5rem;
            font-size: .875rem;
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            color: var(--text-primary);
            transition: border-color .2s, box-shadow .2s, background 0.3s ease;
            font-family: inherit;
        }
        .input:focus {
            outline: none;
            border-color: var(--navy-500);
            box-shadow: 0 0 0 3px rgba(58,91,140,.2);
        }
        .input.input-error {
            border-color: var(--error);
            box-shadow: 0 0 0 3px rgba(239,68,68,.15);
        }
        .input.input-success {
            border-color: var(--success);
            box-shadow: 0 0 0 3px rgba(16,185,129,.12);
        }

        /* Placeholder adapté au thème */
        [data-theme="light"] .input::placeholder { color: #9aa4bf; }

        .error-message {
            color: var(--error);
            font-size: .7rem;
            margin-top: .25rem;
            display: flex;
            align-items: center;
            gap: .25rem;
        }
        .help-text {
            font-size: .7rem;
            color: var(--text-muted);
            margin-top: .25rem;
            display: flex;
            align-items: center;
            gap: .25rem;
        }
        .hidden { display: none !important; }

        .char-counter {
            font-size: .7rem;
            color: var(--text-muted);
            text-align: right;
            margin-top: .2rem;
            transition: color .2s;
        }
        .char-counter.full { color: var(--success); font-weight: 600; }
        .char-counter.warn { color: var(--warning); }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            padding: .5rem 1rem;
            font-size: .8125rem;
            font-weight: 500;
            border-radius: var(--radius-lg);
            cursor: pointer;
            transition: all .2s ease;
            border: 1px solid transparent;
            text-decoration: none;
            font-family: inherit;
        }
        .btn-primary { background: var(--navy-500); color: white; }
        .btn-primary:hover { background: var(--navy-400); transform: translateY(-1px); }
        .btn-primary:disabled { opacity: .6; cursor: not-allowed; transform: none; }
        .btn-outline { background: transparent; border-color: var(--border); color: var(--text-secondary); }
        .btn-outline:hover { background: var(--bg-hover); border-color: var(--navy-500); color: var(--text-primary); }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            font-size: .8125rem;
            color: var(--text-muted);
            text-decoration: none;
            margin-bottom: 1rem;
            transition: color .2s;
        }
        .back-link:hover { color: var(--text-primary); }

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
            gap: 0.75rem;
            max-width: 420px;
            width: calc(100% - 3rem);
            pointer-events: none;
        }
        .toast {
            position: relative;
            overflow: hidden;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1rem 2.75rem 1rem 1.25rem;
            box-shadow: var(--shadow-xl), 0 0 0 1px rgba(255,255,255,0.04);
            display: flex;
            align-items: flex-start;
            gap: 0.875rem;
            pointer-events: auto;
            animation: toastSlideIn 0.38s cubic-bezier(0.34, 1.56, 0.64, 1) both;
            transition: background 0.3s ease;
        }
        .toast.toast-hiding {
            animation: toastSlideOut 0.28s ease-in forwards;
        }
        .toast-success { border-left: 4px solid var(--success); }
        .toast-error   { border-left: 4px solid var(--error);   }
        .toast-warning { border-left: 4px solid var(--warning); }
        .toast-info    { border-left: 4px solid var(--info);    }

        .toast-icon {
            flex-shrink: 0;
            width: 2rem;
            height: 2rem;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }
        .toast-success .toast-icon { background: rgba(16,185,129,0.15); color: var(--success); }
        .toast-error   .toast-icon { background: rgba(239,68,68,0.15);  color: var(--error);   }
        .toast-warning .toast-icon { background: rgba(245,158,11,0.15); color: var(--warning); }
        .toast-info    .toast-icon { background: rgba(59,130,246,0.15); color: var(--info);    }

        .toast-body { flex: 1; min-width: 0; }
        .toast-title { font-weight: 600; font-size: 0.8125rem; line-height: 1.3; margin-bottom: 0.2rem; color: var(--text-primary); }
        .toast-msg   { font-size: 0.775rem; color: var(--text-secondary); line-height: 1.45; }

        .toast-close {
            position: absolute;
            top: 0.625rem; right: 0.625rem;
            background: none; border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 0.25rem;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            line-height: 1;
            transition: color .15s, background .15s;
            display: flex; align-items: center; justify-content: center;
        }
        .toast-close:hover { color: var(--text-primary); background: var(--bg-hover); }

        .toast-progress {
            position: absolute;
            bottom: 0; left: 0;
            height: 3px;
            border-radius: 0 0 0 var(--radius-lg);
            animation: toastProgress linear forwards;
        }
        .toast-success .toast-progress { background: var(--success); }
        .toast-error   .toast-progress { background: var(--error);   }
        .toast-warning .toast-progress { background: var(--warning); }
        .toast-info    .toast-progress { background: var(--info);    }

        @keyframes toastSlideIn  { from{opacity:0;transform:translateX(110%)} to{opacity:1;transform:translateX(0)} }
        @keyframes toastSlideOut { from{opacity:1;transform:translateX(0);max-height:120px} to{opacity:0;transform:translateX(110%);max-height:0;padding-top:0;padding-bottom:0;border-width:0} }
        @keyframes toastProgress { from{width:100%} to{width:0%} }

        .fa-spinner { animation: spin 1s linear infinite; }
        @keyframes spin { from{transform:rotate(0deg)} to{transform:rotate(360deg)} }

        @media(max-width:520px) {
            .toast-container { left: 1rem; right: 1rem; width: auto; }
            .theme-btn { top: 0.75rem; right: 0.75rem; }
        }
    </style>
</head>
<body>

<!-- Bouton toggle thème -->
<button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
    <i class="fas fa-moon" id="themeIcon"></i>
</button>

<!-- Toast container -->
<div class="toast-container" id="toastContainer"></div>

<div class="card">
    <div class="card-header">
        <a href="<%= request.getContextPath() %>/client/" class="back-link">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
        <h2 class="card-title">
            <% if (isEdit) { %>
            <i class="fas fa-edit" style="color:var(--navy-300);margin-right:.4rem;"></i>Modifier le client
            <% } else { %>
            <i class="fas fa-user-plus" style="color:var(--navy-300);margin-right:.4rem;"></i>Nouveau client
            <% } %>
        </h2>
        <p class="card-description">
            <%= isEdit
                    ? "Mettez à jour les informations du client."
                    : "Remplissez les informations pour créer un nouveau client." %>
        </p>
    </div>

    <form action="<%= request.getContextPath() %>/client/<%= formAction %>" method="post" id="clientForm" novalidate>
        <% if (isEdit) { %>
        <input type="hidden" name="idcli" value="<%= client.getIdcli() %>">
        <% } %>

        <div class="card-content">

            <!-- Nom -->
            <div class="form-group">
                <label for="nom" class="label label-required">
                    <i class="fas fa-user" style="margin-right:.4rem;"></i>Nom complet
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-user-circle"></i>
                    <input type="text"
                           id="nom" name="nom"
                           class="input"
                           value="<%= isEdit ? client.getNom() : "" %>"
                           placeholder="Ex : Rakoto Jean"
                           autocomplete="name"
                           maxlength="100"
                           required>
                </div>
                <div class="error-message hidden" id="nomError">
                    <i class="fas fa-exclamation-circle"></i> Le nom est obligatoire.
                </div>
            </div>

            <!-- Téléphone -->
            <div class="form-group">
                <label for="numtel" class="label label-required">
                    <i class="fas fa-phone" style="margin-right:.4rem;"></i>Numéro de téléphone
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-mobile-alt"></i>
                    <input type="tel"
                           id="numtel" name="numtel"
                           class="input"
                           value="<%= isEdit ? client.getNumtel() : "" %>"
                           placeholder="0341234567"
                           maxlength="10"
                           autocomplete="tel"
                           required>
                </div>
                <div class="help-text"><i class="fas fa-info-circle"></i> 10 chiffres sans espace</div>
                <div class="char-counter" id="telCounter">0 / 10</div>
                <div class="error-message hidden" id="telError">
                    <i class="fas fa-exclamation-circle"></i> Numéro invalide (exactement 10 chiffres requis).
                </div>
            </div>

        </div>

        <div class="card-footer">
            <a href="<%= request.getContextPath() %>/client/" class="btn btn-outline">
                <i class="fas fa-times"></i> Annuler
            </a>
            <button type="submit" class="btn btn-primary" id="submitBtn">
                <i class="fas fa-check" id="submitIcon"></i>
                <span id="btnText"><%= isEdit ? "Mettre à jour" : "Enregistrer" %></span>
                <i class="fas fa-spinner hidden" id="loadingSpinner"></i>
            </button>
        </div>
    </form>
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
       2. TOAST MANAGER
    ================================================================ */
    const TOAST_META = {
        success: { icon: 'fas fa-check',                title: 'Succès'      },
        error:   { icon: 'fas fa-times-circle',         title: 'Erreur'      },
        warning: { icon: 'fas fa-exclamation-triangle', title: 'Attention'   },
        info:    { icon: 'fas fa-info-circle',          title: 'Information' }
    };

    const toastManager = {
        container: document.getElementById('toastContainer'),

        _show(type, message, customTitle, duration) {
            duration    = duration    || 5000;
            customTitle = customTitle || TOAST_META[type].title;

            const t = document.createElement('div');
            t.className = 'toast toast-' + type;
            t.innerHTML =
                '<div class="toast-icon"><i class="' + TOAST_META[type].icon + '"></i></div>' +
                '<div class="toast-body">' +
                '<div class="toast-title">' + _esc(customTitle) + '</div>' +
                '<div class="toast-msg">'   + message           + '</div>' +
                '</div>' +
                '<button class="toast-close" title="Fermer"><i class="fas fa-times"></i></button>' +
                '<div class="toast-progress" style="animation-duration:' + duration + 'ms"></div>';

            t.querySelector('.toast-close').addEventListener('click', () => this._dismiss(t));
            this.container.appendChild(t);
            setTimeout(() => this._dismiss(t), duration);
        },

        _dismiss(t) {
            if (!t || t.classList.contains('toast-hiding')) return;
            t.classList.add('toast-hiding');
            setTimeout(() => { if (t.parentElement) t.parentElement.removeChild(t); }, 300);
        },

        success(msg, title, dur) { this._show('success', msg, title, dur); },
        error(msg,   title, dur) { this._show('error',   msg, title, dur); },
        warning(msg, title, dur) { this._show('warning', msg, title, dur); },
        info(msg,    title, dur) { this._show('info',    msg, title, dur); }
    };

    function _esc(str) {
        const d = document.createElement('div');
        d.appendChild(document.createTextNode(String(str)));
        return d.innerHTML;
    }

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

        /* Toast contextuel */
        <% if (!isEdit) { %>
        toastManager.info('Remplissez le formulaire pour ajouter un nouveau client.', 'Nouveau client', 3500);
        <% } else { %>
        toastManager.info('Vous modifiez le client : <strong><%= client.getNom() %></strong>', 'Mode édition', 4000);
        <% } %>
    });

    /* ================================================================
       4. VALIDATION EN TEMPS RÉEL
    ================================================================ */
    const nomInput   = document.getElementById('nom');
    const telInput   = document.getElementById('numtel');
    const telCounter = document.getElementById('telCounter');
    const submitBtn  = document.getElementById('submitBtn');
    const btnText    = document.getElementById('btnText');
    const spinner    = document.getElementById('loadingSpinner');
    const submitIcon = document.getElementById('submitIcon');

    function validateNom() {
        const val    = nomInput.value.trim();
        const errEl  = document.getElementById('nomError');
        const isValid = val.length > 0;
        nomInput.classList.toggle('input-error',   !isValid);
        nomInput.classList.toggle('input-success',  isValid);
        errEl.classList.toggle('hidden', isValid);
        return isValid;
    }

    function validateTel() {
        const val    = telInput.value.trim();
        const errEl  = document.getElementById('telError');
        const isValid = /^[0-9]{10}$/.test(val);
        telInput.classList.toggle('input-error',   !isValid);
        telInput.classList.toggle('input-success',  isValid);
        errEl.classList.toggle('hidden', isValid);
        return isValid;
    }

    function updateTelCounter() {
        const len = telInput.value.length;
        telCounter.textContent = len + ' / 10';
        telCounter.className = 'char-counter' + (len === 10 ? ' full' : len >= 8 ? ' warn' : '');
    }

    telInput.addEventListener('input', function () {
        let v = this.value.replace(/\D/g, '');
        if (v.length > 10) v = v.slice(0, 10);
        this.value = v;
        updateTelCounter();
        validateTel();
    });

    nomInput.addEventListener('input', validateNom);

    // Initialiser le compteur si édition
    updateTelCounter();

    /* ================================================================
       5. SOUMISSION DU FORMULAIRE
    ================================================================ */
    document.getElementById('clientForm').addEventListener('submit', function (e) {
        const nomOk = validateNom();
        const telOk = validateTel();

        if (!nomOk && !telOk) {
            e.preventDefault();
            toastManager.warning('Le nom et le numéro de téléphone sont invalides.', 'Formulaire incomplet');
            return;
        }
        if (!nomOk) {
            e.preventDefault();
            toastManager.warning('Le nom du client est obligatoire.', 'Champ manquant');
            nomInput.focus();
            return;
        }
        if (!telOk) {
            e.preventDefault();
            toastManager.warning('Le numéro de téléphone doit contenir exactement 10 chiffres.', 'Numéro invalide');
            telInput.focus();
            return;
        }

        /* Tout est valide → animation de chargement */
        submitBtn.disabled = true;
        spinner.classList.remove('hidden');
        submitIcon.classList.add('hidden');
        btnText.textContent = 'En cours…';

        toastManager.info(
            '<%= isEdit ? "Mise à jour en cours…" : "Enregistrement du client en cours…" %>',
            'Patientez'
        );
    });
</script>
</body>
</html>
