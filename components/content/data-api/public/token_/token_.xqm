module namespace token_ = 'content/data-api/public/token_';

(:
  Возвращает данные пользователя по иднетификатору сессии
  @param $params?nonce индентификатор сессии, переданные пользователем
  @return параметры сессии пользователя login и garnts

:)
declare function token_:main($params){ 
  let $encrypStr := token_:enrypt($params?string)
  let $url :=
    web:create-url(
      'http://' || request:hostname()|| ':' || request:port() ||'/lipers-simplex/p/api/v01/session_',
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