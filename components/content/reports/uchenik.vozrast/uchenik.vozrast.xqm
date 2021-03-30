module namespace uchenik.vozrast = 'content/reports/uchenik.vozrast';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function uchenik.vozrast:main( $params ){
  
  let $data :=
    $params?_getFile(
       'Kids/kids-site-lipers.xlsx',
       './file/table[ @label = "ППС" ]'
     )

  return
    map{
      'таблица' : uchenik.vozrast:строкиТаблицы( $data/table )
    }
};

declare function uchenik.vozrast:строкиТаблицы( $data ){
  let $детиВсего := $data/row[ not( normalize-space( cell[ @label = 'дата выбытия из ОО' ]/text() ) ) ][ cell[ @label = 'Класс' ]/text() ]
  let $возраст := ( 6 to 18 )
  
  let $детиПоКлассам := 
    for $класс in ( 1 to 11 )
    let $детейВКлассе := 
            $детиВсего[ cell[ @label = 'Класс' ]/text() = $класс ]
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
          return
            (
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'м'] ) }</td>,
                <td>{ count( $детиВозраста[ cell[ @label = 'пол' ] = 'ж'] ) }</td>,
                <td class = "text-center">{ count( $детиВозраста ) }</td>
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