
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Ordini"/>
</jsp:include>
<c:choose>
    <c:when test="${utente != null}">
        <c:if test="${ordini.size() > 0}">
            <div class="all" ondblclick="chiudi(this)">
            <p>IN QUESTA SEZIONE PUOI TROVARE TUTTI GLI ORDINI EFFETTUATI</p>
            <c:forEach items="${ordini}" var="ord">
                <div class="ordini">
                    <div class="info">
                        <div class="info-lato"><p>Numero Ordine: ${ord.id}</p></div>
                        <div class="info-lato"><p>Data: ${ord.data}</p></div>
                        <div class="info-lato"><p>Totale: ${String.format("%.2f",ord.totale)}€</p></div>
                        <div class="info-lato"><p><i class="fa fa-angle-double-down"></i></p></div>
                    </div>
                    <div class="contain-ord">
                        <c:forEach items="${ord.prodotti}" var="prodotto">
                            <div class="prodotto-ordine">
                                <p>Nome:<a style="text-decoration: none"
                                           href="Prodotto?id=${prodotto.prodotto.id}"></a>${prodotto.prodotto.nome}</p>
                                <p>Prezzo:${String.format("%.2f",prodotto.prodotto.prezzo)}€</p>
                                <p>Quantita:${prodotto.quantita}</p>
                            </div>
                        </c:forEach>

                    </div>

                </div>
            </c:forEach>
        </c:if>
        <c:if test="${ordini.size() < 1}">
            <h3> Nessun ordine effettuato</h3>
        </c:if>
        </div>

    </c:when>
    <c:otherwise>
        <p>Per visualizzare gli ordini <a href="./login.jsp">Effettua il login</a></p>
    </c:otherwise>
</c:choose>
<jsp:include page="footer.jsp"/>


