module namespace spisokUchenikovClass = 'content/data-api/public/spisokUchenikovClass';

declare function spisokUchenikovClass:main($params){
  let $всеУченики := spisokUchenikovClass:списокВсехУчеников($params)
  let $ученикиКласса := 
    for $i in $всеУченики/row[cell[@label="Класс"]=$params?класс]
    return
      $i/cell[@label="Фамилия,"] || ' ' || $i/cell[@label="имя,"]
  return
    map{'данные' :
    <result>
      <класс>{$params?класс}</класс>
      <списокКласса>{string-join($ученикиКласса, ", ")}</списокКласса>
    </result>}
};

declare
  %private
function
  spisokUchenikovClass:списокВсехУчеников($params) as element(table)
{
    $params?_getFileStore(
       'авторизация/lipersKids.xlsx',
       './file/table[1]',
       $params?_config('store.yandex.personalData')
     )/table
};