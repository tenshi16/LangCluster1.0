<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
    </head>
    <body>
        <script>
           
             webix.ui({
                    id:"Comentario",
                cols:[
                    {view:"button",name:"Comentario",label:"Boton", click:function(){
                            $$("Contenido").attachEvent("onTimedKeyPress",function(){ 
                                var value = this.getValue().length;
                                $$("maximo").define("label",(this.getValue().length+"/700"));
                                $$("maximo").refresh();
                                if(value>700){
                                    /*
                                    $$("Contenido").define("value",($$("Contenido").getValue().substr(0, 700)));
                                    $$("Contenido").refresh();
                                    $$("Contenido").focus();
                                    */
                                    $$("AceptarCom").disable();
                                }
                                else{
                                    $$("AceptarCom").enable();
                                    $$("Contenido").focus();
                                }
                            });
                             $$("CommentIni").show();
                    }}
            ]
            });
            
  
 
        webix.ui({
                    id:"CommentIni",
                    view:"window",
                    height:400,
                    width:600,
                    head:"Registrar Comentario",
                    position:"center",
                    body:{
                        rows:[
                            {cols:[
                        { id:"Tema",view:"richselect", value:"General",label:"Tema:", 
                            options:[
                                { id:"General" },
                                { id:"Notificar un Problema" },
                                { id:"Sugerencias" },
                                { id:"Problemas con la frase actual" }
                            ]
                        },
                            ]},
                        {template: "<hr width=\"100%\" size=\"2\" noshade>",  autoheight:true, borderless:true},
                        {id:"Contenido",view:"textarea",label:"Comentario:", labelPosition:"top"},
                        {cols:[
                            {},
                            {},
                            { view:"label", label:"Caracteres:   ", align:"right"},
                            { id:"maximo",view:"label", label:"0/700", align:"center"}
                        ]},
                        {cols:[
                            { id:"AceptarCom",view:"button", label:"Aceptar", click:"Aceptar"},
                            { view:"button", label:"Cancelar", click:"Cancelar"}
                        ]},
                        ]
                    }
            });

            
            click:function Aceptar(){
               var aux = $$("Tema").getValue();
               if(aux==="General"){
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),p2:"1",p3:$$("Contenido").getValue(),id:"25"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                webix.alert("Lo sentimos ha ocurrido un problema");
                            }else{
                                webix.alert("Comentario enviado.");
                            }
                        }
                    });
               }
               if(aux==="Notificar un Problema"){
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),p2:"2",p3:$$("Contenido").getValue(),id:"25"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                webix.alert("Lo sentimos ha ocurrido un problema");
                            }else{
                                webix.alert("Comentario enviado.");
                            }
                        }
                    });
               }
               if(aux==="Sugerencias"){
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),p2:"3",p3:$$("Contenido").getValue(),id:"25"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                webix.alert("Lo sentimos ha ocurrido un problema");
                            }else{
                                webix.alert("Comentario enviado.");
                            }
                        }
                    });
               }
               if(aux==="Problemas con la frase actual"){
                  /*
                   * hay una relacion entre comentario y termino, del cual se tiene que llenar además de la tabla comentario
                   * la auxiliar tambien para identificar de que termino se está refiriendo
                   */
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),p2:"4",p3:$$("Contenido").getValue(),/*term:"", id:"18"*/ id:"25"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                webix.alert("Lo sentimos ha ocurrido un problema");
                            }else{
                                webix.alert("Comentario enviado.");
                            }
                        }
                    });
               }
            }
            
            click:function Cancelar(){
                $$("CommentIni").hide();
            }
            
            
            
            
        </script>
    </body>
</html>
