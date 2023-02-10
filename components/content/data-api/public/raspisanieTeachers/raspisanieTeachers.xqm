module namespace raspisanieTeachers = 'content/data-api/public/raspisanieTeachers';

declare function raspisanieTeachers:main($params){
  let $расписание := raspisanieTeachers:расписаниеRDF($params)
  return
    map{
      'данные' : <расписание>{ $расписание ?? $расписание !! 'Занятий нет'}</расписание>
    }
};

declare function raspisanieTeachers:расписаниеRDF($params){
  let $номерЛичногоДела := request:parameter('номерЛичногоДела')
  let $деньНедели := request:parameter('деньНедели')
  let $расписание := 
    fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-учителя",
          "номерЛичногоДела":$номерЛичногоДела,
          "деньНедели":$деньНедели
        }
      )
    )/result/text()
   
   let $расписание :=
     let $запрос := 'http://a.roz37.ru/lipers/запросы/расписание-учителя'
     let $параметрыЗапроса :=
       map{
         "номерЛичногоДела":$номерЛичногоДела,
         "деньНедели":$деньНедели
       }
     return
       $params?_semantikQueryRDF($запрос, $параметрыЗапроса)/text()
   return
     $расписание
};