module namespace raspisanie = 'content/data-api/public/raspisanie';

import module namespace model = 'http://lipers.ru/modules/модельДанных' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-Zeitplan/master/modules/dataModel.xqm';
  
import module namespace lipersRasp = 'http://lipers.ru/modules/расписание' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-Zeitplan/master/modules/lipers-module-lipersRasp.xqm';

declare function raspisanie:main($params){
  let $расписание :=  <p>расписание</p>
  return
    map{ 'данные' : raspisanie:расписание($params) }
};

declare function raspisanie:расписание($params){
  let $data := 
    $params?_getFileStore(
       'Расписание/Текущее/rs.xlsx',
       '.',
       $params?_config('store.yandex.personalData')
     )
  let $нормализованныйКласс := lower-case(replace($params?класс, '\s', ''))
  let $paramsLocal := map{'класс':$нормализованныйКласс}
  let $списокПризнаков := $data//table[ @label = 'Признаки' ]
  let $словарьПредметов := $data//table[ @label = 'Кодификатор предметов' ]  
  let $списокКлассов :=
    $data//table[@label = 'Классы']/row/cell[@label='Класс']/text() 
  
  let $расписаниеДанные := 
    model:расписание(
       $data//table[ @label = 'Расписание учителей' ],
       map{
         'признаки' : $списокПризнаков/row/cell[ @label = 'Признак' ]/text()
       }
     )
        
 let $расписаниеПолное :=
   lipersRasp:рендерингРасписаниеДетское2(
     $расписаниеДанные, $словарьПредметов, $paramsLocal, ''
   )//table[1]
   
 return
   if($params?деньНедели)
   then(
      let $r := 
        $расписаниеПолное
        update delete node ./tr[2]/td[1]
      let $деньНедели := $params?деньНедели
      let $уроки :=
        for $i in $r//tr[position()>1]/td[position()=(1+$деньНедели)]
        count $c
        where  $i/text()
        return
          'Урок ' || $c || ': ' || $i/text()
      return
        if($нормализованныйКласс=$списокКлассов)
        then(
          <result>
            <уроки>{string-join($уроки, ';&#10;')}</уроки>
          </result>
        )
        else(
          <result>
            <уроки>При запросе расписания введите класс из списка: {string-join($списокКлассов, ', ')}</уроки>
          </result>
        )
        
   )
   else($расписаниеПолное)
};