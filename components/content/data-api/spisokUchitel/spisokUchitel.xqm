module namespace spisokUchitel = 'content/data-api/spisokUchitel';

declare function spisokUchitel:main( $params ){
  let $учителя := spisokUchitel:списокВсехУчителей( $params )
  
  return
    map{'данные' : $учителя}
};

declare
  %private
function
  spisokUchitel:списокВсехУчителей($params) as element(table)
{
  $params?_getFileRDF(
     'авторизация/lipersTeachers.xlsx', (: путь к файлу внутри хранилища :)
     '.', (: запрос на выборку записей :)
     'http://81.177.136.43:9984/zapolnititul/api/v2/forms/24ebf0d0-bc64-4bfe-9c0c-f869a1db5473/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
     $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
  )/table
};