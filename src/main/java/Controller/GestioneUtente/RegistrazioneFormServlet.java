package Controller.GestioneUtente;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegistrazioneForm")
public class RegistrazioneFormServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if (request.getSession().getAttribute("utente") != null) {
            throw new MyServletException("Utente loggato.");
        }
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/results/registrazione.jsp");
        requestDispatcher.forward(request, response);
    }
}
