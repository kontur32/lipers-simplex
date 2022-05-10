module namespace lipers-simplex = "lipers-simplex/teacher";

import module namespace funct="funct" at "../functions/functions.xqm";

declare 
  %rest:GET
  %rest:path( "/lipers-simplex/p/{$метод}" )
  %output:method( "xhtml" )
  %output:doctype-public( "www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" )
function lipers-simplex:main($метод){
  let $params :=    
     map{
      'content' : funct:tpl( 'content/data-api/public/' || $метод, map{'token':request:parameter('token')} ),
      'footer' : funct:tpl( 'footer', map{} )
    }
  return
    funct:tpl( 'main', $params )
};