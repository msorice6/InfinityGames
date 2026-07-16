<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Infinity Games - ${param.pageTitle}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%--    <link rel="stylesheet" href="./css/style.css" type="text/css"/>--%>
    <link rel="stylesheet" href="./css/footer.css" type="text/css"/>
    <link rel="stylesheet" href="./css/adminCategoria.css" type="text/css"/>
    <link rel="stylesheet" href="./css/utentiAdmin.css" type="text/css"/>
    <link rel="stylesheet" href="./css/adminProdotto.css" type="text/css"/>
    <link rel="stylesheet" href="./css/carrello.css" type="text/css"/>
    <link rel="stylesheet" href="./css/categoria.css" type="text/css"/>
    <link rel="stylesheet" href="./css/profilo.css" type="text/css"/>
    <link rel="stylesheet" href="./css/ordini.css" type="text/css"/>
    <link rel="stylesheet" href="./css/prodotto.css" type="text/css"/>
    <link rel="stylesheet" href="./css/recenti.css" type="text/css"/>
    <link rel="stylesheet" href="./css/contatti.css" type="text/css"/>
    <link rel="stylesheet" href="./css/login.css" type="text/css"/>

    <link rel="stylesheet" href="./css/banner.css" type="text/css"/>
    <link rel="stylesheet" href="./css/index.css" type="text/css"/>
    <link rel="stylesheet" href="./css/global.css" type="text/css"/>

    <script src="./javascript/menuRes.js"></script>
    <script src="./javascript/menuLaterale.js"></script>
</head>
<body>

<div class="super_container">
    <div class="container">
        <div class="logo">
            <a href="/InfinityGames/">
                <img class="logo-img" src="./images/logoTSW.png" width="50%" height="90px">
                <span class="imgName">INFINITY GAMES</span>
            </a>
        </div>
        <div class="menu">
            <ul class="menu_tendina">
                <li class="dropdown">
                    <a class="menuitem" href="${pageContext.request.contextPath}/Negozio" style="text-decoration: none">NEGOZIO</a>
                    <div class="dropdown-nonresp">
                        <a href="ListaDesideri">Lista dei desideri</a>
                        <a href="./notizie.jsp">Chi siamo</a>
                    </div>
                </li>
                <li class="dropdown">
                    <a class="menuitem" href="Libreria" style="text-decoration: none">LA TUA LIBRERIA</a>
                </li>
                <a class="menuitem" href="Assistenza" style="text-decoration: none">ASSISTENZA</a>
                <a class="menuitem" href="Carrello" style="text-decoration: none">CARRELLO
                    <c:if test="${carrello.prodotti.size() != null && carrello.prodotti.size() > 0}">
                        (${carrello.prodotti.size()})
                    </c:if>
                </a>
                <c:if test="${utente == null}">
                    <a class="menuitem" href="./login.jsp" style="text-decoration: none">LOGIN</a>
                </c:if>
                <c:if test="${utente != null}">
                    <li class="dropdown">
                        <a class="menuitem" href="#" style="text-decoration: none">${utente.username}</a>
                        <div class="dropdown-nonresp">
                            <c:if test="${utente.admin}">
                                <a href="AdminCategoria">Aggiungi Categoria</a>
                                <a href="AdminProdotto">Aggiungi Prodotto</a>
                                <a href="AdminProdottiInEvidenza">Gestisci Prodotti in Evidenza</a>
                                <a href="AdminUtenti">Utenti</a>
                            </c:if>
                            <c:if test="${!utente.admin}">
                                <a href="Profilo">Profilo</a>
                                <a href="Ordini">I miei ordini</a>
                            </c:if>
                            <a href="Logout">Logout</a>
                        </div>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
