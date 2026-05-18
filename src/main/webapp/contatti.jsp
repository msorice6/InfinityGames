
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>


<jsp:include page="./WEB-INF/results/banner.jsp">
    <jsp:param name="pageTitle" value="Contatti"/>
</jsp:include>

<div class="contatti">
    <div class="sub-cont" style="width: 600px; margin: 20px auto;">
        <p>
            Ciao, ${utente.username}.
            Contattaci per qualsiasi evenienza compilando il form seguente:
        </p>
        <form id="form" action="/" method="post">
            <h2>Scriveteci!</h2>
            <fieldset>
                <p>
                    <label for="name">* Username</label>
                    <input type="text" name="name" id="name" size="30" />
                </p>
                <p>
                    <label for="email">* Email</label>
                    <input type="text" name="email" id="email" size="30" />
                </p>

            </fieldset>
            <fieldset>
                <p>
                    <label for="message">* Messsaggio:</label>
                    <textarea name="message" id="message" cols="30" rows="10"></textarea>
                </p>
            </fieldset>
            <p class="submit"><button type="submit">Inviare</button></p>
        </form>
        </div>
</div>

<jsp:include page="./WEB-INF/results/footer.jsp"/>

