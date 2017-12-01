<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <!--    LangCluster - Agregar Noticias    -->
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
                     // NOTICIAS (2): AÑADIR COMPONENTES DINÁMICAMENTE AL SCROLLVIEW
                          for(var i=0;i<cont.length;i++){
                            listcont.push(
                                {id:"bar"+i,height: 30, cols:[
                                    {view:"checkbox", id:"check"+i, css:"blue",width:20},
                                    {template:"<strong>"+cont[i].nombre+" ("+cont[i].email+")</strong>", css:"blue2"},
                                    {template:cont[i].fecha_noticia, css:"blue3",width:180}
                                ]},
                                 {id:"titulo"+i,template:"<strong>Título: </strong>"+cont[i].titulo,css:"blue3",autoheight:true},
                                {id:"content"+i,template: cont[i].contenido_noticia,autoheight:true}
                            );
                        }
                        webix.i18n.dateFormat="%d/%m/%Y";
                        webix.i18n.setLocale();
                        start();
                    }
                });
        }
        
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
                                    list();
                            }
                        }
                    });
                }
            }
        
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
                   },
                   {cols:[{},
                        {view: "button", name: "DelUser",label: "Eliminar Noticias", click: del},
                        {view: "button",name:"ModUser",label: "Agregar Noticia", click:function(){
                            $$("Contenido").attachEvent("onTimedKeyPress",function(){ 
                                var value = this.getValue().length;
                                $$("maximo").define("label",(this.getValue().length+"/1000"));
                                $$("maximo").refresh();
                                if(value>1000){
                                    $$("AceptarCom").disable();
                                }
                                else{
                                    $$("AceptarCom").enable();
                                    $$("Contenido").focus();
                                }
                            });
                             $$("Notiini").show();
                        }},
                        {}]
                  }
            ]
            });
            }
            
            webix.ui({
                    id:"Notiini",
                    view:"window",
                    height:400,
                    width:600,
                    head:"Nueva Noticia",
                    position:"center",
                    body:{
                        rows:[
                            {cols:[
                                {id:"Titu",view:"text",label:"Título:", value:""}
                            ]},
                            {template: "<hr width=\"100%\" size=\"2\" noshade>",  autoheight:true, borderless:true},
                            {id:"Contenido",view:"textarea",value:"",label:"Noticia:", labelPosition:"top"},
                            {cols:[
                                {},
                                {},
                                { view:"label", label:"Caracteres:   ", align:"right"},
                                { id:"maximo",view:"label", label:"0/1000", align:"center"}
                            ]},
                            {cols:[
                                { id:"AceptarCom",view:"button", label:"Publicar", click:"Publicar"},
                                { view:"button", label:"Cancelar", click:"Cancelar"}
                            ]}
                        ]
                    }
            });
        
        click: function Publicar(){
           console.log("Publicar="+$$("Contenido").getValue()+"Publicar="+$$("Titu").getValue());
           if($$("Contenido").getValue().length!==0 ||
             $$("Contenido").getValue().length!=="" ||
             $$("Titu").getValue().length !== 0 ||
             $$("Titu").getValue().length !==""){
              var a=$$("Contenido").getValue();
              var x=$$("Titu").getValue();
              $.ajax({
                    type:'POST',
                    data: {p0:getCookie("username"),p1:x,p2:a,id:"29"},
                    url: 'Servlet',
                    success: function(result){
                       if(result > 0){
                            webix.alert("Noticias publicada.");
                            $$("Notiini").hide();
                            document.location.reload();
                       }
                       
                    }
                 });
           }else{
              webix.message("Existen campos vacios.");
           }
           
        }
        
        click: function Cancelar(){
           webix.message("Cancelar");
           $$("Notiini").hide();
        }
        
        click: function del(){
           var list="";
               for(var i=0;i<cont.length;i++){
                   if($$("check"+i).getValue()==1){
                        console.log("cont[i]="+cont[i].id.toString());
                         list+=cont[i].id+",";
                   }
               }
               list=list.substr(0,list.length-1);
            $.ajax({
                    type:'POST',
                    data: {p1:list,id:"28"},
                    url: 'Servlet',
                    success: function(result){
                       if(result > 0){
                           //CORREGIR AQUI
                            webix.alert("Noticias borradas.");
                            document.location.reload();
                       }
                    }
                 });
         }
        click: function add(){
            webix.message(" Agregar");
        }
        </script>
    </body>
</html>
