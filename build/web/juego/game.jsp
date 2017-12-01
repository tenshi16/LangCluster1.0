<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <!--    LangCluster - Juego    -->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="../CookieControl.js"></script>
        <script src="../codebase/webix.js"></script>
        <script src="../jquery-1.12.4.min.js"></script>
        <script src="imagen.js"></script>
        <script src="audio.js"></script>
        <script src="vocabulario.js"></script>
        <link rel="shortcut icon" type="image/ico" href="../img/favicon.ico" />
        <title>LangCluster</title>
        <style>
            .webix_slider_box .webix_slider_handle{
                background-color:rgba(189,224,244,0);
                margin-top: -10px;
                border:0;
            }
            .webix_slider_box .webix_slider_left{height:30px;border:1px solid #ccc;background:#5FCC67}
            .webix_slider_box .webix_slider_right{height:30px;background:rgba(1,1,1,0);}
            .blue{
                background-color:rgba(189,224,244,1);
            }
            .bar{
                background-image:url("../img/Juego/bar.png");
                background-attachment:fixed;
            }
            .text{
                background:rgba(189,224,244,0.2);
            }
        </style>
    </head>
    <body>
    <script>
        var data=[],datadetail,n,points=0,studiedphrases=[],TOTAL=0,error=0,c=0;
        var avance= [];
        var fails=0;
        var topic,iso=getCookie("LANG");   //Dependerán de cookies:
        var tipos;
        var subtipo;
        var option = new Array();
        var startTime,startDate;
        var d = new Date();
        var ini,final;
        var paso;
        var mix = ['1','2','3','1','2','3','1','2','3','1','2','3','1','2','3','1','2','3','1','2','3'];
        var newmix;
        
        access();
        function access(){
                var cookie = getCookie("username");
                if (cookie == "" || cookie == null){
                    webix.ui({
                        id:"access0",
                        rows:[
                                { template:"<center><br/><br/><br/>"
                                    +"<img src='../img/LangCluster.png'/>"
                                    +"<br/><br/><br/>"
                                    +"Estimado usuario, debe iniciar sesión para acceder a esta sección.</center>" }
                        ]
                    });
                }
                else{
                    start();
                }
            }
        
        
        function start(){
            option=getCookie("juego").split(',');
            /*
             * option[0] Nivel Actual 1,2,3....
             * option[1] TIPO DE ACTIVIDAD : Audio 1, Imagenes 2, Vocabulario 3, Mixto 4
             * option[2] NUEVO 1 , REPASO 0
             * option[3] TOPICO
             */ 
            topic=option[3];
            if (option === "" || option === null){
                webix.confirm({
                    title:"¡Ha ocurrido un error!",
                    type:"alert-error",
                    text:"Error: Ha ocurrido un error al intentar iniciar su juego. Por favor inténtelo nuevamente.<br/><br/>",
                    callback:function(){
                        history.back();
                    }
                });
            }
            else{
                studiedphrases=new Array(); TOTAL=0;
                console.log(option[2]);
                if(option[2] === "1"){// nuevo juego
                    $.ajax({
                        type:'POST',
                        data: {topic:topic,iso:iso,id:"NewGame"},
                        url: '../Servlet',
                        success: function(result){
                            var length=0;
                            try{data=JSON.parse(result);
                                length=data.length;
                            }catch(error){}
                            if(length<20){
                                $.ajax({
                                    type:'POST',
                                    data: {topic:1, iso:iso, number:(20-length), id:"CompleteNewGame"},
                                    url: '../Servlet',
                                    success:function(result){
                                        if(!result || 0 === result.length){
                                            data=null;
                                        }else{
                                            var x=JSON.parse(result);
                                            for(var i=length;i<length+x.length;i++){
                                                data[i]=x[i-(length)];
                                            }
                                        }
                                    },
                                    complete: function(){
                                        startComplete();
                                    }
                                });
                            }
                            else{
                                startComplete();
                            }
                        }
                    });
                }
                else{
                    var user=getCookie("username");
                    //var user="Integer.sem@Praesentluctus.co.uk";
                    $.ajax({
                        type:'POST',
                        data: {user:user, iso:iso, topic:1, id:"ReviewGame"},
                        url: '../Servlet',
                        success:function(result){
                            if(!result || 0 === result.length){
                                data=null;
                                webix.confirm({
                                    title:"¡Ha ocurrido un error!",
                                    type:"alert-error",
                                    text:"Debe realizar una sesión de juego nuevo antes de poder repasar.<br/><br/>Si considera que esto se trata de un error, por favor, intente acceder nuevamente.",
                                    callback: function(){
                                        history.back();
                                    }
                                });
                            }else{
                                data=JSON.parse(result);
                                if(data.length<20){
                                    $.ajax({
                                        type:'POST',
                                        data: {topic:1, iso:iso, number:(20-data.length), id:"CompleteReviewGame"},
                                        url: '../Servlet',
                                        success:function(result){
                                            if(!result || 0 === result.length){
                                                data=null;
                                            }else{
                                                var x=JSON.parse(result);
                                                var length=data.length;
                                                for(var i=length;i<length+x.length;i++){
                                                    data[i]=x[i-(length)];
                                                }
                                            }
                                        },
                                        complete: function(){
                                            startComplete();
                                        }
                                    });
                                }
                                else{
                                    startComplete();
                                }
                            }
                        }
                    });
                }//Modo de juego Repaso o nuevo
                //Capturar el tipo de juego y llamar a las funciones correspondientes
                
            }
        }
        
        function startComplete(){
            console.log(JSON.stringify(data));
            TOTAL=20;
            $.ajax({
                type:'POST',
                data: {topic:topic, id:"Game2"},
                url: '../Servlet',
                success: function(result){
                    if(!result || 0 === result.length){
                        webix.message("error 2 - Datadetail=null");
                    }
                    else{
                        datadetail=JSON.parse(result);
                        n=0;
                        loadlabels();
                        $$("slider").setValue(0);
                    }
                }
            });
            startDate=new Date();
            startTime=startDate.getHours()+":"+startDate.getMinutes()+":"+startDate.getSeconds();
            startDate=startDate.getFullYear()+"-"+startDate.getMonth()+"-"+startDate.getDate();
        }
        
        var labels;
        function loadlabels(){
            labels=new Array();var aux=true;
            if(studiedphrases.length==19) n=data.length-1;
            else if(studiedphrases.length>=15){
                    n=Math.floor((Math.random() * 15) + 1);
                }else{
                    for(var i=0;i<studiedphrases.length;i++){
                        if(data[n].termino===studiedphrases[i]){
                            aux=false;
                            break;
                        }
                    }
                }
            if(aux){
                setCookie("phrase",data[n].id_termino,1);
                studiedphrases.push(data[n].termino);
                var array=data[n].termino.split(" ");
                for(var i=0;i<array.length;i++){
                    labels.push({
                        id:"word"+i,
                        view:"label",
                        label:array[i].toString(),
                        value:array[i].toString().replace("!","").replace("?",""),
                        autowidth:true,
                        borderless:true, 
                        click:function(id){
                            try{$$("pop").hide();}catch(error){}
                            var word=this.getValue(),base="",iso="";
                            var words;
                            for(var j=0;j<datadetail.length;j++){
                                words=new Array();
                                for(var k=0;k<datadetail.length;k++){
                                    if(datadetail[k].palabra.toLowerCase()===word.toLowerCase()){
                                        words.push(datadetail[k].palabraes);
                                    }
                                }
                                var uniquewords=[];
                                $.each(words, function(i, el){
                                    if($.inArray(el, uniquewords) === -1) uniquewords.push(el);
                                });
                                if(datadetail[j].palabra.toLowerCase()===word.toLowerCase()){
                                    word=uniquewords.join("; ");
                                    iso=datadetail[j].iso;
                                    if(datadetail[j].tipo.toUpperCase()==="VER"){
                                        base=datadetail[j].palabra_base;
                                    }
                                    break;
                                }
                            }
                            var popbody=new Array();
                            if(base.trim()!==""){
                                $.ajax({
                                    type:'POST',
                                    data: {word:base, id:"Game3"},
                                    url: '../Servlet',
                                    success: function(result){
                                        var translation=JSON.parse(result);
                                        var form0=new Array(),form1=new Array(),form2=new Array(),form3=new Array();
                                        $.ajax({
                                            type:'POST',
                                            data: {verb:base, iso:iso, type:"0"},
                                            url: '../Declinator',
                                            success: function(result){
                                                var json=JSON.parse(result);
                                                for(var k=0;k<json.length;k++){
                                                    if(k<6)
                                                        form0.push({template:json[k],autoheight:true, autowidth:true});
                                                    else if(k<12)
                                                        form1.push({template:json[k],autoheight:true, autowidth:true});
                                                    else if(k<18)
                                                        form2.push({template:json[k],autoheight:true, autowidth:true});
                                                    else form3.push({template:json[k],autoheight:true, autowidth:true});
                                                }
                                            },
                                            complete: function(){
                                                webix.ui({
                                                    view:"popup",
                                                    id:"pop",
                                                    body:{
                                                        rows:[
                                                            {template:function(){
                                                                        var text="<center><strong>"+base.toUpperCase()+"</strong> : ";
                                                                        var esp=new Array();
                                                                        for(var k=0;k<translation.length;k++){
                                                                            esp.push(translation[k].palabraes.toUpperCase());
                                                                        }
                                                                        var uniquewords=[];
                                                                        $.each(esp, function(i, el){
                                                                            if($.inArray(el, uniquewords) === -1) uniquewords.push(el);
                                                                        });
                                                                        text+=uniquewords.join("; ")+"</center>";
                                                                        return text;
                                                                    },autoheight:true, autowidth:true, css:"blue"},
                                                            {rows:[{cells:[{id:"form0",rows:form0},
                                                                           {id:"form1",rows:form1},
                                                                           {id:"form2",rows:form2},
                                                                           {id:"form3",rows:form3}
                                                                  ]}]},
                                                            {view:"tabbar", type:"bottom", multiview:true,tabMinWidth:20, options: [
                                                                    { value: "PRE", id: 'form0'},
                                                                    { value: "PAS", id: 'form1' },
                                                                    { value: "FUT", id: 'form2' },
                                                                    { value: "OTROS", id: 'form3' }
                                                            ],height:30}
                                                        ]
                                                    }
                                                }).show($$(id).getNode());
                                            }
                                        });
                                    }
                                });
                            }
                            else{
                                popbody.push({template:"<em>"+word+"</em>",autoheight:true, autowidth:true});
                                webix.ui({
                                    view:"popup",
                                    id:"pop",
                                    body:{
                                        rows:popbody
                                    }
                                }).show($$(id).getNode());
                            }
                        }
                    });            
                }
                try{$$("page").destructor();
                }catch(error){}
                gameType();
                load();
            }
            else{
                n++;
                loadlabels();
                try{    $$("slider").setValue(studiedphrases.length);
                }catch(error){}
            }
        }
        
        function gameType(){
            console.log("option[1]= "+option[1]+", termino="+data[n].termino+", id="+data[n].id_termino);
            newmix=shuffle(mix);
            if(n!==20){
                if(option[1] === "1"){
                   tipos = audio(data[n],datadetail[n]);
                }
                if(option[1] === "2"){
                   tipos = imagen(data[n]);
                }
                if(option[1] === "3"){
                   tipos = voca(data[n],datadetail[n]);
                }
                if(option[1] === "4"){
                    c++;
                    console.log("newmix= "+newmix.toString());
                    console.log("n= "+c);
                    if(newmix[c]==="1"){
                        tipos = audio(data[n],datadetail[n]);
                    }
                    if(newmix[c]==="2"){
                        tipos = imagen(data[n]);
                    }
                    if(newmix[c]==="3"){
                        tipos = voca(data[n],datadetail[n]);
                    }
                }
            }
        }
        
        function load(){
            webix.ui({
                id:"page",
                cols:[{width:100},
                      { rows:[{height:20},
                              {//Barra Superior
                                cols:[{width:40},
                                      { view:"label",label:"<strong>Frases Nuevas:</strong>",css:"text"},
                                      { id:"newphrases",view:"label",label: TOTAL},
                                      {width:20},
                                      { view:"label",label:"<strong>Por Repasar:</strong>",css:"text"},
                                      { id:"remainingphrases",view:"label",label:(TOTAL-studiedphrases.length)},
                                      {width:20},
                                      { view:"label",label:"<strong>Puntos:</strong>",css:"text"},
                                      { id:"points",view:"label",label: points},
                                      {width:40}
                                ],css:"bar"
                              },
                              { cols:[{width:40},
                                      {height:60,id:"slider", view:"slider", label:"Progreso:", value:"0", min:0,  max: TOTAL,on:{
                                                onSliderDrag:function(){
                                                        $$("slider").setValue(studiedphrases.length);
                                                    },
                                                onChange:function(){
                                                        $$("slider").setValue(studiedphrases.length);
                                                   }
                                             }
                                      },
                                      {width:40}
                                ],css:"bar"
                              },
                              {height:20},

                              //MODIFICAR A PARTIR DE AQUÍ SEGÚN EL CONTENIDO DE SU SECCIÓN DEL JUEGO (Excepto el id)

                              {
                                  rows:[{
                                        cols:[
                                            {},
                                            {id:"phrase",view:"label",label:"<strong>Frase: </strong>",borderless:true},
                                            {id:"wordscroll",
                                             view:"scrollview",
                                             scroll:"false",
                                             body:{
                                                cols:labels //Frase descompuesta en labels
                                             },
                                             borderless:true
                                            },
                                            {}
                                        ],height:40},
                                        {id:"tradu",template:"<strong>Traducción: </strong>"+data[n].terminoes,borderless:true,autoheight:true},
                                        {cols:[tipos]} // JUEGO
                                    ]
                            },
                            {},
                            {   cols:[{width:20},
                                      { view: "button", value:"Salir",
                                            click:function(){
                                                webix.confirm({
                                                    title:"¡Atención!",
                                                    type:"alert-warning",
                                                    ok:"Sí", 
                                                    cancel:"No",
                                                    text:"¿Está seguro de que desea abandonar el juego?<br/><br/>¡Perderá todo su progreso!",
                                                    callback:function(answer){
                                                        if(answer == true){
                                                            eraseCookie("phrase",data[n].termino);
                                                            history.back();
                                                        }
                                                    }
                                                });
                                            }
                                      },
                                      {},
                                      { id:"Check",view: "button", value:"Corregir", hotkey: "enter",
                                            click:methodvalue
                                       },
                                       {width:20}
                                     ]
                            },
                            {height:20}
                        ]
                    },
                    {width:100}
                ]
            });
            if(subtipo==="A1" || subtipo==="A2" || subtipo==="A3" || 
               subtipo==="V1" || subtipo==="V2" || subtipo==="V3" || subtipo==="V4"){
               $$("phrase").hide();
               $$("wordscroll").hide();
               $$("tradu").hide();
            }
            if(subtipo==="V1" || subtipo==="V2" || subtipo==="V3" || subtipo==="V4"){
                $$("tradu").show();
            }
            if(subtipo==="T1" || subtipo==="T2"){
               $$("phrase").hide();
               //$$("wordscroll").hide();
               $$("tradu").hide();
            }
            try{$$("textIn").focus();}catch(error){} //Hace el focus en caso de encontrar ese campo para escribir
            ini=new Date().getTime();
        }
        
    var parar=false;
    click:function methodvalue(){
        console.log("entro= "+newmix[c]);
        console.log("subtipo= "+subtipo);
        if(option[1]==="1" || newmix[c]==="1"){ //audio
            if(subtipo==="A1" || subtipo==="A3" || subtipo==="A4" || subtipo==="A2" ){
                paso=Post();
                if(parar===false) Verify(paso);
            }
        }
        if(option[1]==="2" || newmix[c]==="2"){ //image
            if(subtipo==="T2"){
                paso=Post1();
                if(parar===false) Verify(paso);
            }else{ // Clic en botones. paso lo pasa a true para poder corregir por boton.
            paso=false;
            Verify(paso);
            }
         }
        if(option[1]==="3" || newmix[c]==="3"){//voca
            if(subtipo==="V3" || subtipo==="V4" || subtipo==="V2" ){
                paso=Post2();
                if(parar===false)Verify(paso);
            }
        }
    }
            
    function shuffle(array) {
        var counter = array.length;

        // While there are elements in the array
        while (counter > 0) {
            // Pick a random index
            var index = Math.floor(Math.random() * counter);

            // Decrease counter by 1
            counter--;

            // And swap the last element with it
            var temp = array[counter];
            array[counter] = array[index];
            array[index] = temp;
        }
        return array;
    }
        
    function Verify(paso){
        console.log("Verifying "+data[n].termino);
        d = new Date();
        final=new Date().getTime();
        var tiempo= final-ini;
        console.log("calculo= "+tiempo+" paso= "+paso);
        if(n!==data.length-1){
         //if(n!==data.length-13){
            acu(data[n].id_termino, tiempo, paso);
            n++;
            loadlabels(true);
            $$("slider").setValue(studiedphrases.length);
        }
        else{
            acu(data[n].id_termino, tiempo, paso);
            //console.log("av= "+JSON.stringify(avance));
            $$("Check").hide();
            $$("slider").setValue(studiedphrases.length+1);
            var endDate = new Date();
            var endTime=endDate.getHours()+":"+endDate.getMinutes()+":"+endDate.getSeconds();
            endDate=endDate.getFullYear()+"-"+endDate.getMonth()+"-"+endDate.getDate();
            $.ajax({
                type:'POST',
                data: {username:getCookie("username"),p1:JSON.stringify(avance), id:"send"},
                url: '../Servlet',
                success: function(result){
                    $.ajax({
                        type:'POST',
                        data: {username:getCookie("username"),topic:topic,
                               p1:JSON.stringify(avance),
                               startDate:startDate,startTime:startTime,
                               endDate:endDate,endTime:endTime,
                               points:points,fails:fails,
                               id:"EndGame"},
                        url: '../Servlet',
                        success: function(result){
                                if(!result || 0 === result.length){
                                    $$("Check").show();
                                    webix.alert("Lo sentimos ha ocurrido un problema enviando los resultados.");
                                }else{
                                    Resu();
                                }
                        }
                    });
                }
            });
        }
    }//funcion   
    
    var finded = new Array();
    function acu(id, t, paso){
        var find=false;
        if(paso===false){
            fails++;
            points--;
            for(var i=0;i<avance.length;i++){
                  if(avance[i].termino===data[n].id_termino){
                     avance[i].error=avance[i].error+1;
                     break;
                  }else{
                        find=true;
                  }
            }
            if(find===true){
                avance.push({
                    termino: id,
                    tiempo: t,
                    error: 1
               });
               find=true;
            }
            if(avance.length===0){
                avance.push({
                    termino: id,
                    tiempo: t,
                    error: 1
                });
            }            
       }else{
            points++;
            for(var i=0;i<avance.length;i++){
                if(avance[i].termino===data[n].id_termino){
                    avance[i].error=avance[i].error-1;
                    if(avance[i].error.toString().includes("-")) avance[i].error=0;
                    break;
                }else{
                    find=true;
                }
            }
            
            if(find===true){
                avance.push({
                    termino: id,
                    tiempo: t,
                    error: 0
                });
                find=true;
            }
            
            if(avance.length===0){
                avance.push({
                     termino: id,
                     tiempo: t,
                     error: 0
                });
            }  
       }
    }
    
    function Resu(){
        try{
            $$("iconos1").disable();
            $$("iconos2").disable();
        }catch(error){} 
       
        webix.ui({
                 view:"window",
                 id:"Resul",
                 height:500,
                 width:500,  
                 head:"<strong>Resultados</strong>",
                 position:"center",
                     body:{
                        rows:[
                            {cols:[
                                {view:"button", type:"image", image:"../img/Nave2.png", borderless: true},
                                {rows:[
                                      {view:"label", label:"Puntaje acumulado:", align:"left"},
                                      {view:"label", label:points, align:"left"},
                                      {template:"<hr width=\"90%\" size=\"2\" noshade>"},
                                      {view:"label", label:"Errores:", align:"left"},
                                      {view:"label", label:fails, align:"left"},
                                      {template:"<hr width=\"90%\" size=\"2\" noshade>"},
                                      {view:"label", label:"Precisión:", align:"left"},
                                      {view:"label", label:(100-((fails*100)/20))+"%", align:"left"}
                                ]}
                            ]},
                         {cols:[{},
                              {view:"button",value:"Aceptar", click: function(){
                                       window.open("const/C"+option[0]+".jsp","_self");
                                       $$("Resul").hide;
                                 }
                              },{}]}
                     ]}
            }).show();
    }
    
    </script>
    </body>
</html>