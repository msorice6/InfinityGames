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
                    <select name="ord" id="ordineSelect" onchange="this.form.submit()">
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
                    <select name="categoria" id="categoriaSelect" onchange="this.form.submit()">
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
                <button type="submit">
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

<jsp:include page="footer.jsp"/>