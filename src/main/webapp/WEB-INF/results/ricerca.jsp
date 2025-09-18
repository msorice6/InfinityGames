<%@ page import="Model.Prodotto" %>
<%@ page import="Model.Categoria" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: Francesco Sabia
  Date: 05/05/2020
  Time: 11:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>
<!--<html>
<head>
    <title>Cerca su Infinity Games</title>
    <link rel="stylesheet"
          href="./css/style.css"
          type="text/css"/>
    <link rel="stylesheet"
          href="./css/categoria.css"
          type="text/css"/>
</head>
<body>-->
<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Ricerca"/>
</jsp:include>
<div class="contain" ondblclick="chiudi(this)">
    <div class="contain_all">

        <p>Ricerca prodotti per:"${stringa}"</p>
        <c:choose>
            <c:when test="${ricerca.size() > 0}">
                <!-- MENU # 1 -->
                <div id="menu-main">
                    <div class="tab-bar2">
                        <div class="ordina2">
                            <p>Ordine:
                                <c:forEach items="${ord.values()}" var="o">
                                    <c:choose>
                                        <c:when test="${o == 'DEFAULT'}">
                                            <c:set var="desc" value="default" />
                                        </c:when>
                                        <c:when test="${o == 'PREZZO_ASC'}">
                                            <c:set var="desc" value="prezzo (crescente)" />
                                        </c:when>
                                        <c:when test="${o == 'PREZZO_DESC'}">
                                            <c:set var="desc" value="prezzo (decrescente)" />
                                        </c:when>
                                    </c:choose>
                                    <c:choose>
                                        <c:when test="${o == ord}">
                                            <i>${desc}</i>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?q=${stringa}&pag=${pag}&perpag=${perpag}&ord=${o}">${desc}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </p>
                        </div>
                    </div>
                </div>
                <div id="menu" >
                    <c:forEach items="${ricerca}" var="prodotto">
                        <div class="contieni">
                            <div class="img-col">
                                <a class="sub-img" href="Prodotto?id=${prodotto.id}"><img src="images/prodotti/${prodotto.images}"></a>
                            </div>
                            <div class="col-2">
                                <div class="right-col">
                                    <div class="name-over">
                                        <h5>
                                                ${prodotto.nome}
                                        </h5>
                                    </div>
                                    <div class="prezzo-down">
                                        <div class="sub-prezzo">
                                            <c:choose>
                                                <c:when test="${prodotto.sconto > 0}">
                                                    <span style="color: green">-${prodotto.sconto}%</span>
                                                    <h5>Prezzo: <del>${prodotto.prezzo}€</del> ${String.format("%.2f",prodotto.prezzo = prodotto.prezzo - (prodotto.prezzo*prodotto.sconto)/100)}€</h5>
                                                </c:when>
                                                <c:otherwise>
                                                    <h5>Prezzo: ${prodotto.prezzo}€</h5>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>


                            </div>
                            <div class="col-2-right">
                                <div style="float: right">
                                    <p>Categorie:
                                        <c:forEach items="${prodotto.categorie}" var="categoria" varStatus="status">
                                            <a class="categoria" href="CategoriaServlet?id=<c:out value="${categoria.id}"/>"><c:out value="${categoria.nome}" /></a><c:if test="${not status.last}">, </c:if>
                                        </c:forEach>
                                    </p>
                                </div>
                            </div>
                        </div>

                    </c:forEach>

                </div>


                <div style="position: relative; top: 10px">
                    <a <c:if test="${pag > 1}">href="?id=${param.id}&pag=${pag - 1}"</c:if>>&larr; precendente</a>
                    &emsp;
                    <c:forEach begin="1" end="${npag}" varStatus="loop">
                        <c:choose>
                            <c:when test="${loop.index == pag}">
                                <b>${loop.index}</b>
                            </c:when>
                            <c:otherwise>
                                <a href="?id=${param.id}&pag=${loop.index}">${loop.index}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    &emsp;
                    <a <c:if test="${pag < npag}">href="?id=${param.id}&pag=${pag + 1}"</c:if>>successiva &rarr;</a>
                </div>
            </c:when>
            <c:otherwise>
                <h3>NESSUN PRODOTTO</h3>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<jsp:include page="footer.jsp"/>

