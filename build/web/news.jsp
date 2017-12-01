<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <!--    LangCluster - Noticias    -->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <script src="codebase/i18n/es.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
            .blue{
                background:rgb(102,177,227);
            }
            .blue2{
                background:rgb(147,200,236);
            }
            .blue3{
                background:rgb(201,227,245);
            }
        </style>
        
        <title>Noticias</title>
    </head>
    <body>
        
        <script>       
        
        var listcont=new Array();
        var cont;
        function list(){
            $.ajax({
                    type:'POST',
                    data: {id:"27"},
                    url: 'Servlet',
                    success: function(result){
                        //console.log(result);
                        cont=JSON.parse(result);
                          for(var i=0;i<cont.length;i++){
                            listcont.push(
                                {id:"bar"+i,height: 30, cols:[
                                    {template:"<strong>"+cont[i].nombre+" ("+cont[i].email+")</strong>", css:"blue2"},
                                    {template:cont[i].fecha_noticia, css:"blue3",width:180}
                                ]},
                                 {id:"titulo"+i,template:"<strong>Título: </strong>"+cont[i].titulo,css:"blue3",autoheight:true},
                                {id:"content"+i,template: cont[i].contenido_noticia,autoheight:true}
                            );
                        }
                        start();
                    }
                });
        }
        
        list();
        
        function start() {
                  webix.ui({
                    id:"delUser",
                rows:[
                    {template: "<center><font size=\"4\"><strong>Tablón de noticias</strong></font></center><hr width=\"90%\" size=\"2\" noshade>",  autoheight:true},
                    {cols:[{width:120},
                           {id:"scrollvieww", 
                            view:"scrollview",
                            scroll:"y",
                            body:{
                                rows: listcont
                            }},
                            {width:120}]
                    }
                ]
            });
        }
        </script>
    </body>
</html>
