    <%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <!--    LangCluster - Statistics    -->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
        .blue{
            background:#3498DB;
        }
        </style>
    <body>
    <script>
       //variables de reporte Admin     
        var topicosGlobalReporte; 
        var usuariosCantidadReporte;
        var usuariosEstatusReporte;
        var stringcontodaladatadelosobjetos;
        var usuariosEstatusObj=[];
        var codigo_reporte;        
        var reportAdminView;
        var hoy= new Date();
        var email_usuario=getCookie("username");
        var cookies=getCookie("codigoR");
        
        
        function eliminarCookie(){
            setCookie("codigoR","",-1);
            cookies="";
        }
       
        var typereturned; access();
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
                                    ajaxfunc();
                                }
                        }
                    });
                }
            }
                                    
    function ajaxfunc(){
          
        if(cookies.toString().includes("1")===true){
            consultarValidarReporte();
        }
        else if(cookies=="" || cookies==null){
            startChartsDataAdmin();
        }
    }
        
    function initStatView(){
        reportAdminView={
            rows:[{view:"scrollview",
                   id:"myscrollview",
                   scroll:false,
                   body:{rows:[{cols:[{rows:[{template:"<center>Estudiantes por Idioma</center>", height:22},
                                             {view: "chart",
                                              type:"pie",                          
                                              value:"#porcentaje#",
                                              label:"#idioma#",
                                              pieInnerText:"#porcentaje#",
                                              tooltip:{
                                                  template:"#cantidad#"
                                              },
                                              data: usuariosCantidadReporte
                                              }
                                            ]
                                        },
                                        {rows:[{template:"<center>Tópicos más Escogidos</center>", height:22},
                                               {view: "chart",
                                                type:"bar",
                                                value:"#frecuencia#",
                                                color:"#color#",
                                                label:"#frecuencia#",
                                                shadow:2,
                                                width:600,
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
                                                        end:10,
                                                        step:1
                                                },
                                                data:topicosGlobalReporte 
                                                }
                                               ]
                                        }
                                     ]
                                },  // aca       
                                {rows:[{template:"<center>Actividad de Usuarios</center>", height:22},
                                       {cols:[ 
                                            {view: "chart",
                                            type:"line",

                                            xAxis:{
                                                template:"#mes#"                         
                                            },
                                            yAxis:{
                                                start:0,
                                                step:10, //make this variable
                                                end:100
                                            },
                                            legend:{
                                              values:[{text:"Activos",color:"#1293f8"},{text:"Inactivos",color:"#66cc00"}],
                                                align:"right",
                                                valign:"middle",
                                                layout:"y",
                                                width: 100,
                                                margin: 8  
                                            },
                                            series:[{
                                                value:"#activo#",
                                                item:{
                                                    borderColor: "#1293f8",
                                                    color:"#ffffff"
                                                },
                                                line:{
                                                    color:"#1293f8",
                                                    width:3
                                                },
                                                tooltip:{
                                                    template:"#activo#"
                                                }
                                            },
                                            {
                                                value:"#inactivo#",
                                                item:{
                                                    borderColor: "#66cc00",
                                                    color:"#ffffff"
                                                },
                                                line:{
                                                    color:"#66cc00",
                                                    width:3
                                                },
                                                tooltip:{
                                                    template:"#inactivo#"
                                                }
                                            }            
                                            ],
                                            data: usuariosEstatusObj
                                            }
                                        ]
                                       }
                                      ]
                                },
                                {cols:[{view:"text", value:codigo_reporte, label:"Código: ",readonly:true,width:373},
                                       {},
                                       {view:"text",value:hoy, label:"Fecha: ",disabled:true,width:210}
                                      ]
                                }               
                              ]
                        }
                   },
                   {cols:[{},
                          {view: "button", type: "iconButton", label: "Exportar Reporte", icon: "image",width:150,click: function(){webix.toPNG($$("myscrollview"));}},
                          {}
                         ]
                   }
                ]
               }; 
	webix.ui({          
            id:"Statistics",
            rows:[{rows:[reportAdminView]}]       
	});
    }
           
           
         
    function generateUUID(){
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
      
    function setUsersActivity(){
            var activoEnero=0,inactivoEnero=0;
            var activoFebrero=0,inactivoFebrero=0;
            var activoMarzo=0,inactivoMarzo=0;
            var activoAbril=0,inactivoAbril=0;
            var activoMayo=0,inactivoMayo=0;
            var activoJunio=0,inactivoJunio=0;
            var activoJulio=0,inactivoJulio=0;
            var activoAgosto=0,inactivoAgosto=0;
            var activoSeptiembre=0,inactivoSeptiembre=0;
            var activoOctubre=0,inactivoOctubre=0;
            var activoNoviembre=0,inactivoNoviembre=0;
            var activoDiciembre=0,inactivoDiciembre=0;


/*
            var PorcentajeActivoEnero=0,  PorcentajeInactivoEnero=0;
            var PorcentajeActivoFebrero=0,PorcentajeInactivoFebrero=0;
            var PorcentajeActivoMarzo=0,  PorcentajeInactivoMarzo=0;
            var PorcentajeActivoAbril=0,  PorcentajeInactivoAbril=0;
            var PorcentajeActivoMayo=0,   PorcentajeInactivoMayo=0;
            var PorcentajeActivoJunio=0,  PorcentajeInactivoJunio=0;
            var PorcentajeActivoJulio=0,  PorcentajeInactivoJulio=0;
            var PorcentajeActivoAgosto=0, PorcentajeInactivoAgosto=0;
            var PorcentajeActivoSeptiembre=0,PorcentajeInactivoSeptiembre=0;
            var PorcentajeActivoOctubre=0,PorcentajeInactivoOctubre=0;
            var PorcentajeActivoNoviembre=0,PorcentajeInactivoNoviembre=0;
            var PorcentajeActivoDiciembre=0,PorcentajeInactivoDiciembre=0;*/


            //var hoyMili=hoy.getTime();

            var TRESMESES=7889238000;

            var count = Object.keys(usuariosEstatusReporte).length;
            var ultimaSesion;
            var mesDiferencia;
            for(var i=0;i<count;i++){
                ultimaSesion = new Date(usuariosEstatusReporte[i].fecha);
                var mes = ultimaSesion.getMonth()+1;
                mesDiferencia= hoy - ultimaSesion;
                switch(mes){
                    case 1:
                        if(mesDiferencia>TRESMESES){
                            inactivoEnero++;
                        }
                        else{
                            activoEnero++;
                        }
                        break;
                    case 2:
                        if(mesDiferencia>TRESMESES){
                            inactivoFebrero++;
                        }
                        else{
                            activoFebrero++;
                        }
                        break;
                   case 3:
                        if(mesDiferencia>TRESMESES){
                            inactivoMarzo++;
                        }
                        else{
                            activoMarzo++;
                        }
                        break;
                   case 4:
                        if(mesDiferencia>TRESMESES){
                            inactivoAbril++;
                        }
                        else{
                            activoAbril++;
                        }
                        break;
                   case 5:
                        if(mesDiferencia>TRESMESES){
                            inactivoMayo++;
                        }
                        else{
                            activoMayo++;
                        }
                        break;
                   case 6:
                        if(mesDiferencia>TRESMESES){
                            inactivoJunio++;
                        }
                        else{
                            activoJunio++;
                        }
                        break;
                   case 7:
                        if(mesDiferencia>TRESMESES){
                            inactivoJulio++;
                        }
                        else{
                            activoJulio++;
                        }
                        break;
                   case 8:
                        if(mesDiferencia>TRESMESES){
                            inactivoAgosto++;
                        }
                        else{
                            activoAgosto++;
                        }
                        break;
                   case 9:
                        if(mesDiferencia>TRESMESES){
                            inactivoSeptiembre++;
                        }
                        else{
                            activoSeptiembre++;
                        }
                        break;
                   case 10:
                        if(mesDiferencia>TRESMESES){
                            inactivoOctubre++;
                        }
                        else{
                            activoOctubre++;
                        }
                        break;
                   case 11:
                        if(mesDiferencia>TRESMESES){
                            inactivoNoviembre++;
                        }
                        else{
                            activoNoviembre++;
                        }
                        break;
                   case 12:
                        if(mesDiferencia>TRESMESES){
                            inactivoDiciembre++;
                        }
                        else{
                            activoDiciembre++;
                        }
                        break;
                }
            }   
            hoy=hoy.getFullYear()+"-"+(hoy.getMonth()+1)+"-"+hoy.getDate(); //fecha solo para mostrar

            // add object
            usuariosEstatusObj.push({"activo":activoEnero,"inactivo":inactivoEnero,"mes":"Enero"               });
            usuariosEstatusObj.push({"activo":activoFebrero,"inactivo":inactivoFebrero,"mes":"Febrero"         });
            usuariosEstatusObj.push({"activo":activoMarzo,"inactivo":inactivoMarzo,"mes":"Marzo"               });
            usuariosEstatusObj.push({"activo":activoAbril,"inactivo":inactivoAbril,"mes":"Abril"               });
            usuariosEstatusObj.push({"activo":activoMayo,"inactivo":inactivoMayo,"mes":"Mayo"                  });
            usuariosEstatusObj.push({"activo":activoJunio,"inactivo":inactivoJunio,"mes":"Junio"               });
            usuariosEstatusObj.push({"activo":activoJulio,"inactivo":inactivoJulio,"mes":"Julio"               });
            usuariosEstatusObj.push({"activo":activoAgosto,"inactivo":inactivoAgosto,"mes":"Agosto"            });
            usuariosEstatusObj.push({"activo":activoSeptiembre,"inactivo":inactivoSeptiembre,"mes":"Septiembre"});
            usuariosEstatusObj.push({"activo":activoOctubre,"inactivo":inactivoOctubre,"mes":"Octubre"         });
            usuariosEstatusObj.push({"activo":activoNoviembre,"inactivo":inactivoNoviembre,"mes":"Noviembre"   });
            usuariosEstatusObj.push({"activo":activoDiciembre,"inactivo":inactivoDiciembre,"mes":"Diciembre"   });
        }

    function startChartsDataAdmin()
    {   $.ajax({
            type:'POST',
            data: {id:"14"},
            url: 'Servlet',
            success: function(result){
                topicosGlobalReporte=JSON.parse(result);
            },
            complete: function (){
                $.ajax({
                    type:'POST',
                    data: {id:"15"},
                    url: 'Servlet',
                    success: function(result){                                
                        usuariosCantidadReporte=JSON.parse(result);
                    },
                    complete: function(){
                        codigo_reporte=generateUUID();
                        $.ajax({
                            type:'POST',
                            data: {id:"16"},
                            url: 'Servlet',
                            success: function(result){
                                usuariosEstatusReporte=JSON.parse(result);
                                setUsersActivity();
                            },
                            complete: function (){
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
                                            success: function(result){}
                                        });            
                                        initStatView();
                                    }
                                });
                            }
                        });
                    }
                });
            }
        });
    }
        
    function consultarValidarReporte()
    {   codigo_reporte=cookies;
        $.ajax({
            type:'POST',
            data: {codigo_reporte:codigo_reporte,id:"7"},
            url: 'UploadFile',
            success: function(result){ 
                console.log("resultado:"+result);
                if(result==="null"||result===null){
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
                                    topicosGlobalReporte=array[0];
                                    usuariosCantidadReporte=array[1];
                                    usuariosEstatusObj=array[2];
                                    try{
                                        topicosGlobalReporte=JSON.parse(topicosGlobalReporte);
                                        usuariosCantidadReporte=JSON.parse(usuariosCantidadReporte);
                                        usuariosEstatusObj=JSON.parse(usuariosEstatusObj);
                                    }catch(e){}
                                    initStatView();
                                }
                            }
                        }); 
                    }
                 }
        }); 
    }
        
    function saveReport(){
        stringcontodaladatadelosobjetos= JSON.stringify(topicosGlobalReporte) +
        "666" + JSON.stringify(usuariosCantidadReporte) + "666" + 
         JSON.stringify(usuariosEstatusObj); 
    }
    
    eliminarCookie();
    </script>
    </body>
</html>
