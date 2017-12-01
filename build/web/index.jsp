<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <!--    LangCluster - Index    -->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <script src="codebase/i18n/es.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
            .webix_layout_toolbar.webix_toolbar,.webix_layout_toolbar,.fondo,.webixtype_base,
            .webix_button,.webix_button input,.webix_button div,.webix_popup_button,.webix_popup_button div{
                background:#8AB3E4;
            }
            #areaA, #areaB{
                margin: 50px;
                width:700px; height:100px;
            }/*
            .blue{
                background:#3498DB;
            }*/
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
                margin:0px;
            }
            .imageAvatar{            
                display: block;
                max-width:75px !important;
                max-height:75px !important;
                width: 75px !important;
                height: 75px !important;
            }
            .imageAvatar2{
                /*
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: 37px;
                */
                /*
                max-width:75px;
                width: 75px;
                height:auto;
                */
                
                display: block;
                max-width:37px !important;
                max-height:37px !important;
                width: 37px !important;
                height: 37px !important;
                
            }
            a:link,a:visited,a:active {
                color: rgb(48,57,177);
                text-decoration: none;
            }
            a:hover {
                color: rgb(31,38,105);
                font-weight: bold;
                text-decoration: none;
            }
        </style>
    <title>LangCluster</title>
    </head>


