<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Negozio"/>

</jsp:include>

<div class="contain" ondblclick="chiudi(this)">
    <div class="contain_all">

        <h1>NEGOZIO</h1>
        <p>Scopri tutti i nostri prodotti, ordina e filtra per categoria.</p>

        <!-- BARRA DI ORDINAMENTO E FILTRO - VERSIONE CON FORM -->
        <form method="get" action="Negozio" id="filtroForm">
            <div class="filtri-ordine">
                <div class="ordine-group">
                    <label for="ordineSelect">Ordina per:</label>
                    <select name="ord" id="ordineSelect" onchange="negozio()">
                        <option value="ALFABETICO_ASC" ${ord == 'ALFABETICO_ASC' ? 'selected' : ''}>A-Z</option>
                        <option value="ALFABETICO_DESC" ${ord == 'ALFABETICO_DESC' ? 'selected' : ''}>Z-A</option>
                        <option value="PREZZO_ASC" ${ord == 'PREZZO_ASC' ? 'selected' : ''}>Prezzo: dal più basso
                        </option>
                        <option value="PREZZO_DESC" ${ord == 'PREZZO_DESC' ? 'selected' : ''}>Prezzo: dal più alto
                        </option>
                        <option value="VENDUTI_ASC" ${ord == 'VENDUTI_ASC' ? 'selected' : ''}>Meno venduti</option>
                        <option value="VENDUTI_DESC" ${ord == 'VENDUTI_DESC' ? 'selected' : ''}>Più venduti</option>
                    </select>
                </div>

                <div class="filtro-group">
                    <label for="categoriaSelect">Categoria:</label>
                    <select name="categoria" id="categoriaSelect" onchange="negozio()">
                        <option value="0">Tutte le categorie</option>
                        <c:forEach items="${categorie}" var="cat">
                            <option value="${cat.id}" ${categoriaId == cat.id ? 'selected' : ''}>${cat.nome}</option>
                        </c:forEach>
                    </select>
                </div>


            <!-- Ricerca testuale  FATTA DA GERARDO-->
            <div class="ordine-group">
                <label>Ricerca</label>
                <input type="text" id="inputText" name="q" list="ricerca-datalist"
                       placeholder="Ricerca..." value="<c:out value="${param.q}" />"
                       onkeyup="ricerca(this.value)" autocomplete="off">
                <button type="submit" onclick="negozio()">
                    <img src="./images/search.png" width="15px" height="15px" alt="Cerca">
                </button>
                <datalist id="ricerca-datalist"></datalist>
            </div>
        <!-- FINE Ricerca testuale  FATTA DA GERARDO -->

    </div> <!-- questo stava piu' su -->
        </form>

      <c:choose>
      <c:when test="${prodotti.size() > 0}">

        <!-- CONTENITORE PRODOTTI -->
        <div id="menu">
          <c:forEach items="${prodotti}" var="prodotto">
            <div class="contieni">
              <div class="img-col">
                <a class="sub-img" href="Prodotto?id=${prodotto.id}">
                  <img src="images/prodotti/${prodotto.images}" alt="${prodotto.nome}">
                </a>
              </div>
              <div class="col-2">
                <div class="right-col">
                  <div class="name-over">
                    <h5>${prodotto.nome}</h5>
                  </div>
                  <div class="prezzo-down">
                    <div class="sub-prezzo">
                      <c:choose>
                        <c:when test="${prodotto.sconto > 0}">
                          <span style="color: green">-${prodotto.sconto}%</span>
                          <h5>Prezzo: <del>${String.format("%.2f", prodotto.prezzo)}€</del>
                              ${String.format("%.2f", prodotto.prezzoScontato)}€</h5>
                        </c:when>
                        <c:otherwise>
                          <h5>Prezzo: ${String.format("%.2f", prodotto.prezzo)}€</h5>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-2-right">
                <div style="float: right">
                  <p>Quantità vendute: ${prodotto.quant_vend}</p>
                  <p>Categorie:
                    <c:forEach items="${prodotto.categorie}" var="categoria" varStatus="status">
                      <a class="categoria" href="Negozio?categoria=${categoria.id}&ord=${ord}">
                        <c:out value="${categoria.nome}"/>
                      </a><c:if test="${not status.last}">, </c:if>
                    </c:forEach>
                  </p>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>

          <!-- PAGINAZIONE -->
          <div class="paginazione">


              <c:if test="${npag > 1}"> <!-- controlla se funziona -->
                  <c:if test="${pag > 1}">
                      <a href="?categoria=${categoriaId}&ord=${ord}&pag=${pag - 1}&perpag=${perpag}">&larr;
                          precedente</a>
                  </c:if>
                  &emsp;
                  <c:forEach begin="1" end="${npag}" var="i">
                      <c:choose>
                          <c:when test="${i == pag}">
                              <b>${i}</b>
                          </c:when>
                          <c:otherwise>
                              <a href="?categoria=${categoriaId}&ord=${ord}&pag=${i}&perpag=${perpag}">${i}</a>
                          </c:otherwise>
                      </c:choose>
                  </c:forEach>
                  &emsp;
                  <c:if test="${pag < npag}">
                      <a href="?categoria=${categoriaId}&ord=${ord}&pag=${pag + 1}&perpag=${perpag}">successiva
                          &rarr;</a>
                  </c:if>
            </c:if>  <!-- controlla se funziona -->

          </div>

      </c:when>
      <c:otherwise>
        <h3>NESSUN PRODOTTO TROVATO</h3>
        <p>Prova a cambiare filtro o categoria.</p>
      </c:otherwise>
    </c:choose>

  </div>
