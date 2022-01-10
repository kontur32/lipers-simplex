module namespace spisokUchitel = 'content/data-api/spisokKnig';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

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
     'авторизация/BibliotekaLipers.xlsx', (: путь к файлу внутри хранилища :)
     './table',
     'http://81.177.136.43:9984/zapolnititul/api/v2/forms/b3d871a0-bea6-4459-b7fb-9480fef40e6a/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
     $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
  )/table
};