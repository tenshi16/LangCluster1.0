<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <!--    LangCluster - Data (Consulta)    -->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8"> 
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <script src="codebase/i18n/es.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
            #scrollview{
                margin:100px;
            }
            #ArrowArea{
                width:15%;
            }
            .image{
                display: inline-block;
                vertical-align: middle;
                border-radius: 20%;
            }
        </style>
    </head>
    <body>
    <script>
        
    var consulteddata,consulteddata2,translations,typereturned;  getData();
    function getData(){
        $.ajax({
                type:'POST',
                data: {id:"Data3"},
                url: 'Servlet',
                success: function(result){
                    try{consulteddata=JSON.parse(result);
                        consulteddata2=JSON.parse(result);
                        translations=result;
                    }catch(e){
                        consulteddata="0";
                        consulteddata2="0";
                        translations=null;
                    }
                },
                complete:function(){
                    access();
                }
        });
    }
    
    function JSONremove(property, value) {
        consulteddata2.forEach(function(result, index) {
            if(result[property] === value) {
                consulteddata2.splice(index, 1);
            }    
        });
    }

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
                                    webix.ui({
                                        id:"access2",
                                        cols:[
                                            {width:20},
                                            {   rows:[
                                                    {height:20},
                                                    {view:"label",label:"<strong>Términos Estudiados:</strong>",height:20},
                                                    {view:"datatable",
                                                     id:"dataT",
                                                     columns:[
                                                            { id:"topico", header:"<center><strong>Tópico</strong></center>", adjust:"data", sort:"string"},
                                                            { id:"terminoes", header:"<center><strong>Término</strong></center>",adjust:"data", sort:"string"}
                                                     ],
                                                     data: consulteddata,
                                                     on:{
                                                        onAfterLoad:function(){
                                                            webix.delay(function(){
                                                                if (!this.count()){
                                                                    this.showOverlay("- Data no disponible -");
                                                                }
                                                                else{
                                                                    $$("dataT").hideOverlay();
                                                                }
                                                            }, this);
                                                        }
                                                     }
                                                    },
                                                    {height:20}
                                                ]},
                                            {width:20},
                                            {   rows:[ {height:20},
                                                       {id:"newTermino",view:"text", label:"<strong>Término Seleccionado:</strong>", value:"", labelPosition:"top"},
                                                       {height:20},
                                                       {view:"label", label:"<strong>Traducciones Disponibles:</strong>", height:20},
                                                       {view:"datatable",
                                                        id:"dataT2",
                                                        columns:[
                                                            {id:"idioma", header:"<center><strong>Idioma</strong></center>", adjust:"data", sort:"string"},
                                                            {id:"termino", header:"<center><strong>Traducción</strong></center>", adjust:"data", sort:"string"}
                                                        ],
                                                        data: consulteddata2,
                                                        on:{
                                                           onAfterLoad:function(){
                                                               webix.delay(function(){
                                                                   if (!this.count()){
                                                                       this.showOverlay("- Data no disponible -");
                                                                   }
                                                                   else{
                                                                       $$("dataT2").hideOverlay();
                                                                   }
                                                               }, this);
                                                           }
                                                        }
                                                       },
                                                       {height:20}
                                                ]
                                            },
                                            {width:20}
                                        ]
                                    });
                                    $$("dataT").attachEvent("onItemClick", function(id, e, node){
                                        consulteddata2=JSON.parse(translations);
                                        var auxJSON=JSON.parse(translations);
                                        $$("dataT2").hideOverlay();
                                        var item = this.getItem(id).terminoes;
                                        for(var i=0;i<auxJSON.length;i++){
                                            if(auxJSON[i].terminoes.toString().toUpperCase() !== item.toString().toUpperCase()){
                                                JSONremove('id',i+1);
                                            }
                                            if(auxJSON[i].terminoes.toString().toUpperCase() === "null"||auxJSON[i].terminoes === null){
                                                JSONremove('id',i+1);
                                            }
                                        }
                                        $$("newTermino").setValue(item);
                                        $$("dataT2").clearAll();
                                        $$("dataT2").parse(consulteddata2);
                                    });
                                    $$("dataT2").attachEvent("onItemClick", function(id, e, node){
                                        var item = this.getItem(id).termino;
                                    });
                                }
                            }
                        });
                    }
                }
    </script>
    </body>
</html>
