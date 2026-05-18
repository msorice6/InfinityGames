
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="banner.jsp">
    <jsp:param name="pageTitle" value="AutenticazioneFallita"/>
</jsp:include>

<div class="reg-all" ondblclick="chiudi(this)">
    <div class="font">
        <p style="margin-top: 0px">Username e/o password non validi</p>
        <p>Se vuoi effetuare l'accesso vai al  <a href="./login.jsp" >LOGIN</a> </p>
    </div>
</div>


<jsp:include page="footer.jsp"/>
