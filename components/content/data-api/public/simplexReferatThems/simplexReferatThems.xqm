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
           fetch:xml($url)
      }
    </result>
};