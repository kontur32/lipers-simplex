module namespace spisokClassov = 'content/data-api/public/spisokClassov';

declare function spisokClassov:main($params){
  let $классы := spisokClassov:списокКлассов($params)
  return
    map{'данные' :
    <result>
      {$классы}
    </result>}
};

declare
  %private
function
  spisokClassov:списокКлассов($params) as element(класс)*
{
  let $классы :=
    fetch:xml(
      web:create-url(
        'http://a.roz37.ru:9984/garpix/semantik/app/request/execute',
        map{
          'rp' : 'http://a.roz37.ru/lipers/запросы/реестр-классов',
          'источник':'http://lipers.ru/lipers-simplex/Spravochniki/Reestr-classov.xlsx'
        }
      )
    )/child::*/класс
  for $i in $классы
  order by xs:integer(replace($i/text(), "\D", ""))
  return
    $i
};