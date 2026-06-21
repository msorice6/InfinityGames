package Controller.GestioneVistaProdotto;

import Controller.GestioneUtente.MyServletException;
import Model.*;
import org.json.JSONArray;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/NegozioAjax")
public class NegozioAJAXServlet extends HttpServlet {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ProdottoDAO service = new ProdottoDAO();
        CategoriaDAO categoriaService = new CategoriaDAO();

        // 1. Parametri filtro categoria
        String categoriaIdStr = request.getParameter("categoria");
        int categoriaId = 0;
        if (categoriaIdStr != null && !categoriaIdStr.equals("")) {
            try {
                categoriaId = Integer.parseInt(categoriaIdStr);
            } catch (NumberFormatException e) {
                throw new MyServletException("ID categoria non valido");
            }
        }

        // 2. Parametri paginazione
        String pagStr = request.getParameter("pag");
        int pag;
        if (pagStr == null || pagStr.equals("")) {
            pag = 1;
        } else {
            try {
                pag = Integer.parseInt(pagStr);
            } catch (NumberFormatException e) {
                throw new MyServletException("Parametro pagina non valido");
            }
        }
        request.setAttribute("pag", pag);

        int perpag = 12;
        request.setAttribute("perpag", perpag);

        // 3. Parametro ordinamento
        String ordStr = request.getParameter("ord");
        ProdottoDAO.OrderByNegozio ord;
        if (ordStr == null || ordStr.equals("")) {
            ord = ProdottoDAO.OrderByNegozio.ALFABETICO_ASC;
        } else {
            try {
                ord = ProdottoDAO.OrderByNegozio.valueOf(ordStr);
            } catch (IllegalArgumentException e) {
                ord = ProdottoDAO.OrderByNegozio.ALFABETICO_ASC;
            }
        }
        request.setAttribute("ord", ord);

        // 4. Recupera i prodotti
        List<Prodotto> prodotti;

        String q = request.getParameter("q");
        int totalProdotti;
        if (q != null && !q.trim().isEmpty()) {
            // Ricerca FULLTEXT
            String search = q.trim();
            String against = search + "*";
            totalProdotti = service.countByNomeFullText(against);
            prodotti = service.doRetrieveByNomeFullText(against, ord, (pag - 1) * perpag, perpag);
            request.setAttribute("q", q);
        } else if (categoriaId > 0) {
            totalProdotti = service.countByCategoria(categoriaId);
            prodotti = service.doRetrieveByCategoriaLimit(categoriaId, ord, (pag - 1) * perpag, perpag);
        } else {
            totalProdotti = service.countAllProdotti();
            prodotti = service.doRetrieveByNegozioLimit(ord, (pag - 1) * perpag, perpag);
        }

        // 5. Calcolo pagine
        int npag = (totalProdotti + perpag - 1) / perpag;
        request.setAttribute("npag", npag);
        request.setAttribute("categoriaId", categoriaId);

        // 6. Categorie per il menu a tendina
        ArrayList<Categoria> categorie = categoriaService.doRetrieveAll();
        request.setAttribute("categorie", categorie);
        System.out.println("sono nell'ajax npag: "+npag+" categoria: "+ categoriaIdStr+ "ordinamento: "+ ordStr);
        // 7. Prodotti
        request.setAttribute("prodotti", prodotti);

        JSONArray prodJson = new JSONArray();
        for (Prodotto p : prodotti) {
            org.json.JSONObject obj = new org.json.JSONObject();
            obj.put("id", p.getId());
            obj.put("nome", p.getNome());
            obj.put("prezzo", p.getPrezzo());
            prodJson.put(obj);
        }
        response.setContentType("application/json");
        response.getWriter().append(prodJson.toString());
    }
}