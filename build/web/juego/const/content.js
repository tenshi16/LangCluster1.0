var des="";
var nom="";
var t1="";
var t2="";
var level="";
var maxima="";
var vistar="";
var topic="";

function ajas(val){
        $.ajax({
            type:'POST',
            data: {p1:val,p2:getCookie("username"),id:"30"},
            url: '../../Servlet',
            success: function(result){
               if(result || 0 !== result.length){
                var a=JSON.parse(result);
                des= a[0].des;
                nom = a[0].nom;     
                level = a[0].nivel;   
                topic=val;
                try{
                    $$("Ini1").destructor();
                }catch(error){}
                maxima = a[0].maximas; 
                vistas = a[0].vistas; 
                var aux=((vistas*100)/maxima).toString();
                var mv =aux.substr(0,aux.indexOf(".")+3);
                webix.ui({
                    id:"Ini1",
                    view:"window",
                    autoheight:true,
                    position:"center",
                    width:500,
                    head:{
                       view:"toolbar", margin:-4, cols:[
                        {view:"label", label: nom,labelPosition:"top" },
                        //Numero muy largo hay que truncarlo 
                        {view:"label", label: "Terminos vistos: "+mv+"%" ,labelPosition:"top" },
                        { view:"icon", icon:"times-circle",
                          click:"$$('Ini1').close();"}
                        ]
                      },
                    body:{
                        rows:[
                              //{template: "<left><strong>Nivel:</strong>"+level+" <strong>Nombre:</strong>"+nom+"</left><hr width=\"90%\" size=\"2\" noshade>",  autoheight:true},
                              {id:"Desc",template:des,borderless:true},
                              {id:"Jugar",view:"button",value:"Seleccionar" , click: Actividad}
                        ]
                    }
                }).show();
               }else{
                  $.ajax({
                 type:'POST',
                 data: {p1:val,id:"71"},
                 url: '../../Servlet',
                 success: function(result){
                   var a=JSON.parse(result);
                     des= a[0].des;
                     nom = a[0].nom;     
                     level = a[0].nivel;   
       
                     webix.ui({
                          id:"Ini1",
                      view:"window",
                      autoheight:true,
                      position:"center",
                      width:500,
                      head:{
                         view:"toolbar", margin:-4, cols:[
                          {view:"label", label: nom,labelPosition:"top" },
                          { view:"icon", icon:"times-circle",
                            click:"$$('Ini1').close();"}
                          ]
                        },
                      body:{
                          rows:[
                                //{template: "<left><strong>Nivel:</strong>"+level+" <strong>Nombre:</strong>"+nom+"</left><hr width=\"90%\" size=\"2\" noshade>",  autoheight:true},
                                {id:"Desc",template:des},
                                {id:"Jugar",view:"button",value:"Seleccionar" , click: Actividad}
                          ]
             }
                     }).show();
                 }});
               }
            }
         });
        }


function Actividad(){
   $$("Ini1").hide();
   webix.ui({
        id:"Ini2",
        view:"window",
        autoheight:true,
        position:"center",
        width:500,
        head:{
            view:"toolbar", margin:-4, cols:[
                { view:"icon", icon:"arrow-left",
                    click:function(){ 
                        $$("Ini2").hide();
                        $$("Ini1").show();
                }},
                { id:"left",view:"icon", icon:"arrow-right",
                    click:function(){
                        $$("Ini2").hide();
                        $$("left").enable();
                        clas(t1);
                   }, disabled:true},
                 {view:"label", label: "Tipo de Actividad",labelPosition:"top" },
                 { view:"icon", icon:"times-circle",
                   click:"$$('Ini2').close();"}
             ]
           },
        body:{
            rows:[
                {template: "<left><strong>Nivel: </strong>"+level+" | <strong>Tópico: </strong>"+topic+" | <strong>Nombre: </strong>"+nom+"</left><hr width=\"90%\" size=\"2\" noshade>",  autoheight:true, borderless: true},
                {height:20},
                {cols:[
                      {id:"1", click: clas, view:"button", type:"imageTop", label:"Audio", height:150, image:"../../img/icon/audio.png"},
                      {id:"2", click: clas, view:"button", type:"imageTop", label:"Imágenes", height:150, image:"../../img/icon/ima.png"},
                      {id:"3", click: clas, view:"button", type:"imageTop", label:"Vocabulario", height:150, image:"../../img/icon/voca.png"},
                      {id:"4", click: clas, view:"button", type:"imageTop", label:"Mixto", height:150, image:"../../img/icon/mix.png"},
                ]},
                {height:20}
            ]
         }
      }).show();
};


function clas(id){
   $$("Ini2").hide();
   $$("left").enable();
   t1=id;
   webix.ui({
        id:"Ini3",
        view:"window",
        autoheight:true,
        position:"center",
        width:500,
        head:{
            view:"toolbar", margin:-4, cols:[
               { view:"icon", icon:"arrow-left",
                    click:function(){
                        $$("Ini3").hide();
                        $$("Ini2").show();
                        Actividad();
               }},
             {view:"label", label: "Tipo de Estudio",labelPosition:"top" },
             { view:"icon", icon:"times-circle",
               click:"$$('Ini3').close();"}
             ]
           },
        body:{
             rows:[
                {template: "<left><strong>Nivel: </strong>"+level+" | <strong>Tópico: </strong>"+topic+" | <strong>Nombre: </strong>"+nom+"</left><hr width=\"90%\" size=\"2\" noshade>",  autoheight:true, borderless: true},
                {height:20},
                {cols:[{},
                      {id:"1", click: nr, view:"button", type:"imageTop", label:"Nuevo", height:150, image:"../../img/icon/nuevo.png"},
                      {id:"2", click: nr, view:"button", type:"imageTop", label:"Repaso", height:150, image:"../../img/icon/repaso.png"},
                      {}
                ]},
             {height:20}
             ]
        }
      }).show();
}


function nr(au){
   t2=au;
   //webix.message(" Nivel = "+level+" Tipo de actividad="+type+" Tipo de juego="+type2);
   //Se envia con un cookie la actividad y el tipo de juego
   setCookie("juego", level+","+t1+","+t2+","+topic ,30);
   //Modo de juego...
   window.open("../game.jsp","_self");
}


/*
 * 
 * 
 * Cookies
 * 
 *
 */
function setCookie(cname, cvalue,days) {
   var d = new Date();
   d.setTime(d.getTime() + (days*24*60*60*1000));
   var expires = "expires="+d.toUTCString();
   document.cookie = cname + "=" + cvalue + "; " + expires+"; path=/";
   //webix.storage.local.put(cname, cvalue);
}
            
        
function eraseCookie(tipo,cname) {
   setCookie(tipo,cname,-1);
}

function getCookie(cname) {
   var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) === 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";

    /*var cookie=webix.storage.local.get(cname);
    return cookie;*/
}