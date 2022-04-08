module namespace docs = "lipers-simplex/student/docs";

import module namespace config = "app/config" at '../functions/config.xqm';
import module namespace funct="funct" at "../functions/functions.xqm";

declare 
  %rest:GET
  %rest:query-param("path","{$path}", 'Biblioteka/lipersBooks.xlsx')
  %rest:query-param("schema","{$schema}", 'http://localhost:9984/garpix/semantik/app/api/v0.1/schema/generate/Учебники в наличии')
  %rest:path("/lipers-simplex/api/v01/transfom/trci-rdf")
  %output:method('text')
  %private
function docs:main($path as xs:string, $schema as xs:string){
  let $trci :=
    funct:getFile($path, '.', config:param('store.yandex.personalData'))
  let $request :=
      <http:request method='post'>
        <http:multipart media-type = "multipart/form-data">
            <http:header name="Content-Disposition" value= 'form-data; name="trci"; filename="aaa.xml"'/>
            <http:body media-type = "application/xml">{$trci}</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="schema";'/>
            <http:body media-type = "text/plain">{$schema}</http:body>
        </http:multipart> 
      </http:request>
  let $rdf :=  
     http:send-request (
        $request,
       'http://localhost:'||request:port()||'/garpix/semantik/app/app/api/v0.1/transfom/trci-rdf'
      )[ 2 ]/child::*
  let $graphName := 'http://lipers.ru/lipers-simplex/' || $path
  let $storeURL := 'http://81.177.136.214:3030/gs/upload'
  return
    (
      docs:deleteGraph($graphName, $storeURL),
      docs:uploadGraph($rdf, $graphName, $storeURL)
    ) 
    
};

declare
  %private
function docs:uploadGraph(
  $rdf as element(),
  $graphName as xs:string,
  $storeURL as xs:string
)
{
  let $request :=
      <http:request method='POST'>
        <http:multipart media-type = "multipart/form-data; boundary=----7MA4YWxkTrZu0gW" >
            <http:header name="Content-Disposition" value= 'form-data; name="file"; filename="/C:/Users/kontu/Downloads/php74.rdf'/>
            <http:body media-type = "application/rdf+xml">{$rdf}</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="graph";'/>
            <http:body media-type = "text/plain">{$graphName}</http:body>
        </http:multipart> 
      </http:request>
    
  let $response := 
     http:send-request (
        $request,
        $storeURL
      )
  return
     $response[1]/@status/data()  
};

declare
  %private
function docs:deleteGraph(
  $graphName as xs:string,
  $storeURL as xs:string
) as xs:string{
  let $request :=
    replace('DROP GRAPH  <%1>', '%1', $graphName)
  let $url :=
    web:create-url(
      $storeURL,
      map{
        'query':$request
      }
    )
  return
    http:send-request(
      <http:request method='POST'>
        <http:header name="Content-Type" value= 'multipart/form-data; boundary=----7MA4YWxkTrZu0gW'/>
      </http:request>,
      $url
    )[1]/@status/data()  
};