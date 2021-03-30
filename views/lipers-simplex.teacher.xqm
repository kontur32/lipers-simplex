module namespace lipers-simplex = "lipers-simplex/teacher";

import module namespace funct="funct" at "../functions/functions.xqm";

declare 
  %rest:GET
  %rest:path( "/lipers-simplex/t" )
  %output:method( "xhtml" )
  %output:doctype-public( "www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" )
function lipers-simplex:main(){
    
    let $params :=    
       map{
        'header' : funct:tpl( 'header', map{ 'area' : 'teacher' } ),
        'content' : funct:tpl( 'content/teacher', map{} ),
        'footer' : funct:tpl( 'footer', map{} )
      }
    return
      funct:tpl( 'main', $params )
};