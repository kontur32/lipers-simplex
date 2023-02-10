module namespace raspisanieTeachers = 'content/data-api/public/raspisanieTeachers';

declare function raspisanieTeachers:main($params){
  let $расписание := raspisanieTeachers:расписаниеRDF($params)
  return
    map{
      'данные' : <result><расписание>{ $расписание ?? $расписание !! 'Занятий нет'}</расписание></result>
    }
};

declare function raspisanieTeachers:расписаниеRDF($params){
  let $номерЛичногоДела := request:parameter('номерЛичногоДела')
  let $деньНедели := request:parameter('деньНедели')
  let $запрос := 'http://a.roz37.ru/lipers/запросы/расписание-учителя'
  let $параметрыЗапроса :=
    map{
     "номерЛичногоДела":$номерЛичногоДела,
     "деньНедели":$деньНедели
    }
  return
    $params?_semantikQueryRDF($запрос, $параметрыЗапроса)/text()
};