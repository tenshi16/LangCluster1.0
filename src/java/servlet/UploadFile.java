/*
 * LangCluster - UploadFile Servlet
 */

package servlet;

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.Transparency;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileItemFactory;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "UploadFile", urlPatterns = {"/UploadFile"})
public class UploadFile extends HttpServlet {
    private static final String DATA_FILES=File.listRoots()[0]+"\\LangCluster\\";
    private Connection connection;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        boolean access=request.getHeader("referer").substring(0,request.getHeader("referer").lastIndexOf("/")).contains(request.getRequestURL().toString().substring(0,request.getRequestURL().toString().lastIndexOf("/")));
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        if(access){
            File uploadDir = new File(DATA_FILES);
            if(!uploadDir.exists()) uploadDir.mkdir();
                    
            String id=(request.getParameter("id")==null? "":request.getParameter("id"));
            //USO ESPECIAL DEL SERVLET
            if(!id.trim().isEmpty()){
                //System.out.println("Access Granted to ["+id+"] on UploadFile");
                switch(id){
                    case "0":   // ARCHIVOS EN DIRECTORIO
                        File[] files=uploadDir.listFiles();
                        JSONArray jsonArray = new JSONArray();
                        for(int i=0;i<files.length;i++)
                            jsonArray.put(i,files[i]);
                        if(jsonArray.isNull(0)) out.println("NoData");
                        else                    out.println(jsonArray);
                        return;
                    case "1":   //IMPORTAR DATA
                        try{connect();
                            File LANG=new File(DATA_FILES+request.getParameter("file"));
                            boolean overwrite=((request.getParameter("overwrite") != null && request.getParameter("overwrite").equals("true")));
                            if(LANG.exists()&&!overwrite)   throw new Exception("errorExistent Data");
                            checkfile(LANG.getPath());
                            System.out.println("-IMPORTAR-");
                            DB_INSERT(LANG.getPath());
                        }catch(Exception e){
                            out.println("error"+e.getMessage());}
                        return;
                    case "2":   //SOBRESCRIBIR DATA
                        try{connect();
                            File LANG=new File(DATA_FILES+request.getParameter("file"));
                            checkfile(LANG.getPath());
                            System.out.println("-SOBRESCRIBIR-");
                            String[] array=request.getParameter("array").split(",");
                            DB_OVERWRITE(LANG.getPath(),array);
                        }catch(Exception e){
                            out.println("error"+e.getMessage());}
                        return;
                    case "3":   //GENERAR DATA
                        try{connect();
                            File LANG=new File(DATA_FILES+request.getParameter("lang")+".LANGCLUSTER");
                            String content="";
                            if(LANG.exists()) LANG.delete();
                            LANG.createNewFile();
                            
                            /*
                            BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(IPAAssistant.file), "UTF8"));    
                            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(IPAAssistant.file), "UTF-8"));
                            */
                            PrintWriter writer = new PrintWriter(new OutputStreamWriter(new FileOutputStream(LANG),Charset.forName("UTF-8")));
                            writer.println("LANG CLUSTER - DATA ("+request.getParameter("lang").toUpperCase()+")");
                            content+="LANG CLUSTER - DATA ("+request.getParameter("lang").toUpperCase()+")\n";
                            for(int i=0;i<8;i++){
                                String SQL="";
                                switch(i){
                                    case 0: writer.println("tb_IDIOMA"); content+="tb_IDIOMA\n";
                                            SQL="select * from idioma where idioma.ISO in (select idioma.ISO from idioma where idioma.ISO=?)";
                                    break;
                                    case 1: writer.println("tb_TERMINOES"); content+="tb_TERMINOES\n";
                                            SQL="select * from terminoES";
                                    break;
                                    case 2: writer.println("tb_TOPICO"); content+="tb_TOPICO\n";
                                            SQL="select * from topico";
                                    break;
                                    case 3: writer.println("tb_NIVEL"); content+="tb_NIVEL\n";
                                            SQL="select * from nivel where nivel.num_nivel in (select id from (select nivel.num_nivel as id from nivel inner join termino on nivel.num_nivel=termino.num_nivel inner join idioma on idioma.ISO=termino.ISO where idioma.ISO=? group by nivel.num_nivel) as auxtable)";
                                    break;
                                    case 4: writer.println("tb_TERMINO"); content+="tb_TERMINO\n";
                                            SQL="select * from termino where termino.ISO in (select idioma.ISO from idioma where idioma.ISO=?)";
                                    break;
                                    case 5: writer.println("tb_AUX_TERMINO_TERMINOES"); content+="tb_AUX_TERMINO_TERMINOES\n";
                                            SQL="select termino.termino,terminoes.terminoes from aux_termino_terminoes inner join termino on termino.id_termino=aux_termino_terminoes.id_termino inner join terminoes on terminoes.id_terminoes=aux_termino_terminoes.id_terminoes where termino.iso in (select idioma.ISO from idioma where idioma.ISO=?)";
                                    break;
                                    case 6: writer.println("tb_MULTIMEDIA"); content+="tb_MULTIMEDIA\n";
                                            SQL="select * from multimedia where multimedia.id_multimedia in (select id from (select multimedia.id_multimedia as id from multimedia inner join aux_multimedia_termino on aux_multimedia_termino.id_multimedia=multimedia.id_multimedia inner join termino on termino.id_termino=aux_multimedia_termino.id_termino inner join aux_idioma_multimedia on aux_idioma_multimedia.id_multimedia=multimedia.id_multimedia inner join idioma on idioma.ISO=aux_idioma_multimedia.ISO where idioma.ISO=?)as auxtable);";
                                    break;
                                    case 7: writer.println("tb_AUX_IDIOMA_MULTIMEDIA"); content+="tb_AUX_IDIOMA_MULTIMEDIA\n";
                                            SQL="select idioma.iso, ruta_multimedia from aux_idioma_multimedia inner join idioma on idioma.iso=aux_idioma_multimedia.iso inner join multimedia on multimedia.id_multimedia=aux_idioma_multimedia.id_multimedia where idioma.iso in (select idioma.ISO from idioma where idioma.ISO=?)";
                                    break;
                                    case 8: writer.println("tb_AUX_MULTIMEDIA_TERMINO"); content+="tb_AUX_MULTIMEDIA_TERMINO\n";
                                            SQL="select termino.termino,ruta_multimedia from aux_multimedia_termino inner join termino on termino.id_termino=aux_multimedia_termino.id_termino inner join idioma on idioma.iso=termino.iso inner join multimedia on multimedia.id_multimedia=aux_multimedia_termino.id_multimedia where idioma.iso in (select idioma.ISO from idioma where idioma.ISO=?)";
                                    break;
                                }
                                PreparedStatement pst = connection.prepareStatement(SQL);
                                if(i!=1&&i!=2) pst.setString(1,request.getParameter("lang"));
                                ResultSet rs=pst.executeQuery();
                                JSONArray JSONArray = convertToJSON(rs);
                                if(!JSONArray.isNull(0)){
                                    writer.println(JSONArray);
                                    content+=JSONArray+"\n";
                                }
                            }
                            writer.println("*LANGCLUSTER*");
                            content+="*LANGCLUSTER*";
                            writer.close();
                            out.println(LANG.getPath()+"_LangClusterFile_"+content);
                        }catch(Exception e){
                            out.println("error"+e.getMessage());}
                        return;
                    case "4":   //ELIMINAR DATA
                        try{connect();
                            String[] array=request.getParameter("array").split(",");
                            PreparedStatement pst=null;
                            for(int i=0;i<array.length;i++){
                                if(array[i].contains(".")){ //TOPICO
                                    pst = connection.prepareStatement("delete from topico where id_topico=?");
                                    pst.setString(1, array[i].substring(array[i].indexOf(".")+1, array[i].length()));//Si es 2.1=>1);
                                }
                                else{//1,3,4
                                    switch(array[i]){ //si es root es todo e igual pasara por el resto. 2 es topicos, evaluado arriba
                                        case "1": //Datos del idioma
                                        pst = connection.prepareStatement("delete from Idioma where iso=?");
                                        pst.setString(1,request.getParameter("lang"));
                                        break;
                                        case "3": //Términos
                                        pst = connection.prepareStatement("delete from termino where termino.id_termino in (select id from (select termino.id_termino as id from termino inner join idioma on idioma.ISO=termino.ISO where idioma.ISO=?) as auxtable)");
                                        pst.setString(1,request.getParameter("lang"));
                                        break;
                                        case "4": // Nivel
                                        pst = connection.prepareStatement("delete from nivel where nivel.num_nivel in(select id from (select nivel.num_nivel as id from nivel inner join termino on nivel.num_nivel=termino.num_nivel inner join idioma on idioma.ISO=termino.ISO where idioma.ISO =? group by nivel.num_nivel) as auxtable)");
                                        pst.setString(1,request.getParameter("lang"));
                                        break;
                                        case "5": //Archivos multimedia asociados
                                        pst = connection.prepareStatement("delete from multimedia where multimedia.id_multimedia in (select id from (select multimedia.id_multimedia as id from multimedia inner join aux_multimedia_termino\n" +
                                                "on aux_multimedia_termino.id_multimedia=multimedia.id_multimedia\n" +
                                                "inner join termino\n" +
                                                "on termino.id_termino=aux_multimedia_termino.id_termino\n" +
                                                "inner join aux_idioma_multimedia\n" +
                                                "on aux_idioma_multimedia.id_multimedia=multimedia.id_multimedia\n" +
                                                "inner join idioma\n" +
                                                "on idioma.ISO=aux_idioma_multimedia.ISO\n" +
                                                "where idioma.ISO=?)as auxtable)");
                                        pst.setString(1,request.getParameter("lang"));
                                        break;
                                    }
                                }
                                //System.out.println(pst+"<>"+array[i]);
                                if(!array[i].trim().equals("root")){
                                    pst.execute();
                                }
                            }
                        }catch(Exception e){
                            out.println("error"+e.getMessage());}
                        return;
                    case "5":   // RUTA DE ARCHIVO "file"
                            File[] listfiles=uploadDir.listFiles();
                            String dir="";
                            for(int i=0;i<listfiles.length;i++){
                                if(listfiles[i].getName().equals(request.getParameter("file"))){
                                    dir=listfiles[i].getPath();
                                }
                            }
                            if(dir.trim().isEmpty()) out.println("NoData");
                            else                     out.println(dir);
                        return;
                    case "6":
                        try{String ruta=getServletContext().getRealPath("/Uploads").replaceAll("build", "").replace("\\\\", "\\")+File.separator;
                            File LANG=new File(ruta+"report\\"+request.getParameter("codigo_reporte").substring(0, 9)+".txt"); //para subir desde aquicambiar a nombre aaaah
                            if(LANG.exists()) LANG.delete();
                            LANG.createNewFile();
                            //BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(IPAAssistant.file), "UTF8"));   
                            try (PrintWriter writer = new PrintWriter(new OutputStreamWriter(new FileOutputStream(LANG),Charset.forName("UTF-8")))) {
                                writer.println(request.getParameter("stringcontodaladatadelosobjetos"));
                                writer.close();
                            }
                        }catch(Exception e){
                            out.println("error"+e.getMessage());}
                        return;
                    
                    case "7":
                            try{String ruta=getServletContext().getRealPath("/Uploads").replaceAll("build", "").replace("\\\\", "\\")+File.separator;
                                File[] files1=new File(ruta+"report"+File.separator).listFiles();
                                dir="";
                                String content="";
                                for(int i=0;i<files1.length;i++){
                                    if(files1[i].getName().equals(request.getParameter("codigo_reporte").substring(0, 9)+".txt")){ //me regresa la dirección pero necesito el string
                                        dir=files1[i].getPath();
                                    }
                                }
                                BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(dir), "UTF8"));
                                //BufferedReader reader=new BufferedReader(new FileReader(dir));
//                              BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(dir), "UTF8"));
                                String line;    
                                while((line=reader.readLine())!=null){
                                    content+=line;
                                }
                                if(dir.trim().isEmpty()) out.println("NoDATA");
                                else                        out.println(content);
                            }catch(Exception e){
                                System.out.println(e.getMessage());
                                out.println("null");}
                            return;
                }
            }
            
            System.out.print("Uploading File");
            
            //USO COMÚN PARA GUARDAR ARCHIVO
            if(!ServletFileUpload.isMultipartContent(request)){
                out.println("");
                return; 
            }

            FileItemFactory itemfactory = new DiskFileItemFactory(); 
            ServletFileUpload upload = new ServletFileUpload(itemfactory);
            String path = getServletContext().getRealPath("/Uploads").replaceAll("build", "").replace("\\\\", "\\");
            
            try{
                List<FileItem>  items = upload.parseRequest(request);
                File file = new File(path+File.separator+items.get(0).getName());
                file.createNewFile();
                items.get(0).write(file);
                //System.out.println("Archivo en: "+path+File.separator+items.get(0).getName());
                if(items.get(0).getName().endsWith(".jpg")||items.get(0).getName().endsWith(".png")){
                    //GUARDADO DE IMÁGENES
                    connect();
                    PreparedStatement pst = connection.prepareStatement("select id_usuario as id,nombre from usuario where email=?");
                    pst.setString(1, items.get(1).getString());
                    ResultSet rs=pst.executeQuery();
                    JSONObject obj = convertToJSON(rs).getJSONObject(0);
                    String name=obj.getInt("id")+".png";
                    BufferedImage originalImage = ImageIO.read(file);
                    BufferedImage resizeImageJpg = resizeImage(originalImage);
                    ImageIO.write(resizeImageJpg, "png", new File(path+File.separator+"avatar"+File.separator+name));
                    file.delete();
                }
                out.println("saved");
                //}
            }
            catch(FileUploadException e){       //Problema al subir el archivo
                out.println("errorUPLOAD");
            }
            catch(Exception ex){                //Otro posible error
                out.println("error"+ex.getMessage());
            }
            System.out.println("Done");
        }else out.print(""); 
	closeconnect();
        out.flush(); 
        out.close();
    }

    @Override
    public String getServletInfo() {
        return "LangCluster - UploadFile Servlet";
    }// </editor-fold>

    private void connect() throws Exception{
        Class.forName("com.mysql.jdbc.Driver");
        String url = "jdbc:mysql://localhost/";
        String dbName = "LangCluster";
        String username = "administrador";
        String password = "pass";
        String UTF="&useUnicode=true&characterEncoding=UTF-8";
        connection = DriverManager.getConnection(url+dbName+"?"+UTF,username,password);
    }
    
    private void closeconnect(){
        try{connection.close();}catch(Exception e){}
    }
    
    private JSONArray convertToJSON(ResultSet resultSet) throws Exception {
        JSONArray jsonArray = new JSONArray();
        while (resultSet.next()) {
            int total_rows = resultSet.getMetaData().getColumnCount();
            JSONObject obj = new JSONObject();
            for (int i = 0; i < total_rows; i++) {
                String columnName = resultSet.getMetaData().getColumnLabel(i + 1).toLowerCase();
                Object columnValue = resultSet.getObject(i + 1);
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
    
    private void checkfile(String PATH) throws Exception{
        File LANG=new File(PATH);
        if(!LANG.exists()) LANG.createNewFile();
        PreparedStatement pst = connection.prepareStatement("show tables");
        ResultSet rs=pst.executeQuery();
        JSONArray JSONArray = convertToJSON(rs);
        if(JSONArray.isNull(0)) throw new Exception("");    //ERROR DE CONEXIÓN
        BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(PATH), "UTF8"));
        String line,language="";    int i=0;    boolean EOF=false;
        while((line=reader.readLine())!=null){
            if(i==0){    if(!line.startsWith("LANG CLUSTER - DATA (")) throw new Exception("errorFormatError"); //EL ARCHIVO NO INICIA CORRECTAMENTE
                         else language=line.substring(line.indexOf("(")+1,line.indexOf("(")+3);
            }
            else if(line.startsWith("tb_")){
                    boolean aux=false;
                    for(int j=0;j<JSONArray.length();j++){
                        String tablename=JSONArray.get(j).toString().substring(JSONArray.get(j).toString().indexOf(":")+2,JSONArray.get(j).toString().length()-2);
                        if(!aux){
                            if(line.substring(3, line.length()).trim().toUpperCase().equals(tablename.trim().toUpperCase())) aux=true; //TABLA ENCONTRADA
                        }
                    }
                    if(!aux) throw new Exception("errorFormatError");  //LA TABLA NO EXISTE EN LA BASE DE DATOS
                    i++; line=reader.readLine();
                    JSONArray json = new JSONArray(line);
                    
                    if(line.startsWith("[{\"desc_idioma\":")){       //SI ES LA TABLA IDIOMA
                        JSONObject obj = json.getJSONObject(0);
                        if(!obj.getString("iso").trim().toUpperCase().equals(language.trim().toUpperCase())){
                            throw new Exception("errorFormatError");  //EL IDIOMA DE LA TABLA IDIOMA NO CONCUERDA CON LA DATA DEL ARCHIVO
                        }
                    }                    
                    if(json.isNull(0)) throw new Exception("errorFormatError");  //LA TABLA NO SIGUE EL FORMATO JSON
            }
            if(!EOF){
                if(line.startsWith("*LANGCLUSTER*")) EOF=true;
            }else throw new Exception("errorFormatError"); //MÁS DE UNA LÍNEA FINAL
            i++;
        }
    }
    
    private void DB_INSERT(String PATH) throws Exception{
        BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(PATH), "UTF8"));
        String line,language="";
        ArrayList<String> multimedia=new ArrayList<>(),termino=new ArrayList<>(),terminoES=new ArrayList<>();
        while((line=reader.readLine())!=null){
            String SQL="";
            if(line.startsWith("LANG CLUSTER - DATA (")) language=line.substring(line.indexOf("(")+1,line.indexOf("(")+3);
            if(line.startsWith("tb_")){
                String table=line.substring(3,line.length()).trim().toUpperCase();
                line=reader.readLine();
                JSONArray json = new JSONArray(line);
                
                System.out.println("TABLA: "+table);
                if(table.equals("AUX_IDIOMA_MULTIMEDIA")){
                    ArrayList<String> id_multimedia=new ArrayList<>();
                    for(int k=0;k<multimedia.size();k++){
                        PreparedStatement pst = connection.prepareStatement("select id_multimedia from multimedia where ruta_multimedia=?");
                        pst.setString(1, multimedia.get(k));
                        ResultSet rs = pst.executeQuery();
                        JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                        id_multimedia.add(String.valueOf(JSONobj.getInt("id_multimedia")));
                    }
                    //INSERTS
                    for(int k=0;k<id_multimedia.size();k++){
                        PreparedStatement pst = connection.prepareStatement("insert into AUX_IDIOMA_MULTIMEDIA values (?,\""+language+"\")");
                        pst.setString(1, id_multimedia.get(k));
                        pst.executeUpdate();
                    }
                }
                else if(table.equals("AUX_MULTIMEDIA_TERMINO")){
                    ArrayList<String> id_multimedia=new ArrayList<>(),id_termino=new ArrayList<>();
                    for(int k=0;k<multimedia.size();k++){
                        PreparedStatement pst = connection.prepareStatement("select id_multimedia from multimedia where ruta_multimedia=?");
                        pst.setString(1, multimedia.get(k));
                        ResultSet rs = pst.executeQuery();
                        JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                        id_multimedia.add(String.valueOf(JSONobj.getInt("id_multimedia")));
                    }
                    for(int k=0;k<termino.size();k++){
                        PreparedStatement pst = connection.prepareStatement("select id_termino from termino where termino=?");
                        pst.setString(1, termino.get(k));
                        ResultSet rs = pst.executeQuery();
                        JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                        id_termino.add(String.valueOf(JSONobj.getInt("id_termino")));
                    }
                    //INSERTS
                    for(int k=0;k<id_multimedia.size();k++){
                        PreparedStatement pst = connection.prepareStatement("insert into AUX_IDIOMA_MULTIMEDIA values (?,?)");
                        pst.setString(1, id_multimedia.get(k));
                        pst.setString(1, id_termino.get(k));
                        pst.executeUpdate();
                    }
                }
                else if(table.equals("AUX_TERMINO_TERMINOES")){
                    ArrayList<String> id_terminoES=new ArrayList<>(),id_termino=new ArrayList<>();
                    for(int k=0;k<termino.size();k++){
                        PreparedStatement pst = connection.prepareStatement("select id_termino from termino where termino=?");
                        pst.setString(1, termino.get(k));
                        ResultSet rs = pst.executeQuery();
                        JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                        id_termino.add(String.valueOf(JSONobj.getInt("id_termino")));
                    }
                    for(int k=0;k<terminoES.size();k++){
                        PreparedStatement pst = connection.prepareStatement("select id_terminoES from terminoES where terminoES=?");
                        pst.setString(1, terminoES.get(k));
                        ResultSet rs = pst.executeQuery();
                        JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                        id_terminoES.add(String.valueOf(JSONobj.getInt("id_terminoes")));
                    }
                    //INSERTS
                    for(int k=0;k<id_termino.size();k++){
                        PreparedStatement pst = connection.prepareStatement("insert into AUX_TERMINO_TERMINOES values (?,?)");
                        pst.setString(1, id_termino.get(k));
                        pst.setString(2, id_terminoES.get(k));
                        pst.executeUpdate();
                    }
                }
                else{
                    for(int j=0;j<json.length();j++){
                        JSONObject obj = json.getJSONObject(j);
                        switch(table){
                            case "IDIOMA":
                                SQL="insert into IDIOMA values (\""+obj.getString("iso")+"\",\""+obj.getString("nombre_idioma")+"\",\""+obj.getString("desc_idioma").trim()+"\")"
                                  + "on duplicate key update iso=values(iso),nombre_idioma=values(nombre_idioma),desc_idioma=values(desc_idioma)";
                                break;
                            case "TERMINOES":
                                terminoES.add(obj.getString("terminoes"));
                                SQL="insert into TERMINOES (terminoES) values (\""+obj.getString("terminoes")+"\")";
                                break;
                            case "TERMINO":
                                termino.add(obj.getString("termino"));
                                SQL="insert into TERMINO (ISO,id_topico,num_nivel,termino) values (\""+obj.getString("iso")+"\","+obj.getInt("id_topico")+","+obj.getInt("num_nivel")+",\""+obj.getString("termino")+"\")";
                                break;
                            case "TOPICO":
                                SQL="insert into TOPICO values ("+obj.getInt("id_topico")+","+obj.getInt("num_nivel")+",\""+obj.getString("nombre_topico")+"\",\""+obj.getString("desc_topico")+"\")"
                                  + "on duplicate key update id_topico=values(id_topico),nombre_topico=values(nombre_topico),desc_topico=values(desc_topico)";
                                break;
                            case "NIVEL":
                                SQL="insert into NIVEL values ("+obj.getInt("num_nivel")+",\""+obj.getString("desc_nivel")+"\")"
                                  + "on duplicate key update num_nivel=values(num_nivel),desc_nivel=values(desc_nivel)";
                                break;
                            case "MULTIMEDIA":
                                multimedia.add(obj.getString("ruta_multimedia"));
                                SQL="insert into MULTIMEDIA (ruta_multimedia,tipo_multimedia) values (\""+obj.getString("ruta_multimedia")+"\",\""+obj.getString("tipo_multimedia").toUpperCase()+"\")";
                                break;
                        }
                        if(!SQL.trim().isEmpty()){
                            System.out.println("Ejecutando: "+SQL);
                            PreparedStatement pst = connection.prepareStatement(SQL);
                            pst.executeUpdate();
                        }
                    }
                }
            }
        }
        System.out.println("Data Cargada Exitosamente");
    }
    
    private void DB_OVERWRITE(String PATH,String[] array) throws Exception{
        System.out.println(PATH);
        PreparedStatement pst=null;
        BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(PATH), "UTF8"));
        String line,language="";
        ArrayList<String> multimedia=new ArrayList<>(),termino=new ArrayList<>(),terminoES=new ArrayList<>();
        while((line=reader.readLine())!=null){
            System.out.println(line);
            String SQL="";
            if(line.startsWith("LANG CLUSTER - DATA (")) language=line.substring(line.indexOf("(")+1,line.indexOf("(")+3);
            if(line.startsWith("tb_")){
                String table=line.substring(3,line.length()).trim().toUpperCase();
                line=reader.readLine();
                JSONArray json = new JSONArray(line);
                
                System.out.println("TABLA: "+table);
                if(table.equals("AUX_IDIOMA_MULTIMEDIA")){
                    for(int i=0;i<array.length;i++){
                        if(array[i].equals("1")||array[i].equals("?")){
                            ArrayList<String> id_multimedia=new ArrayList<>();
                            for(int k=0;k<multimedia.size();k++){
                                pst = connection.prepareStatement("select id_multimedia from multimedia where ruta_multimedia=?");
                                pst.setString(1, multimedia.get(k));
                                ResultSet rs = pst.executeQuery();
                                JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                                id_multimedia.add(String.valueOf(JSONobj.getInt("id_multimedia")));
                            }
                            //INSERTS
                            for(int k=0;k<id_multimedia.size();k++){
                                pst = connection.prepareStatement("insert into AUX_IDIOMA_MULTIMEDIA values (?,\""+language+"\")");
                                pst.setString(1, id_multimedia.get(k));
                                pst.executeUpdate();
                            }
                            break;
                        }
                    }
                }
                else if(table.equals("AUX_MULTIMEDIA_TERMINO")){
                    for(int i=0;i<array.length;i++){
                        if(array[i].equals("3")||array[i].equals("5")){
                            ArrayList<String> id_multimedia=new ArrayList<>(),id_termino=new ArrayList<>();
                            for(int k=0;k<multimedia.size();k++){
                                pst = connection.prepareStatement("select id_multimedia from multimedia where ruta_multimedia=?");
                                pst.setString(1, multimedia.get(k));
                                ResultSet rs = pst.executeQuery();
                                JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                                id_multimedia.add(String.valueOf(JSONobj.getInt("id_multimedia")));
                            }
                            for(int k=0;k<termino.size();k++){
                                pst = connection.prepareStatement("select id_termino from termino where termino=?");
                                pst.setString(1, termino.get(k));
                                ResultSet rs = pst.executeQuery();
                                JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                                id_termino.add(String.valueOf(JSONobj.getInt("id_termino")));
                            }
                            //INSERTS
                            for(int k=0;k<id_multimedia.size();k++){
                                pst = connection.prepareStatement("insert into AUX_IDIOMA_MULTIMEDIA values (?,?)");
                                pst.setString(1, id_multimedia.get(k));
                                pst.setString(1, id_termino.get(k));
                                pst.executeUpdate();
                            }
                            break;
                        }
                    }
                }
                else if(table.equals("AUX_TERMINO_TERMINOES")){
                    for(int i=0;i<array.length;i++){
                        if(array[i].equals("3")){
                            ArrayList<String> id_terminoES=new ArrayList<>(),id_termino=new ArrayList<>();
                            for(int k=0;k<termino.size();k++){
                                pst = connection.prepareStatement("select id_termino from termino where termino=?");
                                pst.setString(1, termino.get(k));
                                ResultSet rs = pst.executeQuery();
                                JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                                id_termino.add(String.valueOf(JSONobj.getInt("id_termino")));
                            }
                            for(int k=0;k<terminoES.size();k++){
                                pst = connection.prepareStatement("select id_terminoES from terminoES where terminoES=?");
                                pst.setString(1, terminoES.get(k));
                                ResultSet rs = pst.executeQuery();
                                JSONObject JSONobj = convertToJSON(rs).getJSONObject(0);
                                id_terminoES.add(String.valueOf(JSONobj.getInt("id_terminoes")));
                            }
                            //INSERTS
                            for(int k=0;k<id_termino.size();k++){
                                pst = connection.prepareStatement("insert into AUX_TERMINO_TERMINOES values (?,?)");
                                pst.setString(1, id_termino.get(k));
                                pst.setString(2, id_terminoES.get(k));
                                pst.executeUpdate();
                            }
                            break;
                        }
                    }
                }
                else{
                    for(int j=0;j<json.length();j++){
                        JSONObject obj = json.getJSONObject(j);
                        switch(table){
                            case "IDIOMA":
                                for(int i=0;i<array.length;i++){
                                    if(array[i].equals("1")){
                                        SQL="insert into IDIOMA values (\""+obj.getString("iso")+"\",\""+obj.getString("nombre_idioma")+"\",\""+obj.getString("desc_idioma").trim()+"\")"
                                          + "on duplicate key update iso=values(iso),nombre_idioma=values(nombre_idioma),desc_idioma=values(desc_idioma)";
                                        break;
                                    }
                                }
                                break;
                            case "TERMINOES":
                                for(int i=0;i<array.length;i++){
                                    if(array[i].equals("3")){
                                        terminoES.add(obj.getString("terminoes"));
                                        SQL="insert into TERMINOES (terminoES) values (\""+obj.getString("terminoes")+"\")";
                                        break;
                                    }
                                }
                                break;
                            case "TERMINO":
                                for(int i=0;i<array.length;i++){
                                    if(array[i].equals("3")){
                                        termino.add(obj.getString("termino"));
                                        SQL="insert into TERMINO (ISO,id_topico,num_nivel,termino) values (\""+obj.getString("iso")+"\","+obj.getInt("id_topico")+","+obj.getInt("num_nivel")+",\""+obj.getString("termino")+"\")";
                                        break;
                                    }
                                }
                                break;
                            case "TOPICO":
                                for(int i=0;i<array.length;i++){
                                    if(array[i].contains(".")){
                                        SQL="insert into TOPICO values ("+obj.getInt("id_topico")+","+obj.getInt("num_nivel")+",\""+obj.getString("nombre_topico")+"\",\""+obj.getString("desc_topico")+"\")"
                                          + "on duplicate key update id_topico=values(id_topico),nombre_topico=values(nombre_topico),desc_topico=values(desc_topico)";
                                        break;
                                    }
                                }
                                break;
                            case "NIVEL":
                                for(int i=0;i<array.length;i++){
                                    if(array[i].equals("4")){
                                        SQL="insert into NIVEL values ("+obj.getInt("num_nivel")+",\""+obj.getString("desc_nivel")+"\")"
                                          + "on duplicate key update num_nivel=values(num_nivel),desc_nivel=values(desc_nivel)";
                                        break;
                                    }
                                }
                                break;
                            case "MULTIMEDIA":
                                for(int i=0;i<array.length;i++){
                                    if(array[i].equals("5")){
                                        multimedia.add(obj.getString("ruta_multimedia"));
                                        SQL="insert into MULTIMEDIA (ruta_multimedia,tipo_multimedia) values (\""+obj.getString("ruta_multimedia")+"\",\""+obj.getString("tipo_multimedia").toUpperCase()+"\")";
                                        break;
                                    }
                                }
                                break;
                        }
                        if(!SQL.trim().isEmpty()){
                            System.out.println("Ejecutando: "+SQL);
                            pst = connection.prepareStatement(SQL);
                            pst.executeUpdate();
                        }
                    }
                }
            }
        }
        System.out.println("Data Sobrescrita Exitosamente");
    }
    
    private static BufferedImage resizeImage(BufferedImage originalImage){
        int type = (originalImage.getTransparency() == Transparency.OPAQUE) ? BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB;
        //int type = originalImage.getType() == 0? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
        BufferedImage resizedImage = (BufferedImage) originalImage;
        int w= originalImage.getWidth(),    h=originalImage.getHeight();
        int maxW,maxH; maxW=maxH=75;
        do{ if(w>maxW){
                w/=2;
                if(w<maxW) w=maxW;
            }
            else{
                w=maxW;
            }
            if(h>maxH){
                h/=2;
                if(h<maxH) h=maxH;
            }
            else{
                h=maxH;
            }
            BufferedImage auxImage = new BufferedImage(w, h, type);
            Graphics2D g = auxImage.createGraphics();
            g.drawImage(resizedImage, 0, 0, w, h, null);
            g.dispose();
            g.setComposite(AlphaComposite.Src);
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION,RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            /*g.setRenderingHint(RenderingHints.KEY_RENDERING,RenderingHints.VALUE_RENDER_QUALITY);
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);*/
            
            resizedImage=auxImage;
        }while(w!=maxW||h!=maxH);
	return resizedImage;
    }
}
