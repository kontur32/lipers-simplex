module namespace uchenik.konduit = 'content/reports/uchenik.konduit';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm'; 

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchenik.konduit:main( $params ){
  
  let $data:=
    fetch:xml(
      'http://81.177.136.43:9984/zapolnititul/api/v2.1/data/publication/70ac0ae7-0f03-48cc-9962-860ef2832349'
    )
  return
    map{
       'оценкиЧетверть' : <div>{ uchenik.konduit:main( $data, session:get( '000' )) }</div>,
       'классы' : <div>{ uchenik.konduit:main3( $data, session:get( '000' )) }</div>
    }
};

declare function uchenik.konduit:main3( $data, $номерЛичногоДела ){  
     
  let $u := (1 to 11)   
    
  return
       distinct-values ($u)
};

declare function uchenik.konduit:main( $data, $номерЛичногоДела ){  
 
  for $данные2 in stud:ученики( $data//table[ row[ 1 ]/cell/text() ] )
  let $номерЛичногоДела := ($данные2?1)
  
  let $tables := $data//table[ row[ 1 ]/cell/text() = $номерЛичногоДела ]
  

  let $имяУченика := 
    ( $tables/row[ 1 ]/cell[ text() = $номерЛичногоДела ]/@label/data() )[ 1 ]
     
  let $оценкиПромежуточнойАттестации := 
    stud:промежуточнаяАттестацияУченика( $tables, $номерЛичногоДела )
  
  let $class := stud:ученики ( $tables )
  
  let $menu :=
    let $i := distinct-values($class?3)
  let $href := $i
  return 
    <a href = '{ $href }'>{ $i }</a>
    
  let $result := 
   <div>   
   <div>   
   <h6>Оценки за текущий учебный год: { $имяУченика }, {distinct-values($class?3) } класс</h6>     
   <table class = "table table-striped table-bordered">
     <tr>
           <th width="20%">Предмет</th>
           <th width="10%">I четверть</th>
           <th width="10%">II четверть</th>
           <th width="10%">III четверть</th>
           <th width="10%">IV четверть</th>
           <th width="10%">Годовая оценка</th>
      </tr>
     {
      for $p in $оценкиПромежуточнойАттестации
      return 
         <tr> 
           <td> { $p?1 } </td>
           <td> { $p?2 } </td>
         </tr>
      }
    </table>
    </div>
    </div>
  return
    $result
};

declare function uchenik.konduit:ссылкаНаИсходныеДанные($params){
  web:create-url(
     $params?_config( "api.method.getData" ) || 'stores/' ||  $params?_config('store.yandex.personalData') || '/rdf',
     map{
       'access_token' : session:get('access_token'),
       'path' : 'tmp/kids.xlsx',
       'xq' : '.',
       'schema' : 'http://81.177.136.43:9984/zapolnititul/api/v2/forms/846524b3-febe-4418-86cc-c7d2f0b7839a/fields'
     }
   )
};