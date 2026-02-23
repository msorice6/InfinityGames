package Controller.GestioneUtente;

import Model.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name="/HomeServlet", urlPatterns = "/index.html")
public class HomeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ProdottoDAO prodottoDAO = new ProdottoDAO();
        ArrayList<Prodotto> prodotti = prodottoDAO.doRetrieveEvidenzaAll_forTesting();
        ArrayList<Prodotto> lista= prodottoDAO.doRetrieveAllSconto();

        request.setAttribute("sconti",lista);
        request.setAttribute("prodotti", prodotti);

        RequestDispatcher dispatcher=request.getRequestDispatcher("/WEB-INF/results/index.jsp");
        dispatcher.forward(request,response);

    }
}
