module namespace uchenik.propuski = 'content/reports/uchenik.propuski';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm'; 

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchenik.propuski:main( $params ){
  
  let $data:=
    fetch:xml(
      'http://81.177.136.43:9984/zapolnititul/api/v2.1/data/publication/70ac0ae7-0f03-48cc-9962-860ef2832349'
    )
  let $началоПериода := 
    if(request:parameter('началоПериода'))
    then(request:parameter('началоПериода'))
    else(format-date(current-date(), "[Y0001]-[M01]-[D01]"))
  let $конецПериода := 
    if(request:parameter('конецПериода'))
    then(request:parameter('конецПериода'))
    else(format-date(current-date(), "[Y0001]-[M01]-[D01]"))
  return
    map{
       'началоПериода' : $началоПериода,
       'конецПериода' : $конецПериода,
       'пропуски' : <div>{ uchenik.propuski:main( $data, session:get( '000' )) }</div>
    }
};

declare function uchenik.propuski:main( $data, $номерЛичногоДела ){  
 
  for $данные2 in stud:ученики( $data//table[ row[ 1 ]/cell/text() ] )
  let $номерЛичногоДела := ($данные2?1)
  
  let $tables := $data//table[ row[ 1 ]/cell/text() = $номерЛичногоДела ]
  
  let $началоПериода :=
    if( request:parameter( 'началоПериода' ) )
    then( xs:date( request:parameter( 'началоПериода' ) ) )
    else( current-date() ) 
  
  let $конецПериода :=
    if( request:parameter( 'конецПериода' ) )
    then( xs:date( request:parameter( 'конецПериода' ) ) )
    else( current-date() ) 

  let $имяУченика := 
    ( $tables/row[ 1 ]/cell[ text() = $номерЛичногоДела ]/@label/data() )[ 1 ]
     
  let $оценкиПромежуточнойАттестации := 
    stud:количествоПропусковПоПредметам( $tables, $номерЛичногоДела, $началоПериода, $конецПериода  )
  
  let $class := stud:ученики ( $tables )
    
  let $result := 
   <div>   
   <div>   
   <h6>Оценки за текущий учебный год: { $имяУченика }, {distinct-values($class?3)} класс</h6>     
   <table class = "table table-striped table-bordered">
     <tr>
           <th width="10%">Предмет</th>
           <th width="20%">Количество пропусков за выбранный период</th>
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

declare function uchenik.propuski:ссылкаНаИсходныеДанные($params){
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