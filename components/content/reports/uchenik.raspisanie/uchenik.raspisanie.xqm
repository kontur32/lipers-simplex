module namespace uchenik.raspisanie = 'content/reports/uchenik.raspisanie';

declare function  uchenik.raspisanie:main($params){
  let $реестрКлассов := 
    $params?_tpl( 'content/data-api/public/spisokClassov', $params)
    //классы/table/row/cell/text()
  
  let $класс := 
    request:parameter('класс') ?? request:parameter('класс') !! '1'
  let $меню := for $i in $реестрКлассов return <a href="?класс={$i}">{$i}</a>
  
  let $расписание :=  
    $params?_tpl( 'content/data-api/public/raspisanie', map:merge(($params, map{'класс':$класс })))
  return
    map{
      'меню':$меню,
      'класс':$класс,
      'расписание' : $расписание 
    }
};