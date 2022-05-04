module namespace validateUserID = 'content/data-api/public/validateUserID';

import module namespace  jwt = "sandbox/ivgpu/вопросник/модули/jwt" at "https://raw.githubusercontent.com/kontur32/sandbox.ivgpu/dev-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D1%8B-2022/endpoints/quiz/modules/modules.jwt.xqm";

declare function validateUserID:main($params){
  let $jwtToken := request:parameter('jwtToken')
  let $secret := $params?_config('secret')
  let $isValid := jwt:validateJWT($jwtToken, $secret)
  let $результат :=
    if(namespace-uri($isValid)="http://www.w3.org/2005/xqt-errors")
    then(
      <result>
        <результат>0</результат>
      </result>
    )
    else(
      <result>
        <результат>{$isValid}</результат>
      </result>
    )
  return
    map{'данные' : $результат}
};
