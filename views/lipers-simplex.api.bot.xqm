module namespace bot = "/lipers-simplex/bot/api/v01/";

import module namespace funct="funct" at "../functions/functions.xqm";
(:
  отправляет результат выполнения компонента по адресу, указанному в callback
:)
declare 
  %rest:GET
  %rest:path("/lipers-simplex/bot/api/v01/{$метод}")
  %rest:query-param('callback', '{$callback}')
  %output:method( "text" )
function bot:main($метод as xs:string, $callback){
  let $query-params := bot:query-params()
  return
    (
      if($callback)
      then(
        try{
          let $result :=
            funct:tpl('content/data-api/public/' || $метод, $query-params)
          return
            (
              $result,
              bot:build-url($callback, $result, $query-params),
              fetch:text(bot:build-url($callback, $result, $query-params))
            )   
        }
        catch*{
          <err:BOT02>не удалось отправить запрос по адресу {$callback}</err:BOT02>
        }
      )
      else(<err:BOT01>Не передан параметр 'callback'</err:BOT01>)
    )
};

declare function bot:build-url($callback, $result, $query-params){
  web:create-url(
      $callback,
      map:merge(
        (
          for $i in $result/result/child::*
          return
            map{$i/name():$i/text()},
          $query-params
        )
      )
    )
};

declare function bot:query-params(){
  map:merge(
    for $i in request:parameter-names()
    return
      map{$i: request:parameter($i)}
  )
};