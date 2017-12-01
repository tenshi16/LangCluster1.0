<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
    <!--    LangCluster - Ayuda    -->
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
            body{
                background-image: url("img/Juego/home.png");
                background-repeat: no-repeat;
                background-size: 100% 100%;
                max-width: 100%;
                height: auto;
                width: auto/9; /* Bug de ie8 */
            }
            a:link,a:visited,a:active {
                color: rgb(48,57,177);
                text-decoration: none;
            }
            a:hover {
                color: rgb(31,38,105);
                font-weight: bold;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
    <script>        
        var basic=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"accordion",
                autoheight:true,
                rows:[ 
                    { header:"¿Qué es LangCluster?", body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template: "<p align='justify'><strong>LangCluster</strong> es un sistema e-learning basado en la necesidad de proveer al "+
                                    "usuario común de un método de repaso, e incluso de "+
                                    "enseñanza, novedoso y de fácil acceso a un idioma deseado, adaptándose a estándares internacionales de "+
                                    "evaluación de suficiencia lingüística y proveyendo a los estudiantes de una forma segura de aprender el "+
                                    "contenido necesario para estos y, por ende, alcanzar el grado de independencia necesaria buscada en el "+
                                    "idioma mediante métodos personalizados y siempre ajustados al tiempo y nivel que posean para utilizarlo.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Cómo acceder a LangCluster?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>Tras acceder mediante su navegador de preferencia, confirme que la dirección sea <strong>www.langcluster.com</strong> "+
                                    "para proceder con seguridad. Si esto es correcto, presione el botón Usuario en el menú "+
                                    "superior a la derecha y seleccione <strong>Iniciar Sesión</strong> si ya está registrado en el sistema.<br/><br/>"+
                                    "Ingrese su usuario (el email con el cual se registró) y contraseña, posteriormente presione Entrar o la tecla Enter. "+
                                    "Si no recuerda su usuario o contraseña, por favor, INSTRUCCIONES.<br/><br/>"+
                                    "Si aún no posee una cuenta en LangCluster, presione <strong>Registrar Usuario</strong> y complete los datos presentes en pantalla. "+
                                    "Cabe destacar que el uso de un avatar es completamente opcional.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Cómo jugar en LangCluster?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"Opciones de Contacto", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>Existen dos formas principales para contactarse con LangCluster:<br/><br/>"+
                                    "En caso de tener algún comentario, duda o queja mientras realiza alguna actividad en su sesión activa; o bien, de encontrarse "+
                                    "con algún error o incongruencia en el programa, encontrará en la parte inferior de su ventana de sesión y en cada pregunta o "+
                                    "ejercicio de la actividad realizada, un botón que le dará acceso a una ventana de <strong>Comentario</strong>, en ella podrá escoger el tema de "+
                                    "su consulta y podrá describir su observación o inconformidad, un administrador del sistema lo revisará y dará solución "+
                                    "a su problema, notificándole por correo electrónico de ser necesaria una respuesta.<br/><br/>"+
                                    "Si posee otro tipo de problema (datos olvidados, problema general con el sistema, quejas o recomendaciones del mismo que no "+
                                    "considere apropiadas para un comentario o cualquier otra temática que considere no incluida en los mismos o en la presente "+
                                    "sección de ayuda, contactos profesionales con el equipo de LangCluster, notificar que desea hacer un uso docente (profesional) del sistema, "+
                                    "entre otras posibilidades) puede acceder a la sección de <string>Contacto</string> mediante el link ubicado en la barra"+
                                    "inferior de su pantalla o haciendo clic <a href='javascript:void(0)' onclick='link();'>aquí</a>.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    }
                ]
            }
        ];
        
        var game=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"accordion",
                autoheight:true,
                rows:[ 
                    { header:"Iniciando un nuevo juego", body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>Seleccionar idioma</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Qué indica el nivel de un tópico?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Qué son los tipos de estudio?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Qué son los tipos de actividad?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Dónde puedo consultar mi avance detallado en un curso o tópico?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¡Necesito más ayuda!", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    }
                ]
            }
        ];
        
        var user=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"accordion",
                autoheight:true,
                rows:[ 
                    { header:"¿Cómo modifico o recupero mis datos?", body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Cómo registro un comentario?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Dónde puedo consultar mis avances en el juego?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Qué es el Blog?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Cómo notifico un problema?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¡Necesito más ayuda!", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    }
                ]
            }
        ];
        
        var stat=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"accordion",
                autoheight:true,
                rows:[ 
                    { header:"¿Qué indican mis estadísticas?", body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Cómo puedo filtrar mis estadísticas para un curso, día o tópico en específico?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Qué es un Reporte?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Puedo consultar un reporte anterior?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Puedo exportar un reporte?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¡Necesito más ayuda!", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    }
                ]
            }
        ];
        
        var prof=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"accordion",
                autoheight:true,
                rows:[ 
                    { header:"¿Por qué usar LangCluster como apoyo docente?", body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Qué beneficios puede traer LangCluster a una clase?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template:
                                    "<p align='justify'>además de usos de LangCluster para docentes.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Cómo notifico que soy un docente?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Debo ser un usuario activo si soy docente?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>Indicar que no necesita jugar siempre.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¡Necesito más ayuda!", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template:
                                    "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    }
                ]
            }
        ];
        
        var map=[
            {   view:"scrollview", 
                id:"scrollview", 
                scroll:"y", 
                body:{
                    rows:[
                        {template:"<center><img src='img/data/map.png' width="+($(window).width()-50)+" /></center>",height: $(window).height()-50}
                    ]
                }
            }
        ];    
        
        function link(){
            window.open('contact.jsp', '_self');
        }
        
        access();
        
        function access(){
            webix.ui({
                id:"page",
                cols:[{width:20},
                      {
                        rows:[{height:20},
                              {view:"tabbar", id:"tab", multiview:true, options: [
                                        { value: "Nociones Básicas", id: 'form0' },
                                        { value: "Juego", id: 'form1' },
                                        { value: "Jugadores", id: 'form2' },
                                        { value: "Estadísticas", id: 'form3' },
                                        { value: "Docentes", id: 'form4' },
                                        { value: "Mapa del Sitio", id: 'form5' }
                                    ],height:50
                               },
                               {cells:[{id:"form0",rows: basic},
                                       {id:"form1",rows: game},
                                       {id:"form2",rows: user},
                                       {id:"form3",rows: stat},
                                       {id:"form4",rows: prof},
                                       {id:"form5",rows: map}
                                      ]
                               },
                               {height:20}
                        ]
                      },
                      {width:20}
                ]
            });
            var cookie = getCookie("fromcontact");
            if (cookie != "" && cookie != null){
                eraseCookie("fromcontact","null");
                if(cookie === "prof"){
                    $$("tab").setValue("form4");
                }
            }
        }
        //Crear cookie proffromHelp en notificar como docente (Haga clic aqui para notificar que es docente, etc, el aqui crea el cookie y lleva a contact; ya alla lo esta manejando)
        
        //En Home.jsp poner cuando esté listo un cuadro como el de game/naveg.jsp diciendo:
        //Este sitio web utiliza cookies para mejorar la experiencia del usuario. Si continua navegando estará aceptando todas las cookies según se indica en nuestra política de Cookies. Leer Más. Acepto.
    </script>
    </body>
</html>
