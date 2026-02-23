package Controller.GestioneOrdini;

import Model.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DateFormat;
import java.util.*;

import static java.lang.Integer.*;

@WebServlet("/Acquisto")
public class AcquistoServlet extends HttpServlet {

    private OrdiniDAO ordiniDAO = new OrdiniDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        Utente utente = (Utente) request.getSession().getAttribute("utente");

        System.out.println("id utente: " + utente.getId());
        if (utente != null) {


            if (request.getParameter("conf-acq") != null) {

                ProdottoDAO prodottoDAO = new ProdottoDAO();

                Carrello carrello = (Carrello) request.getSession().getAttribute("carrello");
                System.out.println("preparati a ricevere un carrellone");

                Date date = new Date();
                // Formato compatibile con MySQL DATETIME
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String s = sdf.format(date);

                Collection<Carrello.ProdottoQuantita> lista = carrello.getProdotti();
                ArrayList<Carrello.ProdottoQuantita> lis = new ArrayList(lista);

                Ordini ordine = new Ordini();
                ordine.setUtente(utente.getId());
                ordine.setProdotti(lis);

                ordine.setData(s);
                ordine.setTotale(carrello.getPrezzoTotCent());


                ordiniDAO.doSave(ordine);

                // salva nel database la quantita' del prodotto
                for (int i = 0; i < lis.size(); i++) {
                    ProdottoDAO.setQuantita(lis.get(i).getProdotto().getId(), lis.get(i).getQuantita());
                }

                // salva nella libreria dell'utente i prodotti nel carrello e rimuove i prodotti dal carrello
                    Collection<Carrello.ProdottoQuantita> listaProdotti = carrello.getProdotti();
                    for (Carrello.ProdottoQuantita pq : listaProdotti) {
                        // Estraggo il prodotto dall'oggetto wrapper
                        Prodotto p = pq.getProdotto();

                        // Stampo l'ID (che corrisponde all'idProdotto nel DB)
                        System.out.println("ID Prodotto: " + p.getId() + " - Nome: " + p.getNome());

                        //Se il prodotto e' gia' memorizzato nella libreria non lo memorizza
                        if (!prodottoDAO.isPresenteInLibreria(p.getId(), carrello.getIdUtente())) {
                            prodottoDAO.doSaveInLibreria(p, carrello.getIdUtente());
                        }


//                        carrello.remove(p.getId());
                    }
                    CarrelloDAO.doDeleteAll(carrello);
                    carrello.getProdotti().clear();


                    RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/results/AcquistoSuccesso.jsp");
                    dispatcher.forward(request, response);


                } else {


                    RequestDispatcher dispatcher = request.getRequestDispatcher("./login.jsp");
                    dispatcher.forward(request, response);
                }
            }
        }
    }
