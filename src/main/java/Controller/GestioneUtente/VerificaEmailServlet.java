package Controller.GestioneUtente;

import Model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/VerificaEmail")
public class VerificaEmailServlet extends HttpServlet {
    private final UtenteDAO utenteDAO = new UtenteDAO();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email");

            response.setContentType("text/xml");
            if (email != null && email.matches("^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w+)+$")
                    && utenteDAO.doRetrieveByEmail(email) == null) {
                response.getWriter().append("<ok/>");
            } else {
                response.getWriter().append("<no/>");
            }
        }

}
