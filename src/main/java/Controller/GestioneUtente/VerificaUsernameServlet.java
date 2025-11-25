package Controller.GestioneUtente;

import Model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/VerificaUsername")
public class VerificaUsernameServlet extends HttpServlet {
    private final UtenteDAO utenteDAO = new UtenteDAO();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String username = request.getParameter("username");
        response.setContentType("text/xml");
        if (username != null && username.length() >= 6 && username.matches("^[0-9a-zA-Z]+$")
                && utenteDAO.doRetrieveByUsername(username) == null) {
            response.getWriter().append("<ok/>");
        } else {
            response.getWriter().append("<no/>");
        }
    }
}
