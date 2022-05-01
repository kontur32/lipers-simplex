module namespace bot = "/lipers-simplex/bot/api/v01/";

import module namespace funct="funct" at "../functions/functions.xqm";

declare 
  %rest:GET
  %rest:path("/lipers-simplex/bot/api/v01/{$метод}")
  %rest:query-param('callback', '{$callback}', '')
  %output:method( "xml" )
function bot:main($метод as xs:string, $callback){
  let $query-params :=
    for $i in request:parameter-names()
    return
      map{$i: request:parameter($i)}
  let $result :=
    funct:tpl('content/data-api/public/' || $метод, map:merge($query-params))
  
  let $request :=
    web:create-url(
      $callback,
      map:merge(
        (
          for $i in $result/result/child::*
          return
            map{$i/name():$i/text()},
          $query-params
        )
      )
    )
  return
    fetch:text($request)
};