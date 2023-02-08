module namespace rdfResourceURI = 'content/data-api/rdfResourceURI';

(:
  возвращает в виде map данные из токена авторизации: iss и userID
:)
declare function rdfResourceURI:main($params){
  let $tokenPayload := $params?_getTokenPayload()
  let $URIресурса := 
   xs:anyURI(
     substring-after($tokenPayload?iss, '//') || ':' ||
     $tokenPayload?userID || '/store/'||
     $params?storeID || '/' ||
     $params?path
   )
  return
    map{'данные' : $URIресурса}
};
