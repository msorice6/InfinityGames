<%--
  Created by IntelliJ IDEA.
  User: Francesco Sabia
  Date: 19/05/2020
  Time: 11:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core" %>


<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Categoria"/>
</jsp:include>

 <div class="cat-all" ondblclick="chiudi(this)">

    <div class="font">
        <div>
            <h1>Inserisci l'id dei prodotti che vuoi mettere in evidenza:</h1>
<%--            <c:if test="${param.rimuovi == null}"> --%>
                <div>
                    <form action="AdminProdottiInEvidenza" method="get"
                          style="display: flex; gap: 20px; align-items: center; justify-content: center;">
                        <input type="number" name="num1" value="${prodotti[0].id}" style="width: 100px; height: 40px; font-size: 16px;">
                        <input type="number" name="num2" value="${prodotti[1].id}" style="width: 100px; height: 40px; font-size: 16px;">
                        <input type="number" name="num3" value="${prodotti[2].id}" style="width: 100px; height: 40px; font-size: 16px;">
                        <input type="number" name="num4" value="${prodotti[3].id}" style="width: 100px; height: 40px; font-size: 16px;">
                        <input type="submit" value="Salva" style="font-size: 16px; padding: 10px 20px;">
                    </form>

<%--                questo button l'ho voluto usare per salvare gli input types nella servlet
                                            <button type="button" onclick="searchProduct(this)" style="width: 100px; padding: 5px;">Cerca</button>
--%>

                        <%--
                                            <form action="AdminCategoria" method="post">
                                                <input type="hidden" name="id" value="${categoria.id}">
                                                <div>
                                                    <label>Nome:</label>
                                                    <input type="text" name="nome" value="${categoria.nome}">
                                                </div>
                                                <div>
                                                    <label>Descrizione:</label>
                                                    <textarea name="descrizione">${categoria.descrizione}</textarea>
                                                </div>
                                                <input type="submit" value="${operazione}">
                                                <c:if test="${categoria != null}">
                                                    <input type="submit" name="rimuovi" value="Rimuovi">
                                                </c:if>
                                            </form>
                                        </div>
                                    </c:if>
                        --%>
        </div>
    </div>
 </div>
<jsp:include page="footer.jsp"/>
