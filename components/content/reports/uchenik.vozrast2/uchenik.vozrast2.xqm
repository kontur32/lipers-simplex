module namespace uchenik.vozrast = 'content/reports/uchenik.vozrast2';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare variable $uchenik.vozrast:месяцДеньПеревода := '06-01';

declare function uchenik.vozrast:main( $params ){
  
  let $текущаяДата :=
    if( request:parameter( 'дата' ) )
    then( xs:date( request:parameter( 'дата' ) ) )
    else( xs:date( '2021-04-06' )  ) 
    
  let $data :=
    $params?_getFileStore(
       'авторизация/lipersKids.xlsx',
       './file/table[1]',
       $params?_config('store.yandex.personalData')
     )

  let $детиВсего :=
    $data/table/row
    [   
        dateTime:dateParse( cell[ @label = 'дата поступления в ОО' ]/text() )
        <=
        $текущаяДата
        and
        (dateTime:dateParse( cell[ @label = 'дата выбытия из ОО' ]/text() ) >=
        $текущаяДата or not(  cell[ @label = 'дата выбытия из ОО' ]/text() ) )
    ]

  return
    map{
      'дата' : xs:string( $текущаяДата ),
      'детиПоКлассам' :  uchenik.vozrast:детиПоКлассам( $детиВсего, $текущаяДата ) ,
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
        <td class = "text-center">{ count( $детейВКлассе[ cell[ @label = 'пол' ] = 'м']  ) }</td>
        <td class = "text-center">{ count( $детейВКлассе[ cell[ @label = 'пол' ] = 'ж']  ) }</td>
        {
          for $j in $возраст
          let $детиВозраста :=
           $детейВКлассе[
               uchenik.vozrast:возраст( 
               $текущаяДата,
               dateTime:dateParse( cell[ @label = 'дата рождения' ]/text() )
             ) = $j
              ]
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
  

  let $детиВсегоНОО :=
   let $НОО := ( 1 to 4 )    
    let $детейНОО := 
            (($детиВсего[ $текущийКласс( ., $текущаяДата ) = $НОО ]))
            return
      
        <tr>
          <td>Всего НОО </td>
          <td class = "text-center">{ (sum (count ($детейНОО ))) }</td>
          <td class = "text-center">{ count( $детейНОО[ cell[ @label = 'пол' ] = 'м'] ) }</td>
          <td class = "text-center">{ count( $детейНОО[ cell[ @label = 'пол' ] = 'ж'] ) }</td>
          {
            for $j in $возраст
            let $детиВозраста :=
             $детейНОО[
               uchenik.vozrast:возраст( 
               $текущаяДата,
               dateTime:dateParse( cell[ @label = 'дата рождения' ]/text() )
             ) = $j
              ]
            return
              (
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'м' ] ) }</td>,
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'ж' ] ) }</td>,
                <td class = "text-center">{ count( $детиВозраста ) }</td>
              )
          }
        </tr>
        
        
  let $детиВсегоООО :=
   let $ООО := ( 5 to 9 )    
    let $детейООО := 
            (($детиВсего[ $текущийКласс( ., $текущаяДата ) = $ООО ]))
            return
      
        <tr>
          <td>Всего ООО </td>
          <td class = "text-center">{ (sum (count ($детейООО ))) }</td>
          <td class = "text-center">{ count( $детейООО[ cell[ @label = 'пол' ] = 'м'] ) }</td>
          <td class = "text-center">{ count( $детейООО[ cell[ @label = 'пол' ] = 'ж'] ) }</td>
          {
            for $j in $возраст
            let $детиВозраста :=
             $детейООО[
               uchenik.vozrast:возраст( 
               $текущаяДата,
               dateTime:dateParse( cell[ @label = 'дата рождения' ]/text() )
             ) = $j
              ]
            return
              (
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'м' ] ) }</td>,
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'ж' ] ) }</td>,
                <td class = "text-center">{ count( $детиВозраста ) }</td>
              )
          }
        </tr>
  
  let $детиВсегоСОО :=
   let $СОО := ( 10 to 11 )    
    let $детейСОО := 
            (($детиВсего[ $текущийКласс( ., $текущаяДата ) = $СОО ]))
            return
      
        <tr>
          <td>Всего СОО </td>
          <td class = "text-center">{ (sum (count ($детейСОО ))) }</td>
          <td class = "text-center">{ count( $детейСОО[ cell[ @label = 'пол' ] = 'м'] ) }</td>
          <td class = "text-center">{ count( $детейСОО[ cell[ @label = 'пол' ] = 'ж'] ) }</td>
          {
            for $j in $возраст
            let $детиВозраста :=
             $детейСОО[
               uchenik.vozrast:возраст( 
               $текущаяДата,
               dateTime:dateParse( cell[ @label = 'дата рождения' ]/text() )
             ) = $j
              ]
            return
              (
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'м' ] ) }</td>,
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'ж' ] ) }</td>,
                <td class = "text-center">{ count( $детиВозраста ) }</td>
              )
          }
        </tr>
   

  
  let $детиВсего :=
        <tr>
          <th>Всего </th>
          <th class = "text-center">{ count( $детиВсего ) }</th>
          <th class = "text-center">{ count( $детиВсего[ cell[ @label = 'пол' ] = 'м'] ) }</th>
          <th class = "text-center">{ count( $детиВсего[ cell[ @label = 'пол' ] = 'ж'] ) }</th>
          {
            for $j in $возраст
            let $детиВозраста :=
             $детиВсего[
               uchenik.vozrast:возраст( 
               $текущаяДата,
               dateTime:dateParse( cell[ @label = 'дата рождения' ]/text() )
             ) = $j
              ]
            return
              (
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'м' ] ) }</td>,
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'ж' ] ) }</td>,
                <th class = "text-center">{ count( $детиВозраста ) }</th>
              )
          }
        </tr>
  return
     <table class = 'table-striped'>
       <tr class = "text-center">
          <th rowspan = "3">Класс</th>
          <th rowspan = "3">В классе</th>
          <th rowspan = "3">Мальчики</th>
          <th rowspan = "3">Девочки</th>
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
        { $детиВсегоНОО }
        { $детиВсегоООО }
        { $детиВсегоСОО }
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
    let $возрастУченика := uchenik.vozrast:возраст( $текущаяДата,  $датаРождения )
    order by $возрастУченика
    order by $классРассчетный
    count $c
    return
      <tr>
        <td>{ $c }</td>
        <td>{ $i/cell[ @label = "Фамилия,"]/text()}</td>
		<td>{ $i/cell[ @label = "имя,"]/text()}</td>
        <td class = "text-center">{  $датаРождения }</td>
        <td class = "text-center">
          { $возрастУченика }
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
			<th>Имя</th>
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
        if( 
          $дата < 
          xs:date( year-from-date( $дата ) || '-' || $uchenik.vozrast:месяцДеньПеревода )
        )
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
