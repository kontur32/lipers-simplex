module namespace ocenkiUchenikaRaw = 'content/data-api/public/ocenkiUchenikaRaw';

declare function ocenkiUchenikaRaw:main($params){
  let $оценкиУченика := 
    fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/оценки-ученика/текущие-оценки-ученика",
          "номерЛичногоДелаУченика":$params?номерЛичногоДелаУченика
        }
      )
    )//_
  return
    map{'данные' : <оцекиУченика>{$оценкиУченика}</оцекиУченика>}
};
