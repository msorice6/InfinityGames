<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="./WEB-INF/results/banner.jsp">
    <jsp:param name="pageTitle" value="Registrazione"/>
</jsp:include>

<c:if test="${utente == null}">
    <div class="page-content2" onclick="chiudi(this)">

        <div class="leftcol-reg">
            <form name="registrazione" action="Registrazione" method="post" style="max-width:500px;margin:auto">
                <h2>Register Form</h2><br>
                <label>Username (almeno 6 caratteri, solo lettere e numeri, non utilizzato da altri utenti)</label><br>
                <div class="input-container">
                    <i class="fa fa-user icon"></i>
                    <input class="input-field" type="text" placeholder="Username" id = "username" name="username"
                           oninput="validaUsername()">
                </div>
                <label>Email (diversa da quella di utenti esistenti)</label><br>
                <div class="input-container">
                    <i class="fa fa-envelope icon"></i>
                    <input class="input-field" type="text" placeholder="Email"  id = "email"  name="email" oninput="validaEmail()">
                </div>
                <label>Password (almeno 8 caratteri, deve contenere: una lettera maiuscola, una minuscola, un
                    numero)</label><br>
                <div class="input-container">
                    <i class="fa fa-key icon"></i>
                    <input class="input-field" type="password" placeholder="Password" id = "password" name="password"
                           oninput="validaPassword()">
                </div>
                <label>Password (conferma)</label><br>
                <div class="input-container">
                    <i class="fa fa-key icon"></i>
                    <input class="input-field" type="password" placeholder="Password" id="passwordConferma" name="passwordConferma"
                           oninput="validaPassword()">
                </div>
                <input id="registrami" type="submit" class="btn" value="Registrami" disabled>
                <span id="registramimessaggio">${notifica}</span>
            </form>
        </div>
    </div>
</c:if>
<c:if test="${utente != null}">
    <div class="reg-all" onclick="chiudi(this)">
        <div class="font">
            <p style="margin-top: 0px">Sei già registrato, esci e crea un nuovo account</p>
            <p>Vai al <a href="/InfinityGames/" >NEGOZIO</a> </p>
        </div>
    </div>
</c:if>
<jsp:include page="./WEB-INF/results/footer.jsp"/>


