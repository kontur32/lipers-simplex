module namespace sessions_ = 'content/data-api/public/sessions_';

declare function sessions_:main($params){
    map{
      'данные' :
        <lipersID>{
           for $i in sessions:ids()
           where sessions_:nonce($i) = $params?nonce
           return
             sessions:get($i, 'login')
        }</lipersID>
    }
};

declare function sessions_:nonce($string){
  substring(replace($string, '[A-Za-z]', ''), 1, 5)
};