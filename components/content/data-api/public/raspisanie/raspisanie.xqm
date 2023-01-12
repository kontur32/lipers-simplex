module namespace raspisanie = 'content/data-api/public/raspisanie';

declare function raspisanie:main($params){
    map{'данные' : raspisanie:расписаниеRDF($params)}
};

declare function raspisanie:расписаниеRDF($params){
  if($params?класс and $params?деньНедели)
  then(
     let $нормализованныйКласс := lower-case(replace($params?класс, '\s', ''))
     let $деньНедели := xs:integer($params?деньНедели)
     let $data := 
       fetch:xml(
        web:create-url(
          "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
          map{
            "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
            "класс":$нормализованныйКласс
          }
        )
      )//table[1]/tr[position()>1]/td[1+$деньНедели]
     let $уроки := 
       for $i in $data
       count $c
       return
         $c || ') ' || $i/text()
     return
        <result>
          <уроки>{string-join($уроки, ';&#10;')}</уроки>
        </result>
  )
  else(<result><уроки>Ошибка запроса</уроки></result>)
};