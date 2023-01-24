module namespace uchenik.litkoinAll = 'content/reports/uchenik.litkoinAll';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm'; 

declare function uchenik.litkoinAll:main( $params ){
  let $период := uchenik.litkoinAll:период()
  let $началоПериода := $период?началоПериода  
  let $конецПериода := $период?конецПериода
  let $data := $params?_tpl('content/data-api/public/journal-Raw', $params)
  return
    map{
      'началоПериода' : format-date(xs:date(normalize-space($началоПериода)), "[Y]-[M01]-[D01]"),
      'конецПериода' : format-date(xs:date(normalize-space($конецПериода)), "[Y]-[M01]-[D01]"),
      'литкоин' : <div>{uchenik.litkoinAll:карточкиУчеников($data, $params, $началоПериода, $конецПериода)}</div>
    }
};

declare function uchenik.litkoinAll:карточкиУчеников($data, $params, $началоПериода, $конецПериода){  
  for $ученик in stud:ученики( $data//table[ row[ 1 ]/cell/text() ] )
  let $номерЛичногоДела := $ученик?1
  let $имяУченика := $ученик?2
  let $tables := $data//table[ row[ 1 ]/cell/text() = $номерЛичногоДела ]

  let $оценкиПоПредметам := 
    stud:записиПоВсемПредметамЗаПериод(
      $tables,
      $номерЛичногоДела,
      xs:date( $началоПериода ),
      xs:date( $конецПериода )
    )  
  let $оценкиПромежуточнойАттестации := 
    stud:промежуточнаяАттестацияУченика( $tables, $номерЛичногоДела )
  
  let $hrefLitkoin :=
    web:create-url(
      'http://81.177.136.43:9984/lipers-simplex/p/s/reports/uchenik.litkoin',
      map{
        'ld' : $номерЛичногоДела,
        'login':'login',
        'fio' : $имяУченика
      }
    )
  let $QRlink :=
    $params?_tpl('content/data-api/qrGernerate', map{'string': $hrefLitkoin})//result
  
  let $result := 
    <div>
      <p>Журнал успеваемости ученика: { $имяУченика }</p>
      <p><a href="{$hrefLitkoin}">личный кабинет</a></p>
      <p><img src="{$QRlink}"/></p>
      <p>Подсчет литкоинов</p>
      <table  class = "table table-striped table-bordered">
        <tr class="text-center"> 
           <th >Предмет</th>
           <th >Текущие оценки</th>
           <th>Средний балл</th>
        </tr>
        {
          for $i in $оценкиПоПредметам[ position() >= 2 ]
          let $оценки := $i?2?2[ number( . ) >0 ]
          let $количествоПропусков := count( $i?2[ ?2 = 'н' ] )
          let $оценкиВсе := $i?2?2
            
          return
            <tr>
              <td>{ $i?1}</td>
              <td class="text-center">{ string-join( $i?2?2, ', ' ) } { if( $количествоПропусков )then( ' (пропусков: ' || $количествоПропусков || ')' ) }</td>
              <td class="text-center">{ round( avg( $оценки ), 1 ) }</td>              
           </tr>
  }
       
 {   
      let $i := $оценкиПоПредметам[ position() >= 2 ]
      let $литкоины := ((count( $i?2[ ?2 = '5' ] ) * 3) + (count( $i?2[ ?2 = '4' ] ) * 2)) - (count( $i?2[ ?2 = '2' ] ))
      let $штраф := (count( $i?2[ ?2 = '2' ] ))
      return      
        <tr>
          <th><font size="5" color="blue" face="Arial"><center>Всего литкоинов:</center></font></th>
          <td><center> штрафы за {$штраф} двойки(ек): <span><font size="3" color="red" face="Arial">  минус {$штраф} балла(ов) </font></span> </center></td>
          <td><font size="5" color="blue" face="Arial"><b><center> {$литкоины} </center></b></font></td>
         </tr>                
  }
      </table>
     </div>
  return
    $result
};

declare function uchenik.litkoinAll:период(){
  let $началоПериода := 
    if(request:parameter('началоПериода'))
    then(request:parameter('началоПериода'))
    else(       
        if (fn:month-from-date(current-date() ) = (06, 07, 08, 09, 10, 11, 12))
        then (fn:year-from-date(current-date()) || '-09-01')
        else fn:year-from-date(current-date() ) - 1 || '-09-01'
        )
  let $конецПериода := 
    if(request:parameter('конецПериода'))
    then(request:parameter('конецПериода'))
    else(format-date(current-date(), "[Y0001]-[M01]-[D01]"))
  return
    map{
      'началоПериода':$началоПериода,
      'конецПериода':$конецПериода
    }
};