<body>
    <form method="post">    
    <script>
        var HTML="<center><font size=\"1\"><strong>Lang Cluster</strong> |<a href='javascript:void(0)' onclick='gohome();'> www.langcluster.com</a> | ©2016-2017 | Todos los derechos reservados | <a href='javascript:void(0)' onclick='norms();'>Políticas</a> | <a href='javascript:void(0)' onclick='contact(false);'>Contacto</a></font></center>";

        var menu = {
            view:"toolbar",
            elements:[
                { id:"help", view:"button", label:"Ayuda", gravity:2, click:changepage}
            ],
            borderless:true
        };

         var Dere1 = {
            view:"toolbar",
            elements:[
                { id:"b1", view:"button", label:"Usuario", gravity:2, popup:"my_pop"}
            ],
            borderless:true
        };

        var Dere2 = {
            view:"toolbar",
            elements:[
                { id:"b2", view:"button", value:"Bienvenido, "+getCookie("name"), gravity:2,click: ptslvl}
            ],
            borderless:true
        };
        
        var nivel;
        var puntaje;
        var puntajeD; 
        var nombre;
        var ruta;
        var RBand;
        var barrita;

        function aux(){
                try{$$("barra").hide();}catch(error){};
                barrita.show({
                        x:1200, 
                        y:50
                    });;
        }
        
        function ptslvl(id){
            try{    if($$("barra").isVisible()){ $$("barra").hide();}
                    else{ throw "null";}
            }catch(error){
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),id:"7"},
                        url: 'Servlet',
                        success: function(result){
                            var obj = JSON.parse(result);
                            nivel = obj[0].nivel;
                            puntaje = obj[0].puntaje;
                            puntajeD = obj[0].puntajed;
                            nombre = obj[0].nombre;
                            ruta = obj[0].ruta;
                            console.log(ruta);
                            if(obj[0].ruta==="null"||obj[0].ruta===null){
                                ruta="Uploads/avatar/0.jpg";
                            }
                            if(nivel === "null"||nivel === null)        nivel=0;
                            if(puntaje === "null"||puntaje === null)    puntaje=0;
                        },
                        complete:function(){
                            var cookie = getCookie("LANG");
                            if (cookie.toString().length !== 0){
                                    if(cookie==="EN"){
                                        RBand="img/data/aUK.jpg";
                                    }
                                    if(cookie==="FR"){
                                        RBand="img/data/aFR.jpg";
                                    }
                                    if(cookie==="JA"){
                                        RBand="img/data/aJA.jpg";
                                    }
                                    //Barrita
                                    barrita = new webix.ui({
                                        view:"popup",
                                            id:"barra",
                                            body:{ 
                                                rows:[ 
                                                 {cols:[//{template:"<div class='imageAvatar' width='75' height='75' ><img src=\""+ruta+"\"/></div>",width:75,height:75,borderless:true},
                                                        {view:"button", type:"image", image:ruta, height:75, width:75, css:"imageAvatar", borderless:true},
                                                        {id:"Band",view:"button", type:"imageTop", image: RBand, height:37, width:37, css:"imageAvatar2", borderless:true},
                                                        {rows:[{view:"label", label:"<strong>"+nombre+"</strong>"},
                                                               {view:"label", label:"<em>"+getCookie("username")+"</em>"}
                                                              ]}
                                                    ]},
                                                    {id:"config", view:"button", value:"Ajustes", click: changepage},
                                                    {id:"22", view:"label",  label:"Puntaje Acumulado: "+puntaje},
                                                    {id:"33", view:"label",  label:"Puntaje Diario: "+puntajeD},
                                                    {id:"44", view:"label", label:"Nivel: "+nivel},
                                                    {id:"cerrar", view:"button", value:"Cerrar Sesión", click: function(){
                                                            eraseCookie("username",getCookie("username"));
                                                            eraseCookie("name",getCookie("name"));
                                                            eraseCookie("config",getCookie("config"));
                                                            document.location.reload();
                                                       }
                                                    }
                                                ]
                                            },
                                            select:true
                                    });
                                    //Barrita fin
                            }else{ 
                                console.log("no paso");
                                //Barrita
                            barrita = new webix.ui({
                                view:"popup",
                                    id:"barra",
                                    body:{ 
                                        rows:[ 
                                         {cols:[//{template:"<div class='imageAvatar' width='75' height='75' ><img src=\""+ruta+"\"/></div>",width:75,height:75,borderless:true},
                                                {view:"button", type:"image", image:ruta, height:75, width:75, css:"imageAvatar", borderless:true},
                                                {rows:[{view:"label", label:"<strong>"+nombre+"</strong>"},
                                                       {view:"label", label:"<em>"+getCookie("username")+"</em>"}
                                                      ]}
                                            ]},
                                            {id:"config", view:"button", value:"Ajustes", click: changepage},
                                            {id:"22", view:"label",  label:"Puntaje Acumulado: "+puntaje},
                                            {id:"33", view:"label",  label:"Puntaje Diario: "+puntajeD},
                                            {id:"44", view:"label", label:"Nivel: "+nivel},
                                            {id:"cerrar", view:"button", value:"Cerrar Sesión", click: function(){
                                                    eraseCookie("username",getCookie("username"));
                                                    eraseCookie("name",getCookie("name"));
                                                    eraseCookie("config",getCookie("config"));
                                                    document.location.reload();
                                               }
                                            }
                                        ]
                                    },
                                    select:true
                            });
                            //Barrita fin
                                RBand="";
                            }
                            aux();  
                        }
                    }); 
                }
        };

        var Dere=Dere1;
        usermenu();
        function usermenu(){
            var cookie = getCookie("username");
            if (cookie === "" || cookie === null){
                Dere=Dere1;
            }
            else{
                Dere=Dere2;
            }
        };

        webix.ui({
            view:"popup",
            id:"reportPopUpUser",
            body:{
                view:"list",
                data:[
                    {id:"generarReporte", name:"Generar Reporte"},
                    {id:"consultarReporte", name:"Consultar Reporte"},                                         
                    {id:"estadisticas",name:"Estadísticas"}
               ],
               on:{
                   "onItemClick": function (id, e, trg){
                            if(id==="generarReporte")  {setCookie("rep","1",1); changepage("statUser");  $$("reportPopUpUser").hide();}
                        else if(id==="consultarReporte"){ConsultaVUser(); $$("reportPopUpUser").hide();}                                           
                        else if(id==="estadisticas"){
                            $$("reportPopUpUser").hide();
                            setCookie("stat","1",1);
                            changepage("statUser");
                        }
                    }},
               template:"#name#",
               autoheight:true,
               select:true
            }
	});
        
        webix.ui({
            view:"popup",
            id:"reportPopUpAdmin",
            body:{
                view:"list",
                data:[
                    {id:"generarReporteAdmin",  name:"Generar Reporte General de Sistema"},
                    {id:"consultarReporteAdmin",name:"Consultar Reporte General de Sistema"}
                ],
                on:{
                    "onItemClick": function (id, e, trg){
                             if(id==="generarReporteAdmin"){ changepage("stat"); $$("reportPopUpAdmin").hide();}
                        else if(id==="consultarReporteAdmin"){
                            ConsultaV();
                            $$("reportPopUpAdmin").hide();
                        }
                }},
                template:"#name#",
                autoheight:true,
                select:true
            }
        });
         
        function ConsultaV(){
            webix.ui({
                 view:"window",
                 id:"ventanaConsulta",
                 height:150,
                 width:400,  
                 head:"Consulta",
                 position:"center",
                     body:{rows:[
                            {view:"text", label:"Código:",id:"b1"},
                            {cols:[
                                {view:"button", value:"Consultar",click:function(){ 
                                    if($$("b1").getValue()!=""){
                                        $$("ventanaConsulta").hide();
                                        setCookie("codigoR",$$("b1").getValue(),1);
                                        changepage("stat");
                                    }
                                 }},
                                {view:"button", value:"Cancelar", click:function(){$$("ventanaConsulta").hide();}}
                            ]}
                     ]}
            }).show();
        }
         
        function ConsultaVUser(){
            webix.ui({
                 view:"window",
                 id:"ventanaConsultaUser",
                 height:150,
                 width:400,  
                 head:"Consulta",
                 position:"center",
                     body:{rows:[
                            {view:"text", label:"Código:",id:"b1"},
                            {cols:[
                                {view:"button", value:"Consultar",click:function(){ 
                                    if($$("b1").getValue()!=""){
                                        $$("ventanaConsultaUser").hide();
                                        setCookie("consultaUser","1",1);
                                        setCookie("codigoR",$$("b1").getValue(),1);                                    
                                        changepage("statUser");
                                    }
                                 }},
                                {view:"button", value:"Cancelar", click:function(){$$("ventanaConsultaUser").hide();}}
                            ]}
                     ]}
            }).show();
        }
         
        webix.ui({
                view:"popup",
                id:"my_pop",
                body:{
                    view:"list", 
                    data:[ 
                         {id:"1", name:"Iniciar Sesión"},
                         {id:"2", name:"Registrar Usuario"}
                    ],
                    on:{
                         "onItemClick": function (id, e, trg){
                             $$("my_pop").hide();
                             if(id==="1"){
                                Ini();
                             }
                             if (id==="2" ){
                                Regis();
                             }
                          }},
                    template:"#name#",
                    autoheight:true,
                    select:true
               }
        });
  /*
        webix.ui({
                view:"popup",
                id:"popComentario",
                body:{
                    view:"list", 
                    data:[ 
                        {id:"popC1", name:"Consultar y Eliminar Comentario"}
                        //,{id:"popC2", name:"Registrar Comentario"}
                     ],
                     on:{
                         "onItemClick": function (id, e, trg){
                             if(id==="popC1"){
                                 changepage("comment2"); 
                                 $$("popComentario").hide();
                             }
                             
                             if (id==="popC2" ){
                                 changepage("comment"); 
                                 $$("popComentario").hide();
                             }
                             
                          }},
                    template:"#name#",
                    autoheight:true,
                    select:true
                }
        });
        */
         
        webix.ui({
                view:"popup",
                id:"popData",
                body:{
                    view:"list", 
                    data:[ 
                        {id:"popD1", name:"Data del Sistema"},
                        {id:"popD2", name:"Usuarios"}
                    ],
                    on:{
                        "onItemClick": function (id, e, trg){
                            if(id==="popD1"){
                                changepage("data"); 
                                $$("popData").hide();
                            }
                            if (id==="popD2" ){
                                changepage("usr"); 
                                $$("popData").hide();
                            }
                         }},
                    template:"#name#",
                    autoheight:true,
                    select:true
                }
        });
  
         
        function Ini(){
            try{$$("Ini").hide();}catch(error){}
            try{$$("Regi").hide();}catch(error){}
            webix.ui({
                    id:"Ini",
                    view:"window",
                    height:225,
                    //width:300,
                    head:"<strong>Iniciar Sesión</strong>",
                    position:"center",
                    body:{
                        view: "form",
                        id: "myForm",
                        width:350,
                        elements:[
                            {rows:[
                                {cols:[{view:"label", label:"Email",gravity:1},
                                       {id:"Buser",view:"text",name:"username",gravity:2}
                                ]},
                                {cols:[{view:"label", label:"Contraseña",gravity:1},
                                       {view:"text", type:"password", name:"password",gravity:2}
                                ]}
                            ]},
                            { margin:5, cols:[
                                { view:"button", value:"Entrar" , type:"form",click: doOnClick, hotkey: "enter" },
                                { view:"button", value:"Cancelar", click: function(){$$("Ini").hide();} }
                            ]},
                            {template:"<center><a href='javascript:void(0)' onclick='contact(true);'>¿No recuerda sus datos?</a></center>",height:23}
                            ]
                    }
            }).show();
         }
         
         function doOnClick(){
                var mail = $$("myForm").getValues().username;
                var pass = $$("myForm").getValues().password;
                if (mail.length!== 0 && pass.length!== 0){
                    iniSesion();
                }
                else{
                    webix.alert("Hay campos vacíos");
                }
            }
            
        var countries; countrylist();
        function countrylist(){
            $.ajax({
                type:'POST',
                data: {id:"4"},
                url: 'Servlet',
                success: function(result){
                    countries=JSON.parse(result);
                }
            });            
        };
        

        function Regis(){
            try{$$("Ini").hide();}catch(error){}
            try{$$("Regi").hide();}catch(error){}
            webix.i18n.setLocale('es-ES');
            webix.ui({
                id:"Regi",
                view:"window",
                height:500,
                width:500,
                head:"<strong>Registrar Usuario</strong>",
                position:"center",
                body:{
                view:"form", 
                id:"Registrar",
                width:500,
                cols:[
                    {rows:[
                    { id:"avatar",view:"button", type:"imageButtonTop", label:"Cargar Avatar 70x70", 
                            labelPosition:"top",image:"Uploads/avatar/0.jpg", width:200, height:90,
                            click: avatar
                         },
                            { id:"pais", view:"text", name:"country", label:"País:", value:countries[0].nombre_pais, suggest: countries},
                            { 
                            id:"Calendar",
                            view:"datepicker",	
                            value:"", 
                            //$$('calendar1').selectDate(new Date(2012,3,30));
                            name: "end_date",
                            label: 'Fecha de nacimiento:',
                            labelPosition:"top",
                            calendarDateFormat: "%Y-%m-%d",
                            editable: true, 
                            suggest:{
                            type:"calendar",
                            body:{
                                blockDates:function(date){
                                    var d=new Date().getFullYear();
                                    if(date.getFullYear()>=d-5)
                                        return true;
                                },
                                skipEmptyWeeks: true
                            }     
                         }
                      },
                    { view:"button", value:"Registrar" , type:"form", click: function(){
                           if ($$("Registrar").validate()){
                            Register();
                           }
                    }}
                    ]
                    },
                    {rows:[
                    { id:"Nom",view:"text", placeholder:"Nombre"},
                    {},
                    { id:"email", name:"email", view:"text", placeholder:"Correo", invalidMessage: "Correo invalido."},
                    { id:"pass1", type:"password", view:"text", placeholder:"Contraseña"},
                    { id:"pass2",type:"password", view:"text", placeholder:"Repetir Contraseña"},
                    { view:"button", value:"Cancelar", click: function(){$$("Regi").hide();}}
                    ]}
                ],
                rules:{
                     "email": webix.rules.isEmail
                    }
            }}).show();
        }
        
        click: function avatar(){
            //webix.message("hola mundo!");
            importdata();
        }
        
        function importdata(){
                webix.ui({
                    id:"windowImportData",
                    view:"window",
                    width:500,
                    head:"<strong>Importar Avatar</strong>",
                    position:"center",
                    body:{
                        view:"form", id:"uploadform",
                        rows:[{cols:[{id:"doclist", view:"list",width:350, type:"uploader", scroll:false},
                                     {
                                        view:"uploader", upload:"${pageContext.request.contextPath}/UploadFile",
                                        id:"upl1", name:"files",
                                        value:"Seleccionar", multiple: false,  
                                        link:"doclist", autosend:false
                                    }
                                    ]},
                              {cols:[{view:"button", value:"Aceptar", type:"form", click: function(){$$("windowImportData").hide();
                                     }},
                                     {view:"button", value:"Cancelar", click:function(){$$("windowImportData").hide();}}]
                        }]
                    }
                }).show();
            }

        //CARGA MIGUEL
        
        function up(){
            var aux=false;
            $$('upl1').files.data.each(function(obj){
                    var error=false;
                    //obj.name=Base64.encode($$("email").getValue().toString())+".jpg";
                    //avatar=obj.name;
                    if(obj.type.toString()!="jpg" && obj.type.toString()!="png"){
                        webix.message({type:"error",text:"No se reconoce el formato del archivo"});
                        error=true;
                    }
                    if(obj.size > 30000){
                        webix.message({type:"error",text:"El archivo no puede superar los 30KB"});
                        error=true;
                    }
                    if(!error){
                        $$("upl1").send(obj.id,{user:$$("email").getValue()});
                        aux=true;
                    }
                    else{
                        aux=false;
                    }
            });
            return aux;
        }
        
        
        function Register(){
            if($$("pass1").getValue()===$$("pass2").getValue()){
                if($$("email").getValue().length!==0 &&
                   $$("Nom").getValue().length!==0 &&  
                   $$("Calendar").getValue().length!==0 &&  
                   $$("pais").getValue()!==0){
                    //registrar
                    var error=false;
                    var country=true;
                    try{    
                            
                            
                            for(var i=0;i<countries.length;i++){
                               if(countries[i].id===$$("pais").getValue().toString()){
                                  country=false;
                               }
                            }
                            if(country){
                               webix.alert("País inexistente.")
                            }
                            
                            if(!error && !country){
                                
                                 $.ajax({
                                    type:'POST',
                                    data: {username:$$("email").getValue(), id:"2"},
                                    url: 'Servlet',
                                    success: function(result){
                                        if(!result || 0 === result.length){
                                           //console.log("regis"+avatar);
                                            $.ajax({
                                               type:'POST',
                                               data: { p1:$$("email").getValue(),
                                                       p2:$$("pass1").getValue(),
                                                       p3:$$("Nom").getValue(),
                                                       p4:webix.i18n.parseFormatStr($$("Calendar").getValue()),
                                                       p5:$$("pais").getValue(),
                                                       p6:avatar,
                                                       id:"6"
                                                    },
                                               url: 'Servlet',
                                               success: function(result){
                                                  $$("Regi").hide();
                                                  $$("windowImportData").hide();
                                                   webix.alert("Nuevo usuario registrado.");
                                               }
                                           }); 
                                            }else{
                                                webix.alert("Correo en uso.");     
                                            }
                                        }
                                 });
                                 var ok = up();
                                 
                            }
                    }catch(error){}

                    //registrar
                   
               }else{
                    webix.alert("Existen campos vacíos.");
               }
            }else{
                webix.alert("Campos de contraseñas no concuerdan.");
           } 
        }
        /*
        webix.ui({
            id:"Comentario",
            cols:[
                {view:"button",name:"Comentario",label:"Boton", click:function(){
                        $$("Contenido").attachEvent("onTimedKeyPress",function(){ 
                            var value = this.getValue().length;
                            $$("maximo").define("label",(this.getValue().length+"/700"));
                            $$("maximo").refresh();
                            if(value>700){
                                $$("AceptarCom").disable();
                            }
                            else{
                                $$("AceptarCom").enable();
                                $$("Contenido").focus();
                            }
                        });
                        $$("CommentIni").show();
                    }
                }
            ]
        });*/
        
        function newcomment(){
            var options=[];
            options.push({ id:"General" });
            options.push({ id:"Notificar un Problema" });
            options.push({ id:"Sugerencias" });
            var idT=getCookie("phrase");
            if (idT !== "" && idT !== null){
                options.push({ id:"Problemas con la frase actual" });
            }
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
                                options:options
                            }
                        ]},
                        {template: "<hr width=\"100%\" size=\"2\" noshade>", autoheight:true, borderless:true},
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
                        ]}
                    ]
                }
                }).show();
                $$("Contenido").attachEvent("onTimedKeyPress",function(){ 
                    var value = this.getValue().length;
                    $$("maximo").define("label",(this.getValue().length+"/700"));
                    $$("maximo").refresh();
                    if(value>700){
                        $$("AceptarCom").disable();
                    }
                    else{
                        $$("AceptarCom").enable();
                        $$("Contenido").focus();
                    }
                });
            }
            
            click:function Aceptar(){
               var aux = $$("Tema").getValue();
               if(aux==="General"){
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),p2:"1",p3:$$("Contenido").getValue(),id:"24"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                webix.alert("Lo sentimos ha ocurrido un problema");
                            }else{
                                webix.alert("Comentario enviado.");
                                $$("CommentIni").hide();
                            }
                        }
                    });
               }
               if(aux==="Notificar un Problema"){
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),p2:"2",p3:$$("Contenido").getValue(),id:"24"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                webix.alert("Lo sentimos ha ocurrido un problema");
                            }else{
                                webix.alert("Comentario enviado.");
                                $$("CommentIni").hide();
                            }
                        }
                    });
               }
               if(aux==="Sugerencias"){
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),p2:"3",p3:$$("Contenido").getValue(),id:"24"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                webix.alert("Lo sentimos ha ocurrido un problema");
                            }else{
                                webix.alert("Comentario enviado.");
                                $$("CommentIni").hide();
                            }
                        }
                    });
               }
               if(aux==="Problemas con la frase actual"){
                    var idT=getCookie("phrase");
                    $.ajax({
                        type:'POST',
                        data: {p1:getCookie("username"),p2:"4",p3:$$("Contenido").getValue(),id_termino:idT,id:"25"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                webix.alert("Lo sentimos ha ocurrido un problema");
                            }else{
                                webix.alert("Comentario enviado.");
                                $$("CommentIni").hide();
                            }
                        }
                    });
               }
            }
            
        click:function Cancelar(){
            $$("CommentIni").hide();
        }
        
         
        var tabbar_admin = {
            id: "tabbar_admin",
            view: "toolbar",
            type: "iconTop",
            multiview: true,
            cols:[
                    { view:"button", id:"addnews",   icon:"", value: "Blog", click: changepage },
                    { view:"button", id:"reportOptions", icon:"", value: "Reporte", popup:"reportPopUpAdmin"},
                    { view:"button", id:"comment2",icon:"", value: "Comentarios", click: changepage },
                    { view:"button", id:"data",   icon:"", value: "Data", popup:"popData"}
            ],
            css:"fondo"
        };

        var tabbar_user = {
            id: "tabbar_user",
            view: "toolbar",
            type: "iconTop",
            multiview: true,
            cols:[
                { view:"button", id:"home",  icon:"", value: "Home", click: changepage, css:"fondo"},
                { view:"button", id:"reportOptions", icon:"", value: "Reporte", popup:"reportPopUpUser", css:"fondo"},
                { view:"button", id:"comment",icon:"", value: "Comentario", click: newcomment, css:"fondo" },
                { view:"button", id:"noticias",  icon:"", value: "Blog", click: changepage, css:"fondo" }
            ],
            css:"fondo"
        };

        var tabbar_start = {
            id: "tabbar_start",
            view: "toolbar",
            type: "iconTop",
            multiview: true,
            cols:[
                { view:"button", id:"home",  icon:"", value: "Home", click: changepage, css:"fondo"},
                { view:"button", id:"reportOptions", icon:"", value: "Reporte", click: ConsultaV, css:"fondo"},
                { view:"button", id:"register",icon:"", value: "¡Regístrate Ahora!", click: Regis, css:"fondo"},
                { view:"button", id:"noticias",  icon:"", value: "Blog", click: changepage, css:"fondo" }
            ],
            css:"fondo"
        };

        function iniSesion(){
            var username = $$("myForm").getValues().username;
            var password = $$("myForm").getValues().password;
            if(!username||!password){ return;}
            $.ajax({
                type:'POST',
                data: {username:username, password:password, id:"1"},
                url: 'Servlet',
                success: function(result){
                    if(!result || 0 === result.length){
                        errorIniSesion(username);   //Hubo un problema
                    }else{
                        var obj = JSON.parse(result);
                        $$("Ini").hide();
                        setCookie("username",obj[0].email,30);
                        setCookie("name",obj[0].nombre,30);
                        type();
                        document.location.reload();
                    }
                }
            });
        }

        function errorIniSesion(username){
            $.ajax({
                type:'POST',
                data: {username:username, id:"2"},
                url: 'Servlet',
                success: function(result){
                    if(!result || 0 === result.length){
                        webix.message("Usuario No Registrado"); //Usuario no existente
                    }else{
                        webix.message("Datos Incorrectos");     //Contraseña incorrecta
                    }
                }
            });
        }

        var usertype=tabbar_start;

        type();
        webix.ui({
            id:"Game",
            rows:[
                { id:"head", type:"clean", cols:[ menu,{css:"fondo"},{id:"logo",view:"button", type:"imageTop", image:"img/LangCluster.png", width:278, borderless:true, click:changepage,css:"fondo"},{css:"fondo"},Dere ], css: "blue"},
                { id:"frame-body", view:"iframe", src:"home.jsp"}, 
                { id:"columns" , cols: [usertype], css: "fondo"},
                { id:"footer", template:HTML, height:20, type:"clean",paddingY:-5}
            ]
        });

        var typereturned;
        function type(){
            var username = getCookie("username");
            if(!username || 0 === username.length){typereturned=tabbar_start;}
            else{
                $.ajax({
                    type:'POST',
                    data: {username: username, id:"3"},
                    url: 'Servlet',
                    success: function(result){
                                if(!result || 0 === result.length){
                                    typereturned=tabbar_user;
                                }else{
                                     var obj = JSON.parse(result);
                                    if(obj[0].id_permiso===0){
                                        typereturned=tabbar_admin;
                                    }
                                    else {
                                        typereturned=tabbar_user;
                                    }
                                }
                            },
                    complete: function(){
                        usertype=typereturned;
                        $$("Game").removeView("columns");
                        var pos = $$("Game").index($$("frame-body"))+1;
                        $$("Game").addView({id:"columns", cols:[usertype], css:"fondo"}, pos);
                    }
                });
            }
        }

        function changepage(id){
            try{$$("Regi").hide();}catch(error){}
            try{$$("Ini").hide();}catch(error){}
            try{$$("ventanaConsulta").hide();}catch(error){}
            try{$$("ventanaConsultaUser").hide();}catch(error){}
            var link;
            switch(id){
                case "report": link="home.jsp";  break;
                //case "comment":link="comentario.jsp";  break;
                case "comment2":link="comments.jsp";
                    if(getCookie("config").length!==0){ 
                      eraseCookie("config",getCookie("config"));
                   }
                   break;
                case "stat":   link="statistics.jsp";  break;
                case "data":   link="data.jsp";  break;
                case "home":   case "logo":  link="home.jsp";  break;
                case "noticias":   link="news.jsp";  break;
                case "usr":   link="deluser.jsp";  
                   if(getCookie("config").length!==0){ 
                      eraseCookie("config",getCookie("config"));
                   }
                   break;
                case "config": link="config.jsp"; 
                   $$("barra").hide(); 
                   if(getCookie("config").length!==0){ 
                      eraseCookie("config",getCookie("config"));
                   } 
                   break;
                case "addnews":  link="addNews.jsp";  break;
                case "help": link="help.jsp"; break;
                case "statUser": link="statisticsUser.jsp"; break;
            }
            $$("frame-body").load(link);
        }
        
        function gohome(){
            try{$$("Regi").hide();}catch(error){}
            try{$$("Ini").hide();}catch(error){}
            try{$$("ventanaConsulta").hide();}catch(error){}
            try{$$("ventanaConsultaUser").hide();}catch(error){}
            $$("frame-body").load("home.jsp");
        }
        
        function norms(){
            try{$$("Regi").hide();}catch(error){}
            try{$$("Ini").hide();}catch(error){}
            try{$$("ventanaConsulta").hide();}catch(error){}
            try{$$("ventanaConsultaUser").hide();}catch(error){}
            $$("frame-body").load("politics.jsp");
        }
        
        function contact(forgot){
            try{$$("Regi").hide();}catch(error){}
            try{$$("Ini").hide();}catch(error){}
            try{$$("ventanaConsulta").hide();}catch(error){}
            try{$$("ventanaConsultaUser").hide();}catch(error){}
            if(forgot){
                setCookie("fromIni","true",1);
            }
            $$("frame-body").load("contact.jsp");
        }
    </script>
    </form>
</body>
</html>
