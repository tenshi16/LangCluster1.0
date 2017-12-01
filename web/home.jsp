<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
           img {
                max-width: 100%;
                height: auto;
                width: auto\9; /* ie8 */
           }
           
           .image{
                max-width: 100%;
                height: auto;
                width: auto\9; /* ie8 */
                display: inline-block;
                vertical-align: middle;
                border-radius: 20%;
                margin:0px;
            }
            .a {
                background-image: url("img/Juego/home.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            
            .ru{
                background-image: url("img/Juego/Up/RU.png"); 
                background-size: 100% 100%;
                background-repeat: no-repeat;
                background-position: center; 
            }
              
            .ru:hover {
                background-image: url("img/Juego/Down/RU.png");
                background-size: 100% 100%;
                background-repeat: no-repeat;
                background-position: center; 
            }
            
            .jp{
                background-image: url("img/Juego/Up/Japon.png");
                background-size: 100% 100%;
                background-repeat: no-repeat;
                background-position: center; 
            }
              
            .jp:hover {
                background-image: url("img/Juego/Down/Japon.png");
                background-size: 100% 100%;
                background-repeat: no-repeat;
                background-position: center; 
            }
            
            .fr{
                background-image: url("img/Juego/Up/Francia.png"); 
                background-size: 100% 100%;
                background-repeat: no-repeat;
                background-position: center; 
            }
              
            .fr:hover {
                background-image: url("img/Juego/Down/Francia.png");
                background-size: 100% 100%;
                background-repeat: no-repeat;
                background-position: center; 
            }
            .flag{
                display: inline-block;
                vertical-align: middle;
                -webkit-border-radius: 100px;
                -moz-border-radius: 100px;
                border-radius: 100px;
                height:100px;
                width:100px;
                position: relative;
                border-style: solid;
            }
        </style>
    
    <body>
    <script>        
        ini();
        var alto,ancho,bord,bordfr,bordru;
        var isos = new Array();
        clas();
        
        function ini(){
            eraseCookie("phrase","");
            eraseCookie("LANG","");
            var ach = $(window).width();
            //alto
            var alt = $(window).height();
            bordfr = $(window).height()*.25;
            bordru = $(window).height()*.05;
            bord = $(window).width()*.02;
            alto=alt*.25;
            ancho=ach*.15;
            if(Math.round(ancho)>Math.round(alto)){
                bord+=80;
                alto=ancho-20;
                ancho-=20;
            }
       }
       
       function clas(){
           $.ajax({
            type:'POST',
            data: {p1:getCookie("username"),id:"Stu"},
            url: 'Servlet',
            success: function(result){
                isos = JSON.parse(result);
            }
            });
       }
       
       function value(aux){
           var find=true;
           for(var i=0;i<isos.length;i++){
               if(aux===isos[i].iso) find=false;
           }
            return find;
       }
           
           
        click:function Ru(){
            try{if($$("langJA").isVisible())    $$("langJA").hide();}catch(error){}
            try{if($$("langFR").isVisible())    $$("langFR").hide();}catch(error){}
            if(value("EN")){
                $.ajax({
                type:'POST',
                data: {lang:"EN", id:"Home1"},
                url: 'Servlet',
                success: function(result){
                    if(!result || 0 === result.length){
                        webix.confirm({
                            title:"¡Ha ocurrido un error!",
                            type:"alert-error",
                            text:"Ha ocurrido un error al tratar de realizar la acción seleccionada. Por favor, inténtelo más tarde.<br/><br/>Si el problema persiste, contáctenos.",
                            callback:function(){
                                document.location.reload();
                            }
                        });
                    }
                    else{
                        var langdata=JSON.parse(result);
                        webix.ui({
                            id:"langEN",
                            view:"window",
                            heigth:250,
                            width:600,
                            head:"<strong>Seleccionar Idioma</strong>",
                            position:"center",
                            body:{
                                rows:[
                                    {view:"label", label:"<img src='img/data/UKbar.png'/>",height:130,width:600,borderless:true},
                                    {   cols:[
                                            {rows:[ {autoheight:true},
                                                    {cols:[{width:10},
                                                           {view:"label", label:"<img src='img/data/UK.png'/>", height:100,width:100, css:"flag"},
                                                           {width:10}]},
                                                    {autoheight:true}
                                                  ]
                                            },
                                            {rows:[ {template:"<strong>"+langdata[0].lang+" (English)</strong>",autoheight:true,borderless:true},
                                                    {template:langdata[0].description,autoheight:true,autowidth:true,borderless:true}
                                                  ]
                                            },
                                            {rows:[ {autoheight:true},
                                                    {view:"button", value:"Confirmar", type:"form",width:100,
                                                        click:function(){
                                                                var cookie = getCookie("username");
                                                                if (cookie == "" || cookie == null){
                                                                    webix.confirm({
                                                                        title:"¡Ha ocurrido un error!",
                                                                        type:"alert-warning",
                                                                        text:"Estimado usuario, debe iniciar sesión para continuar."
                                                                    });
                                                                }
                                                                else{
                                                                    $.ajax({
                                                                        type:'POST',
                                                                        data: {lang:"EN", user:getCookie("username"), id:"Home2"},
                                                                        url: 'Servlet',
                                                                        success: function(result){
                                                                            setCookie("LANG","EN",1);
                                                                            window.open("naveg.jsp","_self");
                                                                        }
                                                                    });
                                                                }
                                                            }
                                                        },
                                                    {view:"button", value:"Cancelar", width:100,click:function(){$$("langEN").hide();}},
                                                    {autoheight:true}
                                                  ]
                                            }
                                        ]
                                    }
                                ]
                            }
                        }).show();
                    }
                }
            });
            }else{
                var cookie = getCookie("username");
                if (cookie == "" || cookie == null){
                    webix.confirm({
                        title:"¡Ha ocurrido un error!",
                        type:"alert-warning",
                        text:"Estimado usuario, debe iniciar sesión para continuar."
                    });
                }
                else{
                    $.ajax({
                        type:'POST',
                        data: {lang:"EN", user:getCookie("username"), id:"Home2"},
                        url: 'Servlet',
                        success: function(result){
                            setCookie("LANG","EN",1);
                            window.open("naveg.jsp","_self");
                        }
                    });
                }
            }
            
        }
        click:function Ja(){
            try{if($$("langEN").isVisible())    $$("langEN").hide();}catch(error){}
            try{if($$("langFR").isVisible())    $$("langFR").hide();}catch(error){}
            $.ajax({
                type:'POST',
                data: {lang:"JA", id:"Home1"},
                url: 'Servlet',
                success: function(result){
                    if(!result || 0 === result.length){
                        webix.confirm({
                            title:"¡Ha ocurrido un error!",
                            type:"alert-error",
                            text:"Ha ocurrido un error al tratar de realizar la acción seleccionada. Por favor, inténtelo más tarde.<br/><br/>Si el problema persiste, contáctenos.",
                            callback:function(){
                                document.location.reload();
                            }
                        });
                    }
                    else{
                        var langdata=JSON.parse(result);
                        webix.ui({
                            id:"langJA",
                            view:"window",
                            heigth:250,
                            width:600,
                            head:"<strong>Seleccionar Idioma</strong>",
                            position:"center",
                            body:{
                                rows:[
                                    {view:"label", label:"<img src='img/data/JAbar.png'/>",height:130,width:600,borderless:true},
                                    {   cols:[
                                            {rows:[ {autoheight:true},
                                                    {cols:[{width:10},
                                                           {view:"label", label:"<img src='img/data/JA.png'/>", height:100,width:100, css:"flag"},
                                                           {width:10}]},
                                                    {autoheight:true}
                                                  ]
                                            },
                                            {rows:[ {template:"<strong>"+langdata[0].lang+" (日本語)</strong>",autoheight:true,borderless:true},
                                                    {template:langdata[0].description,autoheight:true,autowidth:true,borderless:true}
                                                  ]
                                            },
                                            {rows:[ {autoheight:true},
                                                    {view:"button", value:"Confirmar", type:"form",width:100,
                                                        click:function(){
                                                            webix.alert("Idioma no disponible por los momentos -Estamos trabajando.-");
                                                            }
                                                        },
                                                    {view:"button", value:"Cancelar", width:100,click:function(){$$("langJA").hide();}},
                                                    {autoheight:true}
                                                  ]
                                            }
                                        ]
                                    }
                                ]
                            }
                        }).show();
                    }
                }
            });
        }
        
        click:function Fr(){
            try{if($$("langEN").isVisible())    $$("langEN").hide();}catch(error){}
            try{if($$("langJA").isVisible())    $$("langJA").hide();}catch(error){}
            $.ajax({
                type:'POST',
                data: {lang:"FR", id:"Home1"},
                url: 'Servlet',
                success: function(result){
                    if(!result || 0 === result.length){
                        webix.confirm({
                            title:"¡Ha ocurrido un error!",
                            type:"alert-error",
                            text:"Ha ocurrido un error al tratar de realizar la acción seleccionada. Por favor, inténtelo más tarde.<br/><br/>Si el problema persiste, contáctenos.",
                            callback:function(){
                                document.location.reload();
                            }
                        });
                    }
                    else{
                        var langdata=JSON.parse(result);
                        webix.ui({
                            id:"langFR",
                            view:"window",
                            heigth:250,
                            width:600,
                            head:"<strong>Seleccionar Idioma</strong>",
                            position:"center",
                            body:{
                                rows:[
                                    {view:"label", label:"<img src='img/data/FRbar.png'/>",height:130,width:600,borderless:true},
                                    {   cols:[
                                            {rows:[ {autoheight:true},
                                                    {cols:[{width:10},
                                                           {view:"label", label:"<img src='img/data/FR.png'/>", height:100,width:100, css:"flag"},
                                                           {width:10}]},
                                                    {autoheight:true}
                                                  ]
                                            },
                                            {rows:[ {template:"<strong>"+langdata[0].lang+" (Français)</strong>",autoheight:true,borderless:true},
                                                    {template:langdata[0].description,autoheight:true,autowidth:true,borderless:true}
                                                  ]
                                            },
                                            {rows:[ {autoheight:true},
                                                    {view:"button", value:"Confirmar", type:"form",width:100,
                                                        click:function(){
                                                            webix.alert("Idioma no disponible por los momentos -Estamos trabajando.-");
                                                            }
                                                        },
                                                    {view:"button", value:"Cancelar", width:100,click:function(){$$("langFR").hide();}},
                                                    {autoheight:true}
                                                  ]
                                            }
                                        ]
                                    }
                                ]
                            }
                        }).show();
                    }
                }
            });
        }
        
        webix.ui({
                view: "scrollview",
                id: "aaa",
                css:"a",
                body:{
                  cols:[ {},
                        {rows:[
                              {height:bordfr},
                              { id:"fr",view:"button",
                                type:"imageTop",
                                css:"fr",
                                width: ancho,
                                height: alto,
                                click: Fr
                              }
                        ]},
                        {width:bord},
                        {   rows:[
                                 {height:bordru},
                                 {  id:"rur",
                                    view:"button",
                                    type:"imageTop",
                                    css:"ru",
                                    width: ancho,
                                    height: alto,
                                    click: Ru
                                 },
                                 {height:bordru},  
                                 {  id:"jp",view:"button",
                                    type:"imageTop",
                                    css:"jp",
                                    click: Ja,
                                    width: ancho,
                                    height: alto
                                 }
                              ]
                           },
                        {}      
                    ] 
               }//body
            });
 
        $(window).resize(function(){
           var ach = $(window).width();
           //alto
           var alt = $(window).height();
           alto=alt*.2;
           ancho=ach*.2;
        });     
        </script>
        </body>
</html>
