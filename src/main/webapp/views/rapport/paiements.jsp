<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Statut des paiements - Coopérative</title>
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
            --navy-600: #2a497a;
            --text-primary: #f0f4f8;
            --text-secondary: #9aa4bf;
            --text-muted: #6b7294;
            --success: #10b981;
            --warning: #f59e0b;
            --error: #ef4444;
            --info: #3b82f6;
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
            --navy-600: #5a7fb0;
            --text-primary: #0f1322;
            --text-secondary: #3a4560;
            --text-muted: #6b7294;
            --success: #059669;
            --warning: #d97706;
            --error: #dc2626;
            --info: #2563eb;
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.14);
        }

        body {
            background: var(--bg-deep);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: var(--text-primary);
            padding: 20px;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .container {
            max-width: 1400px;
            margin: auto;
            background: var(--bg-card);
            padding: 25px;
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--navy-400);
        }

        h1 { font-size: 1.5rem; }

        h2 {
            font-size: 1.2rem;
            margin: 1.5rem 0 1rem 0;
            color: var(--text-secondary);
        }

        .theme-btn {
            width: 2.25rem;
            height: 2.25rem;
            border-radius: var(--radius-md);
            background: var(--bg-primary);
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

        .form-group {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
            margin: 20px 0;
            padding: 15px;
            background: var(--bg-primary);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        label {
            font-weight: 600;
            color: var(--text-secondary);
        }

        select {
            padding: 8px 15px;
            background: var(--bg-deep);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            color: var(--text-primary);
            font-size: 0.875rem;
            min-width: 250px;
            transition: background 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }

        select:focus { outline: none; border-color: var(--navy-400); }

        .btn-search {
            background: var(--navy-500);
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: var(--radius-lg);
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .btn-search:hover {
            background: var(--navy-400);
            transform: translateY(-1px);
        }

        .stats {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin: 25px 0;
        }

        .stat-card {
            background: var(--bg-primary);
            padding: 15px 25px;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            border-left: 4px solid;
            min-width: 150px;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .stat-card.avance { border-left-color: var(--warning); }
        .stat-card.sans   { border-left-color: var(--error); }
        .stat-card.paye   { border-left-color: var(--success); }
        .stat-card.total  { border-left-color: var(--info); }

        .stat-number {
            font-size: 28px;
            font-weight: bold;
            color: var(--text-primary);
        }

        .stat-label {
            color: var(--text-muted);
            font-size: 0.8rem;
            margin-top: 5px;
        }

        /* ── Table ── */
        .table-wrapper { overflow-x: auto; margin-top: 20px; border-radius: var(--radius-lg); border: 1px solid var(--border); }

        table { width: 100%; border-collapse: collapse; }

        th, td {
            border-bottom: 1px solid var(--border);
            padding: 12px 14px;
            text-align: left;
            transition: border-color 0.3s ease;
        }

        th {
            background: var(--bg-primary);
            color: var(--text-secondary);
            font-weight: 600;
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            white-space: nowrap;
        }

        td { color: var(--text-primary); font-size: 0.85rem; }

        tr:last-child td { border-bottom: none; }

        .avec-avance td { background-color: rgba(245, 158, 11, 0.07); }
        .sans-avance td { background-color: rgba(239, 68,  68,  0.07); }
        .tout-paye   td { background-color: rgba(16,  185, 129, 0.07); }

        tr:hover td { filter: brightness(1.08); }

        /* ── Badges de places ── */
        .places-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 0.35rem;
        }

        .place-badge {
            background: var(--navy-600);
            border: 1px solid var(--navy-400);
            color: white;
            padding: 0.15rem 0.55rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
            white-space: nowrap;
        }

        /* ── Badge paiement ── */
        .payment-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            padding: 0.2rem 0.65rem;
            border-radius: 20px;
            font-size: 0.72rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .badge-avance { background: rgba(245,158,11,0.18); color: var(--warning); }
        .badge-sans   { background: rgba(239,68,68,0.18);  color: var(--error); }
        .badge-paye   { background: rgba(16,185,129,0.18); color: var(--success); }

        .info-empty {
            text-align: center;
            padding: 50px;
            color: var(--text-muted);
            background: var(--bg-primary);
            border-radius: var(--radius-lg);
            border: 1px dashed var(--border);
            margin-top: 20px;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            margin-top: 25px;
            color: var(--navy-300);
            text-decoration: none;
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            background: var(--bg-primary);
            transition: all 0.2s;
        }

        .btn-back:hover {
            background: var(--navy-500);
            color: white;
            border-color: var(--navy-500);
        }

        @media (max-width: 768px) {
            .form-group { flex-direction: column; align-items: stretch; }
            select { min-width: unset; width: 100%; }
            .btn-search { justify-content: center; }
        }
    </style>
</head>
<body>
<div class="container">

    <!-- En-tête avec toggle thème -->
    <div class="top-bar">
        <h1><i class="fas fa-money-bill-wave" style="color:var(--navy-300);margin-right:0.5rem;"></i> Statut des paiements</h1>
        <button class="theme-btn" id="themeBtn" type="button" title="Changer le thème">
            <i class="fas fa-moon" id="themeIcon"></i>
        </button>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/rapport/paiements">
        <div class="form-group">
            <label><i class="fas fa-car" style="margin-right:0.3rem;"></i> Choisir une voiture :</label>
            <select name="idVoit" required>
                <option value="">-- Sélectionnez une voiture --</option>
                <c:forEach items="${voitures}" var="v">
                    <option value="${v.idvoit}" ${idVoitChoisi == v.idvoit ? 'selected' : ''}>
                            ${v.idvoit} - ${v.design} (${v.type})
                    </option>
                </c:forEach>
            </select>
            <button type="submit" class="btn-search">
                <i class="fas fa-search"></i> Rechercher
            </button>
        </div>
    </form>

    <c:if test="${not empty resultats}">
        <h2><i class="fas fa-chart-bar" style="margin-right:0.4rem;color:var(--navy-300);"></i> Résultats pour la voiture sélectionnée</h2>

        <div class="stats">
            <div class="stat-card avance">
                <div class="stat-number">${nbAvecAvance}</div>
                <div class="stat-label">💰 Avec avance</div>
            </div>
            <div class="stat-card sans">
                <div class="stat-number">${nbSansAvance}</div>
                <div class="stat-label">⏳ Sans avance</div>
            </div>
            <div class="stat-card paye">
                <div class="stat-number">${nbToutPaye}</div>
                <div class="stat-label">✅ Tout payé</div>
            </div>
            <div class="stat-card total">
                <div class="stat-number">${resultats.size()}</div>
                <div class="stat-label">📋 Total voyageurs</div>
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>N° Réservation</th>
                    <th>Client</th>
                    <th>Contact</th>
                    <th>Place(s)</th>
                    <th>Date voyage</th>
                    <th>Frais (Ar)</th>
                    <th>Paiement</th>
                    <th>Avance (Ar)</th>
                    <th>Reste (Ar)</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${resultats}" var="r">
                    <tr class="
                        <c:choose>
                            <c:when test="${r.payment == 'avec avance'}">avec-avance</c:when>
                            <c:when test="${r.payment == 'sans avance'}">sans-avance</c:when>
                            <c:when test="${r.payment == 'tout payé'}">tout-paye</c:when>
                        </c:choose>
                    ">
                        <td><code style="font-size:0.75rem;color:var(--navy-300);">${r.idReserv}</code></td>
                        <td><strong>${r.nomClient}</strong></td>
                        <td>${r.numTel}</td>

                            <%-- ══ Affichage des places avec badges ══ --%>
                        <td>
                            <div class="places-badges">
                                <c:choose>
                                    <%-- Si placesList est disponible et non vide --%>
                                    <c:when test="${not empty r.placesList}">
                                        <c:forEach items="${r.placesList}" var="p">
                                            <span class="place-badge">N°${p}</span>
                                        </c:forEach>
                                    </c:when>
                                    <%-- Sinon, afficher places (chaîne ex: "3,7,12") --%>
                                    <c:when test="${not empty r.places}">
                                        <c:forTokens items="${r.places}" delims="," var="p">
                                            <span class="place-badge">N°${p}</span>
                                        </c:forTokens>
                                    </c:when>
                                    <%-- Fallback place simple --%>
                                    <c:when test="${not empty r.place}">
                                        <span class="place-badge">N°${r.place}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:var(--text-muted);font-size:0.75rem;">–</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>

                        <td>${r.dateVoyage}</td>
                        <td style="font-weight:600;">${r.frais} Ar</td>

                        <td>
                            <c:choose>
                                <c:when test="${r.payment == 'avec avance'}">
                                    <span class="payment-badge badge-avance"><i class="fas fa-coins"></i> Avec avance</span>
                                </c:when>
                                <c:when test="${r.payment == 'sans avance'}">
                                    <span class="payment-badge badge-sans"><i class="fas fa-clock"></i> Sans avance</span>
                                </c:when>
                                <c:when test="${r.payment == 'tout payé'}">
                                    <span class="payment-badge badge-paye"><i class="fas fa-check-circle"></i> Tout payé</span>
                                </c:when>
                            </c:choose>
                        </td>

                        <td style="color:var(--warning);font-weight:600;">${r.montantAvance} Ar</td>
                        <td style="color:var(--error);font-weight:700;">${r.resteAPayer} Ar</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <c:if test="${empty resultats and not empty idVoitChoisi}">
        <div class="info-empty">
            <i class="fas fa-info-circle" style="font-size:2rem;margin-bottom:0.75rem;display:block;color:var(--navy-300);"></i>
            Aucune réservation trouvée pour cette voiture.
        </div>
    </c:if>

    <a href="${pageContext.request.contextPath}/rapport/" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour aux rapports
    </a>
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