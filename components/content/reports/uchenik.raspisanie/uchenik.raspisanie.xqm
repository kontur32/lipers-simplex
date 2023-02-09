module namespace uchenik.raspisanie = 'content/reports/uchenik.raspisanie';

declare function  uchenik.raspisanie:main($params){
  let $реестрКлассов := 
    $params?_tpl('content/data-api/public/spisokClassovRDF', $params)
    //класс/text()
  let $класс := 
    request:parameter('класс') ?? request:parameter('класс') !! $реестрКлассов[1]
  let $меню := for $i in $реестрКлассов return <a href="?класс={$i}">{$i}</a> 
  let $расписание :=  
     $params?_tpl(
       'content/data-api/public/raspisanieRDFNew',
       map{'класс':$класс}
     )//table[1]
  return
    map{'меню':$меню, 'класс':$класс, 'расписание' : $расписание}
};