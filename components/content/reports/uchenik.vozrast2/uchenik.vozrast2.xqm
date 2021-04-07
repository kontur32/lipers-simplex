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
  
  let $детиВсего :=
    $data/table/row
    [   
        dateTime:dateParse( cell[ @label = 'дата поступления в ОО' ]/text() )
        <=
        $текущаяДата
        and
        dateTime:dateParse( cell[ @label = 'дата выбытия из ОО' ]/text() ) >=
        $текущаяДата
    ]

  return
    map{
      'дата' : $текущаяДата,
      'детиПоКлассам' : uchenik.vozrast:детиПоКлассам( $детиВсего, $текущаяДата ),
      'детиПоВозрасту' : uchenik.vozrast:детиПоВозрасту( $детиВсего, $текущаяДата )
    }
};

declare function uchenik.vozrast:детиПоВозрасту( $детиВсего, $текущаяДата ){  
  let $текущийКласс :=
      function( $ученик as element( row ), $текущаяДата as xs:date ){
         let $датаЗачисления :=
            dateTime:dateParse( $ученик/cell[ @label = "дата поступления в ОО" ]/text() )
         let $классВКоторыйПоступил := 
            $ученик/cell[ @label = "Класс, в который поступил ребенок" ]/text()
         return
           uchenik.vozrast:текущийКласс(
             $текущаяДата,
             $датаЗачисления,
             $классВКоторыйПоступил
           )
      }
  
  let $возраст := ( 6 to 18 )
  
  let $детиПоКлассам := 
    for $класс in ( 1 to 11 )    
    let $детейВКлассе := 
            $детиВсего[ $текущийКласс( ., $текущаяДата ) = $класс ]
    
    return
      <tr>
        <td>{ $класс }</td>
        <td class = "text-center">{ count( $детейВКлассе ) }</td>
        {
          for $j in $возраст
          let $детиВозраста :=
           $детейВКлассе[ cell[ @label = 'дата рождения' ]/years-from-duration(
              dateTime:yearsMonthsDaysCount( current-date(), dateTime:dateParse(
              text()
            ) )
            ) = $j ]
          let $детейВсегоПоВозрасту := count( $детиВозраста )
          let $шрифт := 
            $детейВсегоПоВозрасту ?? 'font-weight-bold' !! ''
          return
            (
                <td class = '{ $шрифт }'>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'м'] ) }</td>,
                <td class = '{ $шрифт }'>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'ж'] ) }</td>,
                <td class = "text-center { $шрифт }">{ $детейВсегоПоВозрасту }</td>
              )
        }
      </tr>
  
  let $детиВсего :=
        <tr>
          <td>Всего </td>
          <td class = "text-center">{ count( $детиВсего ) }</td>
          {
            for $j in $возраст
            let $детиВозраста :=
             $детиВсего[
               cell[ @label = 'дата рождения' ]
               /years-from-duration(
                  dateTime:yearsMonthsDaysCount(
                    current-date(),
                    dateTime:dateParse( text() )
                  )
                ) = $j ]
            return
              (
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'м' ] ) }</td>,
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'ж' ] ) }</td>,
                <td class = "text-center">{ count( $детиВозраста ) }</td>
              )
          }
        </tr>
  return
     <table class = 'table-striped'>
       <tr class = "text-center">
          <th rowspan = "3">Класс</th>
          <th rowspan = "3">В классе</th>
          <th colspan = "39">Возраст</th>
        </tr>
        <tr>
          {
            for $j in $возраст
            return
              <th colspan = "3" class = "text-center">{ $j }</th>
          }
        </tr>
        <tr>{
          for $j in $возраст
            return
              (
                <th>м</th>,
                <th>д</th>,
                <th>всего</th>
              )
              
        }</tr>
        { $детиПоКлассам }
        { $детиВсего }
     </table>
};

declare function uchenik.vozrast:детиПоКлассам( $детиВсего, $текущаяДата as xs:date ){
  let $детиПоКлассам :=   
    for $i in $детиВсего
    let $датаЗачисления :=
      dateTime:dateParse( $i/cell[ @label = "дата поступления в ОО"]/text() )
    let $классВКоторыйПоступил := 
      $i/cell[ @label = "Класс, в который поступил ребенок"]/text()

    let $классИзБазы := $i/cell[ @label = "Класс" ]/text()
    let $классРассчетный := 
       uchenik.vozrast:текущийКласс( $текущаяДата , $датаЗачисления, $классВКоторыйПоступил )
    let $датаРождения := dateTime:dateParse( $i/cell[ @label = "дата рождения"]/text() )
    
    order by $классРассчетный
    count $c
    return
      <tr>
        <td>{ $c }</td>
        <td>{ $i/cell[ @label = "Фамилия,"]/text()}</td>
        <td class = "text-center">{  $датаРождения }</td>
        <td class = "text-center">
          { uchenik.vozrast:возраст( $текущаяДата,  $датаРождения ) }
        </td>
        <td class = "text-center">{ $датаЗачисления }</td>
        <td class = "text-center">{ $классВКоторыйПоступил }</td>
        <td class = "text-center">{ $классИзБазы }</td>
        <td class = "text-center">{ $классРассчетный }</td>
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