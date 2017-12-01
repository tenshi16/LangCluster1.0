var game;
var ID;
var objeto;
var Itraduc = new Array();

function imagen(Term){
    var n=Math.floor(Math.random() * 10) + 1 ;
    Itraduc = new Array();
    //var n=1;
    console.log("IMAGEN. TERMINO="+Term.termino+", DE ID="+Term.id_termino);
    if(n%2===0) game=T1(Term);
    else        game=T2(Term);
    return game;
}
         
function T1(Term){
    WORD = Term.termino;
    ID = Term.id_termino;
    subtipo="T1";
    objeto = new Array();
    $.ajax({
        type:'POST',
        data: {p1:Term.id_termino, id:"ImagesT1"},
        url: '../Servlet',
        async:false,
        success: function(result){
            objeto = JSON.parse(result);
        },
        complete: function (){
            game = {rows:[
                {template:"<hr width=\"90%\" size=\"2\" noshade>", autoheight:true, borderless:true},
                {cols:[
                      {},
                        {view:"template",template:"<strong>Selecciona:</strong>",borderless:true},
                        {view:"button",id:"helpButton",value:"?",autowidth:true,click:function(){
                          webix.ui({
                            view:"popup",
                            id:"pop",
                            body:{
                                rows:[{ template:"En este subtipo de juego correspondiente a imágenes <br> \n\
                                                  tendrá la oportunidad de seleccionar la imagen  \n\
                                                  que le parezca más apropiada para el término dado."
                                     ,borderless: true,width:400,autoheight:true}]
                            }
                        }).show(this.getNode());    
                         }
                      },{}
                      ]
                },
                {id:"iconos1", cols:[ {},
                        {id:objeto[0].id_termino, click: select, view:"button", type:"imageTop", height:200, width:200, image:"../"+objeto[0].ruta_multimedia+".jpg", hotkey: "1"},
                        {id:objeto[1].id_termino, click: select, view:"button", type:"imageTop", height:200, width:200, image:"../"+objeto[1].ruta_multimedia+".jpg", hotkey: "2"},
                        {id:objeto[2].id_termino, click: select, view:"button", type:"imageTop", height:200, width:200, image:"../"+objeto[2].ruta_multimedia+".jpg", hotkey: "3"},
                        {}
                    ]},
                {id:"iconos2",cols:[
                        {},
                        {id:objeto[3].id_termino, click: select, view:"button", type:"imageTop", height:200, width:200, image:"../"+objeto[3].ruta_multimedia+".jpg", hotkey: "4"},
                        {id:objeto[4].id_termino, click: select, view:"button", type:"imageTop", height:200, width:200, image:"../"+objeto[4].ruta_multimedia+".jpg", hotkey: "5"},
                        {id:objeto[5].id_termino, click: select, view:"button", type:"imageTop", height:200, width:200, image:"../"+objeto[5].ruta_multimedia+".jpg", hotkey: "6"},
                        {}
                    ]}
                ]
             };
             //return game;
       }
    });
    return game;
}
         
function T2(Term){
    ID = Term.id_termino;
    objeto = new Array();
    subtipo="T2";
    $.ajax({
        type:'POST',
        data: {p1:Term.id_termino, id:"ImagesT2"},
        url: '../Servlet',
        async:false,
        success: function(result){
            objeto = JSON.parse(result);
            console.log(JSON.stringify(objeto));
            for(var i=0;i<objeto.length;i++){
                Itraduc.push(objeto[i].terminoes);
            }
            console.log(Itraduc);
        },
        complete: function (){
           game = {rows:[
                 {template:"<hr width=\"90%\" size=\"2\" noshade>", autoheight:true, borderless:true},
                 {cols:[ {},
                       {id:"textIn", view:"text", label:"Ingrese por favor su traducción:", labelPosition:"top"},
                       {view:"button",id:"helpButton",value:"?",autowidth:true,click:function(){
                             webix.ui({
                               view:"popup",
                               id:"pop",
                               body:{
                                   rows:[{ template:"En este subtipo de juego correspondiente a imágenes<br> \n\
                                                     tendrá la oportunidad de escribir la traducción del término dado."
                                        ,borderless: true,width:400,autoheight:true}]
                               }
                           }).show(this.getNode());    
                            }
                         },
                       {}
                    ]},
                 {cols:[
                       {},
                       {id:objeto[0].id_termino, view:"button", type:"imageTop", height:200, width:200, image:"../"+objeto[0].ruta_multimedia+".jpg"},
                       {}
                    ]}
             ]};
        }});
    return game;
}

click:function select(id){
    if(subtipo==="T1"){
        if(ID===id){
            paso = true;
            Verify(paso);
        }else{
            paso = false;
            Verify(paso);
            webix.message("Imagen Incorrecta.");
        }
    }    
}
click:function Post1(){
    var find=false;
    var poss2="";
    if(subtipo==="T2"){
        var In=$$("textIn").getValue().toUpperCase();
        for(var i=0;i<objeto.length;i++){
            poss2+="- "+Itraduc[i]+"<br/>";
            if(In===Itraduc[i].toUpperCase()) find=true;
        }
        if(find){
            paso = true;
            Verify(paso);
        }else{
           paso = false;
           parar=false;
           webix.confirm({
                title:"¡Palabra Incorrecta!",
                type:"alert-error",
                text:"Posibles traducciones:<br/> <left>"+poss2+"</left><br/>",
                callback: function(){
                    Verify(paso);
                }
            });
        }
    }
    return paso;
}