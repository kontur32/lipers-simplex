module namespace check = "check";

import module namespace login = "login" at "../api/login.xqm";
import module namespace config = "app/config" at '../functions/config.xqm';

declare 
  %perm:check( "/lipers-simplex/s" )
function check:userArea(){
 let $grants := session:get( "grants" )
  where  not( $grants = 'student' )
  return
    web:redirect("/lipers-simplex")
};

declare 
  %perm:check( "/lipers-simplex/p/s/reports" )
function check:litcoin(){
 let $номерЛичногоДела := request:parameter( "ld" )
 return
    if(not(session:get('login')))
    then(
      if($номерЛичногоДела)
      then(
        session:close(),
        session:set( "login",  request:parameter( "login" ) ),
        session:set( "grants", 'student' ),
        session:set( "роль", request:parameter( "fio" ) ),
        session:set( "номерЛичногоДела", $номерЛичногоДела ),
        session:set(
          'access_token', login:getToken( $config:param( 'authHost' ), $config:param( 'login' ), $config:param( 'password' ) )
        )
      )
      else(web:redirect("/lipers-simplex"))
    )
    else()
};