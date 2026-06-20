<%@ page import="Model.Prodotto" %>
<%@ page import="java.io.File" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Prodotto ${prodotto.nome}"/>
</jsp:include>
<div class="prodotto" ondblclick="chiudi(this)">
    <div>
        <div class="nome-prod"><p>${prodotto.nome}</p></div>
        <div class="cat">
            <p>>>Categorie:
                <c:forEach items="${prodotto.categorie}" var="categoria" varStatus="status">
                    <a href="CategoriaServlet?id=<c:out value="${categoria.id}"/>"><c:out value="${categoria.nome}" /></a><c:if test="${not status.last}">, </c:if>
                </c:forEach>
            </p>
        </div>
        <c:if test="${utente.admin}">
            <form action="AdminProdotto" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="${prodotto.id}">
                <input type="submit" value="Modifica">
                <input type="submit" name="rimuovi" value="Rimuovi">
            </form>
        </c:if>
    </div>
    <div class="contain-prod">
        <div class="video">
            <iframe width="600" height="350"
                    src="https://www.youtube.com/embed/${prodotto.video}"
                    title="Trailer"
                    frameborder="0"
                    allow="autoplay; encrypted-media; picture-in-picture"
                    allowfullscreen>
            </iframe>
        </div>
        <div class="img-nom-desc" >
            <div class="imagine">
                <img src="./images/prodotti/${prodotto.images}">
            </div>
            <div class="nome-desc">
                <div>
                    <p>${prodotto.descrizione}</p>
                </div>
            </div>

            <div class="end">
                <div class="informazione">
                    <div class="span"><span class="prezzo"> <c:if test="${prodotto.sconto >0}">${String.format("%.2f",prodotto.prezzo= prodotto.prezzo - (prodotto.prezzo*prodotto.sconto)/100)} &euro;</span><span class="scont">-${prodotto.sconto}%</span></c:if>
                        <c:if test="${prodotto.sconto ==0}">${prodotto.prezzo}€</c:if></div>
                    <form class="carr" action="Carrello" method="post">
                        <label style="color: white">Quantità:</label>
                        <select name="addNum">
                            <c:forEach begin="1" end="30" varStatus="loop">
                                <option value="${loop.index}">${loop.index}</option>
                            </c:forEach>
                        </select>
                        <input type="hidden" name="prodId" value="${prodotto.id}">
                        <input type="submit" name="carrello" value="Aggiungi al carrello">
                    </form>
                </div>

                <c:if test="${utente != null}">
                    <div class="pref">
                        <div class="pref-in">
                            <a  href="javascript:void(0)" style="text-decoration: none; color: green" onclick="aggiungi(${prodotto.id})">Aggiungi ai desideri</a>
                        </div>
                        <div id="addDes" style="display: none;color: white">
                            <p id="mes"></p>
                        </div>
                    </div>
                </c:if>
            </div>

        </div>
    </div>
</div>
<jsp:include page="footer.jsp"/>


