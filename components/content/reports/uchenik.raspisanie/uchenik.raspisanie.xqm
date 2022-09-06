module namespace uchenik.raspisanie = 'content/reports/uchenik.raspisanie';

declare function  uchenik.raspisanie:main($params){
  let $реестрКлассов := 
    $params?_tpl('content/data-api/public/spisokClassov', $params)
    //класс/text()
  let $класс := 
    request:parameter('класс') ?? request:parameter('класс') !! $реестрКлассов[1]
  let $меню := for $i in $реестрКлассов return <a href="?класс={$i}">{$i}</a> 
  let $расписание :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":$класс
        }
      )
    )//table[1]
  return
    map{
      'меню':$меню,
      'класс':$класс,
      'расписание' : $расписание 
    }
};