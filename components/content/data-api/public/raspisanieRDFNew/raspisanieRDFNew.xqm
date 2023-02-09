module namespace raspisanieRDFNew = 'content/data-api/public/raspisanieRDFNew';

declare function raspisanieRDFNew:main($params){
  let $запрос := 'http://a.roz37.ru/lipers/запросы/расписание-классов'
  let $параметрыЗапроса := map{'класс':$params?класс}
  let $результат := $params?_semantikQueryRDF($запрос, $параметрыЗапроса)
  return
    map{'данные' : $результат}
};