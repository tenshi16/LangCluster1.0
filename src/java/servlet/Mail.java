package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "Mail", urlPatterns = {"/Mail"})
public class Mail extends HttpServlet {
    
    final String TO="langcluster@gmail.com",PASS="urbe2017";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        boolean access=request.getHeader("referer").substring(0,request.getHeader("referer").lastIndexOf("/")).contains(request.getRequestURL().toString().substring(0,request.getRequestURL().toString().lastIndexOf("/")));
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        if(access){
            try{
                String from=request.getParameter("from");
                String message=request.getParameter("message");
                String reason=request.getParameter("reason");
                String section=request.getParameter("section");
                String oldfrom=request.getParameter("oldfrom");
                String date=request.getParameter("date");
                String code=request.getParameter("code");
                String instituto=request.getParameter("insti");
                String nivel=request.getParameter("nivelinsti");
                String curso=request.getParameter("curso");
                String dir=request.getParameter("dir");
                String ciudad=request.getParameter("ciudad");
                String pais=request.getParameter("pais");
                String name=request.getParameter("name");
                String lname=request.getParameter("lastname");
                String cargo=request.getParameter("cargo");
                if(from.trim().isEmpty() || message.trim().isEmpty() || reason.trim().isEmpty())    throw new Exception("Null Data");
                sendMail(from,message,reason,section,oldfrom,date,code,instituto,nivel,curso,dir,ciudad,pais,name,lname,cargo);
                System.out.println(from+"; reason="+reason+"; section="+section+"; oldfrom="+oldfrom+"; date="+date+"; code="+code);
                out.print("SENT");
                System.out.println("A message has been sent by ["+from+"]");
            } catch (Exception e) {
                out.print("ERROR");
                System.out.println("ERROR: Mail returned ["+e.getMessage()+"] while sending a message");
            }
        }   else out.print(""); 
            out.flush(); 
            out.close();
    }
    
    private void sendMail(String FROM,String MESSAGE,String REASON,
                          String SECTION,String OLDFROM,String DATE,String CODE,
                          String INSTI,String NIVEL,String CURSO,String DIR,String CIUDAD,String PAIS,
                          String NAME,String LASTNAME,String CARGO)throws Exception{
        Properties mailServerProperties = System.getProperties();
        mailServerProperties.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        mailServerProperties.put("mail.smtp.port", "587");
        mailServerProperties.put("mail.smtp.auth", "true");
        mailServerProperties.put("mail.smtp.starttls.enable", "true");
        Session getMailSession = Session.getDefaultInstance(mailServerProperties, null);
        MimeMessage generateMailMessage = new MimeMessage(getMailSession);
        //DATOS DEL CORREO
        generateMailMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(TO));
        generateMailMessage.setFrom(FROM);
        generateMailMessage.setSubject(REASON.toUpperCase()+" | "+FROM.toUpperCase());
        String emailBody = "<strong>Remitente: </strong>"+FROM+"<br/>"+
                           "<strong>Temática: </strong>"+REASON.toUpperCase()+"<br/>";
        
        switch(REASON){
            case "PROFESIONAL": case "ABUSO":
                                    emailBody+="<strong>Sección: </strong>"+SECTION.toUpperCase()+"<br/>";break;
            case "REPORTE PERDIDO": emailBody+="<strong>Sección: </strong>"+SECTION.toUpperCase()+"<br/>";
                                    emailBody+="<strong>Fecha: </strong>"+DATE+"<br/>";
                                    break;
            case "REPORTE ERRONEO": emailBody+="<strong>Sección: </strong>"+SECTION.toUpperCase()+"<br/>";
                                    if(SECTION.toUpperCase().equals("REPORTE")){
                                        emailBody+="<strong>Código: </strong>"+CODE+"<br/>";
                                    }else{
                                        emailBody+="<strong>Fecha: </strong>"+DATE+"<br/>";
                                    }
                                    break;
            case "EMAIL CAMBIADO":  emailBody+="<strong>Correo Anterior: </strong>"+OLDFROM.toUpperCase()+"<br/>";break;
            case "DOCENTE":         emailBody+="<br/><strong>Institución:</strong><br/><strong>Nombre:</strong>"+INSTI.toUpperCase()+"<br/>"+
                                               "<strong>Dirección: </strong>"+DIR.toUpperCase()+"<br/>"+
                                               "<strong>Ubicación: </strong>"+CIUDAD.toUpperCase()+", "+PAIS.toUpperCase()+"<br/>"+
                                               "<strong>Nivel: </strong>"+NIVEL.toUpperCase()+"<br/>"+
                                               "<strong>Curso: </strong>"+CURSO.toUpperCase()+"<br/>"+
                                               "<br/><strong>Persona:</strong><br/><strong>Nombre(s):</strong>"+NAME.toUpperCase()+"<br/>"+
                                               "<strong>Apellido(s): </strong>"+LASTNAME.toUpperCase()+"<br/>"+
                                               "<strong>Cargo: </strong>"+CARGO.toUpperCase()+"<br/>";
                                    break;
        }
        
        emailBody+= "<br/><strong>Mensaje: </strong><br/>"+MESSAGE+
                    "<br/><br/><br/>"+
                    "<em>Correo generado automáticamente desde la sección de contacto de <strong>www.langcluster.com</strong></em>";
        
        generateMailMessage.setContent(emailBody, "text/html");
        Transport transport = getMailSession.getTransport("smtp");
        transport.connect("smtp.gmail.com", TO, PASS);
        transport.sendMessage(generateMailMessage, generateMailMessage.getAllRecipients());
        transport.close();
    }
}