<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Home"/>
</jsp:include>

<div class="container_row" ondblclick="chiudi(this)">
    <div class="homepage">
        <div class="totale">
            <div class="fianco">
                <h2>IN SCONTO</h2>

                <div class="sconti-container">
                    <c:forEach items="${sconti}" var="prodotto" begin="0" end="2">
                        <!-- Aggiunta classe mySlidesSconti e animazione fade -->
                        <div class="mySlidesSconti fade">
                            <div class="sconti">
                                <div>
                                    <a href="Prodotto?id=${prodotto.id}">
                                        <img src="./images/prodotti/${prodotto.images}">
                                    </a>
                                </div>
                                <div class="sub-sc">
                                    <div class="sc1">
                                            ${prodotto.sconto}%
                                    </div>
                                    <div class="sc2">
                                        <div>
                                            <del>${String.format("%.2f",prodotto.prezzo)}€</del>
                                        </div>
                                        <div>
                                                ${String.format("%.2f",prodotto.prezzo = prodotto.prezzo - (prodotto.prezzo*prodotto.sconto)/100)}€
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <div id="frecceSconti" style="text-align:center">
                    <!-- Frecce di navigazione  -->
                        <a class="prev" onclick="plusSlidesSconti(-1)">&#10094;</a>
                        <a class="next" onclick="plusSlidesSconti(1)">&#10095;</a>

                    </div>
                </div>
            </div>

            <div class="allinea">
                <nav class="navbar">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a href="#" class="accordion">IL TUO NEGOZIO</a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="Recenti">Visualizzati di recente</a>
                            </div>
                        </li>
                        <li class="nav-item">
                            <a href="#" class="accordion">GIOCHI</a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="Negozio?ord=PREZZO_ASC">In sconto</a>
                                <a class="dropdown-item" href="Negozio?ord=VENDUTI_DESC">Più venduti</a>
                            </div>
                        </li>
                        <li class="nav-item">
                            <a href="#" class="accordion">CATEGORIA</a>
                            <div class="dropdown-menu">
                                <c:forEach items="${applicationScope.categorie}" var="categoria">
                                    <a class="dropdown-item" href="Negozio?categoria=${categoria.id}">${categoria.nome}</a>
                                </c:forEach>
                            </div>
                        </li>

                        <form class="form-inline" method = "get" action="Prodotto" id = "filtroForm">
                            <input type="text" id = "inputText" name="id" list="ricerca-datalist" placeholder="Ricerca" onkeyup="ricerca(this.value)" value="<c:out value="${param.q}" />">
                            <button type="submit"><img src="./images/search.png" width="15px" height="15px"></button>
                            <datalist id="ricerca-datalist"></datalist>
                            <p id="risultati"style="display: none;" > risultati in p </p>
                        </form>
                    </ul>
                </nav>

                <div class="slideshow-container">
                    <h2>IN EVIDENZA</h2>
                    <c:forEach items="${prodotti}" var="prodotto" begin="0" end="3">
                        <div class="mySlides fade">
                            <a href="Prodotto?id=${prodotto.id}">
                                <img src="./images/prodotti/${prodotto.images}">
                            </a>
                        </div>
                    </c:forEach>

                    <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
                    <a class="next" onclick="plusSlides(1)">&#10095;</a>

                    <div id="bottom" style="text-align:center">
                        <span class="dot" onclick="currentSlide(1)">1</span>
                        <span class="dot" onclick="currentSlide(2)">2</span>
                        <span class="dot" onclick="currentSlide(3)">3</span>
                        <span class="dot" onclick="currentSlide(4)">4</span>
                    </div>
                </div>
            </div>

            <section id="drinks">
                <div class="vertical-menu">
                    <a class="vertical_item" href="#">
                        <img src="./images/logoTSW.png" width="150" height="100">
                    </a>
                    <h4>SFOGLIA PER GENERE</h4>
                    <c:forEach items="${applicationScope.categorie}" var="categoria">
                        <a class="vertical_item" href="Negozio?categoria=${categoria.id}">${categoria.nome}</a>
                    </c:forEach>
                </div>
            </section>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"/>