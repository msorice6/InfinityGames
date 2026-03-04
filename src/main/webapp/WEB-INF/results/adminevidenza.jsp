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

<%-- Import delle classi necessarie --%>
<%@ page import="Model.ProdottoDAO" %>
<%@ page import="Model.Prodotto" %>
<%@ page import="java.util.ArrayList" %>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Categoria"/>
</jsp:include>

<%-- Carico tutti i prodotti dal database --%>
<%
    ProdottoDAO prodottoDAO = new ProdottoDAO();
    ArrayList<Prodotto> tuttiProdotti = prodottoDAO.doRetrieveAll(0, 100); // carico i primi 100 prodotti
    request.setAttribute("tuttiProdotti", tuttiProdotti);
%>

<div class="cat-all" ondblclick="chiudi(this)">
    <div class="font">
        <div>
            <h1>Seleziona i prodotti da mettere in evidenza:</h1>

            <%-- Messaggio di errore --%>
            <c:if test="${not empty errore}">
                <div style="color: red; text-align: center; margin: 20px auto; padding: 15px;
                            background-color: #ffebee; border: 2px solid red; border-radius: 10px;
                            width: 80%; font-weight: bold; font-size: 18px;">
                    ⚠️ ${errore}
                </div>
            </c:if>

            <%-- Messaggio di successo --%>
            <c:if test="${not empty successo}">
                <div style="color: green; text-align: center; margin: 20px auto; padding: 15px;
                            background-color: #e8f5e8; border: 2px solid green; border-radius: 10px;
                            width: 80%; font-weight: bold; font-size: 18px;">
                    ✅ ${successo}
                </div>
            </c:if>

            <div>
                <form action="AdminProdottiInEvidenza" method="get"
                      style="display: flex; gap: 20px; align-items: center; justify-content: center; flex-wrap: wrap;"
                      onsubmit="return validaForm()">

                    <div style="display: flex; flex-direction: column; align-items: center;">
                        <label for="prodotto1" style="font-weight: bold; margin-bottom: 5px;">Prodotto 1:</label>
                        <select name="num1" id="prodotto1" required
                                style="width: 200px; height: 40px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px;">
                            <option value="" ${empty prodotti[0] ? 'selected' : ''}>-- Seleziona un prodotto --</option>
                            <c:forEach var="prodotto" items="${tuttiProdotti}">
                                <option value="${prodotto.id}" ${prodotti[0].id == prodotto.id ? 'selected' : ''}>
                                        ${prodotto.nome}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="display: flex; flex-direction: column; align-items: center;">
                        <label for="prodotto2" style="font-weight: bold; margin-bottom: 5px;">Prodotto 2:</label>
                        <select name="num2" id="prodotto2" required
                                style="width: 200px; height: 40px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px;">
                            <option value="" ${empty prodotti[1] ? 'selected' : ''}>-- Seleziona un prodotto --</option>
                            <c:forEach var="prodotto" items="${tuttiProdotti}">
                                <option value="${prodotto.id}" ${prodotti[1].id == prodotto.id ? 'selected' : ''}>
                                        ${prodotto.nome}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="display: flex; flex-direction: column; align-items: center;">
                        <label for="prodotto3" style="font-weight: bold; margin-bottom: 5px;">Prodotto 3:</label>
                        <select name="num3" id="prodotto3" required
                                style="width: 200px; height: 40px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px;">
                            <option value="" ${empty prodotti[2] ? 'selected' : ''}>-- Seleziona un prodotto --</option>
                            <c:forEach var="prodotto" items="${tuttiProdotti}">
                                <option value="${prodotto.id}" ${prodotti[2].id == prodotto.id ? 'selected' : ''}>
                                        ${prodotto.nome}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="display: flex; flex-direction: column; align-items: center;">
                        <label for="prodotto4" style="font-weight: bold; margin-bottom: 5px;">Prodotto 4:</label>
                        <select name="num4" id="prodotto4" required
                                style="width: 200px; height: 40px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px;">
                            <option value="" ${empty prodotti[3] ? 'selected' : ''}>-- Seleziona un prodotto --</option>
                            <c:forEach var="prodotto" items="${tuttiProdotti}">
                                <option value="${prodotto.id}" ${prodotti[3].id == prodotto.id ? 'selected' : ''}>
                                        ${prodotto.nome}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="display: flex; align-items: center; margin-top: 20px; width: 100%; justify-content: center;">
                        <input type="submit" value="Salva"
                               style="font-size: 18px; padding: 12px 40px; background-color: #4CAF50; color: white;
                                      border: none; border-radius: 5px; cursor: pointer; font-weight: bold;">
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function validaForm() {
        var select1 = document.getElementById("prodotto1");
        var select2 = document.getElementById("prodotto2");
        var select3 = document.getElementById("prodotto3");
        var select4 = document.getElementById("prodotto4");

        // Verifica campi vuoti
        if (select1.value === "" || select2.value === "" || select3.value === "" || select4.value === "") {
            alert("Tutti i campi devono essere selezionati!");
            return false;
        }

        // Verifica duplicati
        if (select1.value === select2.value ||
            select1.value === select3.value ||
            select1.value === select4.value ||
            select2.value === select3.value ||
            select2.value === select4.value ||
            select3.value === select4.value) {
            alert("Non puoi selezionare lo stesso prodotto più volte!");
            return false;
        }

        return true;
    }
</script>

<jsp:include page="footer.jsp"/>