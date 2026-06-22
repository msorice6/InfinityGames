<%@ page import="java.util.ArrayList" %>
<%@ page import="Model.Prodotto" %>
<%@ page import="Model.ProdottoDAO" %>
<%@ page import="Model.Utente" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Libreria"/>
</jsp:include>

<c:choose>
    <c:when test="${utente != null}">
        <div class="contain" ondblclick="chiudi(this)">
            <div class="contain_all">

                <p>IN QUESTA SEZIONE PUOI TROVARE I TUOI GIOCHI</p>

                <c:choose>
                    <c:when test="${libreria.size() > 0}">
                        <!-- MENU # 1 -->
                        <div id="menu-main">
                            <div class="tab-bar">
                                <div class="ordine-group">
                                    <label for="ordineSelect">Ordina per:</label>
                                    <select id="ordineSelect" onchange="libreriaAjax()">
                                        <option value="DEFAULT" ${ord == 'DEFAULT' ? 'selected' : ''}>Default</option>
                                        <option value="PREZZO_ASC" ${ord == 'PREZZO_ASC' ? 'selected' : ''}>A-Z</option>
                                        <option value="PREZZO_DESC" ${ord == 'PREZZO_DESC' ? 'selected' : ''}>Z-A</option>
                                    </select>
                                </div>
                                <div class="ordine-group">
                                    <label>Ricerca</label>
                                    <input type="text" id="inputText" placeholder="Cerca nella libreria..."
                                           value="<c:out value="${param.q}" />" onkeyup="libreriaAjax()">
                                </div>
                            </div>
                        </div>

                        <div id="menu">
                            <c:forEach items="${libreria}" var="prodotto">
                                <div class="contieni">
                                    <div class="img-col">
                                        <a class="sub-img" href="Prodotto?id=${prodotto.id}">
                                            <img src="images/prodotti/${prodotto.images}">
                                        </a>
                                    </div>
                                    <div class="col-2">
                                        <div class="right-col">
                                            <div class="name-over">
                                                <h5>
                                                        ${prodotto.nome}
                                                    <c:if test="${prodotto.quantitaPosseduta > 1}">
                                                        <span style="font-size: 12px; color: #131313; margin-left: 10px;">
                                                            (${prodotto.quantitaPosseduta} copie)
                                                        </span>
                                                    </c:if>
                                                </h5>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-2-right">
                                        <div style="float: right">
                                            <p>
                                                    ${prodotto.descrizione}
                                            </p>
                                            <p>Categorie:
                                                <c:forEach items="${prodotto.categorie}" var="categoria" varStatus="status">
                                                    <a class="categoria" href="Negozio?categoria=${categoria.id}">
                                                        <c:out value="${categoria.nome}" />
                                                    </a><c:if test="${not status.last}">, </c:if>
                                                </c:forEach>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="paginazione" style="position: relative; top: 10px">
                            <c:if test="${npag > 1}">
                                <c:if test="${pag > 1}">
                                    <a href="?pag=${pag - 1}&ord=${ord}&q=${param.q}">&larr; precedente</a>
                                </c:if>
                                &emsp;
                                <c:forEach begin="1" end="${npag}" var="i">
                                    <c:choose>
                                        <c:when test="${i == pag}">
                                            <b>${i}</b>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?pag=${i}&ord=${ord}&q=${param.q}">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                &emsp;
                                <c:if test="${pag < npag}">
                                    <a href="?pag=${pag + 1}&ord=${ord}&q=${param.q}">successiva &rarr;</a>
                                </c:if>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <h3>NESSUN PRODOTTO</h3>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </c:when>
    <c:otherwise>
        <a href="./login.jsp">Effettua il login</a>
    </c:otherwise>
</c:choose>

