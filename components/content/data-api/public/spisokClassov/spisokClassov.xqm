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
      "http://a.roz37.ru:9984/garpix/semantik/app/request/execute?rp=http://a.roz37.ru/lipers/%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D1%8B/%D1%80%D0%B5%D0%B5%D1%81%D1%82%D1%80-%D0%BA%D0%BB%D0%B0%D1%81%D1%81%D0%BE%D0%B2"
    )/child::*/класс
  for $i in $классы
  order by xs:integer(replace($i/text(), "\D", ""))
  return
    $i
};

declare
  %private
function
  spisokClassov:списокКлассов2($params) 
{
    $params?_getFileStore(
       'Расписание/Текущее/rs.xlsx',
       './/table[@label="Классы"]',
       $params?_config('store.yandex.personalData')
     )
};