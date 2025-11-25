package Controller.GestioneCategoria;


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

@WebServlet("/AdminCategoria")
public class AdminCategoriaServlet extends HttpServlet {


    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        //MyServletException.checkAdmin(request);


    String rimuovi = request.getParameter("rimuovi");


    String idstr = request.getParameter("id");
    if (idstr != null) {



      List<Categoria> categorie = (List<Categoria>) getServletContext().getAttribute("categorie");


        Categoria categoria = null;
        if (!idstr.isEmpty()) {
            int id;

            try {
                id = Integer.parseInt(idstr);

            } catch (NumberFormatException e) {
                throw new MyServletException("Id prodotto non valido");
            }
            if(categoriaDAO.doRetrieveCategoriaById(Integer.parseInt(idstr))==null){
                throw new MyServletException("id categoria non valido");
            }
            categoria = categorie.stream().filter(c -> c.getId() == id).findAny().get();
        }

        if (rimuovi != null && !rimuovi.equals("")) {
            categoriaDAO.doDelete(categoria.getId());
            categorie.remove(categoria);
            request.setAttribute("notifica", "Categoria rimossa con successo.");


        } else {
            String descrizione = request.getParameter("descrizione");
            String nome = request.getParameter("nome");
            if (nome != null && !nome.equals("") && descrizione != null && !descrizione.equals("")) { // modifica/aggiunta categoria

                if(!(nome.matches("[a-zA-Z ]+"))){
                    throw new MyServletException("Formato nome non valido");
                }


                if(!(descrizione.matches("[a-zA-Z ]+"))){
                    throw new MyServletException("Formato descrizione non valido");
                }

                if (categoria == null) { // aggiunta nuova categoria
                    categoria = new Categoria();

                    categoria.setNome(nome);


                    if(categoriaDAO.doRetrieveCategoriaByNome(nome)!=null){
                        throw new MyServletException("nome categoria già esistente");
                    }

                    categoria.setDescrizione(descrizione);
                    categoriaDAO.doSave(categoria);
                    categorie.add(categoria);
                    request.setAttribute("notifica", "Categoria aggiunta con successo.");


                } else { // modifica categoria esistente

                    categoria.setNome(nome);
                    categoria.setDescrizione(descrizione);
                    categoriaDAO.doUpdate(categoria);
                    request.setAttribute("notifica", "Categoria modificata con successo.");
                }
            } else {
                request.setAttribute("notifica", "Nessun nome e/o descrizione  inserite");

            }
            request.setAttribute("categoria", categoria);
        }


    }

    RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/admincategoria.jsp");
    requestDispatcher.forward(request, response);


    }



}
