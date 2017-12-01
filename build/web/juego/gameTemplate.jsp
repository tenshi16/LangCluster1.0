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
        <link rel="shortcut icon" type="image/ico" href="../img/favicon.ico" />
        <title>LangCluster</title>
        <style>
            .webix_slider_box .webix_slider_handle{
                /*margin-left: -100px;*/
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
                /*background-color:rgba(189,224,244,0.5);*/
            }
            .text{
                background:rgba(189,224,244,0.2);
                /*-webkit-text-stroke: 2px;
                -webkit-text-stroke-width: 1px;
                -webkit-text-stroke-color: black;*/
            }
        </style>
    </head>
    <body>
    <script>
        /*  INICIO - NO MODIFICAR EL SIGUIENTE CÓDIGO (HASTA LA ETIQUETA "FIN")
        
            COPIAR Y PEGAR EXACTAMENTE COMO ESTÁ EN TODAS LAS VENTANAS DEL JUEGO
        
            EL CSS TAMBIÉN ES NECESARIO (Usado por la ventana de conjugaciones)
        
            ----------------------------------------------------------------------
        
            El json DATA posee los siguientes atributos:
            TERMINOES: Traducción completa en español. Sería la respuesta correcta.     Ej. ¿Qué hora es?
    
            ID: Simple control interno.
    
            TERMINO: Frase a aprender, completar, traducir o lo que sea.                Ej. What time is it?
            
            ----------------------------------------------------------------------
            
            El json DATADETAIL posee los siguientes atributos:
            "tipo":"null","palabra":"the","iso":"EN","genero":"null","palabra_base":"null","palabraes":"el/la","id":187
            TIPO: Filtra si la palabra es verbo, sustantivo, adjetivo... Actualmente sólo filtra verbos.
                  Es una enumeración que siempre devolverá VER, SUS, ADJ o null de ser otra cosa (A nadie le interesa controlar conectivos, pronombres o algo así hasta ahora)
    
            PALABRA: Palabra específica en inglés. Ej. What.
    
            ISO:  ISO del idioma al que se corresponde la palabra, para filtrado interno y del Servlet (Así sabe en base a qué idioma conjugar)
    
            GENERO: Para futuros usos, cuando si manejemos sustantivos, adjetivos y eso... En inglés en realidad da igual y siempre devuelve null.
    
            PALABRA_BASE: En caso de que sea un verbo devuelve el infinitivo de éste. Esto existe para ser enviado al servlet que lo conjuga.
                  Ej. La palabra "Are" tiene palabra_base="be". Así el Servlet Declinator sabe que debe conjugar "be" y no "are".
    
                  Si el verbo está en infinitivo, simplemente tendrá el mismo registro dos veces:
                  Ej. "Sing" tiene palabra_base="sing".
    
                  Si la palabra no es un verbo, devolverá null.
                  Nota: (a largo plazo también servirá para adjetivos, tal vez sustantivos compuestos...)
    
            PALABRAES: Traducción de una palabra específica.
                  Ej. "Qué" si la palabra es "What."
                      "tiempo/hora" si es "time".
                      "ser/estar" si e "be, is, are" o sus derivados.
        
            ----------------------------------------------------------------------
            n es la frase actual... Basícamente el juego siempre llama a data[n] y datadetail[n] pues.
            Cuando toque la siguiente frase, simplemente hagan un n++ y a continuación llamen a loadlabels();
            Pueden ver esto más detalladamente en el botón >, al fin.
            ----------------------------------------------------------------------
       
            Las consultas necesarias para obtener estos datos están en Servlet, con los id Game1,Game2 y Game3, tal que:
            Game1: Devuelve los datos de DATA.
            Game2: Devuelve los datos de DATADETAIL
            Game3: Devuelve la traducción de un verbo (Sólo aplica para la ventana de las conjugaciones).
        */
       
        var data,datadetail,n,topic=1,points=0,studiedphrases=[],TOTAL=0;
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
                    //start() simplemente rellena DATA y DATADETAIL e inicializa n=0;
                    //Cabe destacar que las frases si se podrían escoger random y eso, pero para motivos de prueba, empieza en la primera y sigue el orden normal.
                }
            }
        
        function start(){
            studiedphrases=new Array(); TOTAL=0;
            $.ajax({
                type:'POST',
                data: {topic:topic, id:"Game1"},
                url: '../Servlet',
                success: function(result){
                    if(!result || 0 === result.length){
                        webix.message("error 1 - Data=null");
                    }
                    else{
                        //console.log(result);
                        data=JSON.parse(result);
                        var auxT=[],uniquewords=[];
                        for(var i=0;i<data.length;i++){
                            auxT.push(data[i].termino);
                        }
                        $.each(auxT, function(i, el){
                            if($.inArray(el, uniquewords) === -1) uniquewords.push(el);
                        });
                        TOTAL=uniquewords.length;
                        $.ajax({
                            type:'POST',
                            data: {topic:topic, id:"Game2"},
                            url: '../Servlet',
                            success: function(result){
                                if(!result || 0 === result.length){
                                    webix.message("error 2 - Datadetail=null");
                                }
                                else{
                                    //console.log(result);
                                    datadetail=JSON.parse(result);
                                    n=0;
                                    loadlabels(true);
                                    $$("slider").setValue(0);
                                }
                            }
                        });
                    }
                }
            });
        }
        
        var labels;
        //loadlabels() [Llamado por el método anterior si todo está bien] crea un label por cada palabra constituyente de una frase.
        //Es decir que descompone What time is it en 4 labels: WHAT, TIME, IS, IT.
        //Eso permite que cada palabra tenga una ventana aparte que diga su traducción y/o conjugación sin mezclarse con las demás.
        //labels es el arreglo completo que llamarían en su ui (Su uso está explicado al final de esta página, en el ui)
        function loadlabels(next){
            labels=new Array();var aux=true;
            //console.log("n="+n);
            for(var i=0;i<studiedphrases.length;i++){
                if(data[n].termino===studiedphrases[i]){
                    //console.log("estudiada, saltando");
                    aux=false;
                    break;
                }
            }
            if(aux){
                studiedphrases.push(data[n].termino);
                var array=data[n].termino.split(" ");
                for(var i=0;i<array.length;i++){
                    //console.log(array[i]);
                    labels.push({
                        id:"word"+i,
                        view:"label",
                        label:array[i].toString(),
                        value:array[i].toString().replace("!","").replace("?",""),
                        autowidth:true,
                        borderless:true, 
                        click:function(id){
                            //Los popup se cierran con un clic, así que si hay un popup abierto lo cierra antes de continuar.
                            //Sin esto, al cambiar de palabra tendrías que hacer dos clics: Uno para cerrar el popup anterior
                            //y otro para crear el de la nueva palabra con la que tienes dudas, esto lo hace por ti.
                            try{$$("pop").hide();}catch(error){}
                            var word=this.getValue(),base="",iso="";
                            var words;
                            //console.log("CLICK ON "+word.toLowerCase());
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
                                    //console.log("palabra: "+word+" | BASE = "+datadetail[j].palabra_base);
                                    iso=datadetail[j].iso;
                                    if(datadetail[j].tipo.toUpperCase()==="VER"){
                                        base=datadetail[j].palabra_base;
                                    }
                                    break;
                                }
                            }
                            var popbody=new Array(); //INTERIOR DE POPUP
                            if(base.trim()!==""){  //ES UN VERBO, LA BASE ES ="VER"
                                $.ajax({
                                    type:'POST',
                                    data: {word:base, id:"Game3"},
                                    url: '../Servlet',
                                    success: function(result){
                                        var translation=JSON.parse(result); //Traducción del verbo.
                                        //console.log(JSON.stringify(translation));
                                        var form0=new Array(),form1=new Array(),form2=new Array(),form3=new Array();
                                        $.ajax({
                                            type:'POST',
                                            data: {verb:base, iso:iso, type:"0"},
                                            url: '../Declinator',
                                            success: function(result){
                                                var json=JSON.parse(result);
                                                //PRESENTE-PASADO-FUTURO-OTROS (Un form para c/u). Organiza los pronombres para cada uno (6 porque son: I, You, He/She/It, We, You y They)
                                                //Esto también se personalizaría según el iso a largo plazo... por persona, por tiempo y/o forma según el idioma.
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
                                                }).show($$(id).getNode());  //MOSTRAR JUSTO EN LA PALABRA CLICKEADA
                                            }
                                        });
                                    }
                                });
                            }
                            else{   //NO ES UN VERBO, SÓLO MUESTRA LA TRADUCCIÓND DE LA PALABRA
                                popbody.push({template:"<em>"+word+"</em>",autoheight:true, autowidth:true});
                                webix.ui({
                                    view:"popup",
                                    id:"pop",
                                    body:{
                                        rows:popbody
                                    }
                                }).show($$(id).getNode());  //MOSTRAR JUSTO EN LA PALABRA CLICKEADA
                            }
                        }
                    });            
                }
                try{$$("page").destructor();    //Excepción: Modificar "page" por el id que le pusiesen al .ui de su sección del juego.
                                                //O le dejan todos page y se despreocupan, da igual.
                }catch(error){}
                load();
            }
            else{
                if(next)    n++;
                else{
                    n--;
                }
                loadlabels(next);
                try{
                    $$("slider").setValue(studiedphrases.length);
                }catch(error){}
            }
        }
        //FIN
        
        function load(){
            webix.ui({
                id:"page",
                rows:[{height:20},
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
                      { //Carga
                        cols:[{width:40},
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
                      
                      {//AQUÍ IRÍA SU SECCIÓN DEL JUEGO
                          rows:[{
                            cols:[
                                {id:"phrase",view:"label",label:"<strong>Frase: </strong>",borderless:true},
                                {id:"wordscroll",
                                 view:"scrollview",
                                 scroll:"false",
                                 body:{
                                    cols:labels                     //Frase como tal, ya filtrada con los verbos, traducciones y eso.
                                                                    //Donde quieran poner la frase en su pantalla, simplememente ponen eso en una sección:
                                                                    //....{},{cols: labels},{}....
                                 },
                                 borderless:true
                                },
                                //Controles temporales
                                {view: "button", value:"<", click:function(){
                                        if(n!=0){
                                            points--;
                                            n--;
                                            loadlabels(false);
                                            $$("slider").setValue(studiedphrases.length);
                                        }
                                    }
                                },
                                {view: "button", value:">", click:function(){
                                        if(n!=data.length-1){
                                            points++;
                                            n++;                //Si no es la última, pasa a la siguiente frase.
                                                                //Aquí se validaría que si es la última ganó el juego y guarda los datos, por ejemplo.
                                                                //Lógicamente, no usaría un botón > sino la tecla enter o algo así.
                                            loadlabels(true);
                                            $$("slider").setValue(studiedphrases.length);
                                        }
                                        else{
                                            webix.message("¡Ganaste!");
                                            $$("slider").setValue(studiedphrases.length+1);
                                        }
                                    }
                                }
                            ],height:40},
                            {template:"<strong>Traducción: </strong>"+data[n].terminoes,borderless:true},
                            //Otro control temporal
                            {cols:[{id:"phrase",view:"label",label:"<strong>Tópico Actual: </strong>"+topic,borderless:true},
                                   {view: "button", value:"<", click:function(){
                                        if(topic!=1){
                                            topic--;
                                            //Si ocurre un error, cliqueen de nuevo, es que el tópico no tiene términos aún
                                            start();
                                            }
                                        }
                                    },
                                    {view: "button", value:">", click:function(){
                                        if(topic!=36){
                                            topic++;
                                            //Si ocurre un error, cliqueen de nuevo, es que el tópico no tiene términos aún
                                            start();
                                            }
                                        }
                                    },
                                    { view: "button", value:"Probar Consultas", click:function(){
                                        window.open("gameTest.jsp", "_self");
                                        }
                                    },
                                    { view: "button", value:"Nuevo Juego", click:function(){
                                            setCookie("game","NUEVO",1);
                                            window.open("game.jsp", "_self");
                                        }
                                    },
                                    { view: "button", value:"Juego de Repaso", click:function(){
                                            setCookie("game","REPASO",1);
                                            window.open("game.jsp", "_self");
                                        }
                                    }
                                  ]
                            }
                        ]
                    }
                ]
            });
        }
        /*function load(){
            webix.ui({
                id:"page",
                rows:[{
                    cols:[
                        {id:"phrase",view:"label",label:"<strong>Frase: </strong>"},
                        {id:"wordscroll",
                         view:"scrollview",
                         scroll:"false",
                         body:{
                            cols:labels                     //Frase como tal, ya filtrada con los verbos, traducciones y eso.
                                                            //Donde quieran poner la frase en su pantalla, simplememente ponen eso en una sección:
                                                            //....{},{cols: labels},{}....
                         }
                        },
                        //Controles temporales
                        {view: "button", value:"<", click:function(){
                                if(n!=0){n--;}
                                loadlabels(n);

                            }
                        },
                        {view: "button", value:">", click:function(){
                                if(n!=data.length-1){n++;}  //Si no es la última, pasa a la siguiente frase.
                                                            //Aquí se validaría que si es la última ganó el juego y guarda los datos, por ejemplo.
                                                            //Lógicamente, no usaría un botón > sino la tecla enter o algo así.
                                loadlabels(n);
                            }
                        }
                    ],height:40},
                    {template:"<strong>Traducción: </strong>"+data[n].terminoes},
                    //Otro control temporal
                    {cols:[{id:"phrase",view:"label",label:"<strong>Tópico Actual: </strong>"+topic},
                           {view: "button", value:"<", click:function(){
                                if(topic!=1){
                                    topic--;
                                    //Si ocurre un error, cliqueen de nuevo, es que el tópico no tiene términos aún
                                    start();
                                    }
                                }
                            },
                            {view: "button", value:">", click:function(){
                                if(topic!=36){
                                    topic++;
                                    //Si ocurre un error, cliqueen de nuevo, es que el tópico no tiene términos aún
                                    start();
                                    }
                                }
                            }
                          ]
                    }
                ]
            });
        }
        */
    </script>
    </body>
</html>
