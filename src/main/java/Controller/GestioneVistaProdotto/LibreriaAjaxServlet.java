package Controller.GestioneVistaProdotto;

import Model.*;
import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/LibreriaAjax")
public class LibreriaAjaxServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        Utente utente = (Utente) request.getSession().getAttribute("utente");
        if (utente == null) {
            response.setContentType("application/json");
            response.getWriter().append("{\"prodotti\":[],\"pag\":1,\"npag\":0,\"totalProdotti\":0}");
            return;
        }

        ProdottoDAO service = new ProdottoDAO();

        // Parametro ordinamento
        String ordStr = request.getParameter("ord");
        ProdottoDAO.OrderByAlfabetico ord = ProdottoDAO.OrderByAlfabetico.DEFAULT;
        if (ordStr != null && !ordStr.isEmpty()) {
            try {
                ord = ProdottoDAO.OrderByAlfabetico.valueOf(ordStr);
            } catch (IllegalArgumentException e) {
                ord = ProdottoDAO.OrderByAlfabetico.DEFAULT;
            }
        }

        // Parametro ricerca
        String q = request.getParameter("q");

        // Recupera TUTTI i prodotti della libreria dell'utente
        List<Prodotto> tuttiProdotti = service.doRetrieveByLibreria(
                ProdottoDAO.OrderByAlfabetico.DEFAULT,
                utente.getId(),
                0,
                Integer.MAX_VALUE
        );

        // Filtra per nome se c'è una ricerca
        List<Prodotto> prodottiFiltrati;
        if (q != null && !q.trim().isEmpty()) {
            String search = q.trim().toLowerCase();
            prodottiFiltrati = tuttiProdotti.stream()
                    .filter(p -> p.getNome().toLowerCase().contains(search))
                    .collect(Collectors.toList());
        } else {
            prodottiFiltrati = new ArrayList<>(tuttiProdotti);
        }

        // Ordina
        if (ord == ProdottoDAO.OrderByAlfabetico.PREZZO_ASC) {
            prodottiFiltrati.sort((a, b) -> a.getNome().compareToIgnoreCase(b.getNome()));
        } else if (ord == ProdottoDAO.OrderByAlfabetico.PREZZO_DESC) {
            prodottiFiltrati.sort((a, b) -> b.getNome().compareToIgnoreCase(a.getNome()));
        }

        // Paginazione
        int pag = 1;
        String pagStr = request.getParameter("pag");
        if (pagStr != null && !pagStr.trim().isEmpty()) {
            try {
                pag = Integer.parseInt(pagStr);
            } catch (NumberFormatException e) {
                pag = 1;
            }
        }
        int perpag = 12;
        int totalProdotti = prodottiFiltrati.size();
        int npag = (totalProdotti + perpag - 1) / perpag;

        int fromIndex = (pag - 1) * perpag;
        int toIndex = Math.min(fromIndex + perpag, totalProdotti);

        List<Prodotto> prodottiPagina;
        if (fromIndex < totalProdotti) {
            prodottiPagina = prodottiFiltrati.subList(fromIndex, toIndex);
        } else {
            prodottiPagina = new ArrayList<>();
        }

        // Costruisci JSON
        JSONObject responseJson = new JSONObject();
        responseJson.put("pag", pag);
        responseJson.put("npag", npag);
        responseJson.put("totalProdotti", totalProdotti);

        JSONArray prodJson = new JSONArray();
        for (Prodotto p : prodottiPagina) {
            JSONObject obj = new JSONObject();
            obj.put("id", p.getId());
            obj.put("nome", p.getNome());
            obj.put("descrizione", p.getDescrizione() != null ? p.getDescrizione() : "");
            obj.put("images", p.getImages() != null ? p.getImages() : "");
            obj.put("quantitaPosseduta", p.getQuantitaPosseduta());

            JSONArray catArray = new JSONArray();
            if (p.getCategorie() != null) {
                for (Categoria c : p.getCategorie()) {
                    JSONObject catObj = new JSONObject();
                    catObj.put("id", c.getId());
                    catObj.put("nome", c.getNome());
                    catArray.put(catObj);
                }
            }
            obj.put("categorie", catArray);

            prodJson.put(obj);
        }
        responseJson.put("prodotti", prodJson);

        response.setContentType("application/json");
        response.getWriter().append(responseJson.toString());
    }
}