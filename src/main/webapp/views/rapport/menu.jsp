<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rapports - Coopérative</title>
    <script>
        (function() {
            if (localStorage.getItem('theme') === 'light')
                document.documentElement.setAttribute('data-theme', 'light');
        })();
    </script>
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
            --radius-lg: 0.75rem;
            --radius-xl: 1rem;
            --radius-md: 0.5rem;
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
        }

        body {
            background: var(--bg-deep);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: var(--text-primary);
            min-height: 100vh;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border);
            transition: border-color 0.3s ease;
        }

        h1 {
            font-size: 1.75rem;
            font-weight: 600;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .btn-back {
            background: var(--bg-card);
            color: var(--text-secondary);
            padding: 0.5rem 1rem;
            border-radius: var(--radius-lg);
            text-decoration: none;
            border: 1px solid var(--border);
            transition: all 0.2s;
            font-size: 0.875rem;
        }

        .btn-back:hover {
            background: var(--navy-500);
            color: white;
            border-color: var(--navy-500);
        }

        .theme-btn {
            width: 2.25rem;
            height: 2.25rem;
            border-radius: var(--radius-md);
            background: var(--bg-card);
            border: 1px solid var(--border);
            color: var(--text-muted);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        .theme-btn:hover {
            background: var(--bg-hover);
            color: var(--text-primary);
            border-color: var(--navy-500);
        }

        .rapport-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .rapport-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 2rem;
            text-align: center;
            text-decoration: none;
            transition: transform 0.2s, border-color 0.2s, background 0.3s ease;
            display: block;
        }

        .rapport-card:hover {
            transform: translateY(-5px);
            border-color: var(--navy-400);
            background: var(--bg-hover);
        }

        .rapport-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .rapport-card h2 {
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 1.25rem;
            transition: color 0.3s ease;
        }

        .rapport-card p {
            color: var(--text-muted);
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <h1>📊 Rapports</h1>
        <div class="header-right">
            <a href="<%= request.getContextPath() %>/" class="btn-back">← Retour à l'accueil</a>
            <button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
                <i class="fas fa-moon" id="themeIcon"></i>
            </button>
        </div>
    </header>

    <div class="rapport-grid">
        <a href="<%= request.getContextPath() %>/rapport/paiements" class="rapport-card">
            <div class="rapport-icon">💳</div>
            <h2>Statut des Paiements</h2>
            <p>Voir les paiements par voiture</p>
        </a>

        <a href="<%= request.getContextPath() %>/rapport/recette" class="rapport-card">
            <div class="rapport-icon">💰</div>
            <h2>Recette Totale</h2>
            <p>Voir le montant total accumulé</p>
        </a>
    </div>
</div>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

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