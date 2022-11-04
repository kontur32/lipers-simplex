module namespace raspisanieTeachers = 'content/data-api/public/raspisanieTeachersAll';

declare function raspisanieTeachers:main($params){
  
  let $расписание := raspisanieTeachers:расписаниеRDF($params)
  
  let $меню := 
    for $i in raspisanieTeachers:списокВсехУчителей($params)/row [(cell[@label="активППС"]/text())]
    order by $i 
  return
   ( 
   <table>
   <td align="center">
   <a href="?номерЛичногоДела={$i/cell[@label = 'номер личного дела']}&amp;деньНедели={request:parameter('деньНедели')}">{$i/cell[1]}</a></td></table>
    )
  return
    map{
      'данные' : $расписание  ,
      'меню'   : $меню ,
      'фио'    : <h5><center>{ distinct-values(tokenize(raspisanieTeachers:учитель($params))) }</center></h5>
    }
};

declare function raspisanieTeachers:расписаниеRDF($params){
  let $номерЛичногоДела := 
    if (not (request:parameter('номерЛичногоДела')))
    then ('П/1')
    else (request:parameter('номерЛичногоДела'))
    
  let $деньНедели := 1 to 5
 
  for $расписание in 
    fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp": "http://a.roz37.ru/lipers/запросы/расписание-учителей",
          "номерЛичногоДела":$номерЛичногоДела,
          "деньНедели":$деньНедели    
            } 
                    )
              )
   return
     $расписание
};

declare function raspisanieTeachers:учитель($params){
    for $i in raspisanieTeachers:списокВсехУчителей($params)/row
      where $i/cell[@label = 'номер личного дела'] = request:parameter('номерЛичногоДела')
    return
     distinct-values($i/cell[1])
};

declare
  %private
function
  raspisanieTeachers:списокВсехУчителей($params) as element(table)
{
    $params?_getFileStore(
       'авторизация/lipersTeachers.xlsx',
       './file/table[1]',
       $params?_config('store.yandex.personalData')
     )/table
};