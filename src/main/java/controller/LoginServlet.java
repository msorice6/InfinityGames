package controller;

import model.Customer;
import model.CustomerDAO;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import model.Login;
import model.LoginDAO;

@WebServlet("/login-servlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // prende input dal form in login.html
       String username = request.getParameter("usernameForm");
       String password = request.getParameter("passwordForm");

       // ho la classe LoginDAO che salva tutti gli utenti e la password ( gli account)
        LoginDAO loginDAO = new LoginDAO();

        // l'oggetto Login cerca tra gli account ( il form password per ora non serve a nulla )
        Login login = loginDAO.findAccount(username);

        request.setAttribute("login", login);
        String address;
//        address = "/WEB-INF/results/logged.htm";
        address = "logged.html";

        RequestDispatcher dispatcher =
                request.getRequestDispatcher(address);
        dispatcher.forward(request, response);




    }







}
