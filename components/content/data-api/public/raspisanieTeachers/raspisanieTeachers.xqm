module namespace raspisanieTeachers = 'content/data-api/public/raspisanieTeachers';

declare function raspisanieTeachers:main($params){
  let $расписание := raspisanieTeachers:расписаниеRDF()
  return
    map{
      'данные' : <расписание>{ $расписание ?? $расписание !! 'Занятий нет'}</расписание>
    }
};

declare function raspisanieTeachers:расписаниеRDF(){
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
   return
     $расписание
};