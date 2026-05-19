<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>
    <title>Recette Totale - Coopérative</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --bg-deep: #0a0e1a;
            --bg-primary: #0f1322;
            --bg-card: #1a1f35;
            --bg-hover: #222842;
            --border: #2a2f4a;
            --navy-300: #5a7fb0;
            --navy-400: #4a6d9e;
            --navy-500: #3a5b8c;
            --text-primary: #f0f4f8;
            --text-secondary: #9aa4bf;
            --text-muted: #6b7294;
            --success: #10b981;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --radius-xl: 1rem;
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.5);
        }

        [data-theme="light"] {
            --bg-deep: #f0f4f8;
            --bg-primary: #ffffff;
            --bg-card: #ffffff;
            --bg-hover: #dce4f0;
            --border: #c8d3e6;
            --navy-300: #2a497a;
            --navy-400: #3a5b8c;
            --navy-500: #4a6d9e;
            --text-primary: #0f1322;
            --text-secondary: #3a4560;
            --text-muted: #6b7294;
            --success: #059669;
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.14);
        }

        body {
            background: var(--bg-deep);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .container {
            max-width: 520px;
            width: 100%;
            margin: 2rem;
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        /* ── En-tête ── */
        .card-header {
            background: linear-gradient(135deg, var(--navy-500), var(--navy-300));
            padding: 1.5rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-header h1 {
            font-size: 1.25rem;
            color: white;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .theme-btn {
            width: 2.25rem;
            height: 2.25rem;
            border-radius: var(--radius-md);
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        .theme-btn:hover {
            background: rgba(255,255,255,0.28);
        }

        /* ── Corps ── */
        .card-body {
            padding: 2.5rem 2rem;
            text-align: center;
        }

        .recette-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-muted);
            margin-bottom: 0.75rem;
        }

        .recette-value {
            font-size: 3rem;
            font-weight: 700;
            color: var(--success);
            letter-spacing: -0.02em;
            line-height: 1.1;
            transition: color 0.3s ease;
        }

        .recette-unit {
            font-size: 1.25rem;
            font-weight: 400;
            color: var(--text-secondary);
            margin-left: 0.3rem;
        }

        .divider {
            width: 60px;
            height: 3px;
            background: var(--success);
            border-radius: 2px;
            margin: 1.5rem auto;
            opacity: 0.5;
            transition: background 0.3s ease;
        }

        .recette-note {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        /* ── Pied ── */
        .card-footer {
            padding: 1.25rem 2rem;
            background: var(--bg-primary);
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: center;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            color: var(--navy-300);
            text-decoration: none;
            font-size: 0.875rem;
            padding: 0.5rem 1.1rem;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            background: var(--bg-card);
            transition: all 0.2s;
        }

        .btn-back:hover {
            background: var(--navy-500);
            color: white;
            border-color: var(--navy-500);
        }
    </style>
</head>
<body>
<div class="container">

    <!-- En-tête -->
    <div class="card-header">
        <h1><i class="fas fa-coins"></i> Recette Totale</h1>
        <button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
            <i class="fas fa-moon" id="themeIcon"></i>
        </button>
    </div>

    <!-- Corps -->
    <div class="card-body">
        <p class="recette-label">Montant total encaissé</p>
        <div class="recette-value">
            <%= String.format("%,d", request.getAttribute("recetteTotale") != null
                    ? (Integer) request.getAttribute("recetteTotale") : 0) %>
            <span class="recette-unit">Ar</span>
        </div>
        <div class="divider"></div>
        <p class="recette-note">
            <i class="fas fa-info-circle" style="margin-right:0.3rem;"></i>
            Somme de toutes les avances et paiements complets
        </p>
    </div>

    <!-- Pied -->
    <div class="card-footer">
        <a href="<%= request.getContextPath() %>/rapport/" class="btn-back">
            <i class="fas fa-arrow-left"></i> Retour aux rapports
        </a>
    </div>

</div>

<script>
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
</script>
</body>
</html>