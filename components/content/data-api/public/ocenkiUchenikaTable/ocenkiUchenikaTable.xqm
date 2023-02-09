module namespace ocenkiUchenikaTable = 'content/data-api/public/ocenkiUchenikaTable';

declare function ocenkiUchenikaTable:main($params){
  let $идентификаторУченика := $params?номерЛичногоДелаУченика
  let $период := ocenkiUchenikaTable:период()
  let $началоПериода := $период?началоПериода
  let $конецПериода := $период?конецПериода
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
    let $записиПоПредметуЗаПериод := 
       for $записьПоПредмету in $записиПоПредмету
       let $date := $записьПоПредмету/дата/value/text()
       where ($date <= $период?конецПериода) and ($date >= $период?началоПериода)
       order by $date
       return
         $записьПоПредмету 
    let $пропуски :=
      $записиПоПредметуЗаПериод[matches(оценка/value/text(), 'н')]
    return
     <tr>
       <td>{$предмет}</td>
       <td>
         {
           for $записьПоПредмету in $записиПоПредметуЗаПериод
           return
             (ocenkiUchenikaTable:однаЗаписьЖурнала($записьПоПредмету), ', ')
         }
         (пропусков: {count($пропуски)})
       </td>
       <td class="text-center">{
         ocenkiUchenikaTable:среднийБаллТекущихОценок($записиПоПредметуЗаПериод)
       }</td>
       <td class="text-center">{
         ocenkiUchenikaTable:среднийБаллОценокКонтрольные($записиПоПредметуЗаПериод)
       }</td>
     </tr>
  return
    map{'строки' : $строки}
};

declare
  %private
function
ocenkiUchenikaTable:среднийБаллОценокКонтрольные($записиЖурнала){
  let $всеОценки :=
     for $записьЖурнала in $записиЖурнала
     where matches($записьЖурнала/оценка/value/text(), 'к')
     let $оценка := 
       substring(replace($записьЖурнала/оценка/value/text(), '\D', ''), 1, 1)
     where $оценка
     return
       xs:integer($оценка)
   return
     round(avg($всеОценки), 2)
};
  

declare
  %private
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
  
declare
  %private
function
ocenkiUchenikaTable:однаЗаписьЖурнала($записьПоПредмету){
  let $date := 
     format-date(
       xs:date($записьПоПредмету/дата/value/text()),'[D01].[M01].[Y0001]'
     )
  for $i in tokenize($записьПоПредмету/оценка/value/text(), ';')
   let $буква := substring(replace($i, '\d', ''), 1, 1)  
   let $оценка := substring(replace($i, '\D', ''), 1, 1)
   let $печатьЗаписи :=
     switch($буква)
     case 'к'
       return
         <b title="{$date}">{$оценка}</b>
     case 'д'
       return
         <font size="3" title="{$date} Дом.работа" color="red" face="Arial">{$оценка}</font>
      default return <font title="{$date}">{$i}</font>
   return
     $печатьЗаписи
};

declare function ocenkiUchenikaTable:период(){
  let $началоПериода := 
    if(request:parameter('началоПериода'))
    then(request:parameter('началоПериода'))
    else(       
        if (fn:month-from-date(current-date() ) = (06, 07, 08, 09, 10, 11, 12))
        then (fn:year-from-date(current-date()) || '-09-01')
        else fn:year-from-date(current-date() ) - 1 || '-09-01'
        )
  let $конецПериода := 
    if(request:parameter('конецПериода'))
    then(request:parameter('конецПериода'))
    else(format-date(current-date(), "[Y0001]-[M01]-[D01]"))
  return
    map{
      'началоПериода':$началоПериода,
      'конецПериода':$конецПериода
    }
};