package Controller.GestioneProdottiInEvidenza;

import Model.CategoriaDAO;
import Model.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/AdminProdottiInEvidenza")
public class AdminProdottiInEvidenza extends HttpServlet {
//
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {

        // 1. CONTROLLO ACCESSO LATO SERVER
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utente");

        // Se l'utente non è loggato oppure non è admin
        if (utente == null || !utente.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        } else {

            ProdottoDAO prodottoDAO = new ProdottoDAO();

            // Carica tutti i prodotti per il menu a tendina
            ArrayList<Prodotto> tuttiProdotti = prodottoDAO.doRetrieveAll(0, Integer.MAX_VALUE);

            // ORDINA ALFABETICAMENTE per nome
            Collections.sort(tuttiProdotti, new Comparator<Prodotto>() {
                @Override
                public int compare(Prodotto p1, Prodotto p2) {
                    return p1.getNome().compareToIgnoreCase(p2.getNome());
                }
            });

            request.setAttribute("tuttiProdottiOrdinati", tuttiProdotti);

            // Carica i prodotti attualmente in evidenza
            ArrayList<Prodotto> prodottiEvidenza = prodottoDAO.doRetrieveEvidenzaAll_forTesting();
            // Assicura che l'array abbia sempre 4 elementi (anche null)
            Prodotto[] evidenzaArray = new Prodotto[4];
            for (int i = 0; i < prodottiEvidenza.size() && i < 4; i++) {
                evidenzaArray[i] = prodottiEvidenza.get(i);
            }
            request.setAttribute("prodottiEvidenza", evidenzaArray);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/adminevidenza.jsp");
            requestDispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {

        // 1. CONTROLLO ACCESSO LATO SERVER
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utente");

        // Se l'utente non è loggato oppure non è admin
        if (utente == null || !utente.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        } else {

            ProdottoDAO prodottoDAO = new ProdottoDAO();

            try {
                // Leggi i parametri dai select
                String prod1Str = request.getParameter("prod1");
                String prod2Str = request.getParameter("prod2");
                String prod3Str = request.getParameter("prod3");
                String prod4Str = request.getParameter("prod4");

                List<Integer> ids = new ArrayList<>();

                // Aggiungi solo se non vuoti
                if (prod1Str != null && !prod1Str.isEmpty()) ids.add(Integer.parseInt(prod1Str));
                if (prod2Str != null && !prod2Str.isEmpty()) ids.add(Integer.parseInt(prod2Str));
                if (prod3Str != null && !prod3Str.isEmpty()) ids.add(Integer.parseInt(prod3Str));
                if (prod4Str != null && !prod4Str.isEmpty()) ids.add(Integer.parseInt(prod4Str));

                // CONTROLLO DUPLICATI LATO SERVER
                Set<Integer> setIds = new HashSet<>(ids);
                if (setIds.size() != ids.size()) {
                    request.setAttribute("notifica", "ERRORE: Non puoi selezionare lo stesso prodotto più volte!");
                } else if (ids.isEmpty()) {
                    request.setAttribute("notifica", "Nessun prodotto selezionato.");
                } else {
                    // Rimuovi tutti i prodotti in evidenza esistenti
                    prodottoDAO.doRmEvidenza();

                    // Inserisci i nuovi prodotti in evidenza
                    for (int id : ids) {
                        Prodotto p = new Prodotto();
                        p.setId(id);
                        prodottoDAO.doUpdateEvidenza(p);
                    }

                    request.setAttribute("notifica", "Prodotti in evidenza aggiornati con successo!");
                }

            } catch (NumberFormatException e) {
                request.setAttribute("notifica", "Errore: formato ID non valido.");
            }

            // Ricarica i dati per la visualizzazione
            ArrayList<Prodotto> tuttiProdotti = prodottoDAO.doRetrieveAll(0, Integer.MAX_VALUE);

            // ORDINA ALFABETICAMENTE per nome
            Collections.sort(tuttiProdotti, new Comparator<Prodotto>() {
                @Override
                public int compare(Prodotto p1, Prodotto p2) {
                    return p1.getNome().compareToIgnoreCase(p2.getNome());
                }
            });

            request.setAttribute("tuttiProdottiOrdinati", tuttiProdotti);

            ArrayList<Prodotto> prodottiEvidenza = prodottoDAO.doRetrieveEvidenzaAll_forTesting();
            Prodotto[] evidenzaArray = new Prodotto[4];
            for (int i = 0; i < prodottiEvidenza.size() && i < 4; i++) {
                evidenzaArray[i] = prodottiEvidenza.get(i);
            }
            request.setAttribute("prodottiEvidenza", evidenzaArray);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/adminevidenza.jsp");
            requestDispatcher.forward(request, response);
        }
    }
}