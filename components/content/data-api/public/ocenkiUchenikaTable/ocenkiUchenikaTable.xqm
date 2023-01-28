module namespace ocenkiUchenikaTable = 'content/data-api/public/ocenkiUchenikaTable';

declare function ocenkiUchenikaTable:main($params){
  let $идентификаторУченика :=
    if(request:parameter('номерЛичногоДелаУченика'))
    then(request:parameter('номерЛичногоДелаУченика'))
    else($params?номерЛичногоДелаУченика)
  
  let $оценкиУченика := 
    $params?_tpl(
      'content/data-api/public/ocenkiUchenikaRaw', 
      map{'номерЛичногоДелаУченика':$идентификаторУченика}
    )//_
  
  let $строки :=
    for $записиПоПредмету in $оценкиУченика
    let $предмет := $записиПоПредмету/предмет/value/text()
    group by $предмет
    order by $предмет
    return
     <tr>
       <td>{$предмет}</td>
       <td>{
         for $записьПоПредмету in $записиПоПредмету
         let $date := 
           format-date(
             xs:date($записьПоПредмету/дата/value/text()),
             '[D01].[M01].[Y0001]'
           ) 
         order by xs:date($записьПоПредмету/дата/value/text())
         return
           <font title="{$date}">{$записьПоПредмету/оценка/value/text()}, </font>
       }</td>
       <td class="text-center">{
         ocenkiUchenikaTable:среднийБаллТекущихОценок($записиПоПредмету)
       }</td>
       <td class="text-center"></td>
     </tr>
  return
    map{'строки' : $строки}
};

declare
function
  ocenkiUchenikaTable:среднийБаллТекущихОценок($записиЖурнала){
    let $всеОценки :=
       for $записьЖурнала in $записиЖурнала
       let $оценка := 
         substring(replace($записьЖурнала/оценка/value/text(), '\D', ''), 1, 1)
       where $оценка
       return
         xs:integer($оценка)
     return
       round(avg($всеОценки), 2)
  };