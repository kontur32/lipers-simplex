module namespace api_auth_teachers = 'content/data-api/public/api_auth_teachers';

declare function api_auth_teachers:main($params){
  let $ученик :=
    api_auth_teachers:списокВсехУчителей($params)
    /row
    [cell[@label="Логин"]/text()=$params?login]
    [cell[@label="Пароль"]/text()=$params?password]
  let $ФИО := 
    $ученик/cell[@label="Фамилия"] || ' ' || 
    $ученик/cell[@label="Имя"] || ' ' ||
    $ученик/cell[@label="Отчество"]
      
  return
    map{
      'данные' :
      <user>
        <номерЛичногоДела>{$ученик/cell[@label="номер личного дела"]/text()}</номерЛичногоДела>
        <Должность>{$ученик/cell[@label="Должность по ТК"]/text()}</Должность>
        <ФИО>{$ФИО}</ФИО>
      </user>
    }
};

declare
  %private
function
  api_auth_teachers:списокВсехУчителей($params) as element(table)
{
    $params?_getFileStore(
       'авторизация/lipersTeachers.xlsx',
       './file/table[@label/data()="ППС"]',
       $params?_config('store.yandex.personalData')
     )//table[@label="ППС"]
};