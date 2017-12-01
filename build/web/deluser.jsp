<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
    <!--    LangCluster - Eliminar Usuario    -->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <script src="codebase/i18n/es.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <body>
        <script>
            
        var listas;
        
        var typereturned; access();
        function access(){
                var cookie = getCookie("username");
                if (cookie == "" || cookie == null){
                    webix.ui({
                        id:"access0",
                        rows:[
                                { template:"<center><br/><br/><br/>"
                                    +"<img src='img/LangCluster.png'/>"
                                    +"<br/><br/><br/>"
                                    +"Estimado usuario, debe iniciar sesión para acceder a esta sección.</center>" }
                        ]
                    });
                }
                else{
                    $.ajax({
                        type:'POST',
                        data: {username: cookie, id:"3"},
                        url: 'Servlet',
                        success: function(result){
                                    if(!result || 0 === result.length){
                                        typereturned="1";
                                    }else{
                                        var obj = JSON.parse(result);
                                        if(obj[0].id_permiso==0){
                                            typereturned="0";
                                        }
                                        else {
                                            typereturned="1";
                                        }
                                    }
                                },
                        complete: function(){
                             if(typereturned!= "0"){
                                    webix.ui({
                                        id:"access1",
                                        rows:[
                                                { template:"<center><br/><br/><br/>"
                                                    +"<img src='img/LangCluster.png'/>"
                                                    +"<br/>- Acceso Denegado -"
                                                    +"<br/><br/><br/>"
                                                    +"Estimado usuario, no tiene los permisos necesarios para acceder a esta sección.</center>" }
                                        ]
                                    });
                                }else{ 
                                    lista();
                            }
                        }
                    });
                }
            }
            
        function lista(){
            $.ajax({
                type:'POST',
                data: {id:"12"},
                url: 'Servlet',
                success: function(result){
                    listas=JSON.parse(result);
                    
                },
                complete: function(){
                   start();
                }
            });            
        };
           
        webix.i18n.setLocale('es-ES');
        click:function start() {
                webix.ui({
                    id:"delUser",
                    rows:[
                        {template: "<center><font size=\"4\"><strong>Eliminar usuario</strong></font></center><hr width=\"90%\" size=\"2\" noshade>",  autoheight:true},
                        {cols:[{},
                              {
                                id:"tabla",
                                view:"datatable",
                                select:"row",
                                width:650,
                                columns:[
                                    { id:"nom",   header:["Nombre", {content:"textFilter"}],    width:200,sort:"string"},
                                    { id:"usr",    header:["Usuario", {content:"textFilter"}],      width:200,sort:"string"},
                                    { id:"datein",   header:["Fecha de acceso", {content:"textFilter"}],         width:200,sort:"string"}
                                ],
                                data: listas
                             },
                             {}]
                       },
                       {cols:[{},
                              {view: "button", name: "DelUser",label: "Modificar usuario", click: mod},
                              {view: "button",name:"ModUser",label: "Eliminar Usuario", click: del},
                              {}]
                        }
                    ]
                });
            }
        function change_batch(){
            var mode = $$("rad").getValue();
            if(mode)
                $$("mybar").showBatch(mode);
        }


        function del(){
            
            webix.confirm({
                title:"¡Atención!",
                type:"alert-warning",
                ok:"Sí", 
                cancel:"No",
                text:"¿Está usted seguro de eliminar el usuario?",
                callback:function(answer){
                    if(answer == true){
                        var aux = $$("tabla").getItem($$("tabla").getSelectedId(true).join());
                        $.ajax({
                            type:'POST',
                            data: {p1:aux.usr,id:"13"},
                            url: 'Servlet',
                            success: function(result){
                                if(result == 1){
                                   document.location.reload();
                               }
                            }
                        });
                    }
            }});
            
            
        }

        function mod(){
          var aux = $$("tabla").getItem($$("tabla").getSelectedId(true).join());
          setCookie("config",aux.usr,1);
           window.open("config.jsp", "_self");
        }
      </script>
        </body>
</html>