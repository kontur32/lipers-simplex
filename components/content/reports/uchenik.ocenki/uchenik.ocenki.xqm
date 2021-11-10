module namespace uchenik.ocenki = 'content/reports/uchenik.ocenki';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm';
  
import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function uchenik.ocenki:main( $params ){
  
  let $началоПериода :=
    if( request:parameter( 'началоПериода' ) )
    then( xs:date( request:parameter( 'началоПериода' ) ) )
    else( current-date() ) 
  
  let $конецПериода :=
    if( request:parameter( 'конецПериода' ) )
    then( xs:date( request:parameter( 'конецПериода' ) ) )
    else( current-date() ) 
  
  let $data:=
    fetch:xml(
      'http://81.177.136.43:9984/zapolnititul/api/v2.1/data/publication/70ac0ae7-0f03-48cc-9962-860ef2832349'
    )

  return
    map{
      'началоПериода' : format-date(xs:date( $началоПериода ), "[Y]-[M01]-[D01]"),
      'конецПериода' : format-date(xs:date( $конецПериода ), "[Y]-[M01]-[D01]"),
      'оценки' : <div>{ uchenik.ocenki:main( $data, session:get( 'номерЛичногоДела' ), $началоПериода, $конецПериода ) }</div>
    }
};

declare function uchenik.ocenki:main( $data, $номерЛичногоДела, $началоПериода, $конецПериода ){  
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
  let $оценкиПромежуточнойАттестации := 
    stud:промежуточнаяАттестацияУченика( $tables, $номерЛичногоДела )
    
  let $result := 
    <div>
      <p>Журнал успеваемости ученика: { $имяУченика }</p>
      <p>Текущие оценки за четверть</p>
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
            
          return
            <tr>
              <td>{ $i?1 }</td>
              <td class="text-center">{ string-join( $i?2?2, ', ' ) } { if( $количествоПропусков )then( ' (пропусков: ' || $количествоПропусков || ')' ) }</td>
              <td class="text-center">{ round( avg( $оценки ), 1 ) }</td>
            </tr>
        }
      </table>
      
   <p><center>Оценки за четверть и год</center></p>
   <table class = "table table-striped table-bordered">
     <tr>
           <th width="20%">Предмет</th>
           <th width="10%">Четверть I</th>
           <th width="10%">Четверть II</th>
           <th width="10%">Четверть III</th>
           <th width="10%">Четверть IV</th>
           <th width="10%">Год</th>
        </tr>
     {
      for $p in $оценкиПромежуточнойАттестации
      return 
         <tr> 
           <td> { $p?1 } </td>
           <td> { $p?2[ 1 ] } </td>
           <td> { $p?2[ 2 ] } </td>
           <td> { $p?2[ 3 ] } </td>
           <td> { $p?2[ 4 ] } </td>
           <td> { $p?2[ 5 ] } </td>
         </tr>
      }
    </table>
    </div>
  return
    $result
};