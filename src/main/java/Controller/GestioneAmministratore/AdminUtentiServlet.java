package Controller.GestioneAmministratore;


import Controller.GestioneUtente.MyServletException;
import Model.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminUtenti")
public class AdminUtentiServlet extends HttpServlet {
    private final UtenteDAO utenteDAO = new UtenteDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        MyServletException.checkAdmin(request);

        List<Utente> utenti = utenteDAO.doRetrieveAll();
        request.setAttribute("utenti", utenti);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/adminutenti.jsp");
        requestDispatcher.forward(request, response);
    }
}
