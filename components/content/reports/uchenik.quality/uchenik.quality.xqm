module namespace uchenik.quality = 'content/reports/uchenik.quality';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm';

declare function uchenik.quality:main( $params ){
  let $data:=
    fetch:xml(
      'http://81.177.136.43:9984/zapolnititul/api/v2.1/data/publication/4c72bbf0-c400-459b-947c-53e7ad1b30ce'
    )
  return 
    map{
      'оценки' : <div>{ uchenik.quality:table( $data, '5' ) }</div>
    }
};

declare function uchenik.quality:table( $data, $класс ){  
  let $class :=
    if( number( $класс ) = ( 1 to 11 ) )
    then( $класс )
    else( '5' )
  
  let $класс := uchenik.quality:класс( $data, $class )
  
  let $оценкиУчеников := 
    for $i in stud:ученики( $data )
    where $i?1 = $класс
    return
      [ $i, stud:промежуточнаяАттестацияУченика( $data, $i?1 ) ]
  
  let $предметы := sort( distinct-values( $оценкиУчеников?2?1 ) )
  
  let $промежуткиАттестации := 
    if( number( $class ) <= 9 )
    then(
      ( '1-ая четверть', '2-ая четверть', '3-ая четверть', '4-ая четверть', 'Год' )
    )
    else(
      ( '- ', '1-ое полугодие',' - ' , '2-ое полугодие', 'Год' )
    )
  
  let $строки := 
    for $i in $оценкиУчеников
    count $c
    return
      for $промежуток in $промежуткиАттестации
      count $c1
      return
        <tr >
          {
            if( $c1 = 1 )
            then( <td rowspan="{ count( $промежуткиАттестации ) }">{ $i?1?2 }</td> )
            else()
          }
          <td>{ $промежуток }</td>
          {
             for $предмет in $предметы
             return
               <td>{ $i?2[ ?1 = $предмет ]?2[ $c1 ] }</td>
          }
        </tr>
  
  let $таблица := 
    <table border="1px" >
      <tr>
        <td>Ученик</td>
        <td>Период</td>
        {
          for $i in $предметы
          return
            <td>{ $i }</td>
        }
      </tr>
      { $строки }
    </table>
  
  return
    $таблица
};

declare function uchenik.quality:класс( $data, $class as xs:string ){
  let $d := $data[ matches( row[ 1 ]/cell[ 1 ]/@label/data(), $class ) ]
  return
    if( $d[1]/row[ 1 ]/cell[ position() >= 3 ]/text() )
    then(
      $d[1]/row[ 1 ]/cell[ position() >= 3 ]/text()
    )
    else(
      uchenik.quality:класс( $data[ position() >= 2 ], $class )
  )
};
