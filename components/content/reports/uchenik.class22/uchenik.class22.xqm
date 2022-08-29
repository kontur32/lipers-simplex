module namespace uchenik.class22 = 'content/reports/uchenik.class22';

declare function  uchenik.class22:main($params){
   
  let $реестрКлассов := 
    ('0','1','2','3','4','5','6','7','8','9','10','11')
  let $реестрКлассов :=
    $params?_tpl( 'content/data-api/public/spisokClassov', $params)
    //классы/table/row/cell/text()
  
  let $класс := 
    request:parameter('класс') ?? request:parameter('класс') !! '1'
  let $меню := for $i in $реестрКлассов return <a href="?класс={$i}">{$i}</a>
  
  let $списокКласса :=  
    $params?_tpl( 'content/data-api/public/spisokUchenikovClass', map:merge(($params, map{'класс':$класс })))//списокКласса/text()
    
  
  return
    map{
      'меню':$меню,
      'класс':$класс,
      'расписание' : 
        <ul>{
          for $i in tokenize($списокКласса, ';') return <li>{$i}</li>
        }</ul>
    }
};