module namespace userData = 'content/data-api/public/userData';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function userData:main($params){ 
  let $data := 
    $params?_getFileStore(
       'авторизация/lipersTeachers.xlsx',
       '.',
       $params?_config('store.yandex.personalData')
     )
  return
      map{
        'данные' : 
        <датаРождения>{
          $data//row[cell[@label="Логин"]=request:parameter('lipersID')]
        /cell[@label="Дата рождения (чч.мм.гггг)"]/dateTime:dateParse(text())
        }</датаРождения>
        
      }
   
};