<%-- 
    Document   : statisticsUser
    Created on : Jun 22, 2016, 7:20:47 PM
    Author     : tenshi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <title>JSP Page</title>
    </head>
    <body>
    <script>
        var madurezUsuariosStats;
        var avanceUsuariosStats;
        var topicosUsuariosStats;
        var userStats;
        var nombre="";
        var nombre_pais="";
        var fecha_nacimiento="";
        var nombre_idioma="";
        var repeticiones="";
        var errores="";
        var puntaje="";
        var reportUsuarioView;
        var stringcontodaladatadelosobjetos;
        var consultarEstadisticas;
        var vistaAux;     
        var codigo_reporte;
        var email_usuario=getCookie("username");
        var hoy= new Date();
        var fecha_actual=new Date();
        var twoDaysAgo = new Date(fecha_actual.valueOf() - 1000*60*60*24*2);
        var yesterday = new Date(fecha_actual.valueOf() - 1000*60*60*24);
        var tomorrow=new Date(fecha_actual.valueOf() + 1000*60*60*24);
        var twoDaysAfter=new Date(fecha_actual.valueOf() + 1000*60*60*24*2);
        var typereturned;
        
        function changeDate(fecha){
            fecha_actual=fecha;
            twoDaysAgo=new Date(fecha_actual.valueOf() - 1000*60*60*24*2);
            yesterday=new Date(fecha_actual.valueOf() - 1000*60*60*24);
            tomorrow=new Date(fecha_actual.valueOf() + 1000*60*60*24);
            twoDaysAfter=new Date(fecha_actual.valueOf() + 1000*60*60*24*2);
            $.ajax({
                type:'POST',
                data:{fecha_actual:fecha_actual.getFullYear()+"."+( fecha_actual.getMonth()+1)+"."+ fecha_actual.getDate(),email_usuario:email_usuario,id:"23"},
                url:'Servlet',
                success: function(result){
                    if(!result || 0 === result.length || result===null){
                        webix.alert("No hay Sesion registrada en la fecha Seleccionada");
                    }
                    else {
                        startUserStats();
                    }
                }
            });
        }
    
        var cookies=getCookie("codigoR");
        var cookies1=getCookie("consultaUser");
        var cookies2=getCookie("stat");       
        var cookies3=getCookie("rep");
       
          
        function checkElCookie(){
            if(cookies1.toString().includes("1")===true){
                consultarValidarReporteUsuario(); // usar funcion nueva
            }
            else if(cookies2.toString().includes("1")===true)
                 {  startUserStats();
                 }
            else if(cookies3.toString().includes("1")===true){
                 startChartsDataUser();
                }
                
        }
       
        function initStatViewUser()
        {
            reportUsuarioView={
                rows:[{view:"scrollview",
                        id:"myscrollview",
                        scroll:"y",
                        body:{rows:[{cols:[{rows:[{ template:"<center>Madurez por Idioma</center>", height:22},
                                          { view: "chart",
                                            type:"bar",
                                            value:"#madurez#",
                                            color:"#color#",
                                            label:"#madurez#",
                                            shadow:2,
                                            radius:0,
                                            barWidth:40,
                                            tooltip:{
                                                template:"#madurez#"
                                            },
                                            xAxis:{
                                                title:"Idioma",
                                                template:"'#idioma#",
                                                lines: false
                                            },

                                            padding:{
                                                left:40,
                                                right:10,
                                                top:50
                                            },
                                            yAxis:{ 
                                                    title:"Madurez",
                                                    start:0,
                                                    end:100,
                                                    step:10
                                            },
                                            data:madurezUsuariosStats
                                          }
                                        ]
                                   },
                                   {rows:[{template:"<center>Avance en Idiomas</center>", height:22},
                                          { view: "chart",
                                            type:"bar",
                                            value:"#avance#",
                                            color:"#color#",
                                            label:"#avance#",                         
                                            shadow:2,
                                            radius:0,
                                            barWidth:40,
                                            tooltip:{
                                                template:"#avance#"
                                            },
                                            xAxis:{
                                                title:"Idioma",
                                                template:"'#idioma#",
                                                lines: false
                                            },
                                            padding:{
                                                left:40,
                                                right:10,
                                                top:50
                                            },
                                                   yAxis:{title:"Avance",                                 
                                                    start:0,
                                                    end:4,
                                                    step:1},
                                                            data:avanceUsuariosStats
                                            }
                                        ]
                                   }
                                  ]
                            },  // aca       
                            {rows:[{template:"<center>Tópicos más Escogidos</center>", height:22},
                                   {cols:[ 
                                          { view: "chart",
                                            type:"bar",
                                            value:"#frecuencia#",
                                            color:"#color#",
                                            label:"#frecuencia#",
                                            shadow:2,
                                            radius:0,
                                            barWidth:40,                        
                                            tooltip:{
                                                template:"#frecuencia#"
                                            },
                                            xAxis:{
                                                title:"Tópicos",
                                                template:"'#topico#",
                                                lines: false
                                            },
                                            padding:{
                                                left:40,
                                                right:10,
                                                top:50
                                            },
                                            yAxis:{ title:"Frecuencia",
                                                    start:0,
                                                    end:100,
                                                    step:10
                                            },
                                                            data:topicosUsuariosStats  
                                          }
                                         ]
                                   }
                                  ]
                            },//termina aqui
                            {cols:[{view:"text", value:codigo_reporte, label:"Código: ",readonly:true,width:373},
                                   {},
                                   {view:"text",value:hoy, label:"Fecha: ",disabled:true,width:210}]
                            }               
                       ]// termina el scrollview
                     }
                    },
                    {cols:[
                          {},
                          {view: "button", type: "iconButton", label: "Exportar", icon: "image",width:150,click: function(){webix.toPNG($$("myscrollview"));}},
                          {}
                    ]}       
                 ]  
            };  
            webix.ui({          
		id:"Statistics",
		rows:[{rows:[reportUsuarioView]}]       
            });
    }
     
    function noChartEstadisticasView()
    {   consultarEstadisticas=
            { 
                rows:[
                    {cols:[
                        {view:"datepicker",id:" name:"start", stringResult:true,width:200,click:function(){
                                var fecha=
                        },  // add function to call Consult changing the date of the data and te buttons
                        {view:"button",id:"fecha1",value:twoDaysAgo.getFullYear()+"/"+(twoDaysAgo.getMonth()+1)+"/"+twoDaysAgo.getDate(),width:200, click:function(){changeDate(twoDaysAgo);}},                        //date
                        {view:"button",id:"fecha2",value:yesterday.getFullYear()+"/"+(yesterday.getMonth()+1)+"/"+yesterday.getDate(),width:200,click:function(){changeDate(yesterday);}}, 
                        {view:"button",id:"fecha3",value:fecha_actual.getFullYear()+"/"+( fecha_actual.getMonth()+1)+"/"+ fecha_actual.getDate(),width:300,click:function(){changeDate(fecha_actual);}}, 
                        {view:"button",id:"fecha4",value:tomorrow.getFullYear()+"/"+(tomorrow.getMonth()+1)+"/"+tomorrow.getDate(),width:200,click:function(){changeDate(tomorrow);}}, 
                        {view:"button",id:"fecha5",value:twoDaysAfter.getFullYear()+"/"+(twoDaysAfter.getMonth()+1)+"/"+twoDaysAfter.getDate(),width:200,click:function(){changeDate(twoDaysAfter);}},
                        {view:"button", icon:"http://img.stockfresh.com/files/m/mr_vector/x/21/478309_32029363.jpg"}  
                        ]
                    }, 
                    {   cols:[
                              {view:"scrollview",
                               body:{
                                    rows:[
                                        {view:"button", value:"Datos Generales",width:150,height:150},
                                        {view:"button", value:"Por Idioma",width:150,height:150},
                                        {view:"button", value:"Por Tópico",width:150,height:150},
                                        {view:"button", value:"Por Tipo de Estudio",width:150,height:150},
                                        {view:"button", value:"Por Tipo de Actividad",width:150,height:150},
                                        {view:"button", value:"Vocabulario Manejado",width:150,height:150} 
                                    ]
                                   }
                                }, 
                               {rows:[
                                    {cols:[
                                        {rows:[                 
                                                {view:"label",label:"Datos Generales"},
                                                {cols:[{view:"label",label:"Nombre:",width:150,height:50},{view:"label",label:nombre}]},
                                                {cols:[{view:"label",label:"Pais:",width:150,height:50},{view:"label",label:nombre_pais}]},
                                                {cols:[{view:"label",label:"Fecha de Nacimiento:",width:150,height:50},{view:"label",label:fecha_nacimiento}]}
                                            ]                    
                                        },//primer col
                                        {},
                                        {view:"text",label:"Nombre",value:nombre,readonly:true,width:300}// get user image
                                    ]
                                    },
                                    {cols:[{view:"label",label:"Idioma mas Estudiado:",width:150,height:50},{view:"label",label:nombre_idioma}]},
                                    {cols:[{view:"label",label:"Repeticiones:",width:150,height:50},{view:"label",label:repeticiones}]},
                                    {cols:[{view:"label",label:"Puntaje mas alto:",width:150,height:50},{view:"label",label:puntaje}]},
                                    {cols:[{view:"label",label:"Errores promedio:",width:150,height:50},{view:"label",label:errores}]},
                                    {cols:[{view:"label",label:"Sesion Actual:",width:150,height:50},{view:"label",label:errores}]}, //segundo row
                                    {cols:[{view:"label",label:"Madurez Promedio:",width:150,height:50},{view:"label",label:errores}]},
                                    {cols:[{view:"label",label:"Topico más Escogido:",width:150,height:50},{view:"label",label:errores}]},
                                    {cols:[{view:"label",label:"Total de Repeticiones:",width:150,height:50},{view:"label",label:errores}]},
                                    {cols:[{view:"label",label:"Nivel Alcanzado:",width:150,height:50},{view:"label",label:errores}]},
                                    {}
                                ]} // contenido
                            ]
                    }  // contenido
                    ]
            };
            webix.ui({          
		id:"Statistics",
		rows:[{rows:[consultarEstadisticas]}]       
            });
    }
    
    function consultarValidarReporteUsuario()
    {   codigo_reporte=cookies;          
            $.ajax({
                type:'POST',  //usar con uploadedfile
                data: {codigo_reporte:codigo_reporte,id:"7"},
                url: 'UploadFile',
                success: function(result){     
                    if(!result || 0 === result.length){
                        codigo_reporte="";
                        webix.confirm({
                            title:"¡Error!",
                            type:"confirm-error",
                            text:"Reporte no Encontrado",
                            callback:function(){
                                history.back();
                            }
                        });
                    }
                    else{
                        var result2=result;
                        $.ajax({
                            type:'POST',
                            data:{codigo_reporte:codigo_reporte,id:"18"},
                            url:'Servlet',
                            success:function(result){
                                if(!result||0===result.length){
                                    codigo_reporte="";
                                    webix.confirm({
                                        title:"¡Error!",
                                        type:"confirm-error",
                                        text:"Reporte no Encontrado",
                                        callback:function(){
                                            history.back();
                                        }
                                    });
                                }
                                else{
                                    result=JSON.parse(result);                   
                                    hoy=result[0].fecha_reporte;
                                    var array = result2.split("666"); 
                                    madurezUsuariosStats=array[0];
                                    topicosUsuariosStats=array[1];
                                    avanceUsuariosStats=array[2];
                                    try{
                                        madurezUsuariosStats=JSON.parse(madurezUsuariosStats);
                                        topicosUsuariosStats=JSON.parse(topicosUsuariosStats);
                                        avanceUsuariosStats=JSON.parse(avanceUsuariosStats);
                                    }catch(e){}
                                    console.log(avanceUsuariosStats);
                                    initStatViewUser();               
                                }
                            }
                        }); 
                    }
                }
            });  
        }
        
        function startUserStats()
        {   var aux=false;
            $.ajax({
                type:'POST',                            //werks
                data:{fecha_actual:fecha_actual.getFullYear()+"."+( fecha_actual.getMonth()+1)+"."+ fecha_actual.getDate(),email_usuario:email_usuario,id:"22"},
                url:'Servlet',
                success: function(result){
                    if(result != ""){
                        userStats=JSON.parse(result);
                        nombre=userStats[0].nombre;
                        fecha_nacimiento=userStats[0].fecha_nacimiento;
                        repeticiones=userStats[0].repeticiones;
                        nombre_idioma=userStats[0].nombre_idioma;
                        puntaje=userStats[0].puntaje_sesion;
                        errores=userStats[0].errores_sesion;
                        nombre_pais=userStats[0].nombre_pais;
                        aux=true;
                    }
                    else{
                        webix.alert("No hay sesión activa aún");
                    }
                },
                complete: function(){
                    if(aux) noChartEstadisticasView();
                }
            });
        }
        
        function saveReport()
        {   stringcontodaladatadelosobjetos= JSON.stringify(madurezUsuariosStats) +
            "666" + JSON.stringify(topicosUsuariosStats) + "666" + 
            JSON.stringify(avanceUsuariosStats);
        }
       
        function generateUUID()
        {
            var d = new Date().getTime();
            if(window.performance && typeof window.performance.now === "function"){
                d += performance.now(); //use high-precision timer if available
            }
            var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = (d + Math.random()*16)%16 | 0;
                d = Math.floor(d/16);
                return (c=='x' ? r : (r&0x3|0x8)).toString(16);
            });
            return uuid;
        }
           
        function startChartsDataUser()
        {   $.ajax({
                type:'POST',
                data: {email:getCookie("username"),id:"19"},
                url: 'Servlet',
                success: function(result){
                   madurezUsuariosStats=JSON.parse(result);
                },
                complete:function(){
                    $.ajax({
                        type:'POST',
                        data: {email:getCookie("username"),id:"20"},
                        url: 'Servlet',
                        success: function(result){                                
                          avanceUsuariosStats=JSON.parse(result); 
                        },
                        complete:function(){
                            $.ajax({
                                type:'POST',
                                data: {email:getCookie("username"),id:"21"},
                                url: 'Servlet',
                                success: function(result){
                                    codigo_reporte=generateUUID();
                                    topicosUsuariosStats=JSON.parse(result);
                                },
                                complete:function(){
                                    $.ajax({
                                        type:'POST',
                                        data:{id_usuario:email_usuario,codigo_reporte:codigo_reporte,id:"17"},
                                        url:'Servlet',
                                        success: function(result){ 
                                            saveReport();
                                            $.ajax({
                                                type:'POST',
                                                data:{stringcontodaladatadelosobjetos:stringcontodaladatadelosobjetos,codigo_reporte:codigo_reporte,id:"6"},
                                                url:'UploadFile',
                                                success: function(result){},
                                                complete: function(){
                                                    initStatViewUser();
                                                }
                                            });
                                        }
                                    });
                                }
                            });
                        }
                    });
                }
            });
        }
        
        access();
            
         function ajaxfunc(){   
       
        checkElCookie();
    }
        function access(){
                var typereturned;
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
                    ajaxfunc();
                }
            }
        
        
        function eliminarCookie(){
            setCookie("rep","",-1);
            setCookie("consultaUser","",-1);
            setCookie("stat","",-1);
            cookies1="";
            cookies2="";
            cookies3="";
        }
        
        function checkView(){
            if(cookies3.toString().includes("1")===true){
                vistaAux=reportUsuarioView;
            }    
            else if(cookies1.toString().includes("1")===true){
                vistaAux=reportAdminView;
            }
            else if(cookies2.toString().includes("1")===true){
                vistaAux=consultarEstadisticas;
            }
            else if(cookies1== "" || cookies1==null && cookies2== "" || cookies2==null && cookies3== "" || cookies3==null){
                vistaAux=reportAdminView;
            } 
            eliminarCookie();    
        }
        
        eliminarCookie();
        </script>
    </body>
</html>
