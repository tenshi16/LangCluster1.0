var Vgame;
var Vanswer;
var Vobja= new Array();
var Vruta;
var Vtraduc= new Array();
var VterminoG;
var VpalabraACompletar;

function voca(Term,Detail){
    var id_term=Term.id_termino;
    Vtraduc = new Array();
    $.ajax({
        type:'POST',
        data:{terminoID:id_term,id:"ImagesT2"},
        url:'../Servlet',
        async:false,
        success:function(result){
            Vobja = JSON.parse(result);
            console.log("Traduc= "+JSON.stringify(Vobja));
            for(var i=0;i<Vobja.length;i++){
                Vtraduc.push(Vobja[i].terminoes);
            }
        }
    });
     
    var z=Math.floor(Math.random() * 3) + 1 ;
    console.log("random voca= "+z);
    Vtipo(z,Term,Detail); //aca 3 MAS FACIL
    return Vgame;
}

function Vtipo(tipo,termino,datadetail){
    if (tipo===1){
        Juego2(termino,datadetail);
    }
    if (tipo===2){
        VterminoG=termino;
        Juego3(termino,datadetail);
    }
    if (tipo===3){
        Juego4(termino);
    }
}

function Juego2(term,datadetail){
    subtipo="V2";
    var cantidadDeVerbosOSustantivos=0;
    var indexDeVerboOSustantivo= new Array();
    var cantidadDePalabras=term.termino.split(/\s+/).length;
    var terminoArray=term.termino.split(/\s+/);
    var labels=new Array();
    var aux;
    var richSelect=new Array();
    
    console.log(terminoArray);
    $.ajax({
        type:'POST',
        data:{terminoId:term.id_termino,id:"audio3"}, //busca las palabras del array con su "tipo"
        url:'../Servlet',
        async:false,
        success:function(result){
            Vobja=JSON.parse(result);
            console.log("resultado"+result);
            console.log("cantidad de palabras:"+cantidadDePalabras);
        },
        complete:function(){ 
            for(var i=0;i<cantidadDePalabras;i++){  
                console.log(i+"...");
                console.log(Vobja[i].tipo);
                if(Vobja[i].tipo==="VER" || Vobja[i].tipo==="SUS"){ // Si el tipo es un sustantivo o Verbo guarda el index de cada uno así como la cantidad
                    cantidadDeVerbosOSustantivos++;
                    indexDeVerboOSustantivo.push(i);
                }
            }
            var randz=Math.floor(Math.random() * cantidadDeVerbosOSustantivos) + 1 ; // verbo o sustantivo escogido con rand
            aux=indexDeVerboOSustantivo[randz-1];                                   // aux tiene el index de dicho verbo o sustantivo
            
            for (var i=0;i<cantidadDePalabras;i++){
                if(terminoArray[i].toString().toUpperCase()===Vobja[aux].palabra.toString().toUpperCase()){
                    console.log("____");                                            // Si la palabra evaluada es igual a la escogida con el aux random agregarla a VpalabraACompletar
                    VpalabraACompletar=terminoArray[i];
                }
                else console.log(terminoArray[i]);                  
            }
            
            $.ajax({
                type:'POST',
                data:{VpalabraACompletar:VpalabraACompletar,id:"audio1"}, //busca las palabras del array con su "tipo"
                url:'../Servlet',
                async:false,
                success:function(result){
                    Vobja=JSON.parse(result);
                },
                complete:function(){
                    console.log("cantidad"+cantidadDePalabras);
                    for(var i=0;i<cantidadDePalabras;i++){                          //Llenado de Labels
                    if(terminoArray[i].toString().toUpperCase()===VpalabraACompletar.toString().toUpperCase()){
                        var random=Math.floor(Math.random() * 4);
                        for(var j=0;j<Vobja.length;j++){
                            if(j===random){
                                richSelect.push(VpalabraACompletar);
                            }
                            else richSelect.push(Vobja[j]);    
                        }
                        labels.push({                                                                            // llenar con textview
                            id:"textIn",        //cambiar
                            view:"richselect",
                            options:richSelect
                        });
                        continue;
                    }
                    labels.push({                                                                                   // de lo contrario pushear el resto de palabras como labels
                        id:"word"+i,                                                                            //copypaste salvaje de Diego.
                        view:"label",
                        label:terminoArray[i].toString(),
                        value:terminoArray[i].toString().replace("!","").replace("?",""),
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
                                    aysnc:false,
                                    success: function(result){
                                        var translation=JSON.parse(result);
                                        var form0=new Array(),form1=new Array(),form2=new Array(),form3=new Array();
                                        $.ajax({
                                            type:'POST',
                                            data: {verb:base, iso:iso, type:"0"},
                                            url: '../Declinator',
                                            async:false,
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
                    }//for
                    console.log(labels[0]);
                    console.log(labels[1]); 
                }//complete
            });
        }
    });

    Vgame={rows:[
            {cols:[
                  {},
                    {view:"template",template:"<strong>Selecciona:</strong>",borderless:true},
                    {view:"button",id:"helpButton",value:"?",autowidth:true,click:function(){
                      webix.ui({
                        view:"popup",
                        id:"pop",
                        body:{
                            rows:[{ template:"En este subtipo de juego correspondiente a vocabulario <br> \n\
                                              tendrá la oportunidad de completar la frase seleccionando  \n\
                                              la opción que te parezca más apropiada."
                                ,borderless: true,width:400,autoheight:true}]
                        }
                    }).show(this.getNode());    
                     }
                  },{}
                  ]
            },
            {cols:[
                  {},
                  {id:"wordscrollNEW",view:"scrollview",scroll:"false",
                     body:{
                        cols:labels //Frase descompuesta en labels
                     },borderless:true,width:300,height:45
                  },
                  {}
                  ]
            }
        ]
    };
    return Vgame;
}
       
function Juego3(term,datadetail){
    subtipo="V3";
    var cantidadDeVerbosOSustantivos=0;
    var indexDeVerboOSustantivo= new Array();
    var cantidadDePalabras=term.termino.split(/\s+/).length;
    var terminoArray=term.termino.split(/\s+/);
    var labels=new Array();
    var aux;
    
    console.log(terminoArray);
    $.ajax({
        type:'POST',
        data:{terminoId:term.id_termino,id:"audio3"}, //busca las palabras del array con su "tipo"
        url:'../Servlet',
        async:false,
        success:function(result){
            Vobja=JSON.parse(result);
            console.log(result);
        },
        complete:function(){ 
            for(var i=0;i<cantidadDePalabras;i++){      
                if(Vobja[i].tipo==="VER" || Vobja[i].tipo==="SUS"){ // Si el tipo es un sustantivo o Verbo guarda el index de cada uno así como la cantidad
                    cantidadDeVerbosOSustantivos++;
                    indexDeVerboOSustantivo.push(i);
                }
            }
            var randz=Math.floor(Math.random() * cantidadDeVerbosOSustantivos) + 1 ; // verbo o sustantivo escogido con rand
            aux=indexDeVerboOSustantivo[randz-1];                                   // aux tiene el index de dicho verbo o sustantivo
            for (var i=0;i<cantidadDePalabras;i++){
                if(terminoArray[i].toString().toUpperCase()===Vobja[aux].palabra.toString().toUpperCase()){
                    console.log("____");                                            // Si la palabra evaluada es igual a la escogida con el aux random agregarla a VpalabraACompletar
                    VpalabraACompletar=terminoArray[i];
                }
                else console.log(terminoArray[i]);                  
            }
            
            console.log("cantidad"+cantidadDePalabras);
            for(var i=0;i<cantidadDePalabras;i++){                          //Llenado de Labels
                if(terminoArray[i].toString().toUpperCase()===VpalabraACompletar.toString().toUpperCase()){   //Si la palabra a evaluar es igual a la palabra a Completar
                    labels.push({                                                                            // llenar con textview
                        id:"textIn",
                        view:"text",
                        value:""
                    });
                    continue;
                }
                labels.push({                                                                                   // de lo contrario pushear el resto de palabras como labels
                    id:"word"+i,                                                                            //copypaste salvaje de Diego.
                    view:"label",
                    label:terminoArray[i].toString(),
                    value:terminoArray[i].toString().replace("!","").replace("?",""),
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
            }//for
            console.log(labels[0]);
            console.log(labels[1]);
        }//complete
    });

    Vgame={rows:[
            {cols:[
                  {},
                  {view:"template",template:"<strong>Completa:</strong>",borderless:true},
                  {view:"button",id:"helpButton",value:"?",autowidth:true,click:function(){
                        webix.ui({
                        view:"popup",
                        id:"pop",
                           body:{
                               rows:[{ template:"En este subtipo de juego correspondiente a vocabulario <br/> \n\
                                                 tendrán la oportunidad de completar la frase escribiendo el<br/>\n\
                                                 término faltante en la frase dada."
                                    ,borderless: true,width:400,autoheight:true}]
                           }
                        }).show(this.getNode());    
                        }
                   },
                   {}
                  ]
            },
            {cols:[
                  {},
                  {id:"wordscrollNEW2",view:"scrollview",scroll:"false",
                      body:{
                         cols:labels //Frase descompuesta en labels
                      },
                      borderless:true,width:300,height:45},
                  {}
                  ]     
            }
        ]
    };
    console.log("Vgame"+Vgame);
    return Vgame;
}

function Juego4(term){
    subtipo="V4";
    Vgame={rows:[
            {cols:[
                  {},
                    {iew:"template",template:"<strong>Traduce:</strong>",borderless: true},
                    {view:"button",id:"helpButton",value:"?",autowidth:true,click:function(){
                         webix.ui({
                           view:"popup",
                           id:"pop",
                           body:{
                               rows:[{ template:"En este subtipo de juego correspondiente al de vocabulario <br> \n\
                                                 tendrás la oportunidad de traducir una frase desde el<br/>\n\
                                                 idioma que está estudiando."
                                    ,borderless: true,width:400,autoheight:true}]
                           }
                      }).show(this.getNode());    
                      }
                      },
                      {}
            ]
            },
            {cols:[
                  {},
                  {view:"text",inputAlign:"left",id:"n",value:term.termino,readonly:true}
                  ,{}
            ]
            },
            {cols:[{},{view:"text",id:"textIn",inputAlign:"left"},{}]
        }
        ]
    };
    return Vgame;
}

function Post2(){
    var find=false;
    var poss3="";
        
    if(subtipo==="V2"){//Seleccion
        var In=$$("textIn").getText().toUpperCase();
        poss3=VpalabraACompletar;
        if(In===VpalabraACompletar.toUpperCase()){
            find=true;
        }
    }

    if(subtipo==="V3"){ //Completar
        console.log("pasa");
        var In=$$("textIn").getValue().toUpperCase();
        poss3=VpalabraACompletar;
        if(In===VpalabraACompletar.toString().toUpperCase()){
            find=true;
        }
    }

    if(subtipo==="V4"){ //Traduccion
        var In=$$("textIn").getValue().toUpperCase();
        console.log("Vtraduc.length= "+Vtraduc.length);
        for(var i=0;i<Vtraduc.length;i++){
           poss3+="- "+Vtraduc[i]+"<br/>";
           if(In===Vtraduc[i].toUpperCase()) find=true;
        }
    }

    if(find){
        paso = true;
        Verify(paso);
    }else{
        paso = false;
        parar=true;
        webix.confirm({
            title:"¡Palabra Incorrecta!",
            type:"alert-error",
            text:"Posibles traducciones:<br/> <left>"+poss3+"</left><br/>",
            callback: function(){
                Verify(paso);
            }
        });
    }
    return paso;
}




