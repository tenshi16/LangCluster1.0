<%-- 
    Document   : validate
    Created on : May 22, 2016, 10:24:44 PM
    Author     : Diego
--%>

<%@ page import ="java.sql.*" %>
<%
    try{
        String username = request.getParameter("username");   
        String password = request.getParameter("password");
        Class.forName("com.mysql.jdbc.Driver");  // MySQL database connection
        String url = "jdbc:mysql://localhost/"+"LangCluster"+"?"; String UTF="&useUnicode=true&characterEncoding=UTF-8";
        String user="administrador",pass="pass";
        Connection conn = DriverManager.getConnection(url+UTF,user,pass);
        PreparedStatement pst = conn.prepareStatement("Select email,contrasena from usuario where email=? and contrasena=?");
        pst.setString(1, username);
        pst.setString(2, password);
        ResultSet rs = pst.executeQuery(); 
        if(rs.next())       
           out.println("<div id='response'>¡Bienvenido, "+username+"!</div>");
        else
           out.println("<div id='response'>Usuario no encontrado</div>");
   }
   catch(Exception e){       
       out.println("ERROR: "+e.getLocalizedMessage());
       e.printStackTrace();
   }      
%>
