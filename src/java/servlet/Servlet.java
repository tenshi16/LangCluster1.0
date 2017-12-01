/*
 * LangCluster - Servlet
 */
package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "Servlet", urlPatterns = {"/Servlet"})
public class Servlet extends HttpServlet {
    //private static final String DATA_FILES=File.listRoots()[0]+"\\LangCluster\\";
    private Connection connection;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                PrintWriter out = response.getWriter();
                out.print("null");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                boolean access=request.getHeader("referer").substring(0,request.getHeader("referer").lastIndexOf("/")).contains(request.getRequestURL().toString().substring(0,request.getRequestURL().toString().lastIndexOf("/")));
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                if(access){
                    String id=request.getParameter("id");
                    //System.out.println("Access Granted to ["+id+"]");
                    try{
                        connect();        
                        response.setContentType("Text/plain");
                        Enumeration<String> parameterNames=request.getParameterNames();
                        ArrayList<String> parameters=new ArrayList<>();
                        while(parameterNames.hasMoreElements())
                            parameters.add(request.getParameter(parameterNames.nextElement()));
			
                        PreparedStatement Consulta = filter(id,parameters);
                        //System.out.println("valor Consulta= "+Consulta);
			if(Consulta.toString().contains("update") || Consulta.toString().contains("insert") || Consulta.toString().contains("delete")){
			    int rs = Consulta.executeUpdate(); 
                            //System.out.println("Realizando insert");
			    //System.out.println("valor RS= "+rs);
			    out.println(rs);
			}else{ 
			    ResultSet rs = Consulta.executeQuery();
			    JSONArray JSONArray = convertResultSetIntoJSON(rs);
			    if(JSONArray.isNull(0)) throw new Exception("Null Data");
                            out.println(JSONArray);
                            //System.out.println(JSONArray);
			}
                    }catch(Exception e){
                        System.out.println("ERROR: Servlet returned ["+e.getMessage()+"] while performing ["+id+"]");
                        out.print("");
                    }
                } else out.print(""); 
		closeconnect();
                out.flush(); 
                out.close();
    }
    
    @Override
    public String getServletInfo() {
        return "LangCluster Servlet";
    }// </editor-fold>

    
    private void connect() throws Exception{
        Class.forName("com.mysql.jdbc.Driver");
        String url = "jdbc:mysql://localhost/";
        String dbName = "LangCluster";
        String username = "administrador";
        String password = "pass";
        String UTF="&useUnicode=true&characterEncoding=UTF-8";
        connection = DriverManager.getConnection(url+dbName+"?"+UTF,username,password);
        /*PreparedStatement utf8=connection.prepareStatement("SET NAMES 'UTF8'");
        utf8.executeQuery();
        utf8=connection.prepareStatement("SET CHARACTER SET 'UTF8'");
        utf8.executeQuery();*/
    }
    
    private void closeconnect(){
        try{connection.close();}catch(Exception e){}
    }
    
    private PreparedStatement filter(String id,ArrayList<String> parameters) throws Exception{
	PreparedStatement pst = null;
	PreparedStatement pst1 = null;
        switch(id){
            case "1":   pst = connection.prepareStatement("Select email,nombre from usuario where email =? and contrasena =?");
                        pst.setString(1, parameters.get(0));
                        pst.setString(2, parameters.get(1));
                        break;
            case "2":   pst = connection.prepareStatement("select email from usuario where email = ?");
                        pst.setString(1, parameters.get(0));
                        break;
            case "3":   pst = connection.prepareStatement("select aux_permiso_usuario.id_permiso from aux_permiso_usuario inner join usuario on usuario.id_usuario=aux_permiso_usuario.id_usuario inner join permiso on permiso.id_permiso=aux_permiso_usuario.id_permiso where usuario.email=?");
                        pst.setString(1, parameters.get(0));
                        break;
            case "4":   pst = connection.prepareStatement("select nombre_pais as id from pais order by codigo_pais='-',nombre_pais");
                        break;
            case "5":   pst = connection.prepareStatement("select email, nombre_pais, nombre, fecha_nacimiento, ruta_avatar from `usuario` inner join `pais` on (`usuario`.`codigo_pais` = `pais`.`codigo_pais`) where email= ?");
                        pst.setString(1, parameters.get(0));
                        break;							
	    case "6":   pst1 = connection.prepareStatement("insert into usuario(email,contrasena,nombre,fecha_nacimiento,codigo_pais,ruta_avatar) values(?,?,?,?,(select codigo_pais from pais where nombre_pais=?),?)");
			pst1.setString(1, parameters.get(0));
			pst1.setString(2, parameters.get(1));
			pst1.setString(3, parameters.get(2));
			pst1.setString(4, parameters.get(3).replaceAll("-", ".").substring(0,parameters.get(3).indexOf(" ")));
			pst1.setString(5, parameters.get(4));
			pst1.setString(6, parameters.get(5));
			pst1.executeUpdate();
			pst=connection.prepareStatement("insert into aux_permiso_usuario values('1',(select id_usuario from usuario where email=?))");
			pst.setString(1, parameters.get(0));
			break;
            case "7":	pst= connection.prepareStatement("SELECT * FROM\n" +
                        "(SELECT `usuario`.`nombre` AS nombre ,\n" +
                        " MAX(`nivel`.`num_nivel`) AS nivel, \n" +
                        " SUM(`sesion`.`puntaje_sesion`) AS puntaje,\n" +
                        " `usuario`.`ruta_avatar` AS ruta\n" +
                        " FROM `langcluster`.`sesion` \n" +
                        " INNER JOIN `langcluster`.`usuario` ON (`sesion`.`id_usuario` = `usuario`.`id_usuario`) \n" +
                        " INNER JOIN `langcluster`.`aux_sesion_termino` ON (`aux_sesion_termino`.`id_sesion` = `sesion`.`id_sesion`) \n" +
                        " INNER JOIN `langcluster`.`termino` ON (`aux_sesion_termino`.`id_termino` = `termino`.`id_termino`) \n" +
                        " INNER JOIN `langcluster`.`nivel` ON (`termino`.`num_nivel` = `nivel`.`num_nivel`) \n" +
                        " WHERE usuario.email=? ) AS B\n" +
                        " INNER JOIN\n" +
                        "( SELECT \n" +
                        "`sesion`.`puntaje_sesion` AS puntajed,\n" +
                        "`usuario`.`nombre` AS X\n" +
                        " FROM `langcluster`.`sesion` \n" +
                        " INNER JOIN `langcluster`.`usuario` ON (`sesion`.`id_usuario` = `usuario`.`id_usuario`) \n" +
                        " INNER JOIN `langcluster`.`aux_sesion_termino` ON (`aux_sesion_termino`.`id_sesion` = `sesion`.`id_sesion`) \n" +
                        " INNER JOIN `langcluster`.`termino` ON (`aux_sesion_termino`.`id_termino` = `termino`.`id_termino`) \n" +
                        " INNER JOIN `langcluster`.`nivel` ON (`termino`.`num_nivel` = `nivel`.`num_nivel`) \n" +
                        " WHERE usuario.email=? ) AS C\n" +
                        " ON B.nombre=C.X LIMIT 1;");
                        pst.setString(1, parameters.get(0));
                         pst.setString(2, parameters.get(0));
                        break;
	    case "71":	pst= connection.prepareStatement("SELECT num_nivel AS nivel,nombre_topico AS nom, desc_topico AS des FROM topico WHERE id_topico=?");
                        pst.setInt(1, Integer.parseInt(parameters.get(0)));
                        break;
	    case "8":	pst= connection.prepareStatement("update usuario set nombre=? where email=?");
			pst.setString(1, parameters.get(0));
			pst.setString(2, parameters.get(1));
			break;
	    case "9":	pst= connection.prepareStatement("update usuario SET contrasena=? WHERE email=? AND contrasena=?");
			pst.setString(1, parameters.get(0));
			pst.setString(2, parameters.get(1));
			pst.setString(3, parameters.get(2));
			break;
            case "10":	pst= connection.prepareStatement("update usuario SET fecha_nacimiento=? WHERE email=?");
                        pst.setString(1, parameters.get(0).replaceAll("-", ".").substring(0,parameters.get(0).indexOf(" ")));
                        pst.setString(2, parameters.get(1));
                        break;
            case "11":  pst= connection.prepareStatement("update usuario SET codigo_pais=(SELECT codigo_pais FROM pais WHERE nombre_pais=?) WHERE email=?");
                        pst.setString(1, parameters.get(0));
			pst.setString(2, parameters.get(1));
                        break;
	    case "12":	pst= connection.prepareStatement("select\n" +
			"    `usuario`.`email` AS `usr`\n" +
			"    , `sesion`.`id_sesion` AS `id`\n" +
			"    , `usuario`.`nombre` AS `nom`\n" +
			"    , `sesion`.`fecha_inicio` AS `datein`\n" +
			"    , `aux_permiso_usuario`.`id_permiso` AS `permiso`\n" +
			"FROM\n" +
			"    `sesion`\n" +
			"    INNER JOIN `usuario` \n" +
			"        ON (`sesion`.`id_usuario` = `usuario`.`id_usuario`)\n" +
			"    INNER JOIN `aux_permiso_usuario` \n" +
			"        ON (`aux_permiso_usuario`.`id_usuario` = `usuario`.`id_usuario`)\n" +
			"WHERE `aux_permiso_usuario`.`id_permiso`!=0 \n" +
			" ORDER BY `sesion`.`fecha_inicio` DESC;");
                        break;
            case "13":  pst= connection.prepareStatement("delete from usuario WHERE email=?");
                        pst.setString(1, parameters.get(0));
                        break;   
            //MIGUELANGEL
            //ANGEL
            case "14":   pst = connection.prepareStatement("select\n" +
			"    `aux_sesion_topico`.`repeticiones` as frecuencia\n" +
			"    , `topico`.`nombre_topico` as topico\n" +
			"FROM\n" +
			"    `langcluster`.`aux_sesion_termino`\n" +
			"    INNER JOIN `langcluster`.`sesion` \n" +
			"        ON (`aux_sesion_termino`.`id_sesion` = `sesion`.`id_sesion`)\n" +
			"    INNER JOIN `langcluster`.`aux_sesion_topico` \n" +
			"        ON (`aux_sesion_topico`.`id_sesion` = `sesion`.`id_sesion`)\n" +
			"    INNER JOIN `langcluster`.`topico` \n" +
			"        ON (`aux_sesion_topico`.`id_topico` = `topico`.`id_topico`)\n" +
			"GROUP BY `topico`.`nombre_topico`\n" +
			"ORDER BY `aux_sesion_topico`.`repeticiones` DESC LIMIT 5;");
			break;
	    case "15": pst = connection.prepareStatement("select\n" +
			"     ROUND(COUNT(`aux_idioma_usuario`.`id_usuario`) *100 /(SELECT COUNT(*) FROM `aux_idioma_usuario`)) AS porcentaje\n" +
			"    , COUNT(`aux_idioma_usuario`.`id_usuario`) AS cantidad\n" +
			"    , `idioma`.`Nombre_Idioma` AS idioma\n" +
			"FROM\n" +
			"    `langcluster`.`aux_idioma_usuario`\n" +
			"    INNER JOIN `langcluster`.`usuario` \n" +
			"        ON (`aux_idioma_usuario`.`id_usuario` = `usuario`.`id_usuario`)\n" +
			"    INNER JOIN `langcluster`.`idioma` \n" +
			"        ON (`aux_idioma_usuario`.`ISO` = `idioma`.`ISO`)\n" +
			"GROUP BY `idioma`.`Nombre_Idioma`;");
			break;
	    case "16": pst = connection.prepareStatement("select\n" +
			"    MAX(`fecha_fin`) as fecha\n" +
			"FROM\n" +
			"    `langcluster`.`sesion`\n" +
			"GROUP BY `id_usuario`\n" +
			"ORDER BY MAX(`fecha_fin`) DESC;");
			break;
            case "17": pst = connection.prepareStatement("insert into reporte (id_usuario,codigo_reporte,fecha_reporte,ruta_reporte) values ((select id_usuario from usuario where usuario.email=?),?,?,?);");
                       pst.setString(1, parameters.get(0));
                       String codReport= parameters.get(1).substring(0, 9);
                       pst.setString(2, codReport);
                       DateFormat dat1=new SimpleDateFormat("yyyy.MM.dd");
                       Date fechaa=new Date();
                       String fecha=dat1.format(fechaa);
                       pst.setString(3, fecha);
                       String ruta="report\\"+codReport+".txt";
                       pst.setString(4, ruta);              
                       break;
            case "18": pst = connection.prepareStatement("select fecha_reporte from reporte where codigo_reporte=?;");
                       pst.setString(1, parameters.get(0).substring(0, 9));
                       break;
            case "19":pst= connection.prepareStatement("SELECT   AVG( `aux_sesion_termino`.`madurez` )  AS `madurez`,\n" +
                        "         `idioma`.`Nombre_Idioma` AS `idioma`\n" +
                        "FROM     `aux_sesion_termino` \n" +
                        "INNER JOIN `sesion`  ON `aux_sesion_termino`.`id_sesion` = `sesion`.`id_sesion` \n" +
                        "INNER JOIN `termino`  ON `aux_sesion_termino`.`id_termino` = `termino`.`id_termino` \n" +
                        "INNER JOIN `idioma`  ON `termino`.`ISO` = `idioma`.`ISO` \n" +
                        "WHERE    ( `sesion`.`id_usuario` = (select id_usuario from usuario where email=?) )\n" +
                        "GROUP BY Nombre_Idioma;");
                      pst.setString(1, parameters.get(0));
                break;
            case "20":
                    pst= connection.prepareStatement("SELECT\n" +
"                            (COUNT(`aux_sesion_termino`.`madurez`)*100/  MAX(`termino`.`id_termino`)) AS avance\n" +
"                            , `idioma`.`Nombre_Idioma` as idioma\n" +
"                            FROM\n" +
"                            `langcluster`.`aux_sesion_termino`\n" +
"                            INNER JOIN `langcluster`.`sesion` \n" +
"                                ON (`aux_sesion_termino`.`id_sesion` = `sesion`.`id_sesion`)\n" +
"                            INNER JOIN `langcluster`.`usuario`\n" +
"                                ON (`sesion`.`id_usuario` = `usuario`.`id_usuario`)\n" +
"                            INNER JOIN `langcluster`.`termino`\n" +
"                                ON (`aux_sesion_termino`.`id_termino` = `termino`.`id_termino`)\n" +
"                            INNER JOIN `langcluster`.`idioma` \n" +
"                                ON (`termino`.`ISO` = `idioma`.`ISO`)\n" +
"                        WHERE (`usuario`.`email` =? and `aux_sesion_termino`.`madurez` !=0)\n" +
"                        GROUP BY `idioma`.`Nombre_Idioma`;");
                    pst.setString(1, parameters.get(0));
                break;
            case "21": pst= connection.prepareStatement("SELECT\n" +
                        "    SUM(`aux_sesion_topico`.`repeticiones`) as frecuencia\n" +
                        "    , `topico`.`nombre_topico`   as topico\n" +
                        "FROM\n" +
                        "    `langcluster`.`aux_sesion_topico`\n" +
                        "    INNER JOIN `langcluster`.`sesion` \n" +
                        "        ON (`aux_sesion_topico`.`id_sesion` = `sesion`.`id_sesion`)\n" +
                        "    INNER JOIN `langcluster`.`topico` \n" +
                        "        ON (`aux_sesion_topico`.`id_topico` = `topico`.`id_topico`)\n" +
                        "    INNER JOIN `langcluster`.`usuario` \n" +
                        "        ON (`sesion`.`id_usuario` = `usuario`.`id_usuario`)\n" +
                        "WHERE (`sesion`.`id_usuario` =(select id_usuario from usuario where email=?))\n" +
                        "GROUP BY `topico`.`nombre_topico` \n" +
                        "ORDER BY frecuencia DESC;");
                        pst.setString(1, parameters.get(0));
                break;
            case "22": pst = connection.prepareStatement("SELECT   `usuario`.`nombre`,\n" +
                        "         `pais`.`nombre_pais`,\n" +
                        "         `usuario`.`fecha_nacimiento`,\n" +
                        "         AVG( `aux_sesion_termino`.`repeticiones` ) as repeticiones ,\n" +
                        "         `idioma`.`Nombre_Idioma`,\n" +
                        "         `sesion`.`puntaje_sesion`,\n" +
                        "         `sesion`.`errores_sesion`\n" +
                        "FROM     `sesion` \n" +
                        "INNER JOIN `usuario`  ON `sesion`.`id_usuario` = `usuario`.`id_usuario` \n" +
                        "INNER JOIN `pais`  ON `usuario`.`codigo_pais` = `pais`.`codigo_pais` \n" +
                        "INNER JOIN `aux_sesion_termino`  ON `aux_sesion_termino`.`id_sesion` = `sesion`.`id_sesion` \n" +
                        "INNER JOIN `termino`  ON `aux_sesion_termino`.`id_termino` = `termino`.`id_termino` \n" +
                        "INNER JOIN `idioma`  ON `termino`.`ISO` = `idioma`.`ISO` \n" +
                        "WHERE    ( `sesion`.`fecha_inicio` = ?) AND ( `usuario`.`email` = ?)\n" +
                        "GROUP BY Nombre_Idioma\n" +
                        "ORDER BY `aux_sesion_termino`.`repeticiones` DESC;");
                    pst.setString(1, parameters.get(0));
                    System.out.println("parametro"+parameters.get(0).toString());
                    pst.setString(2, parameters.get(1));
                break;
            case "23": pst=connection.prepareStatement("select fecha_inicio from sesion where fecha_inicio=? and id_usuario=(select id_usuario from usuario"
                    + "where usuario.email=?) inner join"
                    + "usuario on sesion.id_usuario=usuario.id_usuarioSELECT   `sesion`.`fecha_inicio`\n" +
                      "FROM     `sesion` \n" +
                      "INNER JOIN `usuario`  ON `sesion`.`id_usuario` = `usuario`.`id_usuario` \n" +
                      "WHERE    ( `sesion`.`fecha_inicio` = ? ) and usuario.email=?" +
                      "GROUP BY fecha_inicio\n" +
                      "ORDER BY `sesion`.`fecha_inicio` DESC;");
                    pst.setString(1, parameters.get(0));
                    pst.setString(2, parameters.get(1)); 
                break;
            case "audio3": pst=connection.prepareStatement("SELECT\n" +
                        "    `palabra`.`tipo`\n" +
                        "    , `palabra`.`id_palabra`\n" +
                        "    , `palabra`.`palabra`\n" +
                        "FROM\n" +
                        "    `langcluster`.`aux_palabra_termino`\n" +
                        "    INNER JOIN `langcluster`.`palabra` \n" +
                        "        ON (`aux_palabra_termino`.`id_palabra` = `palabra`.`id_palabra`)\n" +
                        "    INNER JOIN `langcluster`.`termino` \n" +
                        "        ON (`aux_palabra_termino`.`id_termino` = `termino`.`id_termino`)\n" +
                        "WHERE (`termino`.`id_termino` =?);");
                        pst.setInt(1, Integer.parseInt(parameters.get(0)));
                break;
                
            case "audio1": pst=connection.prepareStatement(" select palabra as id from palabra where tipo=\"VER\" or tipo=\"SUS\" or palabra!=? order by rand() limit 4;");
                        pst.setString(1,parameters.get(0));
                break;
            //ANGEL
            //MIGUELANGEL
	    case "24":	pst= connection.prepareStatement("insert INTO comentario (id_usuario,id_tema_comentario,fecha_comentario,hora_comentario,texto_comentario)\n" +
			"VALUES ((SELECT id_usuario FROM usuario WHERE email=?),?,?,?,?)");
			DateFormat date1 = new SimpleDateFormat("yyyy.MM.dd");
			DateFormat date2 = new SimpleDateFormat("HH:mm:ss");
			Date date = new Date();
			pst.setString(1, parameters.get(0)); //	correo
			pst.setString(2, parameters.get(1)); // id tipo
			pst.setString(3, date1.format(date)); // fecha Y.M.D
			pst.setString(4, date2.format(date)); // hora HH:MM:SS 24h
			pst.setString(5, parameters.get(2)); // Mensajee
			break;
	    case "25":	pst= connection.prepareStatement("insert INTO comentario (id_usuario,id_tema_comentario,id_termino,fecha_comentario,hora_comentario,texto_comentario)\n" +
			"VALUES ((SELECT id_usuario FROM usuario WHERE email=?),?,?,?,?,?)");
			DateFormat dat1a = new SimpleDateFormat("yyyy.MM.dd");
			DateFormat dat2 = new SimpleDateFormat("HH:mm:ss");
			Date datee = new Date();
			String fecha2=dat1a.format(datee);
			String hora=dat2.format(datee);
			pst.setString(1, parameters.get(0)); //correo
			pst.setString(2, parameters.get(1)); // id tipo
                        pst.setString(3, parameters.get(3));    //id_termino
                        pst.setString(4, fecha2); //fecha_comentario
			pst.setString(5, hora); // hora HH:MM:SS 24h
			pst.setString(6, parameters.get(2)); // Mensaje
                        //System.out.println(pst);
			break;
            case "26":  pst = connection.prepareStatement("select id_usuario as id from usuario where email=?");
                        pst.setString(1, parameters.get(0));
                        ResultSet rs=pst.executeQuery();
                        JSONObject obj = convertResultSetIntoJSON(rs).getJSONObject(0);
                        String name="Uploads/avatar/"+obj.getInt("id")+".png";
                        pst= connection.prepareStatement("update usuario set ruta_avatar=? where email=?");
                        pst.setString(1, name);
			pst.setString(2, parameters.get(0));
                        pst.executeUpdate();
                        pst = connection.prepareStatement("select ruta_avatar from usuario where email=?");
                        pst.setString(1, parameters.get(0));
                        break;
            case "27":  pst= connection.prepareStatement("select usuario.nombre, usuario.email, noticia.fecha_noticia, noticia.titulo_noticia AS titulo, noticia.contenido_noticia, noticia.id_noticia AS id\n" +
			"FROM usuario INNER JOIN noticia ON usuario.id_usuario=noticia.id_usuario ORDER BY noticia.id_noticia DESC;");
                        break;
            case "28":  
                        pst= connection.prepareStatement("delete from noticia where (id_noticia) in ("+parameters.get(0)+")");
			break;
	    case "29":  
                        pst= connection.prepareStatement("insert into noticia (id_usuario,fecha_noticia,titulo_noticia,contenido_noticia) values ((select id_usuario from usuario where email= ?),?,?,?)");
			DateFormat dat11 = new SimpleDateFormat("yyyy.MM.dd");
			Date dateee = new Date();
			String fechaa2=dat11.format(dateee);
			pst.setString(1, parameters.get(0));
			pst.setString(2, fechaa2);
			pst.setString(3, parameters.get(1));
			pst.setString(4, parameters.get(2));
			break;
	    case "30":  
                        pst= connection.prepareStatement("SELECT A.nivel, A.nom, A.des, B.maximas, B.vistas FROM \n" +
			"(SELECT num_nivel AS nivel,nombre_topico AS nom, desc_topico AS des, topico.`id_topico` AS topic FROM topico WHERE id_topico=?)\n" +
			"AS A\n" +
			"INNER JOIN\n" +
			"(SELECT maximas, vistas, C.topic AS topic FROM \n" +
			"(SELECT COUNT(*) AS maximas, termino.id_topico AS topic FROM termino WHERE id_topico=?) AS B\n" +
			"INNER JOIN ( SELECT COUNT(*) AS vistas, termino.id_topico AS topic\n" +
			"FROM `sesion`\n" +
			"INNER JOIN `usuario` ON (`sesion`.`id_usuario` = `usuario`.`id_usuario`)\n" +
			"INNER JOIN `aux_sesion_termino` ON (`aux_sesion_termino`.`id_sesion` = `sesion`.`id_sesion`)\n" +
			"INNER JOIN `termino` ON (`aux_sesion_termino`.`id_termino` = `termino`.`id_termino`)\n" +
			"WHERE (`usuario`.`id_usuario` = (SELECT id_usuario FROM usuario WHERE email=?) AND `termino`.`id_topico` =?)) AS C\n" +
			"ON B.topic=C.topic) AS B\n" +
			"ON A.topic=B.topic");
			pst.setString(1, parameters.get(0));
			pst.setString(2, parameters.get(0));
			pst.setString(3, parameters.get(1));
			pst.setString(4, parameters.get(0));
			break;	
	    case "send":
			JSONArray arr = new JSONArray(parameters.get(1));
			for(int i=0;i<arr.length()-1;i++){
			    JSONObject nue = new JSONObject(arr.get(i).toString());
			    pst1= connection.prepareStatement("insert INTO aux_termino_usuario(id_usuario,id_termino,errores,tiempo) "
				+ "VALUES((SELECT id_usuario FROM usuario WHERE email=?),?,?,?)");
			    pst1.setString(1, parameters.get(0)); 
			    pst1.setInt(2, Integer.parseInt(String.valueOf(nue.get("termino"))));
			    pst1.setInt(3, Integer.parseInt(String.valueOf(nue.get("error"))));
			    pst1.setInt(4, Integer.parseInt(String.valueOf(nue.get("tiempo"))));
			    pst1.executeUpdate();
			}//for
			int aux = arr.length();
			JSONObject nue = new JSONObject(arr.get(aux-1).toString());
			pst= connection.prepareStatement("insert INTO aux_termino_usuario(id_usuario,id_termino,errores,tiempo) "
				+ "VALUES((SELECT id_usuario FROM usuario WHERE email=?),?,?,?)");
			pst.setString(1, parameters.get(0)); 
			pst.setInt(2, Integer.parseInt(String.valueOf(nue.get("termino"))));
			pst.setInt(3, Integer.parseInt(String.valueOf(nue.get("error"))));
			pst.setInt(4, Integer.parseInt(String.valueOf(nue.get("tiempo"))));
			break;	
            case "Stu": 
                        pst= connection.prepareStatement("select usuario.id_usuario, aux_idioma_usuario.iso \n" +
                        "from usuario \n" +
                        "inner join aux_idioma_usuario on aux_idioma_usuario.id_usuario=usuario.id_usuario \n" +
                        "where usuario.id_usuario=(select id_usuario from usuario \n" +
                        "where email= ?) \n" +
                        "group by aux_idioma_usuario.iso");
                      pst.setString(1, parameters.get(0));
                break;
	    //MIGUELANGEL
            //DIEGO
            case "Data0":   pst = connection.prepareStatement("select count(*) as total from idioma ");
                        break;
            case "Data1": pst = connection.prepareStatement("select Nombre_Idioma as id,ISO from idioma");
                        break;
            case "Data2": pst = connection.prepareStatement("select concat(\"2.\",@n:=@n+1) as id, nombre_topico as value from topico, (select @n:=0) as auxtable order by nombre_topico");
                        break;
            case "Data3": pst = connection.prepareStatement("select (@n:=@n+1) as id, terminoes.terminoes,termino.termino,nivel.desc_nivel as nivel,topico.nombre_topico as topico,idioma.nombre_idioma as idioma\n"
                                + "from termino inner join aux_termino_terminoes on termino.id_termino=aux_termino_terminoes.id_termino inner join terminoes on terminoes.id_terminoes=aux_termino_terminoes.id_terminoes\n"
                                + "inner join topico on termino.id_topico=topico.id_topico inner join idioma on idioma.iso=termino.iso inner join nivel on nivel.num_nivel=termino.num_nivel, (select @n:=0) as auxtable");
                        break;
            case "Comment1":    pst = connection.prepareStatement("select nombre_tema as id from tema_comentario");
                        break;
            case "Comment2":    pst = connection.prepareStatement("select (@n:=@n+1) as id,E.* from(\n" +
                            "	select C.*,D.iso from(\n" +
                            "		select A.id_usuario as user_id,B.nombre,B.email,A.id_comentario,A.id_tema_comentario,A.fecha_comentario,A.hora_comentario,A.texto_comentario,A.nombre_tema from (\n" +
                            "			select comentario.id_comentario,comentario.id_usuario,tema_comentario.id_tema_comentario,comentario.fecha_comentario,comentario.hora_comentario,comentario.texto_comentario,tema_comentario.nombre_tema\n" +
                            "				from\n" +
                            "				comentario inner join tema_comentario\n" +
                            "				on comentario.id_tema_comentario=tema_comentario.id_tema_comentario\n" +
                            "		) as A\n" +
                            "		left join(\n" +
                            "			select id_usuario,nombre,email from usuario) as B\n" +
                            "		on A.id_usuario=B.id_usuario\n" +
                            "	) as C\n" +
                            "	left join\n" +
                            "		(select comentario.id_usuario,comentario.id_comentario,comentario.id_tema_comentario,comentario.fecha_comentario,comentario.hora_comentario,comentario.texto_comentario,tema_comentario.nombre_tema,termino.iso\n" +
                            "			from comentario inner join tema_comentario\n" +
                            "			on comentario.id_tema_comentario=tema_comentario.id_tema_comentario\n" +
                            "			inner join\n" +
                            "			termino on termino.id_termino=comentario.id_termino\n" +
                            "			inner join\n" +
                            "			idioma on termino.iso=idioma.iso\n" +
                            "		) as D\n" +
                            "	on C.id_comentario=D.id_comentario\n" +
                            ") as E, (select @n:=0) as auxtable");
                        break;
            case "Comment3":    pst = connection.prepareCall("delete from comentario where id_comentario=?");
                                pst.setString(1, parameters.get(0));
                        break;
            case "Comment4":    pst = connection.prepareCall("delete from comentario where id_comentario in ("+parameters.get(0)+")");
                        break;
            //NO SE USA
            case "Game1":   pst = connection.prepareCall("select termino.id_termino as id, termino.termino,terminoes.terminoes from termino inner join aux_termino_terminoes on termino.id_termino=aux_termino_terminoes.id_termino inner join terminoes on terminoes.id_terminoes=aux_termino_terminoes.id_terminoes where termino.id_topico=?");
                            pst.setString(1, parameters.get(0));
                        break;
            case "Game2":   pst = connection.prepareCall("select palabra.id_palabra as id, palabra.palabra, palabraes.palabraes, palabra.iso,palabra.genero,palabra.tipo,palabra.palabra_base from termino inner join aux_palabra_termino on aux_palabra_termino.id_termino=termino.id_termino inner join palabra on palabra.id_palabra=aux_palabra_termino.id_palabra\n" +
                                                         "inner join aux_palabra_palabraes on aux_palabra_palabraes.id_palabra=palabra.id_palabra inner join palabraes on aux_palabra_palabraes.id_palabraes=palabraes.id_palabraes\n" +
                                                         "where termino.id_termino in (select termino.id_termino from termino where termino.id_topico=?)");
                            pst.setInt(1, Integer.parseInt(parameters.get(0)));
                            //System.out.println(pst);
                        break;
            case "Game3":   pst = connection.prepareCall("select palabraes.palabraes from palabra inner join aux_palabra_palabraes on aux_palabra_palabraes.id_palabra=palabra.id_palabra inner join palabraes on aux_palabra_palabraes.id_palabraes=palabraes.id_palabraes where palabra.palabra=?");
                            String word=parameters.get(0).replaceAll("!+", "").replaceAll("\\?","");
                            pst.setString(1, word.toLowerCase());
                            //System.out.println(pst);
                        break;
            //NO SE USA
            case "Game4":   pst = connection.prepareCall("select newTable.madurez,termino.termino from termino left join (select termino.id_termino,madurez \n" +
                                        "from aux_sesion_termino\n" +
                                        "inner join termino on\n" +
                                        "termino.id_termino=aux_sesion_termino.id_termino\n" +
                                        "where termino.id_topico=? group by termino.id_termino) as newTable\n" +
                                        "on newTable.id_termino=termino.id_termino\n" +
                                        "where termino.iso=? and termino.id_topico=? and\n" +
                                        "newTable.madurez is null or newTable.madurez=0\n" +
                                        "group by termino.termino\n" +
                                        "order by rand() limit 15");
                            pst.setString(1, parameters.get(0));
                            pst.setString(2, parameters.get(1));
                            pst.setString(3, parameters.get(0));
                            //System.out.println(pst);
                        break;
                        
            case "Game5":   pst = connection.prepareCall("select (aux_termino_usuario.tiempo * aux_termino_usuario.errores) as review_order, \n" +
                                        "termino.termino from aux_termino_usuario\n" +
                                        "inner join usuario on\n" +
                                        "usuario.id_usuario=aux_termino_usuario.id_usuario\n" +
                                        "inner join termino on\n" +
                                        "termino.id_termino=aux_termino_usuario.id_termino\n" +
                                        "where usuario.id_usuario in (select id_usuario from usuario where email=?) and termino.iso=? and termino.id_topico=?\n" +
                                        "order by review_order desc");
                            pst.setString(1, parameters.get(0));
                            pst.setString(2, parameters.get(2));
                            pst.setString(3, parameters.get(1));
                            //System.out.println(pst);
                        break;
            case "Game6":   pst = connection.prepareCall("select termino,(@n:=@n+1) as review_order from("+
                                        "select termino.termino from termino left join (select termino.id_termino,madurez \n" +
                                        "from aux_sesion_termino\n" +
                                        "inner join termino on\n" +
                                        "termino.id_termino=aux_sesion_termino.id_termino\n" +
                                        "where termino.id_topico=? group by termino.id_termino) as newTable\n" +
                                        "on newTable.id_termino=termino.id_termino\n" +
                                        "where termino.iso=? and termino.id_topico=? and\n" +
                                        "newTable.madurez is not null or newTable.madurez!=0\n" +
                                        "group by termino.termino\n" +
                                        "order by rand() limit ?) as auxtable,(select @n:=?) as auxtable2");
                            pst.setString(1, parameters.get(0));
                            pst.setString(2, parameters.get(2));
                            pst.setString(3, parameters.get(0));
                            pst.setInt(4, Integer.parseInt(parameters.get(1)));
                            pst.setInt(5, 20-Integer.parseInt(parameters.get(1)));
                            //System.out.println(pst);
                        break;
            case "NewGame": pst = connection.prepareCall("select A.madurez,A.id_termino,B.termino,B.terminoes from\n" +
                                "(\n" +
                                "select newTable.madurez,termino.id_termino from termino left join (select termino.id_termino,madurez\n" +
                                "from aux_sesion_termino\n" +
                                "inner join termino on\n" +
                                "termino.id_termino=aux_sesion_termino.id_termino\n" +
                                "where termino.id_topico=? group by termino.id_termino) as newTable\n" +
                                "on newTable.id_termino=termino.id_termino\n" +
                                "where termino.iso=? and termino.id_topico=? and\n" +
                                "newTable.madurez is null or newTable.madurez=0\n" +
                                "group by termino.termino\n" +
                                "order by rand() limit 15\n" +
                                ") as A\n" +
                                "inner join\n" +
                                "(\n" +
                                "select termino.id_termino, termino.termino,terminoes.terminoes from termino\n" +
                                "inner join aux_termino_terminoes on termino.id_termino=aux_termino_terminoes.id_termino\n" +
                                "inner join terminoes on terminoes.id_terminoes=aux_termino_terminoes.id_terminoes\n" +
                                "where termino.id_topico=?) as B\n" +
                                "on A.id_termino=B.id_termino");
                            pst.setString(1, parameters.get(0));    //id_topico
                            pst.setString(2, parameters.get(1));    //ISO
                            pst.setString(3, parameters.get(0));    //id_topico
                            pst.setString(4, parameters.get(0));    //id_topico
                            //System.out.println(pst);
                        break;
            case "ReviewGame":
                            pst = connection.prepareCall("select A.review_order,A.termino,B.termino,B.terminoes from\n" +
                                "(\n" +
                                "select (aux_termino_usuario.tiempo * aux_termino_usuario.errores) as review_order, termino.id_termino,\n" +
                                "termino.termino from aux_termino_usuario\n" +
                                "inner join usuario on\n" +
                                "usuario.id_usuario=aux_termino_usuario.id_usuario\n" +
                                "inner join termino on\n" +
                                "termino.id_termino=aux_termino_usuario.id_termino\n" +
                                "where usuario.id_usuario in (select id_usuario from usuario where email=?) and termino.iso=? and termino.id_topico=?\n" +
                                "order by review_order desc\n" +
                                ") as A\n" +
                                "inner join\n" +
                                "(\n" +
                                "select termino.id_termino, termino.termino,terminoes.terminoes from termino\n" +
                                "inner join aux_termino_terminoes on termino.id_termino=aux_termino_terminoes.id_termino\n" +
                                "inner join terminoes on terminoes.id_terminoes=aux_termino_terminoes.id_terminoes\n" +
                                "where termino.id_topico=?) as B\n" +
                                "on A.id_termino=B.id_termino");
                            pst.setString(1, parameters.get(0));    //email
                            pst.setString(2, parameters.get(1));    //ISO
                            pst.setString(3, parameters.get(2));    //id_topico
                            pst.setString(4, parameters.get(2));    //id_topico
                            //System.out.println(pst);
                        break;
            case "CompleteNewGame":
                        pst = connection.prepareCall("select A.madurez,A.id_termino,B.termino,B.terminoes from\n" +
                                "(\n" +
                                "select newTable.madurez,termino.id_termino from termino left join (select termino.id_termino,madurez\n" +
                                "from aux_sesion_termino\n" +
                                "inner join termino on\n" +
                                "termino.id_termino=aux_sesion_termino.id_termino\n" +
                                "where termino.id_topico=? group by termino.id_termino) as newTable\n" +
                                "on newTable.id_termino=termino.id_termino\n" +
                                "where termino.iso=? and termino.id_topico=? " +
                                "group by termino.termino\n" +
                                "order by rand() limit ?\n" +
                                ") as A\n" +
                                "inner join\n" +
                                "(\n" +
                                "select termino.id_termino, termino.termino,terminoes.terminoes from termino\n" +
                                "inner join aux_termino_terminoes on termino.id_termino=aux_termino_terminoes.id_termino\n" +
                                "inner join terminoes on terminoes.id_terminoes=aux_termino_terminoes.id_terminoes\n" +
                                "where termino.id_topico=?) as B\n" +
                                "on A.id_termino=B.id_termino");
                            pst.setString(1, parameters.get(0));    //id_topico
                            pst.setString(2, parameters.get(1));    //ISO
                            pst.setString(3, parameters.get(0));    //id_topico
                            pst.setInt(4, Integer.parseInt(parameters.get(2)));    //limit
                            pst.setString(5, parameters.get(0));    //id_topico
                            //System.out.println(pst);
                        break;
            case "CompleteReviewGame":
                        pst = connection.prepareCall("select A.review_order,A.termino,B.termino,B.terminoes from\n" +
                            "(\n" +
                            "select termino,auxtable.id_termino,(@n:=@n+1) as review_order from(\n" +
                            "	select termino.termino,newTable.id_termino from termino left join (select termino.id_termino,madurez\n" +
                            "	from aux_sesion_termino\n" +
                            "	inner join termino on\n" +
                            "	termino.id_termino=aux_sesion_termino.id_termino\n" +
                            "	where termino.id_topico=? group by termino.id_termino) as newTable\n" +
                            "	on newTable.id_termino=termino.id_termino\n" +
                            "	where termino.iso=? and termino.id_topico=? and\n" +
                            "	newTable.madurez is not null or newTable.madurez!=0\n" +
                            "	group by termino.termino\n" +
                            "	order by rand() limit ?) as auxtable,(select @n:=?) as auxtable2\n" +
                            ") as A\n" +
                            "inner join\n" +
                            "(\n" +
                            "select termino.id_termino, termino.termino,terminoes.terminoes from termino\n" +
                            "inner join aux_termino_terminoes on termino.id_termino=aux_termino_terminoes.id_termino\n" +
                            "inner join terminoes on terminoes.id_terminoes=aux_termino_terminoes.id_terminoes\n" +
                            "where termino.id_topico=?) as B\n" +
                            "on A.id_termino=B.id_termino");
                            pst.setString(1, parameters.get(0));    //id_topico
                            pst.setString(2, parameters.get(1));    //ISO
                            pst.setString(3, parameters.get(0));    //id_topico
                            pst.setInt(4, Integer.parseInt(parameters.get(2)));    //limit
                            pst.setInt(5, 20-Integer.parseInt(parameters.get(2))); //@n
                            pst.setString(6, parameters.get(0));   //id_topico
                            //System.out.println(pst);
                        break;
            case "EndGame": pst = connection.prepareCall("insert into sesion(id_usuario,fecha_inicio,hora_inicio,fecha_fin,hora_fin,puntaje_sesion,errores_sesion) values("+
                                    "(SELECT id_usuario FROM usuario WHERE email=?),?,?,?,?,?,?)");
                            pst.setString(1, parameters.get(0));    //email
                            pst.setString(2, parameters.get(3));    //startDate
                            pst.setString(3, parameters.get(4));    //startTime
                            pst.setString(4, parameters.get(5));    //endDate
                            pst.setString(5, parameters.get(6));    //endTime
                            int P=Integer.parseInt(parameters.get(7));
                            pst.setInt(6, P>=0?P:0);                //puntaje
                            pst.setInt(7, Integer.parseInt(parameters.get(8)));       //errores
                            //System.out.println(pst);
                            pst.executeUpdate();
                            
                            //ID de esta sesión
                            pst=connection.prepareCall("select id_sesion from sesion where id_usuario=(SELECT id_usuario FROM usuario WHERE email=?) and "
                                    + "fecha_inicio=? and hora_inicio=? and fecha_fin=? and hora_fin=?");
                            pst.setString(1, parameters.get(0));    //email
                            pst.setString(2, parameters.get(3));    //startDate
                            pst.setString(3, parameters.get(4));    //startTime
                            pst.setString(4, parameters.get(5));    //endDate
                            pst.setString(5, parameters.get(6));    //endTime
                            //System.out.println(pst);
                            
                            ResultSet result = pst.executeQuery();
                            JSONObject JSONobj = convertResultSetIntoJSON(result).getJSONObject(0);
                            int id_sesion=JSONobj.getInt("id_sesion");
                            
                            //aux_sesion_termino
                            JSONArray array = new JSONArray(parameters.get(2));   //avance
                            //String[][] repeticiones=new String[15][2];
                            ArrayList<String> repeticiones=new ArrayList<>();
                            for(int i=0;i<array.length();i++){
                                JSONObject object = new JSONObject(array.get(i).toString());
                                String termino=String.valueOf(object.get("termino"));
                                //System.out.println(i+") "+termino);
                                boolean pass=false;
                                for(int j=0;j<repeticiones.size();j++){
                                    if(termino.equals(repeticiones.get(j).split("_")[0])){
                                        //System.out.println(j+") repeticion: "+repeticiones.get(j));
                                        int time1=Integer.parseInt(String.valueOf(object.get("tiempo")));
                                        int time2=Integer.parseInt(repeticiones.get(j).split("_")[2]);
                                        repeticiones.set(j, termino+"_"+repeticiones.get(j).split("_")[1]+"_"+((time1+time2)/2));
                                        pass=true;
                                        break;
                                    }
                                }
                                if(!pass){
                                    int rep=0;
                                    for(int j=0;j<array.length();j++){
                                        String termino2=String.valueOf(new JSONObject(array.get(j).toString()).get("termino"));
                                        //System.out.println(j+") termino2: "+termino2);
                                        if(termino.equals(termino2)) rep++;
                                    }
                                    repeticiones.add(termino+"_"+rep+"_"+String.valueOf(object.get("tiempo")));
                                }
                            }
                            for(int i=0;i<repeticiones.size();i++){
                                //System.out.println("repeticiones aux_sesion_termino = "+repeticiones.get(i));
                                String[] datos=repeticiones.get(i).split("_");
                                pst= connection.prepareStatement("insert into aux_sesion_termino values ("
                                    + id_sesion+",?,?,?,?)");
                                pst.setInt(1, Integer.parseInt(datos[0]));  //id_termino
                                pst.setInt(2, Integer.parseInt(datos[1]));  //repeticiones
                                pst.setInt(3, 1);//1-3
                                pst.setInt(4, Integer.parseInt(datos[2]));  //tiempo
                                pst.executeUpdate();
                            }
                            
                            //aux_sesion_topico
                            pst= connection.prepareStatement("insert into aux_sesion_topico values ("
                                    + id_sesion+",?,1)");
                            pst.setInt(1, Integer.parseInt(parameters.get(1)));//id_topico
                            
                        break;
            case "ImagesT1":  pst = connection.prepareCall("select termino.id_termino,termino,ruta_multimedia from (select * from "+
                                    "(select ruta_multimedia,id_multimedia from multimedia where id_multimedia=? ) as X "+
                                    "union (select ruta_multimedia,id_multimedia from multimedia where id_multimedia!=? "+
                                    "and tipo_multimedia=\"IMAGEN\" order by rand() limit 5) order by rand()) as Y "+
                                    "inner join aux_multimedia_termino on aux_multimedia_termino.id_multimedia=Y.id_multimedia "+
                                    "inner join termino on termino.id_termino=aux_multimedia_termino.id_termino ");
			    pst.setInt(1, Integer.parseInt(parameters.get(0)));
			    pst.setInt(2, Integer.parseInt(parameters.get(0)));
                            //REGRESA TERMINO,ID_MULTIMEDIA
                        break;
            case "ImagesT2":  pst = connection.prepareCall("select `termino`.`id_termino`, `termino`.`termino`, "
			    + "`terminoes`.`terminoES`, `multimedia`.`ruta_multimedia`, `multimedia`.`tipo_multimedia` "
			    + "FROM `aux_multimedia_termino` INNER JOIN `multimedia` ON (`aux_multimedia_termino`.`id_multimedia`"
			    + " = `multimedia`.`id_multimedia`) INNER JOIN `termino`  ON (`aux_multimedia_termino`.`id_termino` = "
			    + "`termino`.`id_termino`) INNER JOIN `aux_termino_terminoes`  ON (`aux_termino_terminoes`.`id_termino` "
			    + "= `termino`.`id_termino`) INNER JOIN `terminoes`  ON (`aux_termino_terminoes`.`id_terminoES` = "
			    + "`terminoes`.`id_terminoES`) WHERE (`termino`.`id_termino` =? AND `multimedia`.`tipo_multimedia`"
			    + " =\"IMAGEN\");");
			    pst.setInt(1, Integer.parseInt(parameters.get(0)));
                        break;		
            case "audioIDSearch": pst= connection.prepareCall("SELECT\n" +
                                    "    `aux_multimedia_termino`.`id_multimedia`\n" +
                                    "FROM\n" +
                                    "    `langcluster`.`aux_multimedia_termino`\n" +
                                    "    INNER JOIN `langcluster`.`multimedia` \n" +
                                    "        ON (`aux_multimedia_termino`.`id_multimedia` = `multimedia`.`id_multimedia`)\n" +
                                    "WHERE (`aux_multimedia_termino`.`id_termino` =?\n" +
                                    "    AND `multimedia`.`tipo_multimedia` =\"SONIDO\");");
                                  pst.setInt(1,Integer.parseInt(parameters.get(0)));
                                  break;
                
            case "getAudio": pst=connection.prepareCall("select ruta_multimedia from multimedia where id_multimedia=?;");
                             pst.setInt(1,Integer.parseInt(parameters.get(0)));
                                 
                            break;
            case "Home1":   pst = connection.prepareCall("select nombre_idioma as lang,desc_idioma as description from idioma where iso=?");
                            pst.setString(1, parameters.get(0));
                        break;
            case "Home2":   pst = connection.prepareCall("insert into aux_idioma_usuario values (?,(select id_usuario from usuario where email=?))");
                            pst.setString(1, parameters.get(0));
                            pst.setString(2, parameters.get(1));
                        break;
        }
        return pst;
    }
    /*
    private JSONArray convertToJSON(ResultSet resultSet) throws Exception{
        JSONArray jsonArray = new JSONArray();
        while (resultSet.next()) {
           // int total_rows = resultSet.getMetaData().getColumnCount();
            JSONObject obj = new JSONObject();
            //for (int i = 0; i < total_rows; i++) {
            obj.put(resultSet.getMetaData().getColumnLabel(0 + 1)
                .toLowerCase(), resultSet.getObject(0 + 1));
            jsonArray.put(obj);
            //}
        }
        return jsonArray;
    }
    */
    
    public static JSONArray convertResultSetIntoJSON(ResultSet resultSet) throws Exception {
        JSONArray jsonArray = new JSONArray();
        while (resultSet.next()) {
            int total_rows = resultSet.getMetaData().getColumnCount();
            JSONObject obj = new JSONObject();
            for (int i = 0; i < total_rows; i++) {
                String columnName = resultSet.getMetaData().getColumnLabel(i + 1).toLowerCase();
                Object columnValue = resultSet.getObject(i + 1);
                // if value in DB is null, then we set it to default value
                if (columnValue == null){
                    columnValue = "null";
                }
                if (obj.has(columnName)){
                    columnName += "1";
                }
                obj.put(columnName, columnValue);
            }
            jsonArray.put(obj);
        }
        return jsonArray;
    }
}

