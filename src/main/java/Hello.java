// Import required java libraries
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Random;

// Extend HttpServlet class
public class Hello extends HttpServlet {

   private String message;
   private Random r = new Random();

   public void init() throws ServletException {
      // Do required initialization
      message = "Hello new World: src/main/java/Hello.java, className: " + this.getClass().getName();
   }

   public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
      // Lets simulate a handled exception
      try {
         int result = 10 / 0;
      } catch (Exception e) {
         //TODO: handle exception
         System.out.println("exception handled!");
      }

      float chance = r.nextFloat();

      if (chance <= 0.10f)
      {
         int d=10-10;
         int result = 10 / d;
      }
      else
      {
         double val=10; //2147483647
         String sometext="";
         for (int i=1; i<=90000; i++)
         {
            sometext += "Hello World!";
            Math.atan(Math.sqrt(Math.pow(val, 10)));
         }
      }


      // Set response content type
      response.setContentType("text/html");

      // Actual logic goes here.
      PrintWriter out = response.getWriter();
      out.println("<h1>" + message + "</h1>");
   }
}
