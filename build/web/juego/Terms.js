function newGame(){
    var data1=$.ajax({
        type:'POST',
        data: {topic:1, id:"Game1"},
        url: '../Servlet'
    });
    data1.done(function(result){
        return result;
    });
}

//Retorna los 20 términos de un nuevo juego
function newGame2(){
    var data1;
    getNewTerms(function(result){
        if(!result || 0 === result.length){
            data1=null;
        }
        else{
            data1=result;
        }
    });
    return data1;
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

/*
15 palabras random:

select newTable.madurez,termino.termino from termino left join (select termino.id_termino,madurez 
from aux_sesion_termino
inner join termino on
termino.id_termino=aux_sesion_termino.id_termino
where termino.id_topico=1 group by termino.id_termino) as newTable
on newTable.id_termino=termino.id_termino
where termino.id_topico=1 and
newTable.madurez is null or newTable.madurez=0
group by termino.termino
order by rand() limit 15;


20 palabras de repaso:

select (aux_termino_usuario.tiempo * aux_termino_usuario.errores) as review_order, 
termino.termino from aux_termino_usuario
inner join usuario on
usuario.id_usuario=aux_termino_usuario.id_usuario
inner join termino on
termino.id_termino=aux_termino_usuario.id_termino
where usuario.id_usuario=(select id_usuario from usuario where email="diego@gmail.com") and termino.id_topico=1
order by review_order desc;

Completación:

select termino.termino from termino left join (select termino.id_termino,madurez 
from aux_sesion_termino
inner join termino on
termino.id_termino=aux_sesion_termino.id_termino
where termino.id_topico=1 group by termino.id_termino) as newTable
on newTable.id_termino=termino.id_termino
where termino.id_topico=1 and
newTable.madurez is not null or newTable.madurez!=0
group by termino.termino
order by rand() limit 15;

 */