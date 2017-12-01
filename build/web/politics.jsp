<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
    <!--    LangCluster - Políticas    -->
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="codebase/webix.css" type="text/css" media="screen" charset="utf-8">
        <script src="CookieControl.js"></script>
        <script src="codebase/webix.js"></script>
        <script src="jquery-1.12.4.min.js"></script>
        <link rel="shortcut icon" type="image/ico" href="img/favicon.ico" />
        <style>
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
    var form0=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"scrollview", 
                id:"scrollview", 
                scroll:"y", 
                body:{
                    rows:[{
                            template: "<p align='justify'><strong>Información Básica</strong><br/><br/>El presente <strong>sitio web</strong>, su <strong>contenido</strong> y "+
                                      "servicios relacionados <strong>indicados en la presente página</strong> son administrador por "+
                                      "<strong>LangCluster</strong>, su <strong>equipo</strong> y <strong>personal</strong>.<br/>"+
                                      "Su uso del sitio web de Langcluster y todo su contenido, incluyendo los datos "+
                                      "mostrados y manejados en sus cursos, noticias y cualquier otra sección del sitio está sujeto a "+
                                      "estos términos y condiciones, así como  a cualquier otra política y avisos que apliquen en el "+
                                      "sitio web o una sección modulo específico del mismo. Por favor, lea esta sección y el resto de "+
                                      "las políticas antes de continuar utilizando el sitio web, cualquiera de sus secciones o contenido.<br/><br/>"+
                                      "Utilizando este sitio web, usted da a conocer su aceptación de estos terminos. LangCluster y su "+
                                      "personal se reserva el derecho e actualizar este sitio web y/o uno o más partes del contenido del "+
                                      "mismo en cualquier momento sin necesidad de notificárselo. Sin embargo, la últimas novedades del "+
                                      "sitio serán presentadas en la sección de <a href='javascript:void(0)' onclick='link(1);'>noticias (Blog)</a> "+
                                      "y podrá leerlas cuando desee.</p><br/><hr width=\"90%\" size=\"2\" noshade><br/>"+
                                      
                                      "<strong>Derechos de Autor y Uso de Contenido <em>(Copyright)</em></strong><br/><br/>"+
                                      "<p align='justify'>El logo de LangCluster, así como cualquiera de sus imágenes, ilustraciones, "+
                                      "audios, videos y diseños utilizados en las distintas secciones de sitio web y/o cualquier otro "+
                                      "servicio ofrecido por LangCluster (como es su publicidad) están protegidos por los derechos de "+
                                      "autor de LangCluster y/u otras partes que hayan dado consentimiento al uso de su contenido/propiedad "+
                                      "a LangCluster.<br/><br/>"+
                                      "<strong>No</strong> puede utilizar este material y/o cualquier otro contenido sin el permiso "+
                                      "explícito de LangCluster incluyendo, pero no limitandose a, el contenido expresado en esta "+
                                      "sección.<br/><br/>"+
                                      "Cualquier otra marca, nombre de producto o marca regristrada pertenece a sus respectivos dueños.<br/><br/>"+
                                      "El contenido de los cursos, noticias o información relacionada con LangCluster y referenciada en "+
                                      "otras páginas web, a no ser que se especifique lo contrario, puede ser utilizadas para uso personal "+
                                      "y no comercial pero no debe modificar, copiar, distribuir, transmitir, mostrar, reproducir, publicar, "+
                                      "registrar o declarar como contenido propio, crear trabajos derivados de, transferir, vender o hacer "+
                                      "otro uso de cualquier información o documentación obtenido de LangCluster sin el permiso explícito "+
                                      "de la administración del mismo. Sin embargo puede leer nuestra Exención de Responsabilidad a "+
                                      "continuación para saber qué puede hacer y qué no con la mayor parte de nuestro material.</p><br/><hr width=\"90%\" size=\"2\" noshade><br/>"+
                                      
                                      "<strong>Exención de Responsabilidad</strong><br/><br/>"+
                                      "<p align='justify'>Todo nuestro contenido está sujeto a los derechos de autor de LangCluster y su personal "+
                                      "administrativo. Todos los derechos están reservados.<br/><br/>"+
                                      "Sin embargo, la distribución y uso del material, de las maneras indicadas en el punto anterior, con o "+
                                      "sin modificación estarán permitidas siempre y cuando se cumplan las siguientes condiciones:<br/><br/>"+
                                      "1. El material, contenido o información utilizado sea para fines pedagógicos y/o publicitarios.<br/>"+
                                      "2. El material, contenido o información utilizado debe indicar que es de la autoría de <strong>LangCluster</strong>.<br/>"+
                                      "3. El contenido o información utilizado debe hacer referencia a este sitio web y a su correo de contacto <em>(langcluster@gmail.com)</em> en una sección visible.<br/><br/>"+
                                      "EL SERVICIO, INCLUYENDO TODAS LAS IMÁGENES, ARCHIVOS DE AUDIO Y CONTENIDO DE LOS MISMOS, Y CUALQUIER OTRA INFORMACIÓN, "+
                                      "PROPIEDAD Y DERECHOS CONCEDIDOS O PUESTOS A DISPOSICIÓN POR LANGCLUSTER SE PROPORCIONA EN EL ESTADO EN EL QUE SE ENCUENTRA. "+
                                      "LANGCLUSTER Y SUS PROVEEDORES NO PROPORCIONAN NINGUNA DECLARACIÓN O GARANTÍA DE NINGÚN TIPO CON RESPECTO AL SERVICIO. "+
                                      "POR ESTE MEDIO LANGCLUSTER QUEDA EXENTO DE TODAS LAS DECLARACIONES Y GARANTÍAS, YA SEA EXPRESAS O IMPLÍCITAS, CREADAS POR "+
                                      "LEY, CONTRATO U OTRO MEDIO, INCLUIDAS ENTRE OTRAS, TODAS LAS GARANTÍAS DE COMERCIALIZACIÓN, INTERÉS POR ALGÚN PROPÓSITO "+
                                      "DETERMINADO, ADAPTACIÓN A UN PROPÓSITO ESPECÍFICO, TÍTULO O NO INFRACCIÓN. SIN LIMITAR LA GENERALIDAD DE LO ANTERIOR, "+
                                      "LANGCLUSTER NO HACE NINGUNA REPRESENTACIÓN O GARANTÍA DE NINGÚN TIPO RELACIONADA A LA EXACTITUD, DISPONIBILIDAD DEL "+
                                      "SERVICIO, INTEGRIDAD, CONTENIDO DE LA INFORMACIÓN, OPERACIÓN LIBRE DE ERRORES, RESULTADOS A SER OBTENIDOS POR USO O NO "+
                                      "INFRACCIÓN. EL ACCESO Y USO DEL SERVICIO PUEDE NO ESTAR DISPONIBLE DURANTE PERÍODOS DE ALTA DEMANDA, ACTUALIZACIONES AL "+
                                      "SISTEMA, MAL FUNCIONAMIENTO O MANTENIMIENTO PLANIFICADO O NO PLANIFICADO O POR OTRAS RAZONES.</p><br/><hr width=\"90%\" size=\"2\" noshade><br/>"+
                                      
                                      "<strong>Limitación de Responsabilidad</strong><br/><br/>"+
                                      "<p align='justify'>BAJO NINGÚN CASO LANGCLUSTER SERÁ RESPONSABE ANTE USTED O CUALQUIER TERCERA PARTE QUE PIDA A "+
                                      "TRAVÉS DE USTED (YA SEA A TRAVÉS POR VÍA CONTRACTUAL, AGRAVIO, RESPONSABILIDAD ESTRICTA U OTRA TEORÍA) POR DAÑOS "+
                                      "DE CUALQUIER TIPO O NATURALEZA, INCLUIDOS ENTRE OTROS, DAÑOS DIRECTOS, INDIRECTOS, INCIDENTALES, ESPECIALES, EMERGENTES "+
                                      "O FORTUITOS DERIVADOS O RELACIONADOS CON LA EXISTENCIA, USO O IMPOSIBILIDAD DE ACCESO O USO DE ESTE SITIO DE INTERNET "+
                                      "Y/O LA INFORMACIÓN O EL CONTENIDO PUBLICADO EN ESTE SITIO WEB, INCLUYENDO PER NO LIMITADO A LA PÉRDIDA DE USO DEL "+
                                      "SERIVICIO, RESULTADOS INEXACTOS, PÉRDIDA DE BENEFICIOS O PERMISOS, INTERRUPCIÓN DE NEGOCIOS, DAÑOS DERIVADOS DE LA "+
                                      "PÉRDIDA O CORRUPCIÓN DE DATOS O DATOS INCORRECTOS, EL COSTO DE LA RECUPERACIÓN DE LOS DATOS, EL COSTO DE SERVICIOS "+
                                      "SUSTITUTOS O RECLAMACIONES DE TERCEROS POR CUALQUIER DAÑO A COMPUTADORAS, HARDWARE, SOFTWARE, MÓDEMS, TELEFONOS U "+
                                      "OTRAS PROPIEDADES Y BIENES, INDEPENDIENTEMENTE DE SI LANGCLUSTER HA SIDO NOTIFICADO DE LA POSIBILIDAD DE DICHOS DAÑOS.<br/><br/>"+
                                      "El contenido original de LangCluster, incluyendo y destacando sus políticas, términos y permisos fueron redactados "+
                                      "originalmente en <strong>español</strong>. En caso de que cualquier posible traducción o adaptación de este contenido"+
                                      "sea realizado y el mismo presente conflictos con la versión en español, será la versión en español la que posea prioridad "+
                                      "y determine las acciones a realizar o proporcione la base necesaria para los puntos descritos en estas secciones.</p><br/><hr width=\"90%\" size=\"2\" noshade><br/>"+
                                      
                                      "<strong>Su Contenido</strong><br/><br/>"+
                                      "<p align='justify'>Si usted publica, sube o distribuye cualquier mensaje, dato, información, texto, "+
                                      "gráfico, hipervínculo, contenido o cualquier otro material para su uso en esta página web, está otorgando "+
                                      "(o garantizando que el poseedor los derechos de dicho contenido ha otorgado expresamente) a LangCluster el "+
                                      "derecho y licencia perpetua, mundial, libre de regalías, irrevocable y no exclusiva del contenido "+
                                      "suministrado, con el derecho de sublicenciar, usar, reproducir, modificar, adaptar, publicar, mostrar y "+
                                      "utilizar públicamente, mostrar y utilizar digitalmente, traducir, crear trabajos derivados y distribuir "+
                                      "dichas publicaciones o incorporar dichas publicaciones en cualquier forma, medio o tecnología conocida ahora "+
                                      "o desarrollada a lo largo del tiempo y el espacio.<br/>"+
                                      "Usted acepta que no tendrá recurso contra LangCluster por cualquier infracción supuesta o real o "+
                                      "apropiación indebida de cualquier derecho de propiedad en el contenido publicado y/o suministrado a "+
                                      "LangCluster.</p><br/><hr width=\"90%\" size=\"2\" noshade><br/>"+
                                      
                                      "<strong>Vínculos y Publicidad</strong><br/><br/>"+
                                      "<p align='justify'>El sitio web de LangCluster y/o cualquier otro servicio o cuenta relacionado con el "+
                                      "mismo puede contener links a otros sitios web. Estos sitios vinculados no están bajo el control de "+
                                      "LangCluster y LangCluster no es responsable y no avala el contenido de estos sitios vinculados. "+
                                      "Deberá utilizar su juicio independiente con respecto a su interacción con dichos sitios.<br/><br/>"+
                                      "De igual manera, LangCluster se reserva el derecho de utilizar el contenido existente en y/o suministrado "+
                                      "a su sitio web con fines publicitarios.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
        ];
    
    var form1=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"scrollview", 
                id:"scrollview", 
                scroll:"y", 
                body:{
                    rows:[{
                            template: "<p align='justify'>Si utiliza la sección de comentarios para dejar su sugerencia, duda, "+
                                      "pregunta, problema, etc; podrá hacerlo tan pronto haya iniciado sesión. El equipo de LangCluster "+
                                      "no puede responder a todos los comentarios individualmente, pero revisa cada uno en el menor tiempo "+
                                      "posible e indica las novedades, actualizaciones y modificaciones que puedieron ser producto de ellos "+
                                      "a través de la sección de <a href='javascript:void(0)' onclick='link(1);'>Blog (Noticias)</a>.<br/><br/>"+
                                      "Si posee un problema que necesite una respuesta, especialmente si se trata de una situación urgente o "+
                                      "no cubierta en los comentarios; o desea contactarnos de manera más directa, considere utilizar la "+
                                      "sección de <a href='javascript:void(0)' onclick='link(2);'>Contacto</a> del presente sitio web.<br/><br/>"+
                                      "Todos los comentarios pertenecen al individuo que lo escribió, LangCluster "+
                                      "niega expresamente cualquier responsabilidad por el contenido de los mismos. El uso de la "+
                                      "información suministrada en los mismos, sin embargo, es un derecho de los administradores de "+
                                      "LangCluster, pudiendo ser eliminados tras un cierto tiempo a determinar por los mismos y "+
                                      "suspendiendo la cuenta si se considera que el contenido de sus comentarios es ofensivo, denigrante "+
                                      "o inapropiado para el presente sitio web.<br/><br/>"+
                                      "Los comentarios tienen las siguientes normas básicas:<br/>"+
                                      "<i class='fa fa-chevron-circle-right' aria-hidden='true'></i>&nbsp;<strong>Sea amable</strong>. "+
                                      "Su opinión es bienvenida y apreciada, incluso si la misma indica un desacuerdo contra el contenido o "+
                                      "metodologías de LangCluster, pero debe ser expresada con respecto y cortesía. El lenguaje irrespetuoso, "+
                                      "profano, vulgar u ofensivo no será tolerado y podría dirigir a la suspensión de su cuenta.<br/>"+
                                      "<i class='fa fa-chevron-circle-right' aria-hidden='true'></i>&nbsp;<strong>No</strong> utilice los comentarios para promover productos o servicios de su compañía. "+
                                      "Igualmente, <strong>no</strong> utilice este sitio web para menospreciar los productos o servicios de "+
                                      "otras compañías.<br/>"+
                                      "<i class='fa fa-chevron-circle-right' aria-hidden='true'></i>&nbsp;Debido a limitaciones en nuestro equipo, sólo podemos aceptar y responder comentarios escritos en español. "+
                                      "Cualquier otro idioma corre el riesgo de no ser leído o respondido por LangCluster.</p>"
                            ,autoheight:true
                        }]
                    }
                }
        ];
        
    var form2=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"accordion",
                autoheight:true,
                rows:[ 
                    { header:"Información Básica", body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template: "<p align='justify'>Para permitir a este sitio web trabajar correctamente, LangCluster puede necesitar "+
                                              "guardar pequeños archivos de datos en su dispositivo o computadora. Esto es común en muchos sitios web, "+
                                              "especialmente los sistemas más complejos.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Qué son cookies?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template: "<p align='justify'>Una cookie es un pequeño archivo de texto que un sitio web guarda en su computadora o "+
                                              "dispositivo móvil cuando lo visita, permitiéndole recordar sus acciones o preferencias (como es el inicio "+
                                              "de sesión, lenguaje, tamaño de la fuente y otras preferencias visuales) durante un período de tiempo, de "+
                                              "manera que no necesite volver a indicar estas preferencias cada vez que vuelve al sitio web o navega de "+
                                              "una página a otra dentro del mismo.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Cómo usamos las cookies?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template: "<p align='justify'>LangCluster utiliza cookies para guardar sus datos de inicio de sesión de manera "+
                                              "que no deba escribirlos nuevamente cada vez que ingresa al sitio web. Asimismo, las utiliza para "+
                                              "establecer su avance en el juego y para facilitar su navegación entre las distintas páginas que "+
                                              "componen el sitio web de LangCluster, dándole el acceso a las mismas cuando sea pertinente.<br/><br/>"+
                                              "Habilitar el uso de cookies en este sitio es <strong>importante</strong> y <strong>necesario</strong> "+
                                              "si desea que el mismo funcione correctamente, evitando así posibles problemas de acceso, lectura y "+
                                              "registro de datos que puedan presentarse durante su estancia en el mismo y mejorando su experiencia e "+
                                              "navegación como usuario. Aún así, puede eliminar o bloquear estas cookies si lo desea, pero corre el "+
                                              "riesgo de que ciertas partes del sitio no funcionen como deberían.<br/><br/>"+
                                              "Los datos administrados por nuestras cookies no son utilizados para identificarlo personalmente y la "+
                                              "data guardada es controlada única y exclusivamente por LangCluster. Estas cookies no son utilizadas "+
                                              "para ningún otro propósito no descrito en esta sección.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Cómo administro las cookies?", collapsed:true,body:{
                            view:"scrollview", 
                            id:"scrollview", 
                            scroll:"y", 
                            body:{
                                rows:[{
                                    template: "<p align='justify'>Puede manejar y/o borrar las cookies según lo desee, puede leer más detalles de esto "+
                                              "en <a href='http://aboutcookies.org/'>aboutcookies.org</a>. Puede borrar todas las cookies existentes en "+
                                              "su computadora y prevenir que la mayoría de los navegadores las utilicen o permitan su registro.<br/><br/>"+
                                              "Si lo hace, sin embargo, podría tener que ajustar manualmente algunas preferencias del sitio web cada vez "+
                                              "que lo visite y algunas secciones y/o servicios del mismo podrían no funcionar correctamente o ser "+
                                              "accesibles sin ellas.<br/><br/>"+
                                              "Si desea información personalizada sobre este proceso, por favor seleccione su navegador a continuación:<br/><br/>"+
                                              "<i class='fa fa-chevron-circle-right' aria-hidden='true'></i>&nbsp;<a href='https://support.google.com/chrome/answer/95647?hl=en'>Google Chrome</a>.<br/>"+
                                              "<i class='fa fa-chevron-circle-right' aria-hidden='true'></i>&nbsp;<a href='https://support.mozilla.org/en-US/kb/cookies-information-websites-store-on-your-computer'>Mozilla Firefox</a>.<br/>"+
                                              "<i class='fa fa-chevron-circle-right' aria-hidden='true'></i>&nbsp;<a href='http://windows.microsoft.com/en-US/internet-explorer/delete-manage-cookies#ie=ie-11'>Internet Explorer</a>.<br/>"+
                                              "<i class='fa fa-chevron-circle-right' aria-hidden='true'></i>&nbsp;<a href='https://support.apple.com/en-us/HT201265'>Safari</a>.<br/>"+
                                              "<i class='fa fa-chevron-circle-right' aria-hidden='true'></i>&nbsp;<a href='http://help.opera.com/Mac/12.10/en/cookies.html'>Opera</a>.</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    }
                ]
            }
        ];
        
    var form3=[
            {template:"<center><br/><img src='img/LangCluster.png'/><br/><br/></center>",autoheight:true},
            {   view:"accordion",
                autoheight:true,
                rows:[ 
                    { header:"Información Básica", body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template: "<p align='justify'>En el mismo orden de ideas, LangCluster hace uso únicamente de los datos explicitamente mostrados y/o"+
                                              "descritos en el sitio web, sus secciones, políticas y servicios relacionados con los mismos."+
                                              "Seguir: https://www.duolingo.com/privacy </p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    },
                    { header:"¿Qué son cookies?", collapsed:true, body:{
                        view:"scrollview", 
                        id:"scrollview", 
                        scroll:"y", 
                        body:{
                            rows:[{
                                    template: "<p align='justify'>X</p>"
                                    ,autoheight:true
                                }]
                            }
                        }
                    }
                ]
            }
        ];
        
    access();
    function access(){
        webix.ui({
            id:"page",
            cols:[{width:20},
                  {
                    rows:[{height:20},
                          {view:"tabbar", id:"tab", multiview:true, options: [
                                    { value: "Términos y Condiciones", id: 'form0' },
                                    { value: "Política de Comentarios", id: 'form1' },
                                    { value: "Política de Cookies", id: 'form2' },
                                    { value: "Política de Privacidad", id: 'form3' }
                                ],height:50
                           },
                           {cells:[{id:"form0",rows: form0},
                                   {id:"form1",rows: form1},
                                   {id:"form2",rows: form2},
                                   {id:"form3",rows: form3}
                                  ]
                           },
                           {height:20}
                    ]
                  },
                  {width:20}
            ]
        });
    }
    
    function link(id){
        switch(id){
            case 1: window.open('news.jsp', '_self'); break;
            case 2: window.open('contact.jsp', '_self'); break;
        }
    }
    </script>
    </body>
</html>
