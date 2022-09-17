module namespace lipers-simplex = "lipers-simplex/teacher/отчеты";

import module namespace funct="funct" at "../functions/functions.xqm";

declare 
  %rest:GET
  %rest:path("/lipers-simplex/p/api/v01/{$метод}")
  %rest:query-param('output', '{$output}', 'application/xml')
function lipers-simplex:main($метод as xs:string, $output as xs:string){
  let $query-params :=
    for $i in request:parameter-names()
    return
      map{$i: request:parameter($i)}
  let $contentType := $output 
  return
    (
      <rest:response>
        <http:response status="200">
          <http:header name="Content-Type" value="{$contentType}"/>
        </http:response>
      </rest:response>,
      funct:tpl('content/data-api/public/' || $метод, map:merge($query-params))
    )
};