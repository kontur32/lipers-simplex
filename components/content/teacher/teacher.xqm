module namespace content = 'content/teacher';

declare function content:main( $params ){
  let $кодАвторизации := 
    substring(replace(session:id(), '[A-Za-z]', ''), 1, 5)
  let $userLogin := session:get('login')
  let $userString :=
    replace('{"login":"%1","grants":"teacher"}', '%1', $userLogin)
  let $url :=
    $params?_tpl('content/data-api/public/token_', map{'string': $userString})//url/text()
  return
    map{
      'кодАвторизации' : $кодАвторизации,
      'urlРеакцииБота' : $url
    }
};