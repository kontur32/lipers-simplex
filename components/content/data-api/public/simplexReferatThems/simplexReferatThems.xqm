module namespace simplexReferatThems = 'content/data-api/public/simplexReferatThems';


declare function simplexReferatThems:main($params){
    let $предмет := request:parameter('предмет')
    return
      map{'данные' : simplexReferatThems:тема($предмет)}
};

declare function simplexReferatThems:тема($предмет){
    <result>
      <предмет>{$предмет}</предмет>
      {
        let $url :=
          web:create-url(
            'http://a.roz37.ru:9984/garpix/semantik/app/request/execute',
            map{
              'rp':'http://a.roz37.ru/lipers/запросы/темы-рефератов',
              'предмет':$предмет
            }
          )
         return
           fetch:xml($url)//реферат/child::*
      }
      <ссылкаДляОбновления>{
        web:create-url(
          'http://81.177.136.43:9984/lipers-simplex/api/v01/transfom/trci-rdf',
          map{
            'path' : 'SSM/Thems.xlsx',
            'schema' : 'http://a.roz37.ru:9984/garpix/semantik/app/api/v0.1/schema/generate/Схема данных для тем рефератов'
          }
        )
      }</ссылкаДляОбновления>
    </result>
};