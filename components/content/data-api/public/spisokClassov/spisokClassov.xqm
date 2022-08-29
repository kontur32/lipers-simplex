module namespace spisokClassov = 'content/data-api/public/spisokClassov';

declare function spisokClassov:main($params){
  let $классы := spisokClassov:списокКлассов($params)
  return
    map{'данные' :
    <result>
      <классы>{$классы}</классы>
    </result>}
};

declare
  %private
function
  spisokClassov:списокКлассов($params) 
{
    $params?_getFileStore(
       'Расписание/Текущее/rs.xlsx',
       './/table[@label="Классы"]',
       $params?_config('store.yandex.personalData')
     )
};