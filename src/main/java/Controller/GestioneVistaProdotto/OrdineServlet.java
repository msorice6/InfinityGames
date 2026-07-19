package Controller.GestioneVistaProdotto;

import Controller.GestioneUtente.MyServletException;
import Model.*;

import Model.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/Ordine")
public class OrdineServlet extends HttpServlet {

    private OrdiniDAO ordiniDAO= new OrdiniDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id;
        UtenteDAO uservice= new UtenteDAO();

        Utente utente=(Utente)request.getSession().getAttribute("utente");
        if (utente != null){
            /* PRODOTTO */

            try {
                id = Integer.parseInt(request.getParameter("id"));

            } catch (NumberFormatException e) {
                throw new MyServletException("Id prodotto non valido");
            }

            ProdottoDAO service = new ProdottoDAO();

            Prodotto prodotto = service.doRetrieveById(id);
            if (prodotto == null) {
                throw new MyServletException("Prodotto non trovato");
            }
            request.setAttribute("prodotto", prodotto);

            /* ORDINE */

//            List<Ordini> Ordini= ordiniDAO.getRetrieveByUtente(utente.getId());
//            request.setAttribute("ordini",Ordini);

            List<Ordini> Ordini= ordiniDAO.getRetrieveByProdottoUtente(prodotto.getId(), utente.getId());
            request.setAttribute("ordini",Ordini);


        }

        RequestDispatcher requestDispatcher= request.getRequestDispatcher("WEB-INF/results/ordine.jsp");
        requestDispatcher.forward(request, response);

    }
}