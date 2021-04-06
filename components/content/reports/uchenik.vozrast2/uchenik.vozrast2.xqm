module namespace uchenik.vozrast = 'content/reports/uchenik.vozrast2';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function uchenik.vozrast:main( $params ){
  
  let $дата :=
    if( request:parameter( 'дата' ) )
    then( request:parameter( 'дата' ) )
    else( substring-before( xs:string( current-date() ), '+' ) ) 
  
  let $data :=
    $params?_getFile(
       'Kids/kids-site-lipers.xlsx',
       './file/table[ @label = "ППС" ]'
     )

  return
    map{
      'дата' : $дата,
      'таблица' : uchenik.vozrast:строкиТаблицы( $data/table, $дата )
    }
};

declare function uchenik.vozrast:строкиТаблицы( $data, $дата ){
  let $детиВсего :=
    $data/row
    [   
        (
          not( normalize-space( cell[ @label = 'дата выбытия из ОО' ]/text() ) ) and
          dateTime:dateParse( cell[ @label = 'дата поступления в ОО' ]/text() ) <=
          xs:date( $дата )
        
        )
        or
        dateTime:dateParse( cell[ @label = 'дата выбытия из ОО' ]/text() ) >=
        xs:date( $дата ) 
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
  let $датаРождения := $i/cell[ @label = "дата рождения"]/text()
  return
    <tr>
      <td>{ $c }</td>
      <td>{ $i/cell[ @label = "Фамилия,"]/text()}</td>
      <td class = "text-center">{ dateTime:dateParse( $датаРождения ) }</td>
      <td class = "text-center">{ uchenik.vozrast:возраст( $датаРождения ) }</td>
      <td class = "text-center">{ $датаЗачисления }</td>
      <td class = "text-center">{ $классВКоторыйПоступил }</td>
      <td class = "text-center">{ $i/cell[ @label = "Класс"]/text()}</td>
      <td class = "text-center">{ uchenik.vozrast:текущийКласс( $дата, $датаЗачисления, $классВКоторыйПоступил ) }</td>
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
    $текущаяДата,
    $датаЗачисления,
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
    $началоГода( $текущаяДата ) - 
    $началоГода( $датаЗачисления )
};

declare
  %private
function
  uchenik.vozrast:возраст( $дата ){
    years-from-duration(
      dateTime:yearsMonthsDaysCount(
        current-date(),
        dateTime:dateParse( $дата )
      )
    )
  };