package Controller.GestioneProdottiInEvidenza;

import Model.CategoriaDAO;
import Model.Prodotto;
import Model.ProdottoDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/AdminProdottiInEvidenza")
public class AdminProdottiInEvidenza extends HttpServlet {
//    private final il DAO inerente al prodotto che va messo in evidenza

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        ArrayList<Prodotto> prodottoInEvidenza = new ArrayList<>();

        try{

            int num1 = Integer.parseInt(request.getParameter("num1"));
            int num2 = Integer.parseInt(request.getParameter("num2"));
            int num3 = Integer.parseInt(request.getParameter("num3"));
            int num4 = Integer.parseInt(request.getParameter("num4"));

            prodottoDAO.doRmEvidenza();
            Prodotto p = new Prodotto();
            p.setId(num1);
            prodottoDAO.doUpdateEvidenza(p);
            p.setId(num2);
            prodottoDAO.doUpdateEvidenza(p);
            p.setId(num3);
            prodottoDAO.doUpdateEvidenza(p);
            p.setId(num4);
            prodottoDAO.doUpdateEvidenza(p);


        }catch (NumberFormatException e) {

            prodottoInEvidenza = prodottoDAO.doRetrieveEvidenzaAll_forTesting();
            request.setAttribute("prodotti", prodottoInEvidenza);

        }


//        prodottoInEvidenza = prodottoDAO.doRetrieveEvidenzaAll_forTesting();
        request.setAttribute("prodotti", prodottoInEvidenza);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/adminevidenza.jsp");
        requestDispatcher.forward(request, response);
    }

}

