module namespace lipers-simplex = "lipers-simplex/teacher/отчеты";

import module namespace funct="funct" at "../functions/functions.xqm";

declare 
  %rest:GET
  %rest:path("/lipers-simplex/p/api/v01/{$метод}")
  %output:method("xml")
function lipers-simplex:main( $метод as xs:string ){
  let $query-params :=
    for $i in request:parameter-names()
    return
      map{$i: request:parameter($i)}
  return
      funct:tpl('content/data-api/public/' || $метод, map:merge($query-params))
};