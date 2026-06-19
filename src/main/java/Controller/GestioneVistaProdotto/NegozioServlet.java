package Controller.GestioneVistaProdotto;

import Model.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/Negozio")
public class NegozioServlet extends HttpServlet {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String q = request.getParameter("q");
        String ordStr = request.getParameter("ord");
        String categoriaStr = request.getParameter("categoria");
        String pagStr = request.getParameter("pag");
        String perpagStr = request.getParameter("perpag");

        int categoriaId = 0;
        if (categoriaStr != null && !categoriaStr.isEmpty()) {
            try { categoriaId = Integer.parseInt(categoriaStr); } catch (NumberFormatException ignored) {}
        }

        int pag = 1;
        if (pagStr != null && !pagStr.isEmpty()) {
            try { pag = Integer.parseInt(pagStr); } catch (NumberFormatException ignored) {}
        }

        int perpag = 10;
        if (perpagStr != null && !perpagStr.isEmpty()) {
            try { perpag = Integer.parseInt(perpagStr); } catch (NumberFormatException ignored) {}
        }

        ProdottoDAO.OrderByNegozio ord = ProdottoDAO.OrderByNegozio.ALFABETICO_ASC;
        if (ordStr != null && !ordStr.isEmpty()) {
            try { ord = ProdottoDAO.OrderByNegozio.valueOf(ordStr); } catch (IllegalArgumentException ignored) {}
        }

        request.setAttribute("categorie", categoriaDAO.doRetrieveAll());

        List<Prodotto> prodotti;
        int totalProdotti;

        if (q != null && !q.trim().isEmpty()) {
            // Ricerca FULLTEXT
            String search = q.trim();
            // Aggiungo wildcard per la ricerca booleana (come fanno gli altri metodi)
            String against = search + "*";
            totalProdotti = prodottoDAO.countByNomeFullText(against);
            prodotti = prodottoDAO.doRetrieveByNomeFullText(against, ord, (pag - 1) * perpag, perpag);
            request.setAttribute("q", q);
        } else if (categoriaId > 0) {
            totalProdotti = prodottoDAO.countByCategoria(categoriaId);
            prodotti = prodottoDAO.doRetrieveByCategoriaLimit(categoriaId, ord, (pag - 1) * perpag, perpag);
        } else {
            totalProdotti = prodottoDAO.countAllProdotti();
            prodotti = prodottoDAO.doRetrieveByNegozioLimit(ord, (pag - 1) * perpag, perpag);
        }

        int npag = (totalProdotti + perpag - 1) / perpag;
        if (npag == 0) npag = 1;

        request.setAttribute("prodotti", prodotti);
        request.setAttribute("pag", pag);
        request.setAttribute("npag", npag);
        request.setAttribute("perpag", perpag);
        request.setAttribute("ord", ord.name());
        request.setAttribute("categoriaId", categoriaId);

        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/results/negozio.jsp");
        dispatcher.forward(request, response);
    }
}