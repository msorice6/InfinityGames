<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="Gestione Prodotti in Evidenza"/>
</jsp:include>

<script>
    function controllaDuplicati(selectModificato) {
        var selects = document.getElementsByName("prod1")[0];
        var select2 = document.getElementsByName("prod2")[0];
        var select3 = document.getElementsByName("prod3")[0];
        var select4 = document.getElementsByName("prod4")[0];

        var values = [
            selects.value,
            select2.value,
            select3.value,
            select4.value
        ];

        // Controlla duplicati
        for (var i = 0; i < values.length; i++) {
            for (var j = i + 1; j < values.length; j++) {
                if (values[i] !== "" && values[i] === values[j]) {
                    alert("Non puoi selezionare lo stesso prodotto due volte!");
                    selectModificato.value = "";
                    return false;
                }
            }
        }
        return true;
    }

    function aggiornaSelect() {
        var selects = document.getElementsByName("prod1")[0];
        var select2 = document.getElementsByName("prod2")[0];
        var select3 = document.getElementsByName("prod3")[0];
        var select4 = document.getElementsByName("prod4")[0];

        var valoriSelezionati = [
            selects.value,
            select2.value,
            select3.value,
            select4.value
        ];

        // Per ogni select, disabilita le opzioni già selezionate negli altri campi
        var selectsArray = [selects, select2, select3, select4];

        for (var s = 0; s < selectsArray.length; s++) {
            var selectCorrente = selectsArray[s];
            var valoreCorrente = selectCorrente.value;

            // Scansiona tutte le option
            for (var i = 0; i < selectCorrente.options.length; i++) {
                var option = selectCorrente.options[i];
                var valoreOpzione = option.value;

                // Se il valore è selezionato in un altro select e non è quello corrente
                if (valoreOpzione !== "" && valoreOpzione !== valoreCorrente) {
                    var trovato = false;
                    for (var j = 0; j < selectsArray.length; j++) {
                        if (j !== s && selectsArray[j].value === valoreOpzione) {
                            trovato = true;
                            break;
                        }
                    }
                    option.disabled = trovato;
                } else {
                    option.disabled = false;
                }
            }
        }
    }

    window.onload = function() {
        aggiornaSelect();
    };
</script>

<c:choose>
    <c:when test="${utente != null && utente.isAdmin()}">

        <div class="cat-all">
            <div class="font">
                <div>
                    <h1>Seleziona i prodotti da mettere in evidenza:</h1>

                    <c:if test="${notifica != null}">
                        <div style="color: green; margin-bottom: 20px;">
                                ${notifica}
                        </div>
                    </c:if>

                    <div>
                        <form action="AdminProdottiInEvidenza" method="post" onsubmit="return controllaDuplicati(this)"
                              style="display: flex; flex-direction: column; gap: 20px; align-items: center; justify-content: center;">

                            <div style="display: flex; gap: 20px; flex-wrap: wrap; justify-content: center;">
                                <!-- Selezione prodotto 1 -->
                                <div style="text-align: center;">
                                    <label>Prodotto in evidenza 1:</label><br>
                                    <select name="prod1" style="width: 200px; height: 40px; font-size: 14px;"
                                            onchange="aggiornaSelect()">
                                        <c:forEach items="${tuttiProdottiOrdinati}" var="prodotto">
                                            <option value="${prodotto.id}"
                                                    <c:if test="${prodottiEvidenza[0].id == prodotto.id}">selected</c:if>>
                                                    ${prodotto.nome}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Selezione prodotto 2 -->
                                <div style="text-align: center;">
                                    <label>Prodotto in evidenza 2:</label><br>
                                    <select name="prod2" style="width: 200px; height: 40px; font-size: 14px;"
                                            onchange="aggiornaSelect()">
                                        <c:forEach items="${tuttiProdottiOrdinati}" var="prodotto">
                                            <option value="${prodotto.id}"
                                                    <c:if test="${prodottiEvidenza[1].id == prodotto.id}">selected</c:if>>
                                                    ${prodotto.nome}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Selezione prodotto 3 -->
                                <div style="text-align: center;">
                                    <label>Prodotto in evidenza 3:</label><br>
                                    <select name="prod3" style="width: 200px; height: 40px; font-size: 14px;"
                                            onchange="aggiornaSelect()">
                                        <c:forEach items="${tuttiProdottiOrdinati}" var="prodotto">
                                            <option value="${prodotto.id}"
                                                    <c:if test="${prodottiEvidenza[2].id == prodotto.id}">selected</c:if>>
                                                    ${prodotto.nome}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Selezione prodotto 4 -->
                                <div style="text-align: center;">
                                    <label>Prodotto in evidenza 4:</label><br>
                                    <select name="prod4" style="width: 200px; height: 40px; font-size: 14px;"
                                            onchange="aggiornaSelect()">
                                        <c:forEach items="${tuttiProdottiOrdinati}" var="prodotto">
                                            <option value="${prodotto.id}"
                                                    <c:if test="${prodottiEvidenza[3].id == prodotto.id}">selected</c:if>>
                                                    ${prodotto.nome}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div>
                                <input type="submit" value="Salva Prodotti in Evidenza"
                                       style="font-size: 16px; padding: 10px 20px;">
                            </div>
                        </form>
                    </div>

                    <!-- Anteprima prodotti in evidenza attuali - versione compatta -->
                    <c:if test="${prodottiEvidenza != null && fn:length(prodottiEvidenza) > 0}">
                        <div style="margin-top: 30px;">
                            <h3>Prodotti in evidenza:</h3>
                            <div style="display: flex; gap: 10px; justify-content: center; flex-wrap: wrap;">
                                <c:forEach items="${prodottiEvidenza}" var="prodotto">
                                    <c:if test="${prodotto != null}">
                                        <div style="text-align: center;">
                                            <c:if test="${prodotto.images != null}">
                                                <img src="images/prodotti/${prodotto.images}"
                                                     style="width: 60px; height: 60px; object-fit: cover;">
                                            </c:if>
                                            <p style="font-size: 12px; margin: 5px 0;">${prodotto.nome}</p>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

    </c:when>
    <c:otherwise>
        <c:redirect url="error.jsp"/>
    </c:otherwise>
</c:choose>

<jsp:include page="footer.jsp"/>