package Controller.GestioneProdotto;

import Controller.GestioneUtente.MyServletException;
import Model.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Collections;
import java.util.stream.Collectors;

@WebServlet("/AdminProdotto")
@MultipartConfig
public class AdminProdottoServlet extends HttpServlet {

    private final ProdottoDAO prodottoDAO = new ProdottoDAO();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        ProdottoDAO prod = new ProdottoDAO();

        //MyServletException.checkAdmin(request);

        String idstr = request.getParameter("id");
        if (idstr != null) {
            if (request.getParameter("rimuovi") != null) {
                prodottoDAO.doDelete(Integer.parseInt(idstr));
                request.setAttribute("notifica", "Prodotto rimosso con successo.");
            } else {
                Prodotto prodotto;
                String nome = request.getParameter("nome");
                String descrizione = request.getParameter("descrizione");
                String prezzoCent = request.getParameter("prezzoCent");
                String sconto = request.getParameter("sconto");
                Part filePart = request.getPart("file");
                String videoLink = request.getParameter("video");

                if (nome != null  && descrizione != null && prezzoCent != null && sconto != null ) {
                    // modifica/aggiunta prodotto
                    prodotto = new Prodotto();
                    if(nome.equals("")){
                        throw new MyServletException("Campo nome vuoto");
                    }
                    prodotto.setNome(nome);
                    if(descrizione.equals("")){
                        throw new MyServletException("Campo descrizione vuoto");
                    }
                    prodotto.setDescrizione(descrizione);
                    double scont;
                    int prezz;


                    try {
                        scont = Double.parseDouble(prezzoCent);
                        prezz = Integer.parseInt(sconto);
                        if (prezz < 0 || scont < 0) {
                            throw new MyServletException("sconto e/o prezzo non validi");
                        }
                        prodotto.setPrezzo(scont);
                        prodotto.setSconto(prezz);

                    } catch (NumberFormatException e) {
                        throw new MyServletException("sconto e/o prezzo non validi");
                    }


                    if (filePart != null /*&& !filePart.equals("")*/) {
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        if (fileName != null && !fileName.equals("")) {
                            System.out.println("Nome file:" + fileName); //quando carichi una foto controlla che questo ti stampa il nome del
                            //file che hai caricato
                            filePart.write(getServletContext().getRealPath("") + File.separator + "images" + File.separator + "prodotti" + File.separator + fileName);
                            prodotto.setImages(fileName);
                        } else {
                            throw new MyServletException("Nessuna immagine selezionata");
                        }

                    } /*else{
                    throw new MyServletException("Nessuna immagine selezionata");
                }*/


                    if (videoLink != null && !videoLink.trim().isEmpty()) {
                        String videoId = extractYouTubeId(videoLink);
                        if (videoId != null) {
                            prodotto.setVideo(videoId);
                            System.out.println("ID YouTube estratto: " + videoId);
                        } else {
                            throw new MyServletException("Link YouTube non valido. Inserisci un URL del tipo https://www.youtube.com/watch?v=...");
                        }
                    }
                    try {
                        String[] categorie = request.getParameterValues("categorie");
                        if (categorie != null && !categorie.equals("")) {
                            prodotto.setCategorie(categorie != null ? Arrays.stream(categorie).map(id -> {
                                Categoria c = new Categoria();
                                c.setId(Integer.parseInt(id));
                                return c;
                            }).collect(Collectors.toList()) : Collections.emptyList());
                        } else {
                            throw new MyServletException("Nessuna categoria selezionata");
                        }
                    }catch(NumberFormatException e){
                        throw new MyServletException("Nessuna categoria selezionata");
                    }

                    if (idstr.isEmpty()) { // aggiunta nuovo prodotto
                        if (prod.doRetrieveProdottoByNome(nome) != null) {
                            throw new MyServletException("Prodotto già esistente");
                        }
                        prodottoDAO.doSave(prodotto);
                        request.setAttribute("notifica", "Prodotto aggiunto con successo.");
                    } else { // modifica prodotto esistente
                        prodotto.setId(Integer.parseInt(idstr));

                        if(prodottoDAO.doRetrieveById(Integer.parseInt(idstr))==null){
                            throw new MyServletException("id prodotto non valido");
                        }

                        prodottoDAO.doUpdate(prodotto);
                        request.setAttribute("notifica", "Prodotto modificato con successo.");
                    }



                } else {



                  /*  try {
                    if (prod.doRetrieveProdottoByNome(nome) != null) {
                        throw new MyServletException("Prodotto già esistente");
                    }*/


                  /*  }catch(MyServletException e ){
                        request.setAttribute("notifica","Prodotto già esistente");

                        RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/adminprodotto.jsp");
                        requestDispatcher.forward(request, response);
                    } */


                    int id;

                    try {
                        id = Integer.parseInt(idstr);

                    } catch (NumberFormatException e) {
                        throw new MyServletException("Id prodotto non valido");
                    }

                    prodotto = prodottoDAO.doRetrieveById(id);
                }

                request.setAttribute("prodotto", prodotto);
            }

        }

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/adminprodotto.jsp");
        requestDispatcher.forward(request, response);

    }
    private String extractYouTubeId(String url) {
        if (url == null) return null;
        // Pattern per estrarre l'ID da vari formati di URL YouTube
        String pattern = "(?<=v=|youtu.be/|/embed/|/v/|\\?v=|&v=)([a-zA-Z0-9_-]{11})";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
        java.util.regex.Matcher m = p.matcher(url);
        if (m.find()) {
            return m.group();
        }
        return null;
    }
}
