module namespace oauth = "oaut/getToken";

import module namespace config = "app/config" at "../functions/config.xqm";
import module namespace token = "funct/token/getToken" at '../functions/tokens.xqm';
import module namespace funct = "funct" at '../functions/functions.xqm';

declare 
  %rest:GET
  %rest:query-param( "code", "{ $code }" )
  %rest:query-param( "state", "{ $state }" )
  %rest:path( "/lipers-simplex/api/v01/login/oauthGetToken" )
function oauth:main( $code as xs:string, $state as xs:string ){
   let $request := 
    <http:request method='post'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="code";'/>
            <http:body media-type = "text/plain" >{ $code }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="client_id";' />
            <http:body media-type = "text/plain">{ config:param( 'OAuthClienID' ) }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="client_secret";' />
            <http:body media-type = "text/plain">{ config:param( 'OAuthClienSecret' ) }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="grant_type";' />
            <http:body media-type = "text/plain">authorization_code</http:body>
        </http:multipart> 
      </http:request>
  
  let $response := 
      http:send-request(
        $request,
        'http://portal.titul24.ru/oauth/token'
    )[ 2 ]
  let $accessToken := $response/json/access__token/text()
  let $userInfo :=
    json:parse(
      fetch:text( 
        'http://portal.titul24.ru/oauth/me?access_token=' || $accessToken
      )
    )
  let $userEmail := $userInfo//user__email/text()
  
  return
    if( $userEmail )
    then(
      let $accessToken :=
         session:set( 'access_token', token:getAccessToken() )
          
      let $userInfo := oauth:getUserInfo( $userEmail )
      let $displayName :=
        $userInfo/cell[ @label = 'Фамилия Имя Отчество']/text()
      return
        (
          session:set( "grants", 'teacher' ),
          session:set( "login", $userEmail ),
          session:set( "роль", $displayName ),
          session:set( 'userAvatarURL', 'https://www.gravatar.com/avatar/' || lower-case( string( xs:hexBinary( hash:md5( lower-case( $userEmail ) ) ) ) ) ),
          web:redirect( config:param( 'host' ) || config:param( 'rootPath' ) || '/t'  )
        )
    )
    else(
      <err:LOGINFAIL>ошибка авторизации</err:LOGINFAIL>
    )
};

declare function oauth:getUserInfo( $userEmail ){
  let $data :=
    funct:getFile(
      'авторизация/lipersTeachers.xlsx',
      '.',
      'f6104dd1-b88b-4104-9528-b8a7d473b251',
      session:get( 'access_token')
    )

let $user:=
  $data//table/row
  [ cell[ @label = 'Электронная почта'] = $userEmail ]
  
return
  $user
};

declare function oauth:getUserInfo-old( $userEmail ){
  let $data :=
    funct:getFileRaw(  'авторизация/сотрудники.csv', 'f6104dd1-b88b-4104-9528-b8a7d473b251', session:get( 'access_token') )

let $userList:=
  csv:parse(
    convert:binary-to-string( $data, 'windows-1251' ),
    map{ 'header' : 'yes', 'separator' : ';' }
  )
  
return
  $userList/csv/record[ e-mail/text() = $userEmail ]
};

