module namespace start = "start";

declare function start:main( $params as map(*) ){
  let $p := 
    if( $params?area != "")
    then(
       map{
          'логотип' : <div></div>,
          'mainMenu' : $params?_tpl( 'header/mainMenu', $params  ),
          'avatar' : $params?_tpl( 'header/avatar', map{} )
        } 
    )
    else(
       map{
          'логотип' : $params?_tpl( 'header/logo', map{} ),
          'mainMenu' : '',
          'avatar' : ''
        }
    )
  return
    $p
};