module namespace uchenik.litkoin = 'content/reports/uchenik.litkoin';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm';
 
declare function uchenik.litkoin:main( $params ){
  let $период := uchenik.litkoin:период()
  let $началоПериода := $период?началоПериода
  let $конецПериода := $период?конецПериода
  let $data := $params?_tpl('content/data-api/public/journal-Raw', $params)
  return
    map{
      'началоПериода' : format-date(xs:date( $началоПериода ), "[Y]-[M01]-[D01]"),
      'конецПериода' : format-date(xs:date( $конецПериода ), "[Y]-[M01]-[D01]"),
      'литкоин' : <div>{ uchenik.litkoin:main( $data, session:get( 'номерЛичногоДела' ), $началоПериода, $конецПериода ) }</div>
    }
};

declare function uchenik.litkoin:main( $data, $номерЛичногоДела, $началоПериода, $конецПериода ){  
  let $tables := $data//table[ row[ 1 ]/cell/text() = $номерЛичногоДела ]
  let $имяУченика := 
    ( $tables/row[ 1 ]/cell[ text() = $номерЛичногоДела ]/@label/data() )[ 1 ]
    
  let $оценкиПоПредметам := 
    stud:записиПоВсемПредметамЗаПериод(
      $tables,
      $номерЛичногоДела,
      xs:date( $началоПериода ),
      xs:date( $конецПериода )
    )  
    
  let $result := 
    <div>
      <ul><li>Литкоины - это условная денежная единица Лицея "Перспектива". </li> <li>Литкоин используется на Ярмарках Лицея.</li><li>Литкоин начисляется за оценки: "5" - 3 литкоина, "4" - 2 литкоина , "3" - 0 литкоинов, "2" - штраф (минус 1 литкоин)</li></ul>
      <table  class = "table table-striped table-bordered">
        <tr class="text-center">
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
           <th >Предмет</th>
           <th >Текущие оценки</th>
           <th>Средний балл</th>
        </tr>        
        {
          for $i in $оценкиПоПредметам[ position() >= 2 ]
          let $оценки := $i?2?2[ number( . ) >0 ]
          let $количествоПропусков := count( $i?2[ ?2 = 'н' ] )
            
          return
            <tr>
              <td>{ $i?1 }</td>
              <td class="text-center">{ string-join( $i?2?2, ', ' ) } { if( $количествоПропусков )then( ' (пропусков: ' || $количествоПропусков || ')' ) }</td>
              <td class="text-center">{ round( avg( $оценки ), 1 ) }</td>
            </tr>
        }      
      </table>
    </div>
  return
    $result
};

declare function uchenik.litkoin:период(){
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