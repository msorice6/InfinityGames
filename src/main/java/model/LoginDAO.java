package model;

import java.util.HashMap;
import java.util.Map;

public class LoginDAO {
    private Map<String, Login> logins = new HashMap<String, Login>() {
        {
           put("admin", new Login("admin", "admin"));
           put("user1", new Login("giacomone", "giolitti"));


        }

    };
    public Login findAccount(String user){
        return logins.get(user);


    }



}


//private Map<String, Customer> customers = new HashMap<String, Customer>()
//{
//    {
//        put("id001", new Customer("id001", "Harry", "Hacker", -3456.78));
//        put("id002", new Customer("id002", "Codie", "Coder", 1234.56));
//        put("id003", new Customer("id003", "Polly", "Programmer", 987654.32));
//    }
//};
//