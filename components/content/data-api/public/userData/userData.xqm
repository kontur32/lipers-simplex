module namespace userData = 'content/data-api/public/userData';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function userData:main($params){ 
  let $data := 
    $params?_getFileStore(
       'авторизация/lipersTeachers.xlsx',
       '.',
       $params?_config('store.yandex.personalData')
     )
  let $учитель := 
    $data//row[
      cell[@label="Логин"]=request:parameter('lipersID') or
      cell[@label="Электронная почта"]=request:parameter('lipersID')
    ]
  return
    map{
      'датаРождения' : 
      <датаРождения>{
         $учитель 
        /cell[@label="Дата рождения (чч.мм.гггг)"]/dateTime:dateParse(text())
      }</датаРождения>,
      'номерЛичногоДела' : 
      <номерЛичногоДела>{
        $учитель/cell[@label="номер личного дела"]/text()
      }</номерЛичногоДела>
    }
   
};