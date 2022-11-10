module namespace raspisanieRaw26 = 'content/data-api/public/raspisanieRaw26';

declare function raspisanieRaw26:main($params){
  let $путь := 'Расписание/2022-2023 Расписание недельное/2022-текущее-26.xlsx'
  let $data := raspisanieRaw26:расписание($params, $путь)
  return
    map{'данные' : $data}
};

declare
  %private
function
  raspisanieRaw26:расписание($params, $путь) as element(file)
{
  $params?_getFileStore(
     $путь, 
     '.', 
     $params?_config('store.yandex.personalData')
  )/file update insert node attribute {"label"}{$путь} into .
};