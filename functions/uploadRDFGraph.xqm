(:
  модуль реализует загрузку RDF-графа через метод TRAC
:)

module namespace uploadRDFGraph = "uploadRDFGraph";

import module namespace config = "app/config" at "config.xqm";
import module namespace getToken = "funct/token/getToken" at "tokens.xqm";


declare 
  %public
function uploadRDFGraph:upload(
  $graphURI as xs:string,
  $rawData as element()
) as xs:string{
  let $token := 
    if(session:get('access_token'))
    then(session:get('access_token'))
    else(
      let $t := getToken:getAccessToken()
      return
        (session:set('access_token', $t), $t)
    )
  let $endpoint := config:param('api.method.RDF') || 'graph'
  return
    uploadRDFGraph:upload($graphURI, $rawData, $endpoint, $token)
};


declare 
  %public
function uploadRDFGraph:upload(
  $graphURI as xs:string,
  $rawData as element(),
  $endPoint as xs:string,
  $token as xs:string
) as xs:string{
  let $method :=  uploadRDFGraph:method($graphURI, $endPoint, $token)
  let $request := uploadRDFGraph:post-put($method, $rawData, $token)
  let $result := uploadRDFGraph:sendRquest($graphURI, $request, $endPoint)
  return
    $result/@status/data()
};


declare 
  %private
function uploadRDFGraph:sendRquest(
  $graphURI,
  $request,
  $endPoint
) as element()
{
  let $url :=  web:create-url($endPoint,map{'graphURI':$graphURI})
  return
    http:send-request($request, $url)
};

declare 
  %private
function uploadRDFGraph:get($token as xs:string) as element(http:request)
{
  <http:request method='GET'>
    <http:header name="Authorization" value='{"Bearer " || $token}'/>
  </http:request>
};

declare 
  %private
function uploadRDFGraph:method($graphURI, $endPoint, $token) as xs:string
{
  let $exists := 
    uploadRDFGraph:sendRquest(
      $graphURI,
      uploadRDFGraph:get($token),
      $endPoint
    )/@status/data()
  return
    if($exists = "200")then('PUT')else('POST')
};

declare 
  %private
function uploadRDFGraph:post-put(
  $method as xs:string,
  $rawData as element(),
  $token as xs:string
) as element(http:request)
{
  <http:request method='{$method}'>
    <http:header name="Authorization" value='{"Bearer " || $token}'/>
    <http:header name="Content-type" value="multipart/form-data"/>
    <http:multipart media-type = "multipart/form-data" >
        <http:header name='Content-Disposition' value='form-data; name="file"'/>
        <http:body media-type = "application/xml">{$rawData}</http:body>
    </http:multipart>
  </http:request>
};