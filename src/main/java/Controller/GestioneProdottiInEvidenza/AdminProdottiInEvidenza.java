package Controller.GestioneProdottiInEvidenza;

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
import java.util.HashSet;
import java.util.Set;

@WebServlet("/AdminProdottiInEvidenza")
public class AdminProdottiInEvidenza extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        ArrayList<Prodotto> prodottoInEvidenza;
        boolean errore = false;

        try {
            String num1Str = request.getParameter("num1");
            String num2Str = request.getParameter("num2");
            String num3Str = request.getParameter("num3");
            String num4Str = request.getParameter("num4");

            // Verifica campi vuoti
            if (num1Str == null || num1Str.isEmpty() ||
                    num2Str == null || num2Str.isEmpty() ||
                    num3Str == null || num3Str.isEmpty() ||
                    num4Str == null || num4Str.isEmpty()) {

                request.setAttribute("errore", "Tutti i campi devono essere selezionati!");
                errore = true;
            } else {
                int num1 = Integer.parseInt(num1Str);
                int num2 = Integer.parseInt(num2Str);
                int num3 = Integer.parseInt(num3Str);
                int num4 = Integer.parseInt(num4Str);

                int[] valori = {num1, num2, num3, num4};

                // Verifica che tutti i prodotti siano selezionati (>0)
                for (int val : valori) {
                    if (val <= 0) {
                        request.setAttribute("errore", "Tutti i prodotti devono essere selezionati! Non possono esserci campi vuoti.");
                        errore = true;
                        break;
                    }
                }

                if (!errore) {
                    // Verifica duplicati
                    Set<Integer> set = new HashSet<>();
                    for (int val : valori) {
                        if (!set.add(val)) {
                            request.setAttribute("errore", "Non puoi selezionare lo stesso prodotto più volte! Trovato duplicato dell'ID: " + val);
                            errore = true;
                            break;
                        }
                    }
                }

                if (!errore) {
                    // Nessun errore, procedo con l'aggiornamento
                    prodottoDAO.doRmEvidenza();

                    // Inserisco i prodotti
                    for (int val : valori) {
                        if (val > 0) {
                            Prodotto p = new Prodotto();
                            p.setId(val);
                            prodottoDAO.doUpdateEvidenza(p);
                        }
                    }

                    request.setAttribute("successo", "Prodotti in evidenza aggiornati con successo!");
                }
            }

            // Recupero i prodotti attuali per mostrarli
            prodottoInEvidenza = prodottoDAO.doRetrieveEvidenzaAll_forTesting();

        } catch (NumberFormatException e) {
            request.setAttribute("errore", "Errore nel formato dei dati inviati!");
            prodottoInEvidenza = prodottoDAO.doRetrieveEvidenzaAll_forTesting();
        }

        request.setAttribute("prodotti", prodottoInEvidenza);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/adminevidenza.jsp");
        requestDispatcher.forward(request, response);
    }
}