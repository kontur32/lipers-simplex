module namespace uchenik.predmet = 'content/reports/uchenik.predmet';

import module namespace functx = "http://www.functx.com";

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/Artmotor/lipers-zt/master/modules/stud.xqm';
  
import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function uchenik.predmet:main( $params ){
  
  let $data:=
    fetch:xml(
      'http://81.177.136.43:9984/zapolnititul/api/v2.1/data/publication/70ac0ae7-0f03-48cc-9962-860ef2832349'
    )
    
  return
    map{
       'оценки' : <div>{ uchenik.predmet:main( $data, session:get( '000' )) }</div>
    }
};

declare function uchenik.predmet:main(
     $данные as element( table )*,
     $идентификаторУченика as xs:string,
     $идентификаторУчителя as xs:string
     
   )
{
  let $table := $данные[ row[ 1 ]/cell[ text() = $идентификаторУченика ] ]
  
  let $имяУченика :=  $table/row[ 1 ]/cell[ text() = $идентификаторУченика ]/@label/data()
   
  for $i in $table
  let $предмет := tokenize( $i/row[ 1 ]/cell[ 1 ]/@label/data(), ',' )[ 1 ]
  where not ( matches( $предмет, '!' ) )
  order by $предмет  
  return
    [ $предмет, $i/row[ position() = ( 2 to 6 ) ]/cell[ @label = $имяУченика ]/data() ]
};

declare function uchenik.predmet:main( $data, $номерЛичногоДела ){  
 
  for $данные2 in stud:ученики( $data//table[ row[ 1 ]/cell/text() ] )
  let $номерЛичногоДела := ($данные2?1)
  
  let $номерЛичногоДела := ($данные2?1)
  
  let $tables := $data//table[ row[ 1 ]/cell/text() = $номерЛичногоДела ]

  let $имяУченика := 
    ( $tables/row[ 1 ]/cell[ text() = $номерЛичногоДела ]/@label/data() )[ 1 ]
     
  let $оценкиПромежуточнойАттестации := 
    stud:промежуточнаяАттестацияУченика( $tables, $номерЛичногоДела )
    
  let $class := stud:ученики ( $tables )
    
  let $result := 
   <div>
   <p>Список предметов и учителей ученика: { $имяУченика }, {distinct-values($class?3) } класс</p>     
   <table class = "table table-striped table-bordered">
     <tr>
           <th width="10%">Предмет</th>
           <th width="20%">Учитель</th>
           <th width="10%">Кабинет</th>
      </tr>
     {
      for $p in $оценкиПромежуточнойАттестации 
      where distinct-values($p?2) 
      order by $p?2

      return 
         <tr> 
           <td> { $p?1 } </td>
           <td> { substring-before ($p?2, ',') } </td>
           <td> { substring-after ($p?2, ',') } </td>
         </tr>
      }
    </table>
    </div>
  return
    $result
};