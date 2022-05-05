module namespace sessions_ = 'content/data-api/public/sessions_';

declare function sessions_:main($params){    
  let $sessionID := sessions:ids()[sessions_:nonce(.) = $params?nonce]
  let $login := sessions:get($sessionID, 'login')
  let $grants := sessions:get($sessionID, 'grants')
  return    
    map{
      'lipersID' : <lipersID>{$login}</lipersID>,
      'grants' : <grants>{$grants}</grants>
    }
};

declare function sessions_:nonce($string){
  substring(replace($string, '[A-Za-z]', ''), 1, 5)
};