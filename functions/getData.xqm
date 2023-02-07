module namespace getData = "getData";

import module namespace config = "app/config" at "config.xqm";
import module namespace funct = "funct" at "functions.xqm";

declare function getData:getTemplateData1( $templateID, $accessToken ){
  getData:getTemplateData( $templateID, $accessToken, map{} )
};

declare function getData:getTemplateData( $templateID, $accessToken, $params as map(*) ){ 
  let $host := $config:param( 'host' )
  let $path := '/zapolnititul/api/v2.1/data/users/' || $config:param( "accessID" ) || '/templates/' || $templateID (: 21 :)
  
  let $uri := web:create-url( $host || $path, $params )
  
  return 
  http:send-request(
    <http:request method='get'
       href= "{ $uri }">
      <http:header name="Authorization" value= '{ "Bearer " || $accessToken }' />
    </http:request>
  )[2]
};

declare function getData:getToken()
{
  getData:getToken(
    config:param('authHost'),
    config:param('login'),
    config:param('password')
  )
};

declare function getData:getToken( $host, $username, $password )
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
      else()
};

declare function getData:userMeta( $token )
{
  let $request := 
  <http:request method='get'>
    <http:header name="Authorization" value= '{ "Bearer " || $token }' />
  </http:request>
  
  let $response := 
      http:send-request(
        $request,
        "http://portal.titul24.ru" || "/wp-json/wp/v2/users/me?context=edit"
    )
    return
      $response[ 2 ]
};