<script>
    function createProductCardLibreria(prodotto) {
        var divContieni = document.createElement('div');
        divContieni.className = 'contieni';

        var quantitaHtml = prodotto.quantitaPosseduta > 1
            ? '<span style="font-size: 12px; color: #131313; margin-left: 10px;">(' + prodotto.quantitaPosseduta + ' copie)</span>'
            : '';

        var categorieHtml = '';
        if (prodotto.categorie && prodotto.categorie.length > 0) {
            var catLinks = [];
            for(var i = 0; i < prodotto.categorie.length; i++) {
                var cat = prodotto.categorie[i];
                catLinks.push('<a class="categoria" href="Negozio?categoria=' + cat.id + '">' + cat.nome + '</a>');
            }
            categorieHtml = catLinks.join(', ');
        }

        var images = prodotto.images ? prodotto.images : 'default.png';
        var descrizione = prodotto.descrizione ? prodotto.descrizione : '';
        var nome = prodotto.nome ? prodotto.nome : 'Prodotto Sconosciuto';

        divContieni.innerHTML =
            '<div class="img-col">' +
            '<a class="sub-img" href="Prodotto?id=' + encodeURIComponent(prodotto.id) + '">' +
            '<img src="images/prodotti/' + images + '" alt="' + nome + '">' +
            '</a>' +
            '</div>' +
            '<div class="col-2">' +
            '<div class="right-col">' +
            '<div class="name-over">' +
            '<h5>' + nome + quantitaHtml + '</h5>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="col-2-right">' +
            '<div style="float: right">' +
            '<p>' + descrizione + '</p>' +
            '<p>Categorie: ' + categorieHtml + '</p>' +
            '</div>' +
            '</div>';

        return divContieni;
    }

    function libreriaAjax() {
        var inputElement = document.getElementById("inputText");
        var str = inputElement ? inputElement.value : "";
        var currentOrd = document.getElementById("ordineSelect").value;

        var xmlHttpReq = new XMLHttpRequest();
        xmlHttpReq.responseType = 'json';

        xmlHttpReq.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var data = this.response;
                var menuContainer = document.getElementById("menu");
                if (!menuContainer) return;

                menuContainer.innerHTML = "";

                var prodotti = data.prodotti;

                if (!prodotti || prodotti.length === 0) {
                    menuContainer.innerHTML = "<h3>NESSUN PRODOTTO NELLA LIBRERIA</h3>";
                    return;
                }

                prodotti.forEach(function(prodotto) {
                    var newCard = createProductCardLibreria(prodotto);
                    menuContainer.appendChild(newCard);
                });

                // Aggiorna paginazione
                var pag = data.pag;
                var npag = data.npag;
                var paginazioneContainer = document.querySelector(".paginazione");
                if (paginazioneContainer) {
                    if (npag > 1) {
                        var html = "";
                        if (pag > 1) {
                            html += '<a href="?pag=' + (pag - 1) + '&ord=' + currentOrd + '&q=' + encodeURIComponent(str) + '">&larr; precedente</a>';
                        }
                        html += '&emsp;';
                        for (var i = 1; i <= npag; i++) {
                            if (i === pag) {
                                html += '<b>' + i + '</b>';
                            } else {
                                html += '<a href="?pag=' + i + '&ord=' + currentOrd + '&q=' + encodeURIComponent(str) + '">' + i + '</a>';
                            }
                        }
                        html += '&emsp;';
                        if (pag < npag) {
                            html += '<a href="?pag=' + (pag + 1) + '&ord=' + currentOrd + '&q=' + encodeURIComponent(str) + '">successiva &rarr;</a>';
                        }
                        paginazioneContainer.innerHTML = html;
                    } else {
                        paginazioneContainer.innerHTML = "";
                    }
                }
            }
        }

        var requestUrl = "LibreriaAjax?ord=" + encodeURIComponent(currentOrd) + "&q=" + encodeURIComponent(str);
        xmlHttpReq.open("GET", requestUrl, true);
        xmlHttpReq.send();
    }
</script>

<jsp:include page="footer.jsp"/>