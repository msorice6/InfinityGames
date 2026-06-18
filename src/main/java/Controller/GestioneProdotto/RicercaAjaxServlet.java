package Controller.GestioneProdotto;

import Controller.GestioneUtente.MyServletException;
import Model.*;
import org.json.JSONArray;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/RicercaAjax")
public class RicercaAjaxServlet extends HttpServlet {
    private final ProdottoDAO prodottoDAO = new ProdottoDAO();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        System.out.println("ciao");

        JSONArray prodJson = new JSONArray();
        String query = request.getParameter("q");
        if (query != null) {
            List<Prodotto> prodotti = prodottoDAO.doRetrieveByNomeRicerca(query + "*", null,0, 10);

            for (Prodotto p : prodotti) {
                org.json.JSONObject obj = new org.json.JSONObject();
                obj.put("id", p.getId());
                obj.put("nome", p.getNome());
                prodJson.put(obj);
            }

            response.setContentType("application/json");
            response.getWriter().append(prodJson.toString());

        }else {
            throw new MyServletException("parametro non valido");
        }

    }
}
