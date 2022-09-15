module namespace api_auth_kids = 'content/data-api/public/api_auth_kids';

declare function api_auth_kids:main($params){
  let $ученик :=
    api_auth_kids:списокВсехУчеников($params)
    /row[not(cell[@label="дата выбытия из ОО"]/text())]
    [cell[@label="Логин"]/text()=$params?login]
    [cell[@label="Пароль"]/text()=$params?password]
  let $ФИО := 
    $ученик/cell[@label="Фамилия,"] || ' ' || 
    $ученик/cell[@label="имя,"] || ' ' ||
    $ученик/cell[@label="отчество"]
      
  return
    map{
      'данные' :
      <user>
        <номерЛичногоДела>{$ученик/cell[@label="номер личного дела"]/text()}</номерЛичногоДела>
        <ФИО>{$ФИО}</ФИО>
      </user>
    }
};

declare
  %private
function
  api_auth_kids:списокВсехУчеников($params) as element(table)
{
    $params?_getFileStore(
       'авторизация/lipersKids.xlsx',
       './file/table[1]',
       $params?_config('store.yandex.personalData')
     )/table
};