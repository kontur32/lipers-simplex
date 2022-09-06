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
       "http://a.roz37.ru:9984/garpix/semantik/app/request/execute?rp=http://a.roz37.ru/lipers/%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D1%8B/%D1%80%D0%B0%D1%81%D0%BF%D0%B8%D1%81%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B0%D1%81%D1%81%D0%BE%D0%B2&amp;%D0%BA%D0%BB%D0%B0%D1%81%D1%81="|| web:encode-url($класс)
  )//table[1]
  return
    map{
      'меню':$меню,
      'класс':$класс,
      'расписание' : $расписание 
    }
};