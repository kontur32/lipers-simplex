module namespace raspisanieRaw = 'content/data-api/public/raspisanieRaw';

import module namespace model = 'http://lipers.ru/modules/модельДанных'
  at 'https://raw.githubusercontent.com/kontur32/lipers-Zeitplan/master/modules/dataModel.xqm';

declare function raspisanieRaw:main($params){
  let $путь := 'Расписание/2022-2023 Расписание недельное/2022-текущее.xlsx'
  let $data := raspisanieRaw:расписание($params, $путь)
  return
    map{'данные' : $data}
};

declare
  %private
function
  raspisanieRaw:расписание($params, $путь) as element(file)
{
  $params?_getFileStore(
     $путь, 
     '.', 
     $params?_config('store.yandex.personalData')
  )/file update insert node attribute {"label"}{$путь} into .
};