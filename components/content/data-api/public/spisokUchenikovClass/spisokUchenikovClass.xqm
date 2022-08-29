module namespace spisokUchenikovClass = 'content/data-api/public/spisokUchenikovClass';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function spisokUchenikovClass:main($params){
  let $всеУченики := spisokUchenikovClass:списокВсехУчеников($params)
  let $ученикиКласса := 
    for $i in $всеУченики/row[not(cell[@label="дата выбытия из ОО"]/text())][cell[@label="Класс"]=$params?класс]
    return
     $i/cell[@label="Фамилия,"] || ' ' || $i/cell[@label="имя,"] || '. Поступил(а): ' ||format-date(xs:date(dateTime:dateParse( $i/cell[@label="дата поступления в ОО"]/text() )), "[D01].[M01].[Y0001]")
      
  return
    map{'данные' :
    <result>
      <класс>{$params?класс}</класс>
      <списокКласса>{string-join($ученикиКласса, ";&#10;")}</списокКласса>
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