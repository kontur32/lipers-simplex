module namespace queryRDF = "queryRDF";

import module namespace config = "app/config" at "config.xqm";  
import module namespace getToken = "funct/token/getToken" at "tokens.xqm";  

declare
  %public
function queryRDF:get($query){
  queryRDF:get($query, "json")
};


declare
  %private
function queryRDF:get($query, $output){
  queryRDF:get($query, $output, config:param('api.method.RDF') || "query/")
};


declare
  %private
function queryRDF:get($query, $output, $path){
  let $token := 
    if(session:get('userID'))
    then(session:get('userID'))
    else(getToken:getAccessToken())
    
  let $request := 
    <http:request method='GET'>
      <http:header name="Authorization" value='{"Bearer " || $token}'/>
    </http:request>
  let $url := 
    web:create-url(
      $path,
      map{"output":$output, "query":$query}
    )
  let $response := http:send-request($request, $url)   
  return
    $response[2]
};
