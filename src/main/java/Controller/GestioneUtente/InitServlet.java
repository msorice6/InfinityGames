package Controller.GestioneUtente;


import Model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import java.util.ArrayList;

@WebServlet(name="MyInit", urlPatterns = "/MyInit",loadOnStartup=0)
public class InitServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        ArrayList<Categoria> categorie = categoriaDAO.doRetrieveAll();
        getServletContext().setAttribute("categorie", categorie);
        super.init();
    }
}
