package model;

public class Login {

   private final String user, password;
   public Login(String user, String password) {
      this.user = user;
      this.password = password;
   }

    public String getPassword() {
        return password;

    }

    public String getUser() {
    return user;
}


}
