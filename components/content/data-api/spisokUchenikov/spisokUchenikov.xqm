module namespace spisokUchenikov = 'content/data-api/spisokUchenikov';

declare function spisokUchenikov:main( $params ){
  let $ученики := spisokUchenikov:списокВсехУчеников( $params )
  
  return
    map{'данные' : $ученики}
};

declare
  %private
function
  spisokUchenikov:списокВсехУчеников($params) as element(table)
{
  $params?_getFileRDF(
     'авторизация/lipersKids.xlsx', (: путь к файлу внутри хранилища :)
     '.', (: запрос на выборку записей :)
     'http://81.177.136.43:9984/zapolnititul/api/v2/forms/846524b3-febe-4418-86cc-c7d2f0b7839a/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
     $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
  )/table
};