<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <!--    LangCluster - Navegación/Juego    -->
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>      
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
            .webix_slider_box .webix_slider_handle{
                margin-left: -100px; margin-top: -10px; width:226px; height:114px; background:url("img/Nave.png"); border:0;
            }
            .webix_slider_box .webix_slider_left{height:80px;border:1px solid #ccc;background:#5FCC67} /*rojo: C14032, verde: 5FCC67 , amarillo: DBD959*/
            .webix_slider_box .webix_slider_right{height:80px;background:rgba(1,1,1,0);}
            
            .image{
                background:url("img/Conste/1/11Osamayor.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .med{
               background:url("img/Conste/Barramed.png");
               background-repeat: no-repeat;
                background-position: center; 
               
            }
            .space {
                background:#342743;
            }
            
            .blank {
                background-color:rgba(1,1,1,0);
            }
            
            .osa11 {
                background:url("img/Conste/1/11Osamayor.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            
            .osa12 {
                background:url("img/Conste/1/12Osamayor.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .serp21 {
                background:url("img/Conste/1/21Serpiente.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .serp22 {
                background:url("img/Conste/1/22Serpiente.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            
            .fenix11{
                background:url("img/Conste/2/11Fenix.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .fenix12{
                background:url("img/Conste/2/12Fenix.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .canis21{
                background:url("img/Conste/2/21Canis.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .canis22{
                background:url("img/Conste/2/22Canis.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            
            .casio11{
                background:url("img/Conste/3/11Casio.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .casio12{
                background:url("img/Conste/3/12Casio.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .tria11{
                background:url("img/Conste/3/21Trian.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            .tria12{
                background:url("img/Conste/3/22Trian.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }            
        </style>
    </head>
    <body>
    <script>
        var p;
        var m;
        var level=1;
        
        var percentage,distance;
            
        var typereturned; access();
        
        function one(){
            level=1;
            //$$("barrain").showOverlay("<div style='...'>There is no data</div>");
            window.open("juego/const/C1.jsp","_self");
            $$('pro').setValue(1);
            calculator();
        }
        function two(){
            level=2;
            webix.alert("<strong>PRÓXIMAMENTE</strong><br/><br/>Constelación aún no disponible");
            $$('pro').setValue(2);
            calculator();
        }
        function three(){
            level=3;
            webix.alert("<strong>PRÓXIMAMENTE</strong><br/><br/>Constelación aún no disponible");
            $$('pro').setValue(3);
            calculator();
        }
        function four(){
            level=4;
            webix.alert("<strong>PRÓXIMAMENTE</strong><br/><br/>Constelación aún no disponible");
            $$('pro').setValue(4);
            calculator();
        }
        function five(){
            level=5;
            webix.alert("<strong>PRÓXIMAMENTE</strong><br/><br/>Constelación aún no disponible");
            $$('pro').setValue(5);
            calculator();
        }
        function six(){
            level=6;
            webix.alert("<strong>PRÓXIMAMENTE</strong><br/><br/>Constelación aún no disponible");
            $$('pro').setValue(6);
            calculator();
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
                    calculator();
                    loadgame();
                }
            }
            
        function calculator(){
            var num=level-1;
            var MAX_DISTANCE=680;
            distance=(num*MAX_DISTANCE)/6;
            percentage=(distance*100)/MAX_DISTANCE;
            /*switch(num+1){
                case 1: return 230;
                case 2: return 820;
                case 3: return 1400;
                case 4: return 2000;
                case 5: return 2600;
                case 6: return 3200;
            }*/
            changePosition();
        }
        
        function changePosition(){
            try{$$("my_win").destructor();}catch(error){}
            //calculator(num-1);
            //console.log(x);
            webix.ui({
                view:"window",
                id:"my_win",
                autowidth:true,
                height: 30,
                headHeight:0,
                css:"blank",
                body:{
                    template:"<center><strong>"+Math.round(percentage*100)/100+"%</strong> | <strong>Avance</strong>: "+Math.round(distance*100)/100+" Años Luz</center>"
                }
            }).show({
                x: $(window).width()-$$("my_win").width,
                y: 0
                    //alt/2-alt*0.10
            });
        }
        
        
          
        function loadgame(){
            webix.ui({
                id:"Game",
                rows:[
                   {  
                      css:"space",
                      id:"scrollvieww", 
                      view:"scrollview",
                      scroll:"x",
                      body:{ width:3801,
                           rows:[
                               {
                               cols:[
                                  {id:"osa11", css:"image", borderless:true,view:"button", type:"imageTop", height: p, click:one},
                                  {id:"osa12", css:"osa12", template:"", type:"imageTop", height: p},
                                  {id:"fenix11", css:"fenix11", view:"button", type:"imageTop", height: p, click:three},
                                  {id:"fenix12", css:"fenix12", template:"", type:"imageTop", height: p},
                                  {id:"casio11", css:"casio11", view:"button", type:"imageTop", height: p, click:five},
                                  {id:"casio12", css:"casio12", template:"", type:"imageTop", height: p}
                               ]
                               },
                               {height:114, css:"med",
                                  cols:[
                                     {width:100},
                                     {rows:[
                                           {height:114,id:"pro", view:"slider", value:"1", min:1,  max: 7, on:{
                                                  onSliderDrag:function(){
                                                              $$("pro").setValue(level);
                                                         },
                                                  onChange:function(){
                                                              $$("pro").setValue(level);
                                                         }
                                                  }
                                          }
                                        ]
                                     }
                                     ,{width:150}
                                  ]},
                               {
                               cols:[
                                  {id:"serp21", css:"serp21", template:"", type:"imageTop", height: p},
                                  {id:"serp22", css:"serp22", view:"button",  type:"imageTop", height: p, click:two},
                                  {id:"canis21", css:"canis21", template:"", type:"imageTop", height: p},
                                  {id:"canis22", css:"canis22", view:"button",  type:"imageTop", height: p, click:four},
                                  {id:"tria11", css:"tria11", template:"", type:"imageTop", height: p},
                                  {id:"tria12", css:"tria12", view:"button",  type:"imageTop", height: p, click:six}
                               ]
                               }
                           ]
                      }
                   }
                ]
            });
        }
      
   // webix.extend($$("barrain"), webix.ProgressBar);
      
    $(window).resize(function(){
        $$("Game").adjust();
        $$("Game").resize();
        changePosition();
    });
    </script>
   </body>
</html>
