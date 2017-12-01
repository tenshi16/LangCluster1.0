<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../../codebase/webix.js"></script>
        <link rel="stylesheet" href="../../codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="../../jquery-1.12.4.min.js"></script>
        <script src="../../jquery.rwdImageMaps.js"></script>
        <script src="content.js"></script>
        <script src="pictarea.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
            .webix_slider_box .webix_slider_handle{
                margin-left: -100px; margin-top: -10px; width:226px; height:114px; background:url("../../img/Nave.png"); border:0;
            }
            .webix_slider_box .webix_slider_left{height:80px;border:1px solid #ccc;background:#3498db}
            .webix_slider_box .webix_slider_right{height:80px;background:rgba(1,1,1,0);}
        
            body {
                background:#342743;                
                background-repeat: no-repeat;
                background-size: 100% 100%;
                height: auto;
                width: auto
            }
            
            .osa {
               background:url("../../img/Conste/f1/1OOsa.png");
               background-repeat: no-repeat;
               max-height: 421px;
            }
            
            .alter .webix_icon_button{
            color:#F84;
           }
           /*
           img[usemap] {
               border: none;
               height: auto;
               max-width: 100%;
               width: auto;
            }*/
        </style>
    </head>
    
    <body>
        <div id="A"></div>
        <div id="B">
            <center>
            <img src="../../img/Conste/f1/1OOsa.png" alt="" usemap="#Map" />
              <map name="Map" id="Map">
                  <area id="1"  onclick="play(this.id)"  href="#" shape="poly" coords="147,100,144,112,139,119,129,123,139,124,145,131,148,142,150,131,153,124,165,123,157,119,151,112" />
                  <area id="2"  onclick="play(this.id)"  href="#" shape="poly" coords="291,75,288,85,283,95,274,98,284,100,288,106,291,117,294,106,299,99,309,98,299,94,294,87" />
                  <area id="3"  onclick="play(this.id)"  href="#" shape="poly" coords="414,96,411,110,404,117,396,119,407,122,413,131,414,139,418,127,421,121,434,120,423,115,418,109" />
                  <area id="4"  onclick="play(this.id)"  href="#" shape="poly" coords="510,139,507,150,502,158,492,163,500,163,508,170,511,179,513,170,518,164,529,162,519,158,513,150" />
                  <area id="5"  onclick="play(this.id)"  href="#" shape="poly" coords="707,159,703,172,698,178,689,182,699,184,705,191,707,203,710,191,714,185,726,182,715,177,710,172" />
                  <area id="6"  onclick="play(this.id)"  href="#" shape="poly" coords="475,279,471,292,466,297,456,301,466,304,472,311,475,322,478,308,484,303,492,301,484,298,478,292" />
                  <area id="7"  onclick="play(this.id)"  href="#" shape="poly" coords="637,302,634,313,630,322,619,324,629,328,634,336,637,344,639,335,644,327,657,326,646,322,638,312" /> 
              </map>
             </center>
        </div>
        <script>
        access();
        function access(){
                var cookie = getCookie("username");
                if (cookie == "" || cookie == null){
                    webix.ui({
                        id:"access0",
                        rows:[
                                { template:"<center><br/><br/><br/>"
                                    +"<img src='../../img/LangCluster.png'/>"
                                    +"<br/><br/><br/>"
                                    +"Estimado usuario, debe iniciar sesión para acceder a esta sección.</center>" }
                        ]
                    });
                    document.getElementById('B').style.display = 'none';
                }
                else{
                    changePosition();
                    loadGame();
                }
            }
           
        var topic=0;
        function loadGame(){
            webix.ui({
                id:"C1",
                autoheight: true,
                container:"A",
                rows:[
                     {height:120,id:"pro", view:"slider", label:"Progreso:", value:"0", min:0,  max: 7,on:{
                            onSliderDrag:function(){
                                    $$("pro").setValue(topic);
                                },
                            onChange:function(){
                                    $$("pro").setValue(topic);
                               }
                         }
                     }
                  ]
            });
            /*
            $(window).resize(function(){
                $$("Game").adjust();
                $$("Game").resize();
            });*/
        }
        /*
        var percentage,distance; calculator(1);
        function calculator(){
            var num=level-1;
            var MAX_DISTANCE=680;
            distance=(num*MAX_DISTANCE)/6;
            percentage=(distance*100)/MAX_DISTANCE;
            changePosition();
        }*/
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
                    template:"<center><strong>Nivel 1:</strong> Osa Mayor | Inicial</center>"
                }
            }).show({
                x: $(window).width()-$$("my_win").width,
                y: $(window).height()
            });
        }
        
        function play(id){
            topic=id;
            try{$$("Ini").hide();}catch(error){};
            $$('pro').setValue(topic);
            ajas(topic);
           /*
           if(topic==1){
              $$('pro').setValue(1);
              ajas(topic);
           }
           if(topic==2){
              $$('pro').setValue(2);
              ajas(topic);
           }
           if(topic==3){
              $$('pro').setValue(3);
              ajas(topic);
           }
           if(topic==4){
              $$('pro').setValue(4);
              ajas(topic);
           }
           if(topic==5){
              $$('pro').setValue(5);
              ajas(topic);
           }
           if(topic==6){
              $$('pro').setValue(6);
              ajas(topic);
           }
           if(topic==7){
              $$('pro').setValue(7);
              ajas(topic);
           }*/
        }
        
        
        
           /*
        $(document).ready(function(e) {
            $('img[usemap]').rwdImageMaps();
        });
*/
        $(function() {
            $('#map').pictarea({
              rescaleOnResize: true
            });
          });
        
        </script>
    </body>
</html>
