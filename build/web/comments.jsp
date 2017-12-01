<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <!--    LangCluster - Comentarios    -->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <script src="codebase/i18n/es.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
            #areaA, #areaB{
                    margin: 50px;
                    width:700px; height:100px;
            }
            .text{
                display: inline-block;
                vertical-align:middle;
            }
            .row-marked{
                background-color: #ffa;
            }
            .center{
            }
            .webix_hcell.center input[type=checkbox]{
                width:17px;
                height:17px;
                margin-top:16px;
                margin-left:3px;
            }
            .webix_table_checkbox{
                width:16px;
                height:16px;
            }
        </style>
    <title>LangCluster</title>
    </head>
    
    <body>
        <div id="pager_box" style='position:relative;'></div>
        <script>
        
        var tema,curso,orden,allcomments,auxallcomments;
        
        var typereturned; access();
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
            setCookie("config","null",-1);
            $.ajax({
                    type:'POST',
                    data: {id:"Comment1"},
                    url: 'Servlet',
                    success: function(result){
                        try{    tema=JSON.parse(result);
                        }catch(error){tema="0";}
                        $.ajax({
                            type:'POST',
                            data: {id:"Data1"},
                            url: 'Servlet',
                            success: function(result){
                                try{    curso=JSON.parse(result);
                                        curso.push({"id":"Todos","iso":"##"});
                                }catch(error){curso="0";}
                                list();
                            }
                        });
                    }
                });
        }

        function list(){
            $.ajax({
                    type:'POST',
                    data: {id:"Comment2"},
                    url: 'Servlet',
                    success: function(result){
                        try{
                            allcomments=JSON.parse(result);
                            auxallcomments=result;
                        }catch(error){
                            allcomments=null;
                            auxallcomments=null;
                        }
                        webix.i18n.dateFormat="%d/%m/%Y";
                        webix.i18n.setLocale();
                        commentwindow();
                    }
                });
        }
        
        function status(value, obj){
            if (obj.check) return "row-marked";
            return "";
        }
        
        function JSONremove(property, value) {
            allcomments.forEach(function(result, index) {
                if(result[property] === value) {
                    allcomments.splice(index, 1);
                }    
            });
        }
        
        webix.ui.datafilter.dataMasterCheckbox = webix.extend({
          refresh:function(master, node, config){
            node.onclick = function(){
                this.getElementsByTagName("input")[0].checked = config.checked = !config.checked;
                var column = master.getColumnConfig(config.columnId);
                var checked = config.checked ? column.checkValue : column.uncheckValue;
                master.data.each(function(obj){
                    if(obj){
                        obj[config.columnId] = checked;
                        master.callEvent("onCheck", [obj.id, config.columnId, checked]);
                        this.callEvent("onStoreUpdated", [obj.id, obj, "save"]);
                    }					
              });
              master.refresh();
            };
          }
        }, webix.ui.datafilter.masterCheckbox);
        
        function commentwindow(){
            webix.protoUI({
                name:"datatable"
            },webix.ui.datatable,webix.ActiveContent);
            webix.ui({
                id: "checkcomments",
                cols:[{width:100},{
                    rows:[{
                        cols:[
                             {id:"delSelec",view:"button",label:"Eliminar Seleccionados",
                                click:function(){
                                    var selected=new Array();   var array=new Array();
                                    $$("dataT").eachRow(function(id){
                                        if(this.getItem(id).check){
                                            selected.push(id);
                                        }
                                    });
                                    if(selected.length!=0){
                                        webix.confirm({
                                            title:"¡Atención!",
                                            type:"alert-warning",
                                            ok:"Sí", 
                                            cancel:"No",
                                            text:"¿Está seguro de que desea borrar el/los comentario(s) seleccionado(s)?<br/>Esta acción no puede deshacerse.",
                                            callback:function(answer){
                                                if(answer == true){
                                                    for(var i=0;i<selected.length;i++){
                                                        array.push($$("dataT").getItem(selected[i]).id_comentario);
                                                    }
                                                    console.log("array:"+array);
                                                    $.ajax({
                                                        type:'POST',
                                                        data: {array:array.toString(),id:"Comment4"},
                                                        url: 'Servlet',
                                                        success: function(result){
                                                            webix.message("Comentario(s) Eliminado(s) Exitosamente");
                                                        },
                                                        complete: function(){
                                                            document.location.reload();
                                                        }
                                                    });
                                                }
                                            }
                                        });
                                    }
                                    else{//temp
                                        webix.confirm({
                                            title:"¡Atención!",
                                            type:"alert-warning",
                                            ok:"Aceptar",
                                            cancel:"Cancelar",
                                            text:"Debe seleccionar al menos un comentario para proceder"
                                        });
                                    }                                    
                                }},
                             {id:"comboTema",view:"richselect",label:"Tema:",value:tema[0].id,yCount:"3", options:tema,labelWidth:60},
                             {id:"comboCurso",view:"richselect",label:"Curso:",value:curso[3].id,yCount:"3", options:curso,labelWidth:60}
                            ]
                        },
                        {template: "<hr width=\"90%\" size=\"2\" noshade>", autoheight:true, borderless:true},
                        /*  NOTICIAS (3): AÑADIR COMPONENTES DINÁMICAMENTE AL SCROLLVIEW
                            id:"scrollview", 
                            scroll:"y",
                            body:{
                                rows:listcomments
                            }
                            */
                        {
                            view:"datatable",
                            id:"dataT",
                            activeContent:{
				searchButton:{
                                    view:"button", id:"searchButtonId", type:"icon", icon:"search-plus", width:30
				},
                                deleteButton:{
                                    view:"button", id:"deleteButtonId", type:"icon", icon:"trash", width:30
				},
                                deleteAllButton:{
                                    view:"button", id:"deleteAllButtonId", type:"icon", icon:"trash", width:30
				}
                            },
                            columns:[
                                    { id:"check", header:{content:"dataMasterCheckbox",css:"center"}, width:40, template:"{common.checkbox()}", cssFormat:status},
                                    { id:"nombre", header:["<center><strong>Usuario</strong></center>", {content:"textFilter",compare:usuarioemail,colspan:1}], adjust:"data", template:"<strong>#nombre#</strong> (#email#) ", sort:"string", css:"texto", cssFormat:status},
                                    { id:"email", header:"email",hidden:true,sort:"string"},
                                    { id:"fecha_comentario", header:"<center><strong>Fecha</strong></center>", adjust:"data", format:webix.i18n.dateFormatStr, sort:"string", cssFormat:status},
                                    { id:"hora_comentario", header:"<center><strong>Hora</strong></center>", adjust:"data", sort:"string", cssFormat:status},
                                    { id:"texto_comentario", header:"<center><strong>Comentario</strong></center>", sort:"string", minWidth:200, fillspace:true, template:"<html>#texto_comentario#</html>", cssFormat:status},
                                    { id:"search", header:"", adjust:"data", template:"{common.searchButton()}", cssFormat:status},
                                    { id:"delete", header:"", adjust:"data", template:"{common.deleteButton()}", cssFormat:status},
                                    { id:"nombre_tema", header:"nombre_tema", hidden:true, sort:"string"},
                                    { id:"iso", header:"iso", hidden:true, sort:"string"}
                            ],
                            checkboxRefresh:true,
                            fixedRowHeight:false,
                            yCount:10,
                            data:allcomments,
                            on:{
                                onAfterLoad:function(){
                                    webix.delay(function(){
                                        this.adjustRowHeight("texto_comentario", true);
                                        this.render();
                                        if (!this.count()){
                                            this.showOverlay("- No hay comentarios disponibles -");
                                        }
                                    }, this);
                                },
                                onColumnResize:function(){
                                    this.adjustRowHeight("texto_comentario", true);
                                    this.render();
                                },
                                onAfterFilter:function(){
                                    this.getFilter("nombre").focus();
                                } 
                            },
                            navigation: "true",
                            pager:{
                                container: "pager_box",
                                template:"{common.first()} {common.prev()} {common.pages()} {common.next()} {common.last()}",
                                size:10
                            }
                        },
                        {id:"barText", template:"html->pager_box", autoheight: true, borderless:true}
                    ]
                    },{width:100}
                ]
            });
            $$("comboTema").attachEvent("onChange", function(newv, oldv){
                $$("dataT").hideOverlay();
                allcomments=JSON.parse(auxallcomments);
                var auxJSON=JSON.parse(auxallcomments);
                if(newv!=="General"){
                    for(var i=0;i<tema.length;i++){
                        if(newv===tema[i].id){
                            newv=tema[i].id.toString().toUpperCase();
                            break;
                        }
                    }
                    for(var i=0;i<auxJSON.length;i++){
                        if(auxJSON[i].nombre_tema.toString().toUpperCase() !== newv){
                            JSONremove('id',i+1);
                        }
                        if(auxJSON[i].nombre_tema.toString().toUpperCase() === "null"||auxJSON[i].nombre_tema === null){
                            JSONremove('id',i+1);
                        }
                    }
                }
                $$("dataT").clearAll();
                $$("dataT").parse(allcomments);
                if(allcomments.length!=0){
                    $$("barText").show();
                    $$("barText").setContent(document.getElementById("pager_box"));
                }
                else{
                    $$("barText").hide();
                }
            });
            $$("comboCurso").attachEvent("onChange", function(newv, oldv){
                $$("dataT").hideOverlay();
                allcomments=JSON.parse(auxallcomments);
                var auxJSON=JSON.parse(auxallcomments);
                if(newv!=="Todos"){
                    for(var i=0;i<curso.length;i++){
                        if(newv===curso[i].id){
                            newv=curso[i].iso.toString().toUpperCase();
                            break;
                        }
                    }
                    for(var i=0;i<auxJSON.length;i++){
                        if(auxJSON[i].iso.toString().toUpperCase() !== newv){
                            JSONremove('id',i+1);
                        }
                        if(auxJSON[i].iso.toString().toUpperCase() === "null"||auxJSON[i].iso === null){
                            JSONremove('id',i+1);
                        }
                    }
                }
                $$("dataT").clearAll();
                $$("dataT").parse(allcomments);
                if(allcomments.length!=0){
                    $$("barText").show();
                    $$("barText").setContent(document.getElementById("pager_box"));
                }
                else{
                    $$("barText").hide();
                }
            });
            $$('deleteButtonId').attachEvent("onItemClick", function(id, e){
                var id_C=$$("dataT").getItem([this.config.$masterId]).id_comentario;
                webix.confirm({
                    title:"¡Atención!",
                    type:"alert-warning",
                    ok:"Sí", 
                    cancel:"No",
                    text:"¿Está seguro de que desea borrar el comentario seleccionado?<br/>Esta acción no puede deshacerse.",
                    callback:function(answer){
                        if(answer == true){
                            $.ajax({
                                type:'POST',
                                data: {id_C:id_C,id:"Comment3"},
                                url: 'Servlet',
                                success: function(result){
                                    webix.message("Comentario Eliminado Exitosamente");
                                },
                                complete: function(){
                                    document.location.reload();
                                }
                            });
                        }
                    }
                });
            });
            $$('searchButtonId').attachEvent("onItemClick", function(id, e){
                var text;
                if($$("dataT").getItem([this.config.$masterId]).iso===null || $$("dataT").getItem([this.config.$masterId]).iso=== "null"){
                    text="<strong>Curso:</strong> N/A";
                }else{
                    text="<strong>Curso:</strong> "+$$("dataT").getItem([this.config.$masterId]).iso;
                }
                var email=$$("dataT").getItem([this.config.$masterId]).email;
                webix.ui({
                    id:"windowDetail",
                    view:"window",
                    width:600,
                    head:"<strong>Detalles</strong>",
                    position:"center",
                    body:{
                        view:"form",
                        rows:[{view:"label",label:"<center><strong>Comentario #"+this.config.$masterId+"</strong></center>",height:20},
                              {view:"label",label:"<strong>Usuario:</strong> "+$$("dataT").getItem([this.config.$masterId]).nombre+" <em>("+$$("dataT").getItem([this.config.$masterId]).email+")</em>",height:20},
                              {view:"label",label:"<strong>Fecha y Hora:</strong> "+$$("dataT").getItem([this.config.$masterId]).fecha_comentario+" | "+$$("dataT").getItem([this.config.$masterId]).hora_comentario,height:20},
                              {view:"label",label:text,height:20},
                              {template: "<hr width=\"90%\" size=\"2\" noshade>", autoheight:true, borderless:true},
                              {cols:[{view:"button", value:"Perfil de Usuario", type:"form", click:function(){
                                            setCookie("config",email,1);
                                            window.open("config.jsp", "_self");
                                      }},
                                     {view:"button", value:"Eliminar Usuario", type:"form", click:function(){
                                            setCookie("config",email,1);
                                            window.open("deluser.jsp", "_self");
                                      }},
                                     {view:"button", value:"Cancelar", click:function(){$$("windowDetail").hide();}}]}
                        ]
                    }
                }).show();
            });
            $$("barText").setContent(document.getElementById("pager_box"));
        }
        
        function usuarioemail(value, filter, obj){
            if (obj.nombre.toLowerCase().indexOf(filter)!==-1)  return true;
            if (obj.email.toLowerCase().indexOf(filter)!==-1)   return true;
            return false;
        }
        </script>
    </body>
</html>
