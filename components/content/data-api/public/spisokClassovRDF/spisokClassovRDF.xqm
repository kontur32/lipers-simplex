module namespace spisokClassovRDF = 'content/data-api/public/spisokClassovRDF';

declare function spisokClassovRDF:main($params){
  let $ресурс := 
    map{
      'path':'Spravochniki/Reestr-classov.xlsx',
      'storeID':$params?_config('store.yandex.personalData')
    }
  let $URIресурса :=
    $params?_tpl('content/data-api/rdfResourceURI', $ресурс)/URIресурса/text()
  
  let $запрос := 'http://a.roz37.ru/lipers/запросы/реестр-классов'
  let $параметрыЗапроса := map{'источник':$URIресурса}
  let $результат := $params?_semantikQueryRDF($запрос, $параметрыЗапроса)
  return
    map{'данные':$результат}
};