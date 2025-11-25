package Controller.GestioneUtente;

import Model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;

@WebServlet("/Logout")
public class LogoutServlet extends HttpServlet {
    //private final LoginDAO loginDAO = new LoginDAO();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getSession().invalidate();
       // request.getSession().removeAttribute("carrello");

        Cookie cookies[] = request.getCookies();
        if (cookies != null) {
            // cookie con nome 'login' o null se non esiste
            Cookie cookie = Arrays.stream(cookies).filter(c -> c.getName().equals("login")).findAny().orElse(null);
            if (cookie != null) {
                cookie.setMaxAge(0); // rimuove cookie
                response.addCookie(cookie);
                String id = cookie.getValue().split("_")[0];
               // loginDAO.doDelete(id);
            }
        }

        response.sendRedirect("/InfinityGames/");
    }
}
