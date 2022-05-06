module namespace raspisanieTeachers = 'content/data-api/public/raspisanieTeachers';

declare namespace iro = "http://dbx.iro37.ru";
declare namespace с = 'http://dbx.iro37.ru/сущности';
declare namespace п = 'http://dbx.iro37.ru/признаки';

import module namespace model = 'http://lipers.ru/modules/модельДанных' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-Zeitplan/master/modules/dataModel.xqm';
  
import module namespace lipersRasp = 'http://lipers.ru/modules/расписание' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-Zeitplan/master/modules/lipers-module-lipersRasp.xqm';

declare function raspisanieTeachers:main($params){
  let $расписание := raspisanieTeachers:расписание($params)
  return
    map{
      'данные' : <расписание>{ $расписание ?? $расписание !! 'Занятий нет'}</расписание>
    }
};

declare function raspisanieTeachers:расписание($params){
  let $data := 
    $params?_getFileStore(
       'Расписание/Текущее/rs.xlsx',
       '.',
       $params?_config('store.yandex.personalData')
     )
  let $списокПризнаков := $data//table[ @label = 'Признаки' ]
  let $словарьПредметов := $data//table[ @label = 'Кодификатор предметов' ]  
  let $расписаниеУчителей := $data//table[ @label = 'Расписание учителей' ]
  let $расписаниеДанные := 
    model:расписание(
       $расписаниеУчителей,
       map{
         'признаки' : $списокПризнаков/row/cell[ @label = 'Признак' ]/text()
       }
     )
  let $номерЛичногоДела := request:parameter('номерЛичногоДела')
  let $деньНедели := request:parameter('деньНедели')
  let $учебныеЗанятияУчителя :=
      $расписаниеДанные//с:учитель[@*:id = $номерЛичногоДела]
      //с:учебноеЗанятие[п:деньНеделиНомер = $деньНедели]
  let $занятияПоДнюНедели :=
    for $i in $учебныеЗанятияУчителя
    where $i/п:урокНомер/text()
    return
      $i/п:урокНомер/text() || ') класс: ' || string-join($i/п:класс/text(), ', ') ||
      ' предмет: ' || $i/п:предмет/text() || ' подгруппа: ' ||
      $i/п:подгруппа/text()
  return
    string-join($занятияПоДнюНедели, ';&#10;')
};