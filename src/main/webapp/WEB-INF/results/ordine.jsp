<%@ page import="Model.Prodotto" %>
<%@ page import="java.io.File" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Prodotto ${prodotto.nome}"/>
</jsp:include>
<c:choose>
    <c:when test="${utente != null}">
        <div class="prodotto">
            <div>
                <div class="nome-prod"><p>${prodotto.nome}</p></div>
                <div class="cat">
                    <p>>>Categorie:
                        <c:forEach items="${prodotto.categorie}" var="categoria" varStatus="status">
                            <a href="CategoriaServlet?id=<c:out value="${categoria.id}"/>"><c:out
                                    value="${categoria.nome}"/></a><c:if test="${not status.last}">, </c:if>
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

                <div class="img-nom-desc">
                        <%--            <div class="imagine">--%>
                        <%--                <img src="./images/prodotti/${prodotto.images}">--%>
                        <%--            </div>--%>
                    <div class="nome-desc">
                        <div style="height:300px; width: 200%; overflow:auto;">
                            <c:choose>
                                <c:when test="${ordini != null && ordini.size() > 0}">
                                    <h4 style="color: white;">Ordini effettuati per questo prodotto:</h4>
                                    <br>

                                    <c:forEach items="${ordini}" var="ord">
                                        <div style="border-bottom: 1px solid #ccc; margin-bottom: 15px; padding-bottom: 10px;">
                                            <div><p>Numero Ordine: ${ord.id}</p></div>
                                            <div><p>Data: ${ord.data}</p></div>
                                            <div><p>Totale: ${String.format("%.2f", ord.totale)}€</p></div>
                                        </div>
                                    </c:forEach>

                                </c:when>
                                <c:otherwise>
                                    <p>Non hai ancora effettuato ordini per questo prodotto.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>


                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <c:redirect url="error.jsp"/>
    </c:otherwise>
</c:choose>

<jsp:include page="footer.jsp"/>
