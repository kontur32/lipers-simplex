module namespace token_ = 'content/data-api/public/token_';

(:
  Обратимо кодидирует произвольрную строку с 8-битным ключом алгоримом DES
  @param $params?string строка для кодирования
  @return закодированная строка в формате Base64
:)
declare function token_:main($params){ 
  let $encrypStr := token_:enrypt($params?string)
  let $url :=
    web:create-url(
      'http://' || request:hostname()|| ':' || request:port() ||'/lipers-simplex/p/session_',
      map{
        'token':$encrypStr
      }
    )
  let $result :=    
      map{
        'token' : <token>{$encrypStr}</token>,
        'url':<url>{$url}</url>,
        'string': <userData>{$params?string}</userData>
      }
  return
   $result
};

declare function token_:enrypt($string){
  let $key := '12345678'
  let $encrypt := crypto:encrypt($string, 'symmetric', $key, 'DES')
  let $encryptStr := xs:string(xs:base64Binary($encrypt))
  return
     $encryptStr
};