module namespace content = 'content/teacher';

declare function content:main( $params ){
  let $кодАвторизации := 
    replace(string(session:id()), '[A-Za-z]', '')
  let $login := session:get('login')
  return
    map{
      'содержание' : <div>Личный кабинет учителя<div>({$кодАвторизации}, {$login})</div></div>
    }
};