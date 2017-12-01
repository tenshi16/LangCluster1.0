<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <!--    LangCluster - Juego    -->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="../codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="../CookieControl.js"></script>
        <!--<script src="Terms.js"></script>-->
        <script src="../codebase/webix.js"></script>
        <script src="../jquery-1.12.4.min.js"></script>
        <link rel="shortcut icon" type="image/ico" href="../img/favicon.ico" />
        <title>LangCluster</title>
    </head>
    <body>
    <script>
        var data1,data2,ui;
        newGame();
        function newGame(){
            var iso="EN";
            $.ajax({
                type:'POST',
                data: {topic:1, iso:iso, id:"Game4"},
                url: '../Servlet',
                success:function(result){
                    if(!result || 0 === result.length){
                        data1=null;
                    }else{
                        data1=JSON.parse(result);
                    }
                },
                complete:
                function(){
                    //var user=getCookie("username");
                    var user="Integer.sem@Praesentluctus.co.uk";
                    $.ajax({
                        type:'POST',
                        data: {user:user, topic:1, iso:iso, id:"Game5"},
                        url: '../Servlet',
                        success:function(result){
                            if(!result || 0 === result.length){
                                data2=null;
                            }else{
                                data2=JSON.parse(result);
                                if(data2.length<20){
                                    $.ajax({
                                        type:'POST',
                                        data: {topic:1, number:(20-data2.length), iso:iso, id:"Game6"},
                                        url: '../Servlet',
                                        success:function(result){
                                            if(!result || 0 === result.length){
                                                data2=null;
                                            }else{
                                                var x=JSON.parse(result);
                                                var length=data2.length;
                                                for(var i=length;i<length+x.length;i++){
                                                    data2[i]=x[i-(length)];
                                                }
                                                start();
                                            }
                                        }
                                    });
                                }
                                else{
                                    start();
                                }
                            }
                        }
                    });
                }
            });
        }
        
        function start(){
            webix.ui({
                rows:[{ view:"datatable",
                        columns:[{ id:"termino", header:"<center><strong>Términos Nuevos</strong></center>", sort:"string", fillspace:true}],
                        data:data1
                      },
                      {height:20},
                      {
                        view:"datatable",
                        columns:[{ id:"termino", header:"<center><strong>Términos de Repaso</strong></center>", sort:"string", fillspace:true}],
                        data:data2
                      }
                ]
            });
        }
    </script>
    </body>
</html>
