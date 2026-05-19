<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur - Coopérative de Transport</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 3rem auto;
            text-align: center;
        }

        .error-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
        }

        .error-code {
            font-size: 4rem;
            font-weight: bold;
            color: #dc2626;
            margin-bottom: 0.5rem;
        }

        .error-title {
            font-size: 2rem;
            color: #1f2937;
            margin-bottom: 1rem;
        }

        .error-message {
            background: #fee2e2;
            border: 1px solid #fecaca;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            color: #991b1b;
        }

        .error-details {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1rem;
            margin: 1rem 0;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 0.875rem;
            overflow-x: auto;
        }

        .error-details summary {
            cursor: pointer;
            color: #6b7280;
            font-weight: 500;
        }

        .stack-trace {
            margin-top: 0.5rem;
            padding: 0.5rem;
            background: #fff;
            border-radius: 4px;
            max-height: 200px;
            overflow-y: auto;
            font-size: 0.75rem;
            color: #4b5563;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .btn-outline {
            background: transparent;
            border: 2px solid #667eea;
            color: #667eea;
        }

        .btn-outline:hover {
            background: #667eea;
            color: white;
        }

        .info-box {
            background: #dbeafe;
            border: 1px solid #bfdbfe;
            border-radius: 8px;
            padding: 1rem;
            margin: 1.5rem 0;
            color: #1e40af;
        }

        .info-box h3 {
            margin-bottom: 0.5rem;
            color: #1e3a8a;
        }

        .info-box ul {
            text-align: left;
            margin-left: 1.5rem;
            margin-top: 0.5rem;
        }

        .info-box li {
            margin-bottom: 0.25rem;
        }

        @media (max-width: 640px) {
            .error-code {
                font-size: 3rem;
            }

            .error-title {
                font-size: 1.5rem;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="error-container">
        <%
            // Récupérer les informations d'erreur
            Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
            String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
            String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
            exception = (Throwable) request.getAttribute("javax.servlet.error.exception");
            String servletName = (String) request.getAttribute("javax.servlet.error.servlet_name");

            // Déterminer l'icône et le titre selon le code d'erreur
            String errorIcon = "❌";
            String errorTitle = "Une erreur est survenue";

            if (statusCode != null) {
                if (statusCode == 404) {
                    errorIcon = "🔍";
                    errorTitle = "Page non trouvée";
                } else if (statusCode == 403) {
                    errorIcon = "🔒";
                    errorTitle = "Accès interdit";
                } else if (statusCode == 500) {
                    errorIcon = "💥";
                    errorTitle = "Erreur serveur";
                } else if (statusCode == 400) {
                    errorIcon = "⚠️";
                    errorTitle = "Requête invalide";
                } else if (statusCode == 401) {
                    errorIcon = "🔐";
                    errorTitle = "Non autorisé";
                }
            }

            // Si pas de code d'erreur mais une exception
            if (statusCode == null && exception != null) {
                errorIcon = "🐛";
                errorTitle = "Exception applicative";
            }
        %>

        <div class="error-icon"><%= errorIcon %></div>

        <% if (statusCode != null) { %>
        <div class="error-code"><%= statusCode %></div>
        <% } %>

        <h1 class="error-title"><%= errorTitle %></h1>

        <div class="error-message">
            <%
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
            <p><strong><%= errorMessage %></strong></p>
            <%
            } else {
                if (statusCode != null) {
                    if (statusCode == 404) {
            %>
            <p>La page que vous recherchez n'existe pas ou a été déplacée.</p>
            <%
            } else if (statusCode == 500) {
            %>
            <p>Une erreur interne du serveur s'est produite. Nos équipes ont été notifiées.</p>
            <%
            } else if (statusCode == 403) {
            %>
            <p>Vous n'avez pas les permissions nécessaires pour accéder à cette ressource.</p>
            <%
            } else {
            %>
            <p>Une erreur inattendue s'est produite lors du traitement de votre demande.</p>
            <%
                        }
                    }
                }
            %>
        </div>

        <% if (requestUri != null) { %>
        <div class="info-box">
            <h3>📋 Détails de la requête</h3>
            <p><strong>URL demandée :</strong> <%= requestUri %></p>
            <% if (servletName != null) { %>
            <p><strong>Servlet :</strong> <%= servletName %></p>
            <% } %>
            <p><strong>Méthode :</strong> <%= request.getMethod() %></p>
            <p><strong>Horodatage :</strong> <%= new java.util.Date() %></p>
        </div>
        <% } %>

        <% if (exception != null) { %>
        <details class="error-details">
            <summary>🔧 Détails techniques (pour les développeurs)</summary>
            <div class="stack-trace">
                <strong>Exception :</strong> <%= exception.getClass().getName() %><br>
                <strong>Message :</strong> <%= exception.getMessage() != null ? exception.getMessage() : "Aucun message" %><br><br>
                <strong>Stack Trace :</strong><br>
                <%
                    java.io.StringWriter sw = new java.io.StringWriter();
                    java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                    exception.printStackTrace(pw);
                    out.println(sw.toString().replace("\n", "<br>").replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;"));
                %>
            </div>
        </details>
        <% } %>

        <div class="info-box">
            <h3>💡 Que faire maintenant ?</h3>
            <ul>
                <li>Vérifiez que l'URL saisie est correcte</li>
                <li>Retournez à la page d'accueil et naviguez depuis le menu</li>
                <li>Actualisez la page (F5 ou Ctrl+R)</li>
                <li>Si le problème persiste, contactez l'administrateur</li>
            </ul>
        </div>

        <div class="action-buttons">
            <a href="<%= request.getContextPath() %>/" class="btn btn-primary">
                🏠 Retour à l'accueil
            </a>
            <button onclick="history.back()" class="btn btn-outline">
                ← Page précédente
            </button>
            <button onclick="location.reload()" class="btn btn-secondary">
                🔄 Actualiser
            </button>
        </div>

        <div style="margin-top: 2rem; color: #9ca3af; font-size: 0.875rem;">
            <p>
                Si le problème persiste, contactez le support technique :<br>
                📧 support@cooperative.mg | 📞 +261 34 12 345 67
            </p>
        </div>
    </div>
</div>

<script>
    // Ajouter un comportement pour le bouton "Page précédente"
    document.querySelector('button[onclick="history.back()"]')?.addEventListener('click', function(e) {
        if (history.length <= 1) {
            e.preventDefault();
            window.location.href = '<%= request.getContextPath() %>/';
        }
    });

    // Journalisation côté client (optionnel - pour le débogage)
    console.error('Erreur <%= statusCode != null ? statusCode : "inconnue" %> sur <%= requestUri != null ? requestUri : "URL inconnue" %>');
</script>
</body>
</html>