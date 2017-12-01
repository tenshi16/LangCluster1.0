<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
    <!--    LangCluster - Contacto  -->
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
            body{
                background-image: url("img/data/contact.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .trans{
                background-color: rgba(100,100,100,0);
            }
            .hyper{
                background-color: rgba(255,255,255,0.7);
            }
            .hyper:hover{
                background-color: rgba(255,255,255,0.9);
            }
            a:link,a:visited,a:active {
                color: black;
                text-decoration: none;
            }
            a:hover {
                color: rgb(31,38,105);
                font-weight: bold;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <script>
        var conf,countries,user,langcluster;
        var from,message,reason,section,oldfrom,date,code,insti,nivelinsti,curso,dir,ciudad,pais,name,lastname,cargo;
        
        checkuser();
        function checkuser(){
            $.ajax({
                type:'POST',
                data: {id:"4"},
                async: false,
                url: 'Servlet',
                success: function(result){
                    countries=JSON.parse(result);
                }
            });
            $.ajax({
                type:'POST',
                data: {id:"Data1"},
                async: false,
                url: 'Servlet',
                success: function(result){
                    langcluster=JSON.parse(result);
                }
            });
            var cookie = getCookie("username");
            if (cookie == "" || cookie == null){
                user="";
            }
            else{
                user=cookie;
            }
        }
        
        var img="<center><img src='img/LangCluster.png' /></center>";
        
        var form0=[
               {gravity:0.5},
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(1);'>No puedo acceder a mi cuenta</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(2);'>Problemas con Reportes/Estadísticas</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(3);'>Notificar un abuso o problema</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(4);'>Uso Profesional (Docente) de LangCluster</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(5);'>Contacto Profesional</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(6);'>Otros (Contacto en General)</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
        
        var form1=[
               {gravity:0.5},
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(0);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(7);'>He olvidado mis datos</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(8);'>He perdido o cambiado mi correo electrónico</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
        
        var form2=[
               {gravity:0.5},
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(0);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(9);'>He perdido el código de un reporte</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(10);'>Hay un error en mi reporte/estadísticas</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form3=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(0);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"abuso",
                                            elements:[
                                                { id:"email3", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                {id:"combobox3",view:"richselect",label:"<strong>Situación:</strong>",value:1, options:[
                                                        {id:1, value:"Problema durante el juego"},
                                                        {id:2, value:"Problema en el Blog (Sección de noticias)"},
                                                        {id:3, value:"Problema con el contenido del juego"},
                                                        {id:4, value:"Problema con el contenido de un reporte"},
                                                        {id:5, value:"Problema durante el acceso a mi cuenta o datos"},
                                                        {id:6, value:"Mi estatus o permisos en el juego no son correctos"},
                                                        {id:7, value:"Otro (Especifique en el mensaje)"}
                                                    ]},
                                                { view:"label", label:"<strong>Tema:</strong> Notificar un abuso o problema"},
                                                { id:"msg3", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Si desea notificar de un problema durante el desarrollo de su juego o con el contenido del mismo, considere utilizar la sección de Comentarios. En caso contrario, escriba su mensaje aquí con tantos detalles como recuerde de la situación", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b3", view:"button", value:"Enviar", type:"form", click:function(){
                                                            if(!$$("email3").validate()){
                                                                webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                return;
                                                            }
                                                            if($$("email3").getValue().length === 0 || $$("msg3").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                $$("b3").disable();
                                                                section=$$("combobox3").getText();
                                                                from=$$("email3").getValue();
                                                                message=$$("msg3").getValue();
                                                                reason="ABUSO";
                                                                send();
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form4=[
               {gravity:0.5},
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(0);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(11);'>Saber Más</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(12);'>Notificar usuario docente</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form5=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(0);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"sectform",
                                            elements:[
                                                { id:"email2", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                { id:"combobox",view:"richselect",label:"<strong>Sección:</strong>",value:1, options:[
                                                        {id:1, value:"Administración (Directiva)"},
                                                        {id:2, value:"Área Legal"},
                                                        {id:3, value:"Diseño Gráfico"},
                                                        {id:4, value:"Diseño de Contenido"},
                                                        {id:5, value:"Publicidad y Relaciones Públicas"},
                                                        {id:6, value:"Recursos Humanos"},
                                                        {id:7, value:"Otras"}
                                                    ]},
                                                { view:"label", label:"<strong>Tema:</strong> Contacto Profesional"},
                                                { id:"msg2", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Escriba su mensaje aquí", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b2", view:"button", value:"Enviar", type:"form", click:function(){
                                                            if(!$$("email2").validate()){
                                                                webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                return;
                                                            }
                                                            if($$("email2").getValue().length === 0 || $$("msg2").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                $$("b2").disable();
                                                                section=$$("combobox").getText();
                                                                from=$$("email2").getValue();
                                                                message=$$("msg2").getValue();
                                                                reason="PROFESIONAL";
                                                                send();
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form6=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(0);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"general",
                                            elements:[
                                                { id:"email", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                { view:"label", label:"<strong>Tema:</strong> General"},
                                                { id:"msg", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Escriba su mensaje aquí", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b1", view:"button", value:"Enviar", type:"form", click:function(){
                                                            if(!$$("email").validate()){
                                                                webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                return;
                                                            }
                                                            if($$("email").getValue().length === 0 || $$("msg").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                $$("b1").disable();
                                                                from=$$("email").getValue();
                                                                message=$$("msg").getValue();
                                                                reason="GENERAL";
                                                                send();
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
        
        var form7=[
               {gravity:0.5},
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(1);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(13);'>He olvidado mi nombre de usuario</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(14);'>He olvidado mi contraseña</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {template:"<i class='fa fa-chevron-right' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(15);'>He olvidado todos mis datos/Necesito más ayuda</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form8=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(1);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"emailchange",
                                            elements:[
                                                { id:"email8a", view:"text", label:"<strong>Email Anterior:</strong>", value:user, validate:webix.rules.isEmail,placeholder:"Deje en blanco de ser necesario",labelWidth:120},
                                                { id:"email8b", view:"text", label:"<strong>Email Nuevo:</strong>", required:true, value:user, validate:webix.rules.isEmail,labelWidth:120},
                                                { view:"label", label:"<strong>Tema:</strong> He perdido o cambiado mi correo electrónico"},
                                                { id:"msg8a", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Si no recuerda su correo electrónico anterior, suministre todos los detalles que recuerde de su cuenta (curso, nivel, avance, entre otros...)", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b8", view:"button", value:"Enviar", type:"form", click:function(){
                                                            var error=false;
                                                            if(!$$("email8b").validate()){
                                                                webix.message({type:"error",text:"El correo nuevo suministrado es incorrecto"});
                                                                error=true;
                                                            }
                                                            if($$("email8a").getValue().length !== 0){
                                                                if(!$$("email8a").validate()){
                                                                    webix.message({type:"error",text:"El correo antiguo suministrado es incorrecto"});
                                                                    error=true;
                                                                }
                                                            }
                                                            if(error){ return; }
                                                            if($$("email8b").getValue().length === 0 || $$("msg8a").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                if($$("email8a").getValue().length !== 0){
                                                                    $.ajax({
                                                                        type:'POST',
                                                                        data: {username:$$("email8a").getValue(), id:"2"},
                                                                        url: 'Servlet',
                                                                        success: function(result){
                                                                            if(!result || 0 === result.length){
                                                                                conf=webix.confirm({
                                                                                    title:"¡Atención!",
                                                                                    type:"alert-error",
                                                                                    ok:"Olvidé mi correo", 
                                                                                    cancel:"Corregir",
                                                                                    text:"El correo suministrado como anterior no se encuentra registrado.<br/><br/>Si olvidó su email, haga clic <strong><a href='javascript:void(0)' onclick='changelink(13);'>aquí</a></strong>.",
                                                                                    callback: function(answer){
                                                                                        if(answer == true){
                                                                                            changelink(13);
                                                                                        }
                                                                                    }
                                                                            });
                                                                            }
                                                                            else{   //Correo existe
                                                                                $$("b8").disable();
                                                                                oldfrom=$$("email8a").getValue();
                                                                                from=$$("email8b").getValue();
                                                                                message=$$("msg8a").getValue();
                                                                                reason="EMAIL CAMBIADO";
                                                                                send();
                                                                            }
                                                                        }
                                                                    });
                                                                }
                                                                else{
                                                                    $$("b8").disable();
                                                                    oldfrom=$$("email8a").getValue();
                                                                    from=$$("email8b").getValue();
                                                                    message=$$("msg8a").getValue();
                                                                    reason="EMAIL CAMBIADO";
                                                                    send();
                                                                }
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },
                                        {height:10},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form9=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(2);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"staterror",
                                            elements:[
                                                { id:"email9", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                {cols:[
                                                    { id:"combobox9",view:"richselect",label:"<strong>Sección:</strong>",value:1, options:[
                                                            {id:1, value:"Estadísticas"},
                                                            {id:2, value:"Reporte"}
                                                        ]},
                                                    { id:"date", view:"datepicker", date: new Date(), required:true, label: '<strong>Fecha del Error:</strong>', stringResult:true, format:"%d-%m-%Y",labelWidth:130}
                                                ]},
                                                { view:"label", label:"<strong>Tema:</strong> He perdido el código de un reporte"},
                                                { id:"msg9", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Describa el problema encontrado en esta sección", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b9", view:"button", value:"Enviar", type:"form", click:function(){
                                                            if(!$$("email9").validate()){
                                                                webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                return;
                                                            }
                                                            if($$("email9").getValue().length === 0 || $$("msg9").getValue().length === 0 || $$("date").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                $$("b9").disable();
                                                                from=$$("email9").getValue();
                                                                message=$$("msg9").getValue();
                                                                section=$$("combobox9").getText();
                                                                date=$$("date").getValue();
                                                                reason="REPORTE PERDIDO";
                                                                send();
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },
                                        {height:10},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form10=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(2);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"staterror2",
                                            elements:[
                                                { id:"email10", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                { id:"columns", cols:[
                                                    { id:"combobox10",view:"richselect",label:"<strong>Sección:</strong>",value:1, options:[
                                                            {id:1, value:"Estadísticas"},
                                                            {id:2, value:"Reporte"}
                                                        ]},
                                                    { id:"date10", view:"datepicker", date: new Date(), required:true, label: '<strong>Fecha del Error:</strong>', stringResult:true, format:"%d-%m-%Y",labelWidth:130},
                                                    { id:"cod10", view:"text", label:"<strong>Código:</strong>", required:true, hidden:true}
                                                ]},
                                                { view:"label", label:"<strong>Tema:</strong> Hay un error en mi reporte/estadísticas"},
                                                { id:"msg10", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Describa el problema encontrado en esta sección", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b10", view:"button", value:"Enviar", type:"form", click:function(){
                                                            if(!$$("email10").validate()){
                                                                webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                return;
                                                            }
                                                            if($$("email10").getValue().length === 0 || $$("msg10").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                $$("b10").disable();
                                                                from=$$("email10").getValue();
                                                                message=$$("msg10").getValue();
                                                                section=$$("combobox10").getText();
                                                                if(section==="Estadísticas"){
                                                                    if($$("date10").getValue().length === 0){
                                                                        webix.message({type:"error",text:"Debe ingresar la fecha de la sesión errónea"});
                                                                        $$("b10").enable();
                                                                        return;
                                                                    }
                                                                    else{
                                                                        try{date=$$("date10").getValue();}catch(error){date="N/A";}
                                                                        code="N/A";
                                                                        reason="REPORTE ERRONEO";
                                                                        send();
                                                                    }
                                                                }
                                                                else{
                                                                    if($$("cod10").getValue().length === 0){
                                                                        webix.message({type:"error",text:"Debe ingresar el código del reporte erróneo"});
                                                                        $$("b10").enable();
                                                                        return;
                                                                    }
                                                                    else{
                                                                        try{code=$$("cod10").getValue();}catch(error){code="N/A";}
                                                                        date="N/A";
                                                                        $.ajax({
                                                                        type:'POST',
                                                                        data: {code:code, id:"18"},
                                                                        url: 'Servlet',
                                                                        success: function(result){
                                                                            if(!result || 0 === result.length){
                                                                                $$("b10").enable();
                                                                                conf=webix.confirm({
                                                                                    title:"¡Atención!",
                                                                                    type:"alert-error",
                                                                                    ok:"Olvidé el código", 
                                                                                    cancel:"Corregir",
                                                                                    text:"El código suministrado no está registrado en sistema.<br/><br/>Si olvidó el código de su reporte, haga clic <strong><a href='javascript:void(0)' onclick='changelink(16);'>aquí</a></strong>.",
                                                                                    callback: function(answer){
                                                                                        if(answer == true){
                                                                                            changelink(16);
                                                                                        }
                                                                                    }
                                                                                });
                                                                                }
                                                                            else{
                                                                                reason="REPORTE ERRONEO";
                                                                                send();
                                                                            }
                                                                            }
                                                                        });
                                                                    }
                                                                }
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },{height:10},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form12=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(04);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"scrollview", 
                                            id:"scrollview", 
                                            scroll:"y",
                                            height:$(window).height()/2+$(window).height()/6,
                                            body:{
                                                rows:[
                                                    {   view:"form", 
                                                        id:"prof",
                                                        elements:[
                                                            { id:"email12", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                            { view:"label", label:"<strong>Tema:</strong> Notificar usuario docente"},
                                                            { template:"<center><strong>Datos de la Institución</strong></center>",height:25,borderless:true},
                                                            { id:"insti", view:"text", label:"<strong>Nombre:</strong>", required:true },
                                                            { cols:[
                                                                { id:"combobox12a",view:"richselect",label:"<strong>Nivel:</strong>",value:1, required:true, options:[
                                                                    {id:1, value:"Educación Básica"},
                                                                    {id:2, value:"Educación Secundaria"},
                                                                    {id:3, value:"Universidad/Academia Superior"},
                                                                    {id:4, value:"Educación Superior (Otra)"},
                                                                    {id:5, value:"Instituto de Idiomas"},
                                                                    {id:6, value:"Independiente o Personal"},
                                                                    {id:7, value:"Otro"}
                                                                ]},
                                                                {id:"combobox12b",view:"richselect",label:"<strong>Curso:</strong>",value:1, required:true, options:[
                                                                    {id:1, value:"Educación General"},
                                                                    {id:2, value:"Cursos de Idiomas"},
                                                                    {id:3, value:"Filología"},
                                                                    {id:4, value:"Filosofía y Letras"},
                                                                    {id:5, value:"Interpretación"},
                                                                    {id:6, value:"Lenguas Modernas"},
                                                                    {id:7, value:"Lingüística"},
                                                                    {id:8, value:"Literatura"},
                                                                    {id:9, value:"Traducción"},
                                                                    {id:10, value:"Otro"}
                                                                ]}
                                                            ]},
                                                            { id:"dir", view:"textarea", label:"<strong>Dirección:</strong>", height:60, maxlength:200, required:true, labelPosition:"top"},
                                                            { cols:[{ id:"ciudad", view:"text", label:"<strong>Ciudad:</strong>", required:true},
                                                                    { id:"pais",view:"richselect",label:"<strong>País:</strong>",value:countries[0].id, required:true, options:countries}
                                                            ]},
                                                            { template:"<center><strong>Datos Personales</strong></center>",height:25,borderless:true},
                                                            { cols:[{ id:"name", view:"text", label:"<strong>Nombre(s):</strong>", required:true,labelWidth:92},
                                                                    { id:"lastname", view:"text", label:"<strong>Apellido(s):</strong>", required:true,labelWidth:95}                                                            
                                                            ]},
                                                            {id:"combobox12c",view:"richselect",label:"<strong>Idioma (Curso) a Enseñar:</strong>",value:langcluster[0].id, required:true,labelWidth:185, options:langcluster},
                                                            { id:"cargo", view:"text", label:"<strong>Cargo:</strong>", required:true},
                                                            { id:"msg12", view:"textarea", label:"<strong>Detalles:</strong>", height:200, placeholder: "Tome en cuenta que debe estar registrado en el sistema antes de poder notificar que es un docente. Escriba cualquier detalle extra que desee suministrar aquí.", maxlength:1000, labelPosition:"top"},
                                                            { margin:5, cols:[
                                                                { id:"b12", view:"button", value:"Enviar", type:"form", click:function(){
                                                                        if(!$$("email12").validate()){
                                                                            webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                            return;
                                                                        }
                                                                        if($$("email12").getValue().length === 0 || $$("insti").getValue().length === 0
                                                                            || $$("dir").getValue().length === 0 || $$("ciudad").getValue().length === 0 
                                                                            || $$("name").getValue().length === 0 || $$("lastname").getValue().length === 0 ){
                                                                            webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                                        }
                                                                        else{
                                                                            $$("b12").disable();
                                                                            $.ajax({
                                                                                type:'POST',
                                                                                data: {username:$$("email12").getValue(), id:"2"},
                                                                                url: 'Servlet',
                                                                                success: function(result){
                                                                                    if(!result || 0 === result.length){
                                                                                        $$("b12").enable();
                                                                                        conf=webix.confirm({
                                                                                            title:"¡Atención!",
                                                                                            type:"alert-error",
                                                                                            ok:"Aceptar", 
                                                                                            cancel:"Corregir",
                                                                                            text:"El correo suministrado no se encuentra registrado en el sistema. Debe tener una cuenta en LangCluster antes de notificar que es un docente.",
                                                                                            callback: function(){}
                                                                                        });
                                                                                    }
                                                                                    else{
                                                                                        var typereturned;
                                                                                        $.ajax({
                                                                                            type:'POST',
                                                                                            data: {username: $$("email12").getValue(), id:"3"},
                                                                                            url: 'Servlet',
                                                                                            success: function(result){
                                                                                                        if(!result || 0 === result.length){
                                                                                                            typereturned="1";
                                                                                                        }else{
                                                                                                            var obj = JSON.parse(result);
                                                                                                            if(obj[0].id_permiso!=0 && obj[0].id_permiso!=1){
                                                                                                                typereturned="2";
                                                                                                            }
                                                                                                            else {
                                                                                                                typereturned="1";
                                                                                                            }
                                                                                                        }
                                                                                                    },
                                                                                            complete: function(){
                                                                                                    if(typereturned!= "2"){
                                                                                                        from=$$("email12").getValue();          insti=$$("insti").getValue();
                                                                                                        nivelinsti=$$("combobox12a").getText(); curso=$$("combobox12b").getText();
                                                                                                        dir=$$("dir").getValue();               ciudad=$$("ciudad").getValue();
                                                                                                        pais=$$("pais").getText();              name=$$("name").getValue();
                                                                                                        lastname=$$("lastname").getValue();     cargo=$$("cargo").getValue();
                                                                                                        LGcurso=$$("combobox12c").getText();    message=$$("msg12").getValue();
                                                                                                        reason="DOCENTE";
                                                                                                        send();
                                                                                                    }
                                                                                                    else{
                                                                                                        conf=webix.confirm({
                                                                                                            title:"¡Atención!",
                                                                                                            width:400,
                                                                                                            type:"alert-warning",
                                                                                                            ok:"Aceptar",
                                                                                                            cancel:"Notificar de un error",
                                                                                                            text:"Estimado usuario, su email ya está registrado como docente en LangCluster. Es posible que ya haya realizado este proceso anteriormente."
                                                                                                                +"<br/><br/>Si cree que se trata de un error, haga clic <strong><a href='javascript:void(0)' onclick='changelink(17);'>aquí</a></strong> para notificárnoslo.",
                                                                                                            callback: function(answer){
                                                                                                                if(answer == true){
                                                                                                                    history.back();
                                                                                                                }
                                                                                                                else{
                                                                                                                    changelink(17);
                                                                                                                }
                                                                                                            }
                                                                                                        });
                                                                                                    }
                                                                                                }
                                                                                            });
                                                                                    }
                                                                                }
                                                                            });
                                                                        }
                                                                }},
                                                                { view:"button", value:"Cancelar", click:function(){
                                                                        webix.confirm({
                                                                            title:"¡Atención!",
                                                                            type:"alert-warning",
                                                                            ok:"Sí", 
                                                                            cancel:"No",
                                                                            text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                            callback: function(answer){
                                                                                if(answer == true){
                                                                                    history.back();
                                                                                }
                                                                            }
                                                                        });
                                                                } }
                                                            ]}
                                                            ]
                                                    }
                                                ]
                                            }
                                        },
                                        {height:10},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form13=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(7);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"forgotuser",
                                            elements:[
                                                { id:"email13", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                { view:"label", label:"<strong>Tema:</strong> He olvidado mi nombre de usuario"},
                                                { id:"msg13", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Su usuario es el email con el que se ha registrado en LangCluster, si no está seguro del mismo, proporcione un correo alternativo en la sección superior y escriba todos los detalles que recuerde de su cuenta (curso, nivel, avance, entre otros...)", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b13", view:"button", value:"Enviar", type:"form", click:function(){
                                                            if(!$$("email13").validate()){
                                                                webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                return;
                                                            }
                                                            if($$("email13").getValue().length === 0 || $$("msg13").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                $$("b13").disable();
                                                                $.ajax({
                                                                    type:'POST',
                                                                    data: {username:$$("email13").getValue(), id:"2"},
                                                                    url: 'Servlet',
                                                                    success: function(result){
                                                                        if(!result || 0 === result.length){
                                                                            from=$$("email13").getValue();
                                                                            message=$$("msg13").getValue();
                                                                            reason="USUARIO OLVIDADO";
                                                                            send();
                                                                        }
                                                                        else{   //Correo existe
                                                                            $$("b13").enable();
                                                                            conf=webix.modalbox({
                                                                                    title:"¡Atención!",
                                                                                    type:"alert-warning",
                                                                                    width:500,
                                                                                    buttons:["Olvidé mi contraseña", "Enviar igualmente", "Cancelar"],
                                                                                    text:"El correo suministrado está registrado en LangCluster.<br/><br/>Si olvidó su contraseña, haga clic <strong><a href='javascript:void(0)' onclick='changelink(14);'>aquí</a></strong>.",
                                                                                    callback: function(result){
                                                                                        console.log(result);
                                                                                        switch(result){
                                                                                            case "0": $$("email14").setValue($$("email13").getValue());changelink(14); break;
                                                                                            case "1":
                                                                                                $$("b13").disable();
                                                                                                from=$$("email13").getValue();
                                                                                                message=$$("msg13").getValue();
                                                                                                reason="USUARIO OLVIDADO";
                                                                                                send();
                                                                                                break;
                                                                                        }
                                                                                    }
                                                                                });
                                                                        }
                                                                    }
                                                                });
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form14=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(7);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"forgotpass",
                                            elements:[
                                                { id:"email14", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                { view:"label", label:"<strong>Tema:</strong> He olvidado mi contraseña"},
                                                { id:"msg14", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Escriba su mensaje aquí", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b14", view:"button", value:"Enviar", type:"form", click:function(){
                                                            if(!$$("email14").validate()){
                                                                webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                return;
                                                            }
                                                            if($$("email14").getValue().length === 0 || $$("msg14").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                $.ajax({
                                                                    type:'POST',
                                                                    data: {username:$$("email14").getValue(), id:"2"},
                                                                    url: 'Servlet',
                                                                    success: function(result){
                                                                        if(!result || 0 === result.length){
                                                                            $$("b14").enable();
                                                                            conf=webix.confirm({
                                                                                title:"¡Atención!",
                                                                                type:"alert-error",
                                                                                ok:"Olvidé mi correo", 
                                                                                cancel:"Corregir",
                                                                                text:"El correo suministrado no se encuentra registrado.<br/><br/>Si olvidó su email, haga clic <strong><a href='javascript:void(0)' onclick='changelink(13);'>aquí</a></strong>.",
                                                                                callback: function(answer){
                                                                                    if(answer == true){
                                                                                        changelink(13);
                                                                                    }
                                                                                }
                                                                            });
                                                                        }
                                                                        else{   //Correo existe
                                                                            $$("b14").disable();
                                                                            from=$$("email14").getValue();
                                                                            message=$$("msg14").getValue();
                                                                            reason="CONTRASEÑA OLVIDADA";
                                                                            send();
                                                                        }
                                                                    }
                                                                });
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
           
        var form15=[
               {    cols:[  {gravity:1},
                            {   rows:[  {template:img,autoheight:true,css:"trans",borderless:true},
                                        {height:40},
                                        {template:"<i class='fa fa-chevron-left' aria-hidden='true'></i>&nbsp;<a href='javascript:void(0)' onclick='changelink(7);'>Regresar</a>",autoheight:true,borderless:true,css:"hyper"},
                                        {height:10},
                                        {   view:"form", 
                                            id:"errordatos",
                                            elements:[
                                                { id:"email15", view:"text", label:"<strong>Email:</strong>", required:true, value:user, validate:webix.rules.isEmail},
                                                { view:"label", label:"<strong>Tema:</strong> He olvidado todos mis datos/Necesito más ayuda"},
                                                { id:"msg15", view:"textarea", label:"<strong>Mensaje:</strong>", height:200, placeholder: "Considere que si su cuenta fue creada con un correo falso o incorrecto será imposiible recuperar sus datos y deberá registrarse nuevamente. En cualquier caso escriba su mensaje aquí con todos los detalles que recuerde de su cuenta (curso, nivel, avance, entre otros...)", maxlength:1000, required:true, labelPosition:"top"},
                                                { margin:5, cols:[
                                                    { id:"b1", view:"button", value:"Enviar", type:"form", click:function(){
                                                            if(!$$("email15").validate()){
                                                                webix.message({type:"error",text:"El correo suministrado es incorrecto"});
                                                                return;
                                                            }
                                                            if($$("email15").getValue().length === 0 || $$("msg15").getValue().length === 0){
                                                                webix.message({type:"error",text:"Debe completar los campos obligatorios para continuar"});
                                                            }
                                                            else{
                                                                $$("b15").disable();
                                                                from=$$("email15").getValue();
                                                                message=$$("msg15").getValue();
                                                                reason="DATOS OLVIDADOS";
                                                                send();
                                                            }
                                                    }},
                                                    { view:"button", value:"Cancelar", click:function(){
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"alert-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                                                callback: function(answer){
                                                                    if(answer == true){
                                                                        history.back();
                                                                    }
                                                                }
                                                            });
                                                    } }
                                                ]}
                                                ]
                                        },
                                        {height:10},
                                        {gravity:1}
                                    ]
                            },
                            {width:40}
                        ]
               },
               {gravity:1}
           ];
        
        function changelink(id){
            try{webix.modalbox.hide(conf);}catch(error){}
            if(id===11){
                setCookie("fromcontact","prof",1);
                window.open('help.jsp', '_self');
            }
            else{
                if(id===16){
                    $$("combobox9").setValue(2);
                    $$("tab").setValue("form9");
                }else{
                    if(id===17){
                        $$("combobox3").setValue(6);
                        $$("tab").setValue("form3");
                    }
                    else{
                        $$("tab").setValue("form"+id);
                    }
                }
            }
        }
        
        function send(){
            if(from || 0 !== from.length || message || 0 !== message.length || reason || 0 !== reason.length){
                var data={};
                switch(reason.trim().toUpperCase()){
                    case "PROFESIONAL": case "ABUSO": data={from:from,message:message,reason:reason,section:section}; break;
                    case "EMAIL CAMBIADO": data={from:from,message:message,reason:reason,oldfrom:oldfrom}; break;
                    case "REPORTE PERDIDO": data={from:from,message:message,reason:reason,section:section,date:date}; break;
                    case "REPORTE ERRONEO": data={from:from,message:message,reason:reason,section:section,date:date,code:code}; break;
                    case "DOCENTE": data={from:from,message:message,reason:reason,insti:insti,nivelinsti:nivelinsti,curso:curso,dir:dir,ciudad:ciudad,pais:pais,name:name,lastname:lastname,cargo:cargo};
                                    break;
                    default:data={from:from,message:message,reason:reason};
                }
                $.ajax({
                    type:'POST',
                    data:data,
                    url: 'Mail',
                    success: function(result){
                        if(result==="SENT"){
                            webix.confirm({
                                title:"Mensaje Enviado",
                                ok:"Aceptar", 
                                cancel:"Cancelar",
                                text:"Su mensaje ha sido enviado exitosamente",
                                callback: function(){
                                    window.open('home.jsp', '_self');
                                }
                            });
                        }else{
                            webix.confirm({
                                title:"¡Atención!",
                                type:"alert-error",
                                ok:"Aceptar", 
                                cancel:"Cancelar",
                                text:"Ha ocurrido un error al enviar su mensaje, verifique sus datos, conexión a internet e inténtelo nuevamente.",
                                callback: function(answer){
                                    try{$$("b1").enable();}catch(error){};
                                    try{$$("b2").enable();}catch(error){};
                                    try{$$("b3").enable();}catch(error){};
                                    try{$$("b8").enable();}catch(error){};
                                    try{$$("b9").enable();}catch(error){};
                                    try{$$("b10").enable();}catch(error){};
                                    try{$$("b12").enable();}catch(error){};
                                    try{$$("b13").enable();}catch(error){};
                                    try{$$("b14").enable();}catch(error){};
                                    try{$$("b15").enable();}catch(error){};
                                    if(answer != true){
                                        webix.confirm({
                                            title:"¡Atención!",
                                            type:"alert-warning",
                                            ok:"Sí", 
                                            cancel:"No",
                                            text:"¿Está seguro/a de que desea cancelar el envío de su mensaje?",
                                            callback: function(answer){
                                                if(answer == true){
                                                    history.back();
                                                }
                                            }
                                        });
                                    }
                                }
                            });
                        }
                    }
                });
            }
        }
        
        access();
        
        function access(){
            webix.i18n.dateFormat="%d/%m/%Y";
            webix.i18n.setLocale();
            webix.ui({
                id:"page",
                cols:[{width:20},
                      { rows:[{height:20},
                              {view:"tabbar", id:"tab", multiview:true, options: [
                                        { value: "Principal", id: 'form0' },
                                        { value: "Pregunta1", id: 'form1' },
                                        { value: "Pregunta2", id: 'form2' },
                                        { value: "Pregunta3", id: 'form3' },
                                        { value: "Pregunta4", id: 'form4' },
                                        { value: "Pregunta5", id: 'form5' },
                                        { value: "Pregunta6", id: 'form6' },
                                        { value: "Pregunta1.1", id: 'form7' },
                                        { value: "Pregunta1.2", id: 'form8' },
                                        { value: "Pregunta2.1", id: 'form9' },
                                        { value: "Pregunta2.2", id: 'form10' },
                                        { value: "Pregunta4.2", id: 'form12' },
                                        { value: "Pregunta1.1.1", id: 'form13' },
                                        { value: "Pregunta1.1.2", id: 'form14' },
                                        { value: "Pregunta1.1.3", id: 'form15' }
                                    ],height:50,hidden:true
                               },
                               {cells:[{id:"form0",rows: form0},
                                       {id:"form1",rows: form1},
                                       {id:"form2",rows: form2},
                                       {id:"form3",rows: form3},
                                       {id:"form4",rows: form4},
                                       {id:"form5",rows: form5},
                                       {id:"form6",rows: form6},
                                       {id:"form7",rows: form7},
                                       {id:"form8",rows: form8},
                                       {id:"form9",rows: form9},
                                       {id:"form10",rows: form10},
                                       {id:"form12",rows: form12},
                                       {id:"form13",rows: form13},
                                       {id:"form14",rows: form14},
                                       {id:"form15",rows: form15}
                                      ]
                               },
                               {height:20}
                        ]
                      },
                      {width:20}
                ]
            });
            var cookie = getCookie("fromIni");
            if (cookie != "" && cookie != null){
                eraseCookie("fromIni","null");
                $$("tab").setValue("form7");
            }
            cookie = getCookie("proffromHelp");
            if (cookie != "" && cookie != null){
                eraseCookie("proffromHelp","null");
                $$("tab").setValue("form12");
            }
            $$("combobox10").attachEvent("onChange", function(newv, oldv){
                switch(newv){
                    case 1: //Estadísticas
                        $$("date10").show();
                        $$("cod10").hide();
                    break;
                    case 2: //Reporte
                        $$("date10").hide();
                        $$("cod10").show();
                    break;
                }
            });
        }
    </script>
    </body>
</html>
