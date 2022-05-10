module namespace sessions_ = 'content/data-api/public/sessions_';

(:
  Возвращает данные пользователя по иднетификатору сессии
  @param $params?nonce индентификатор сессии, переданные пользователем
  @return параметры сессии пользователя login и garnts

:)
declare function sessions_:main($params){ 
  let $nonce := replace($params?nonce, '\s', '')
  let $result :=    
    let $sessionID :=
      sessions:ids()[sessions_:nonce(.) = $nonce]
    where $sessionID
    let $login := sessions:get($sessionID, 'login')
    let $grants := sessions:get($sessionID, 'grants')
    let $status := $login and $grants ?? '1' !! '0'
    return    
      map{
        'lipersID' : <lipersID>{$login}</lipersID>,
        'grants' : <grants>{$grants}</grants>,
        'status' : <status>{$status}</status>
      }
  return
    if($result instance of map(*))
    then($result)
    else(
      map{
        'lipersID' : <lipersID/>,
        'grants' : <grants/>,
        'status':<status>0</status>
      }
    )
};

declare function sessions_:nonce($string){
  substring(replace($string, '[A-Za-z]', ''), 1, 5)
};