</div>

<script>
    // 1. We must define the function that builds the HTML here so the script knows what to do
    function createProductCardWithTemplate(prodotto) {
        var divContieni = document.createElement('div');
        divContieni.className = 'contieni';

        // Format the price based on whether there is a discount
        var prezzoHtml = '';
        if (prodotto.sconto > 0) {
            var prezzo = prodotto.prezzo ? prodotto.prezzo.toFixed(2) : '0.00';
            var prezzoScontato = prodotto.prezzoScontato ? prodotto.prezzoScontato.toFixed(2) : '0.00';
            prezzoHtml = '<span style="color: green">-' + prodotto.sconto + '%</span>' +
                '<h5>Prezzo: <del>' + prezzo + '€</del> ' + prezzoScontato + '€</h5>';
        } else {
            var prezzo = prodotto.prezzo ? prodotto.prezzo.toFixed(2) : '0.00';
            prezzoHtml = '<h5>Prezzo: ' + prezzo + '€</h5>';
        }

        // Safely extract categories and build the links
        var categorieHtml = '';
        if (prodotto.categorie && prodotto.categorie.length > 0) {
            var catLinks = [];
            var currentOrd = document.getElementById("ordineSelect").value;
            for(var i = 0; i < prodotto.categorie.length; i++) {
                var cat = prodotto.categorie[i];
                catLinks.push('<a class="categoria" href="Negozio?categoria=' + cat.id + '&ord=' + currentOrd + '">' + cat.nome + '</a>');
            }
            categorieHtml = catLinks.join(', ');
        }

        // Fallbacks just in case the JSON is missing data
        var images = prodotto.images ? prodotto.images : 'default.png';
        var quantVend = prodotto.quant_vend ? prodotto.quant_vend : 0;
        var nome = prodotto.nome ? prodotto.nome : 'Prodotto Sconosciuto';

        // Inject everything into the template
        divContieni.innerHTML =
            '<div class="img-col">' +
            '<a class="sub-img" href="Prodotto?id=' + encodeURIComponent(prodotto.id) + '">' +
            '<img src="images/prodotti/' + images + '" alt="' + nome + '">' +
            '</a>' +
            '</div>' +
            '<div class="col-2">' +
            '<div class="right-col">' +
            '<div class="name-over">' +
            '<h5>' + nome + '</h5>' +
            '</div>' +
            '<div class="prezzo-down">' +
            '<div class="sub-prezzo">' +
            prezzoHtml +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="col-2-right">' +
            '<div style="float: right">' +
            '<p>Quantità vendute: ' + quantVend + '</p>' +
            '<p>Categorie: ' + categorieHtml + '</p>' +
            '</div>' +
            '</div>';

        return divContieni;
    }

    // 2. Your main AJAX function
    function negozio() {
        var inputElement = document.getElementById("inputText");
        var str = inputElement ? inputElement.value : "";

        var currentOrd = document.getElementById("ordineSelect").value;
        var currentCategoria = document.getElementById("categoriaSelect").value;

        var xmlHttpReq = new XMLHttpRequest();
        xmlHttpReq.responseType = 'json';

        xmlHttpReq.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var menuContainer = document.getElementById("menu");
                if (!menuContainer) return;

                // Empty the container
                menuContainer.innerHTML = "";

                var prodotti = this.response;

                // Handle no products found
                if (!prodotti || prodotti.length === 0) {
                    menuContainer.innerHTML = "<h3>NESSUN PRODOTTO TROVATO</h3><p>Prova a cambiare filtro o categoria.</p>";
                    return;
                }

                // 3. THIS MUST NOT BE COMMENTED OUT. Loop through the JSON and draw the elements.
                prodotti.forEach(function(prodotto) {
                    var newCard = createProductCardWithTemplate(prodotto);
                    menuContainer.appendChild(newCard);
                });
            }
        }

        var requestUrl = "NegozioAjax?ord=" + encodeURIComponent(currentOrd) +
            "&categoria=" + encodeURIComponent(currentCategoria) +
            "&q=" + encodeURIComponent(str);

        xmlHttpReq.open("GET", requestUrl, true);
        xmlHttpReq.send();
    }
</script>

<jsp:include page="footer.jsp"/>