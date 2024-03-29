module namespace token = "funct/token/getToken";

import module namespace config = "app/config" at '../functions/config.xqm';

declare
  %public
function token:getTokenPayload(){
    if(session:get('access_token'))
    then(token:getTokenPayload(session:get('access_token')))
    else(
      let $t := token:getAccessToken()
      return
        (
          token:getTokenPayload($t),
          session:set('access_token', $t)
        )
    )
};

declare
  %public
function token:getTokenPayload($accessToken as xs:string) as map(*){
  let $token := tokenize($accessToken, '\.')[2]
  let $payload := 
    json:parse(convert:binary-to-string(xs:base64Binary($token)))/json
  let $iss := $payload/iss/text()
  let $userID := $payload/data/user/id/text()
  return
    map{
      'iss':$iss,
      'userID':$userID
    }
};


declare
  %public
function token:getAccessToken() as xs:string*
{
  token:getToken(
    config:param('authHost'),
    config:param('login'),
    config:param('password')
  )
};

declare
  %public
function token:getToken($username, $password) as xs:string*
{
  token:getToken(config:param('authHost'), $username, $password)
};

declare
  %public
function token:getToken( $host, $username, $password ) as xs:string*
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
      if($response[1]/@status/data()="200")
      then($response[2]//token/text())
      else()
};