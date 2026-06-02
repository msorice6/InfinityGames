package Controller.GestioneVistaProdotto;

import Controller.GestioneUtente.MyServletException;
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

@WebServlet("/Negozio")
public class NegozioServlet extends HttpServlet {

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
        // 4. Recupera i prodotti
        List<Prodotto> prodotti;
        int totaleProdotti;

        if (categoriaId > 0) {
            prodotti = service.doRetrieveByCategoriaLimit(categoriaId, ord, (pag - 1) * perpag, perpag);
            totaleProdotti = service.countByCategoria(categoriaId);
        } else {
            prodotti = service.doRetrieveByNegozioLimit(ord, (pag - 1) * perpag, perpag);
            totaleProdotti = service.countAllProdotti();
        }

        // 5. Calcolo pagine
        int npag = (totaleProdotti + perpag - 1) / perpag;
        request.setAttribute("npag", npag);
        request.setAttribute("categoriaId", categoriaId);

        // 6. Categorie per il menu a tendina
        ArrayList<Categoria> categorie = categoriaService.doRetrieveAll();
        request.setAttribute("categorie", categorie);

        // 7. Prodotti
        request.setAttribute("prodotti", prodotti);

        // 8. Forward
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/results/negozio.jsp");
        dispatcher.forward(request, response);
    }
}