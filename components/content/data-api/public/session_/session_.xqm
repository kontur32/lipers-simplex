module namespace session_ = 'content/data-api/public/session_';

(:
  Устанавливает сессиию и возвращает идентификатор сессии
  @param $params?token зашифрованные параметры сессии пользователя
  @return код сессии для авторизации пользователя

:)
declare function session_:main($params){ 
  let $sessionNonce := session_:nonce(session:id())
  let $decrypStr := session_:derypt($params?token)
  let $userData := json:parse($decrypStr)
  let $setSession :=
    (
      session:set('login', $userData//login/text()),
      session:set('grants', $userData//grants/text())
    )
  let $result :=    
      map{
        'nonce' : <кодАвторизации>{$sessionNonce}</кодАвторизации>,
        'sessionData':
          <sessionData>
            <login>{session:get('login')}</login>
            <grants>{session:get('grants')}</grants>
          </sessionData>
      }
  return
   $result
};

declare function session_:derypt($string){
  let $key := '12345678'
  let $decryptStr := crypto:decrypt(xs:base64Binary($string), 'symmetric', $key, 'DES')
  return
     $decryptStr
};

declare function session_:nonce($string){
  substring(replace($string, '[A-Za-z]', ''), 1, 5)
};