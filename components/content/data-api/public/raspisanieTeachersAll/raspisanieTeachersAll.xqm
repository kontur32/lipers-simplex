module namespace raspisanieTeachers = 'content/data-api/public/raspisanieTeachersAll';

declare function raspisanieTeachers:main($params){
  let $номерЛичногоДела := 
    if (not (request:parameter('номерЛичногоДела')))
    then ('П/1')
    else (request:parameter('номерЛичногоДела'))
  let $расписание := raspisanieTeachers:расписаниеRDF($params, $номерЛичногоДела)
  let $учителя := raspisanieTeachers:списокВсехУчителей($params)
  let $меню := 
    for $i in $учителя/row[(cell[@label="активППС"]/text())]
    order by $i
    let $номерЛичногоДела := $i/cell[@label='номер личного дела']/text()
    return
     <table>
       <td align="center">
          <a href="?номерЛичногоДела={$номерЛичногоДела}">{$i/cell[1]}</a>
       </td>
     </table>

  return
    map{
      'данные' : $расписание,
      'меню'   : $меню,
      'фио'    : raspisanieTeachers:учитель($учителя, $номерЛичногоДела)
    }
};

declare function raspisanieTeachers:расписаниеRDF($params, $номерЛичногоДела){  
  let $расписание := 
    let $запрос := 'http://a.roz37.ru/lipers/запросы/расписание-учителей'
    let $параметрыЗапроса := map{"номерЛичногоДела":$номерЛичногоДела}
    return $params?_semantikQueryRDF($запрос, $параметрыЗапроса)//table
  return
     $расписание
};

declare function raspisanieTeachers:учитель($учителя, $номерЛичногоДела){
  $учителя/row
  [cell[@label = 'номер личного дела']=$номерЛичногоДела][1]
  /cell[1]/text()
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