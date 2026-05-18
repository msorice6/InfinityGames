
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true"%>
<html>
<head>
    <title>Errore ${requestScope['javax.servlet.error.status_code']}</title>
    <link rel="stylesheet"
          href="./css/style.css"
          type="text/css"/>
</head>
<body>
<jsp:include page="banner.jsp"/>

<div ondblclick="chiudi(this)">
<h1>Errore ${requestScope['javax.servlet.error.status_code']}</h1>
<pre>${requestScope['javax.servlet.error.exception']}</pre>
<pre><%
    if (exception != null) {
        out.flush();
        exception.printStackTrace(response.getWriter());
    }
%></pre>
</div>
<jsp:include page="footer.jsp"/>
</body>
</html>
