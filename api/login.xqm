module namespace login = "login";

import module namespace config = "app/config" at '../functions/config.xqm';
import module namespace funct = "funct" at '../functions/functions.xqm';

declare 
  %rest:GET
  %rest:query-param( "login", "{ $login }" )
  %rest:query-param( "password", "{ $password }" )
  %rest:path( "/lipers-simplex/api/v01/login" )
function login:main( $login as xs:string, $password as xs:string ){
  
  let $преподаватель :=
    funct:tpl(
      'content/data-api/public/api_auth_teachers',
      map{
          'login' : $login,
          'password' : $password
        }
      )//user
  
  let $студент :=
    funct:tpl(
      'content/data-api/public/api_auth_kids',
      map{
          'login' : $login,
          'password' : $password
        }
      )//user
  
  let $роль := 
    if( $преподаватель/номерЛичногоДела/text() != "" )
    then(
      map{
        'label' : $преподаватель/ФИО/text(),
        'grants' : 'teacher', 
        'redirect' : '/lipers-simplex/t',
        'должность' : $преподаватель/Должность/text(),
        'номерЛичногоДела' : $преподаватель/номерЛичногоДела/text()
      }
    )
    else(
      if( $студент/номерЛичногоДела/text() != "" )
      then(
        map{
          'label' : $студент/ФИО/text(),
          'grants' : 'student', 
          'redirect' : '/lipers-simplex/s',
          'номерЛичногоДела' : $студент/номерЛичногоДела/text()
        }
      )
      else( map{} )
    )
  return
    if( $роль?grants != "" )
    then(
      session:set( "login", $login ),
      session:set( "grants", $роль?grants ),
      session:set( "роль", $роль?label ),
      session:set( "номерЛичногоДела", $роль?номерЛичногоДела ),
      session:set(
        'access_token', login:getToken( $config:param( 'authHost' ), $config:param( 'login' ), $config:param( 'password' ) )
      ),
      web:redirect(  $роль?redirect )
    )
    else( web:redirect( "/lipers-simplex" ) )
};



declare
  %public
function login:getToken( $host, $username, $password ) as xs:string*
{
  let $request := 
    <http:request method='post'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="username";'/>
            <http:body media-type = "text/plain" >{ $username }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="password";' />
            <http:body media-type = "text/plain">{ $password }</http:body>
        </http:multipart> 
      </http:request>
  
  let $response := 
      http:send-request(
        $request,
        $host || "/wp-json/jwt-auth/v1/token"
    )
    return
      if ( $response[ 1 ]/@status/data() = "200" )
      then(
        $response[ 2 ]//token/text()
      )
      else( )
};