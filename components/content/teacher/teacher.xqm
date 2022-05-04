module namespace content = 'content/teacher';

declare function content:main( $params ){
  let $кодАвторизации := 
    substring(replace(session:id(), '[A-Za-z]', ''), 1, 5)
  let $login := session:get('login')
  return
    map{
      'содержание' : <div>Личный кабинет учителя<div>({$кодАвторизации}, {$login})</div></div>
    }
};