<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
    <!--    LangCluster - Configuration    -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
    <script src="CookieControl.js"></script>
    <script src="codebase/webix.js"></script>
    <script src="jquery-1.12.4.min.js"></script>
    <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
    <style>
        .image{
            display: inline-block;
            vertical-align: middle;
            border-radius: 20%;
            overflow:hidden;
            width:70px;
            height:70px;
        }
    </style>
        
    <body>
    <script>
        iniCountries();
        function iniCountries(){
           $.ajax({
                type:'POST',
                data: {id:"4"},
                url: 'Servlet',
                success: function(result){
                    if(!result || 0 === result.length){
                        webix.alert("Lo sentimos ha ocurrido un problema");
                    }else{
                        var auxx=JSON.parse(result);
                        $$("Paises").define("suggest",auxx);
                        $$("Paises").refresh();
                    }
                }
            });
        }
        
        var global;
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
                    ini();
                }
            }
        
        function ini(){
            if(getCookie("username").length !== 0 || getCookie("username").length !== ""){
                $.ajax({
                    type:'POST',
                    data: {username:getCookie("username"),id:"5"},
                    url: 'Servlet',
                    success: function(result){
                        if(!result || 0 === result.length){
                            webix.alert("Lo sentimos ha ocurrido un problema.");
                        }else{
                            var values=JSON.parse(result);
                            //Email
                            $$("email").define("value",values[0].email);
                            $$("email").refresh();
                            global=values[0].email;
                            //Nombre
                            $$("Nom").define("value",values[0].nombre);
                            $$("Nom").refresh();
                            //Paises
                            $$("Paises").define("value",values[0].nombre_pais);
                            $$("Paises").refresh();
                            //foto
                            try{
                                $$("Avatar").define("image",values[0].ruta_avatar);
                            }catch(error){
                                $$("Avatar").define("image","Uploads/avatar/0.jpg");
                            }
                            if(values[0].ruta_avatar==="null"||values[0].ruta_avatar===null){
                                $$("Avatar").define("image","Uploads/avatar/0.jpg");
                            }
                            $$("Avatar").refresh();
                            //Fecha
                            $$("Calendar").define("value",values[0].fecha_nacimiento);
                            $$("Calendar").refresh();
                        }
                    }
                });
            }
            if(getCookie("config").length!==0||getCookie("config").length!==""){
                $.ajax({
                    type:'POST',
                    data: {username:getCookie("config"),id:"5"},
                    url: 'Servlet',
                    success: function(result){
                        if(result || 0 !== result.length){
                            var values=JSON.parse(result);
                            //Email
                            $$("email").define("value",values[0].email);
                            global=values[0].email;
                            $$("email").refresh();
                            //Nombre
                            $$("Nom").define("value",values[0].nombre);
                            $$("Nom").refresh();
                            //Avatar
                            try{
                                $$("Avatar").define("image",values[0].ruta_avatar);
                            }catch(error){
                                $$("Avatar").define("image","Uploads/avatar/0.jpg");
                            }
                            if(values[0].ruta_avatar==="null"||values[0].ruta_avatar===null){
                                $$("Avatar").define("image","Uploads/avatar/0.jpg");
                            }
                            $$("Avatar").refresh();
                            //Paises
                            $$("Paises").define("value",values[0].nombre_pais);
                            $$("Paises").refresh();
                            //Fecha
                            $$("Calendar").define("value",values[0].fecha_nacimiento);
                            $$("Calendar").refresh();
                        }
                    }
                });
            }
        }
        

   
        webix.ui({
            id:"delUser",
            cols:[{},
                  {rows:[
                        {id:"Avatar",view:"button",disabled:true, image:"", css:"image",type:"image",
                         width:200, height:200 ,borderless:true},
                        {id:"PicChange", view:"button", value:"Cambiar",click: changePic, type:""},
                        {id:"Paises",view:"text", name:"country", label:"País:", value:"", suggest:"", readonly:true },
                        {id:"contChange", view:"button", value:"Cambiar", click: changeCont, type:""},
                        { 
                            id:"Calendar",
                            view:"datepicker",	
                            readonly:true,
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
                        {id:"DataChange", view:"button", value:"Cambiar", type:"",click: changeDate}
                       ]
                },
                {rows:[
                      {cols:[
                         {id:"Nom", view: "text", readonly:true, label:"Nombre", labelPosition:"top",value:""},
                         {id:"NomChange", view:"button", value:"Cambiar",click: changeNom, type:""}
                      ]}
                      ,{},
                      {view:"fieldset", label:"Contraseña",
                          body:{
                            rows:[
                                { id:"passActu",view:"text", type:"password", label:"Ingrese la actual", labelPosition:"top",value:""},
                                { id:"passNuev",view:"text", type:"password", label:"Ingrese la nueva", labelPosition:"top",value:""},
                                { id:"PassChange", view:"button", value:"Cambiar", click: changePass, type:""}
                            ]
                         }},
                    {id:"email", view:"text", readonly:true, label:"Correo", labelPosition:"top",value:""}
                    ]},
                {}
            ]
        });
            
        function changeNom(id){
            if($$(id).getValue()=== "Cambiar"){
                if(id==="NomChange"){
                    webix.alert("Ahora puede cambiar el campo");
                    $$("Nom").config.readonly = false;
                    $$("Nom").refresh();
                    $$("NomChange").define("value", "Guardar");
                    $$("NomChange").define("type", "form");
                    $$("NomChange").refresh();
               }
            }else{
              $.ajax({
                type:'POST',
                data: {name:$$("Nom").getValue(),username:global, id:"8"},
                url: 'Servlet',
                success: function(result){
                    if(result == 1){
                            webix.alert("Guardado con éxito."); 
                            $$("NomChange").define("value", "Cambiar");
                            $$("NomChange").define("type", "");
                            $$("NomChange").refresh();
                            $$("Nom").config.readonly = true;
                            $$("Nom").refresh();
                            eraseCookie(getCookie("config"));
                        }else{
                            webix.alert("Hubo un problema.");    
                        }
                    }
                });
           }
        }
        
        var avatar;
        function changePic(id){
           if($$(id).getValue()=== "Cambiar"){
              if(id==="PicChange"){
                disabled:true;
                $$("Avatar").enable();
                $$("Avatar").refresh();
                $$("PicChange").define("value", "Guardar");
                $$("PicChange").define("type", "form");
                $$("PicChange").refresh();
                importdata();
              }
           }else{
                var ok=up();
                if(ok){
                    $.ajax({
                        type:'POST',
                        data: {p2:getCookie("username"),id:"26"},
                        url: 'Servlet',
                        success: function(result){
                                console.log("returned "+result);
                                if(result || 0 !== result.length){
                                    avatar=result[0].ruta_avatar;
                                    ini();
                                    //webix.message("Guardado");
                                }else{
                                    webix.alert("Hubo un problema.");    
                                }
                            }
                    });
                    $$("Avatar").disable();
                    $$("Avatar").refresh();
                    $$("PicChange").define("value", "Cambiar");
                    $$("PicChange").define("type", "");
                    $$("PicChange").refresh();
                    /*$$("upl1").attachEvent("onUploadComplete", function(){
                        document.location.reload();
                    });*/
                }
                else{
                    importdata();
                }
           }

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
                                    id:"upl1", name:"files", accept:"image/png, image/jpeg",
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
            try{if($$("windowOverwriteData").isVisible()){$$("windowOverwriteData").hide();}}catch(error){};
            try{if($$("windowDeleteData").isVisible()){$$("windowDeleteData").hide();}}catch(error){};
            try{if($$("AutoGeneratedData").isVisible()){$$("AutoGeneratedData").hide();}}catch(error){};
        }


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


        function changePass(id){
           if($$("passActu").getValue()!=="" && !$$("passNuev").getValue()!==""){
              $.ajax({
                type:'POST',
                data: {p0:$$("passNuev").getValue(),username:global,p1:$$("passActu").getValue(), id:"9"},
                url: 'Servlet',
                success: function(result){
                   var re=result
                   if(re == 0){
                      webix.alert("Contraseña actual invalida.");
                   }
                   if(re == 1){
                      $$("passActu").setValue("");
                      $$("passNuev").setValue("");
                      webix.alert("Contraseña cambiada satisfactoriamente.");
                   }
             }});
           }else{
              webix.alert("Ingrese valores correctos.");
           }
        }

        function changeDate(id){
           if($$(id).getValue()=== "Cambiar"){
               $$("Calendar").config.readonly = false;
               $$(id).define("value", "Guardar");
               $$(id).define("type", "form");
               $$(id).refresh();

           } else{
              //ajax
               $.ajax({
                type:'POST',
                data: {p1:webix.i18n.parseFormatStr($$("Calendar").getValue()),username:global,id:"10"},
                url: 'Servlet',
                success: function(result){
                   if(result == 0){
                       webix.alert("Ha ocurrido un problema");
                   }else{
                       webix.alert("Guardado con éxito");
                       eraseCookie(getCookie("config"));
                   }

                }
             });
               $$("Calendar").config.readonly = true;
               $$(id).define("value", "Cambiar");
               $$(id).define("type", "");
               $$(id).refresh();
           }
        }

        function changeCont(id){
            if($$(id).getValue()=== "Cambiar"){
            webix.alert("Ahora puede cambiar el campo.");
            $$("contChange").define("value", "Guardar");
            $$("contChange").define("type", "form");
            $$("contChange").refresh();
            $$("Paises").config.readonly = false;
            $$("Paises").refresh();
            }else{
               $.ajax({
                type:'POST',
                data: {p1:$$("Paises").getValue(),username:global, id:"11"},
                url: 'Servlet',
                success: function(result){
                        if(result == 0){
                            webix.alert("Ha ocurrido un problema.");
                        }else{
                            webix.alert("Guardado con éxito");
                            eraseCookie(getCookie("config"));
                        }
                    }
                });
                $$("contChange").define("value", "Cambiar");
                $$("contChange").define("type", "");
                $$("contChange").refresh();
                $$("Paises").config.readonly = true;
                $$("Paises").refresh();
           }
        }
        </script>
    </body>
</html>

