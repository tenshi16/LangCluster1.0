<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
    <!--    LangCluster - Data    -->
        <meta charset="utf-8"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
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
        
        <body>         
        <script>            
            var LangOptions; getLanguages();
            var typereturned;
            function getLanguages(){
                $.ajax({
                        type:'POST',
                        data: {id:"Data1"},
                        url: 'Servlet',
                        success: function(result){
                            try{LangOptions=JSON.parse(result);
                                }catch(e){LangOptions="0";}
                            getTotal();
                            chargeTopics();
                            access();
                        }
                });
            }
            
            var totalfiles;
            function getTotal(){
                var first;
                first=(totalfiles==0);
                $.ajax({
                    type:'POST',
                    data: {id:"Data0"},
                    url: 'Servlet',
                    success: function(result){
                        if(!result || 0 === result.length){
                            totalfiles=0;
                        }
                        else{
                            try{var obj = JSON.parse(result);
                                totalfiles=obj[0].total;
                            }catch(e){totalfiles="0";}
                        }
                    },
                    complete: function(){
                        if(first){
                            document.location.reload();
                        }
                    }
                });
            }
            
            var eliminatedata; var tooverwritedata;
            function chargeTopics(){
                $.ajax({
                    type:'POST',
                    data: {id:"Data2"},
                    url: 'Servlet',
                    success: function(result){
                        try{    eliminatedata=JSON.parse(result);
                                tooverwritedata=JSON.parse(result);
                        }catch(e){
                            eliminatedata="";
                            tooverwritedata="";
                        }
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
                                        rows:[
                                            { id:"bar", cols:[ {template: "<strong>Archivos de Data en Sistema</strong>: "+totalfiles, height:40, borderless:true},
                                                               {borderless:true},
                                                               {view:"button", value:"Importar Data", type:"form", click: importdata },
                                                               {width:20},
                                                               {view:"button", value:"Consultar Data", click: function(){
                                                                    window.open("dataconsult.jsp", "_self");
                                                               }}
                                                             ]},
                                            { rows:[{template: "<center><font size=\"4\"><strong>Cursos Disponibles</strong></font></center>"+
                                                               "<hr width=\"90%\" size=\"2\" noshade>", autoheight:true, borderless:true},
                                                    {height:20},
                                                    {   container:"scrollview",
                                                        view:"scrollview", 
                                                        scroll:"xy", borderless:true,
                                                        body:{
                                                            cols:[{},
                                                                 {id:"data1", rows:[{view:"button", type:"image", image:"img/data/FR.png", height:200, width:200, css:"image", borderless: true},
                                                                       {template:"<center><strong>Français</strong><br/>- Francés -</center>", autoheight: true, borderless:true},
                                                                       {},
                                                                       {id:"FR1", view:"button", value:"Generar Data", type:"form", click:function(){setCookie("clickedlang","FR",1); setCookie("clickedlangfull","Francés",1); generatedata();}},
                                                                       {id:"FR", view:"button", value:"Sobrescribir Data", click:function(){setCookie("clickedlang","FR",1); setCookie("clickedlangfull","Francés",1); overwritedata();}},
                                                                       {id:"FR2",view:"button", value:"Eliminar Data", click:function(){setCookie("clickedlang","FR",1); setCookie("clickedlangfull","Francés",1); deletedata();}},
                                                                       {}
                                                                     ]},
                                                                 {},
                                                                 {id:"data2", rows:[{view:"button", type:"image", image:"img/data/UK.png", height:200, width:200, css:"image", borderless: true},
                                                                       {template:"<center><strong>English</strong><br/>- Inglés -</center>", autoheight: true, borderless:true},
                                                                       {},
                                                                       {id:"EN1", view:"button", value:"Generar Data", type:"form", click:function(){setCookie("clickedlang","EN",1); setCookie("clickedlangfull","Inglés",1); generatedata();}},
                                                                       {id:"EN", view:"button", value:"Sobrescribir Data",  click:function(){setCookie("clickedlang","EN",1); setCookie("clickedlangfull","Inglés",1); overwritedata();}},
                                                                       {id:"EN2", view:"button", value:"Eliminar Data", click:function(){setCookie("clickedlang","EN",1); setCookie("clickedlangfull","Inglés",1); deletedata();}},
                                                                       {}
                                                                     ]},
                                                                 {},
                                                                 {id:"data3", rows:[{view:"button", type:"image", image:"img/data/JA.png", height:200, width:200, css:"image", borderless: true},
                                                                       {template:"<center><strong>日本語</strong><br/>- Japonés -</center>", autoheight: true, borderless:true},
                                                                       {},
                                                                       {id:"JA1", view:"button", value:"Generar Data", type:"form", click:function(){setCookie("clickedlang","JA",1); setCookie("clickedlangfull","Japonés",1); generatedata();}},
                                                                       {id:"JA", view:"button", value:"Sobrescribir Data",  click:function(){setCookie("clickedlang","JA",1); setCookie("clickedlangfull","Japonés",1); overwritedata();}},
                                                                       {id:"JA2", view:"button", value:"Eliminar Data", click:function(){setCookie("clickedlang","JA",1); setCookie("clickedlangfull","Japonés",1); deletedata();}},
                                                                       {}
                                                                     ]},
                                                                 {}
                                                                ]
                                                            }
                                                    }
                                            ]}
                                        ]
                                    });
                                }
                        }
                    });
                }
            }
            
            function importdata(){
                webix.ui({
                    id:"windowImportData",
                    view:"window",
                    width:500,
                    head:"<strong>Importar Data</strong>",
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
                              {cols:[{view:"button", value:"Aceptar", type:"form", click:uploadfile},
                                     {view:"button", value:"Cancelar", click:function(){$$("windowImportData").hide();}}]
                        }]
                    }
                }).show();
                try{if($$("windowOverwriteData").isVisible()){$$("windowOverwriteData").hide();}}catch(error){};
                try{if($$("windowDeleteData").isVisible()){$$("windowDeleteData").hide();}}catch(error){};
                try{if($$("AutoGeneratedData").isVisible()){$$("AutoGeneratedData").hide();}}catch(error){};
            }
            
            function overwritedata(){
                webix.ui({
                    id:"windowOverwriteData",
                    view:"window",
                    width:600,
                    head:"<strong>Sobrescribir Data</strong>",
                    position:"center",
                    body:{
                        view:"form", id:"uploadform",
                        rows:[{id:"comboboxOV",view:"richselect",label:"Archivo (Idioma):",value:getCookie("clickedlangfull"),yCount:"3", options:LangOptions,labelWidth:120},
                              {cols:[{view:"label",label:"Nuevo Archivo:",align:"left",width:121},
                                     {id:"doclist1", view:"list",width:350, type:"uploader", scroll:false},
                                     {
                                        view:"uploader", upload:"${pageContext.request.contextPath}/UploadFile",
                                        id:"upl2", name:"files",
                                        value:"Seleccionar", multiple: false,
                                        link:"doclist1", autosend:false   
                                    }
                                    ]},
                              {id:"codeOV", view:"text", type:'password', value:"", label:"Código de Confirmación:", inputAlign:"left", labelAlign:"left", labelWidth:170},
                              {template: "<hr width=\"90%\" size=\"2\" noshade>", autoheight:true, borderless:true},
                              {view:"label",label:"Áreas a Sobrescribir:",inputWidth:100,align:"left"},
                              {id:"overwritetree",height:150,
                                container:"box",
                                view:"tree",
                                template:"{common.icon()} {common.checkbox()} #value#",
                                threeState: true,
                                data: [{id:"root",value:"Archivo Completo", open:true,data:[
                                            {id:"1", value:"Datos del Idioma"},
                                            {id:"2", value:"Tópicos (Incluye términos)", open:true, data:tooverwritedata},
                                            {id:"3", value:"Términos"},
                                            {id:"4", value:"Niveles"},
                                            {id:"5", value:"Archivos Multimedia Asociados"}
                                       ]//data de root
                                }]//data del Body
                              },
                              {cols:[{view:"button", value:"Aceptar", type:"form", click:overwrite},
                                     {view:"button", value:"Cancelar", click:function(){$$("windowOverwriteData").hide();}}]}
                        ]
                    }
                }).show();
                $$("combobox").attachEvent("onChange", function(newv, oldv){
                    switch(newv){
                        case "Inglés": setCookie("clickedlang","EN",1); setCookie("clickedlangfull","Inglés",1); break;
                        case "Francés": setCookie("clickedlang","FR",1); setCookie("clickedlangfull","Francés",1); break;
                        case "Japonés": setCookie("clickedlang","JA",1); setCookie("clickedlangfull","Japonés",1); break;
                    }
                });
                webix.extend($$("windowOverwriteData"), webix.ProgressBar);
                try{if($$("windowImportData").isVisible()){$$("windowImportData").hide();}}catch(error){};
                try{if($$("windowDeleteData").isVisible()){$$("windowDeleteData").hide();}}catch(error){};
                try{if($$("AutoGeneratedData").isVisible()){$$("AutoGeneratedData").hide();}}catch(error){};
            }
            
            function deletedata(){
                webix.ui({
                    id:"windowDeleteData",
                    view:"window",
                    width:600,
                    head:"<strong>Eliminar Data</strong>",
                    position:"center",
                    body:{
                        view:"form", id:"uploadform",
                        rows:[{id:"combobox",view:"richselect",label:"Archivo (Idioma):",value:getCookie("clickedlangfull"),yCount:"3", options:LangOptions,labelWidth:120},
                              {id:"code", view:"text", type:'password', value:"", label:"Código de Confirmación:", inputAlign:"left", labelAlign:"left", labelWidth:170},
                              {template: "<hr width=\"90%\" size=\"2\" noshade>", autoheight:true, borderless:true},
                              {view:"label",label:"Áreas a Eliminar:",inputWidth:100,align:"left"},
                              {id:"deletetree",height:150,
                                container:"box",
                                view:"tree",
                                template:"{common.icon()} {common.checkbox()} #value#",
                                threeState: true,
                                data: [{id:"root",value:"Archivo Completo", open:true,data:[
                                            {id:"1", value:"Datos del Idioma"},
                                            {id:"2", value:"Tópicos (Incluye términos)", open:true, data:eliminatedata},
                                            {id:"3", value:"Términos"},
                                            {id:"4", value:"Niveles"},
                                            {id:"5", value:"Archivos Multimedia Asociados"}
                                       ]//data de root
                                }]//data del Body
                              },
                              {cols:[{view:"button", value:"Aceptar", type:"form", click:eliminate},
                                     {view:"button", value:"Cancelar", click:function(){$$("windowDeleteData").hide();}}]}
                        ]
                    }
                }).show();
                $$("combobox").attachEvent("onChange", function(newv, oldv){
                    switch(newv){
                        case "Inglés": setCookie("clickedlang","EN",1); setCookie("clickedlangfull","Inglés",1); break;
                        case "Francés": setCookie("clickedlang","FR",1); setCookie("clickedlangfull","Francés",1); break;
                        case "Japonés": setCookie("clickedlang","JA",1); setCookie("clickedlangfull","Japonés",1); break;
                    }
                });
                webix.extend($$("windowDeleteData"), webix.ProgressBar);
                try{if($$("windowImportData").isVisible()){$$("windowImportData").hide();}}catch(error){};
                try{if($$("windowOverwriteData").isVisible()){$$("windowOverwriteData").hide();}}catch(error){};
                try{if($$("AutoGeneratedData").isVisible()){$$("AutoGeneratedData").hide();}}catch(error){};
            }
            
            function uploadfile(){
                $$('upl1').files.data.each(function(obj){
                    var error=false;
                    if(obj.type.toString()!="LANGCLUSTER"){
                        webix.message({type:"error",text:"No se reconoce el formato del archivo"});
                        error=true;
                    }
                    
                    if(!error){
                        $$("upl1").send();
                        $.ajax({
                            type:'POST',
                            data: {file: obj.name, id:"1"},
                            url: 'UploadFile',
                            success: function(result){
                                if(result.startsWith("error")){
                                    errorUpload(obj.name,result.substring(5,result.length));
                                }
                                else{
                                    $$("upl1").attachEvent("onUploadComplete", function(response){
                                        webix.confirm({
                                            title:"Data Cargada",
                                            ok:"Aceptar",
                                            text:"La data ha sido cargada exitosamente",
                                            callback:function(){document.location.reload();}
                                        });
                                    });
                                }
                            }
                        });
                    }
                });
            }
            
            function errorUpload(file,message){
                message=message.substring(5,message.length).trim();
                switch(message){
                    case "Existent Data":
                        webix.confirm({
                            title:"¡Atención!",
                            type:"alert-warning",
                            ok:"Sí", 
                            cancel:"No",
                            text:"El archivo ya existe, ¿desea sobrescribir la data?",
                            callback:function(answer){
                                if(answer == true){
                                     $$("upl1").send();
                                     $.ajax({
                                        type:'POST',
                                        data: {file: file, id:"1",overwrite:"true"},
                                        url: 'UploadFile',
                                        success: function(result){
                                            if(result.startsWith("error")){
                                                errorUpload(file,result.substring(5,result.length));
                                            }
                                            else{
                                                $$("upl1").attachEvent("onUploadComplete", function(response){
                                                    webix.confirm({
                                                        title:"Data Cargada",
                                                        ok:"Aceptar",
                                                        text:"La data ha sido cargada exitosamente",
                                                        callback:function(){document.location.reload();}
                                                    });
                                                });
                                            }
                                        }
                                    });
                                }
                                else{
                                    try{ $$("windowOverwriteData").hideProgress();}catch(error){}
                                }
                             }
                            });
                    break;
                    case "FormatError": webix.confirm({
                                            title:"¡Ha ocurrido un error!",
                                            type:"alert-error",
                                            text:"Error: El archivo seleccionado posee una extensión o formato incorrecto.",
                                            callback:function(){
                                                document.location.reload();
                                            }
                                        });
                    break;
                    default: webix.confirm({
                                title:"¡Ha ocurrido un error!",
                                type:"alert-error",
                                text:"Error: Ha ocurrido un error al intentar guardar los datos. Por favor inténtelo nuevamente.<br/><br/>"
                                    +"Error: "+message,
                                callback:function(){
                                    document.location.reload();
                                }
                            });
                }
            }
            /*
            function encode_utf8(s) {
                for(var c, i = -1, l = (s = s.split("")).length, o = String.fromCharCode; ++i < l;
			s[i] = (c = s[i].charCodeAt(0)) >= 127 ? o(0xc0 | (c >>> 6)) + o(0x80 | (c & 0x3f)) : s[i]
		);
		return s.join("");
            }
            
            function decode_utf8(s) {
                return decodeURIComponent(escape(s));
            }*/
            
            function generatedata(){
                webix.confirm({
                            title:"¡Atención!",
                            type:"confirm-warning",
                            ok:"Sí", 
                            cancel:"No",
                            text:"Si decide generar un archivo de data, cualquier archivo anterior será eliminado.<br/>¿Desea continuar?",
                            callback:function(answer){
                                if(answer==true){
                                    var lang=getCookie("clickedlang");
                                    $.ajax({
                                        type:'POST',
                                        data: {lang:lang, id:"3"},
                                        url: 'UploadFile',
                                        success: function(result){
                                            if(result.startsWith("error")){
                                                webix.confirm({
                                                    title:"¡Ha ocurrido un error!",
                                                    type:"alert-error",
                                                    text:"Error: Ha ocurrido un error al intentar guardar los datos. Por favor inténtelo nuevamente.<br/><br/>"
                                                        +"Error: "+result.substring(5,result.length)
                                                });
                                            }
                                            else{
                                                try{if($$("windowImportData").isVisible()){$$("windowImportData").hide();}}catch(error){};
                                                try{if($$("windowOverwriteData").isVisible()){$$("windowOverwriteData").hide();}}catch(error){};
                                                try{if($$("windowDeleteData").isVisible()){$$("windowDeleteData").hide();}}catch(error){};
                                             /*   var chararray=result.split(''); var newString="";
                                                for(var i=0;i<chararray.length;i++){
                                                    newString+=encode_utf8(chararray[i]);
                                                }
                                                var aux=newString.split("_LangClusterFile_");*/
                                                console.log(result);
                                                var aux=result.split("_LangClusterFile_");
                                                webix.ui({
                                                    id:"AutoGeneratedData",
                                                    view:"window",
                                                    width:600,
                                                    head:"<strong>Archivo "+lang+".LANGCLUSTER</strong>",
                                                    position:"center",
                                                    body:{ rows:[
                                                            {cols:[ {width:20},
                                                                    {view:"label",label:"     <strong>Ruta del Archivo:</strong>",inputWidth:100,align:"left"},
                                                                    {template: aux[0], autoheight:true, borderless:true}
                                                                  ]},
                                                            {template: "<hr width=\"90%\" size=\"2\" noshade>", autoheight:true, borderless:true},
                                                            { id:"filecontents", view:"textarea", label:"<strong>Contenido:</strong>", labelPosition:"top", height:400,
                                                              value: aux[1]
                                                            },
                                                            {view:"button", value:"Aceptar", type:"form",click:function(){$$("AutoGeneratedData").hide();}}
                                                        ]
                                                    }
                                                }).show();
                                            }
                                        }
                                    });
                                }
                            }
                        });
            }
            
            function overwrite(){
                var code=$$("codeOV").getValue();
                if(!code || 0 === code.length){
                    webix.message("Necesita ingresar su código de confirmación para continuar.");
                    return;
                }
                else{
                    var error;
                    $.ajax({
                        type:'POST',
                        data: {username:getCookie("username"), password:code, id:"1"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                error=true;
                            }else{
                                $.ajax({
                                    type:'POST',
                                    data: {username: getCookie("username"), id:"3"},
                                    url: 'Servlet',
                                    success: function(result){
                                                if(!result || 0 === result.length){
                                                    error=true;
                                                }else{
                                                    var obj = JSON.parse(result);
                                                    if(obj[0].id_permiso==0){
                                                        error=false;
                                                    }
                                                    else {
                                                        error=true;
                                                    }
                                                }
                                            },
                                    complete:function(){
                                        if(error){
                                            webix.message({type:"error",text:"Los cambios no pudieron ser guardados.\n\
                                                          Por favor confirme sus datos e inténtelo nuevamente.\n\
                                                          Si el error prosigue, pruebe más tarde."});
                                        }
                                        else{   var array=$$("overwritetree").getChecked();
                                                if(!array || 0 === array.length){
                                                    webix.message("Debe seleccionar los elementos a sobrescribir para continuar");
                                                }
                                                else{
                                                    $$("upl2").files.data.each(function(obj){
                                                        var error=false;
                                                        if(obj.type.toString()!="LANGCLUSTER"){
                                                            webix.message({type:"error",text:"No se reconoce el formato del archivo"});
                                                            error=true;
                                                        }
                                                        if(!error){
                                                            var array=$$("overwritetree").getChecked();
                                                            if(!array || 0 === array.length){
                                                                webix.message("Debe seleccionar los elementos a eliminar para continuar");
                                                            }
                                                            else{
                                                                webix.confirm({
                                                                    title:"¡Atención!",
                                                                    type:"confirm-warning",
                                                                    ok:"Sí", 
                                                                    cancel:"No",
                                                                    text:"¿Está seguro de que desea sobrescribir la data seleccionada?<br/>¡Esta acción no puede deshacerse!",
                                                                    callback:function(result){
                                                                        if( result == true ){
                                                                            $$("windowOverwriteData").getHead().setHTML("<strong>Sobrescribir Data</strong> - Procesando");
                                                                            $$("windowOverwriteData").showProgress({
                                                                                type:"icon",
                                                                                delay:3000
                                                                            });
                                                                            $$("upl2").send();
                                                                            $.ajax({
                                                                                type:'POST',
                                                                                data: {file: obj.name, id:"2",array:array.toString()},
                                                                                url: 'UploadFile',
                                                                                success: function(result){
                                                                                    if(result.startsWith("error")){
                                                                                        errorUpload(obj.name,result.substring(5,result.length));
                                                                                    }
                                                                                    else{
                                                                                        webix.confirm({
                                                                                            title:"Data Cargada",
                                                                                            ok:"Aceptar",
                                                                                            text:"La data ha sido cargada exitosamente",
                                                                                            callback:function(){document.location.reload();}
                                                                                        });
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
                                        }
                                    });
                                }
                            }
                    });
                }
            }                                                     
            
            function eliminate(){
                var code=$$("code").getValue();
                if(!code || 0 === code.length){
                    webix.message("Necesita ingresar su código de confirmación para continuar.");
                    return;
                }
                else{
                    var error;
                    $.ajax({
                        type:'POST',
                        data: {username:getCookie("username"), password:code, id:"1"},
                        url: 'Servlet',
                        success: function(result){
                            if(!result || 0 === result.length){
                                error=true;
                            }else{
                                $.ajax({
                                    type:'POST',
                                    data: {username: getCookie("username"), id:"3"},
                                    url: 'Servlet',
                                    success: function(result){
                                                if(!result || 0 === result.length){
                                                    error=true;
                                                }else{
                                                    var obj = JSON.parse(result);
                                                    if(obj[0].id_permiso==0){
                                                        error=false;
                                                    }
                                                    else {
                                                        error=true;
                                                    }
                                                }
                                            },
                                            complete:function(){
                                                if(error){
                                                    webix.message({type:"error",text:"Los cambios no pudieron ser guardados.\n\
                                                                  Por favor confirme sus datos e inténtelo nuevamente.\n\
                                                                  Si el error prosigue, pruebe más tarde."});
                                                }
                                                else{   var array=$$("deletetree").getChecked();
                                                        if(!array || 0 === array.length){
                                                            webix.message("Debe seleccionar los elementos a eliminar para continuar");
                                                        }
                                                        else{
                                                            webix.confirm({
                                                                title:"¡Atención!",
                                                                type:"confirm-warning",
                                                                ok:"Sí", 
                                                                cancel:"No",
                                                                text:"¿Está seguro de que desea eliminar la data seleccionada?<br/>¡Esta acción no puede deshacerse!",
                                                                callback:function(result){
                                                                    if( result == true ){
                                                                        $$("windowDeleteData").getHead().setHTML("<strong>Eliminar Data</strong> - Procesando");
                                                                        $$("windowDeleteData").showProgress({
                                                                            type:"icon",
                                                                            delay:3000
                                                                        });
                                                                        var lang=$$("combobox").getText();
                                                                        $.ajax({
                                                                            type:'POST',
                                                                            data: {id:"4",lang:getCookie("clickedlang"),array:array.toString()},
                                                                            url: 'UploadFile',
                                                                            success: function(result){
                                                                                webix.message("Data Eliminada Exitosamente");
                                                                                document.location.reload();
                                                                            }
                                                                        });
                                                                    }
                                                                }
                                                            });
                                                        }
                                                }
                                            }
                                        });
                            }
                        }
                    });
                }
            }
    
        </script>
        </body>
</html>
