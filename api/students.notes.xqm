module namespace diploma = "/saivpds/api/v01/students/notes";

import module namespace funct = "funct" at '../functions/functions.xqm';

declare 
  %rest:GET
  %rest:query-param( "id", "{ $id }" )
  %rest:query-param( "group", "{ $group }" )
  %output:method( 'json' )
  %rest:path( "/saivpds/api/v01/students/notes" )
function diploma:main( $id, $group ){
  let $result := 
    funct:getFileWithParams( 
      'Аттестация/ДО_набор.xlsx',
      'http://localhost:8984/static/saivpds/funct/ocenki.student.xq',
      map{
        'id' : $id,
        'group' : $group
      }
    )
  return
    $result
};