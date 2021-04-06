module namespace uchenik.vozrast = 'content/reports/uchenik.vozrast2';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function uchenik.vozrast:main( $params ){
  
  let $текущаяДата :=
    if( request:parameter( 'дата' ) )
    then( xs:date( request:parameter( 'дата' ) ) )
    else( xs:date( '2021-04-06' ) ) 
  
  let $data :=
    $params?_getFile(
       'Kids/kids-site-lipers.xlsx',
       './file/table[ @label = "ППС" ]'
     )

  return
    map{
      'дата' : $текущаяДата,
      'таблица' : uchenik.vozrast:строкиТаблицы( $data/table, $текущаяДата )
    }
};

declare function uchenik.vozrast:строкиТаблицы( $data, $текущаяДата as xs:date ){
  let $детиВсего :=
    $data/row
    [   
        (
          not( normalize-space( cell[ @label = 'дата выбытия из ОО' ]/text() ) ) and
          dateTime:dateParse( cell[ @label = 'дата поступления в ОО' ]/text() ) <=
          $текущаяДата
        
        )
        or
        dateTime:dateParse( cell[ @label = 'дата выбытия из ОО' ]/text() ) >=
        $текущаяДата
    ]
    [ cell[ @label = 'Класс' ]/text() ]
  
let $детиПоКлассам :=   
  for $i in $детиВсего
  let $датаЗачисления :=
    dateTime:dateParse( $i/cell[ @label = "дата поступления в ОО"]/text() )
  let $классВКоторыйПоступил := 
    $i/cell[ @label = "Класс, в который поступил ребенок"]/text()
  where not( $i/cell[ @label = "дата выбытия из ОО"]/text() )
  where normalize-space( $i/cell[ @label = "Класс"]/text() )
  count $c
  let $датаРождения := dateTime:dateParse( $i/cell[ @label = "дата рождения"]/text() )
  return
    <tr>
      <td>{ $c }</td>
      <td>{ $i/cell[ @label = "Фамилия,"]/text()}</td>
      <td class = "text-center">{  $датаРождения }</td>
      <td class = "text-center">{ uchenik.vozrast:возраст( $текущаяДата,  $датаРождения ) }</td>
      <td class = "text-center">{ $датаЗачисления }</td>
      <td class = "text-center">{ $классВКоторыйПоступил }</td>
      <td class = "text-center">{ $i/cell[ @label = "Класс"]/text()}</td>
      <td class = "text-center">{ uchenik.vozrast:текущийКласс( $текущаяДата , $датаЗачисления, $классВКоторыйПоступил ) }</td>
    </tr>
  
  return
     <table class = 'table-striped'>
       <tr class = "text-center">
          <th>№ пп</th>
          <th>Фамилия</th>
          <th>Дата рождения</th>
          <th>Возраст</th>
          <th>Дата зачисления</th>
          <th>Класс поступления</th>
          <th>Класс в базе</th>
          <th>Класс расчетный</th>
        </tr>
        { $детиПоКлассам }
     </table>
};

declare
  %private
function
  uchenik.vozrast:текущийКласс(
    $текущаяДата as xs:date,
    $датаЗачисления as xs:date,
    $классЗачисления
){
  let $началоГода :=
    function( $дата ){
        if( $дата < xs:date( year-from-date( $дата ) || '-09-01' ) )
        then( year-from-date( $дата ) - 1 )
        else( year-from-date( $дата ) )
    }
  return
    xs:integer( $классЗачисления ) + 
    $началоГода(  $текущаяДата  ) - 
    $началоГода( $датаЗачисления  )
};

declare
  %private
function
  uchenik.vozrast:возраст( $текущаяДата as xs:date, $датаРождения as xs:date ){
    years-from-duration(
      dateTime:yearsMonthsDaysCount(
        $текущаяДата,
        $датаРождения 
      )
    )
  };