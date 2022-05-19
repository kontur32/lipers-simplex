module namespace teachers.list = 'content/reports/teachers.list';

import module namespace dateTime = 'dateTime'
  at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function teachers.list:main($params){
    (: чисто для любопытсва :)
    let $href := teachers.list:ссылкаНаИсходныеДанные($params)
    
    (: данные в формате "похожем-на-RDF" :)
    let $всеУчителя := teachers.list:списокУчителей($params)
     
    let $работающиеУчителя := $всеУчителя/table/row[not(lip:увольнениеОО/text())]
    let $количетсвоРаботающихУчителей := count($работающиеУчителя)
    let $текущаяДата :=
      replace(
        substring-before(xs:normalizedString(current-dateTime()), 'T'),
        '(\d{4})-(\d{2})-(\d{2})',
        '$3.$2.$1'
      )
    return
      map{
        'списокУчителей':teachers.list:учителяПоМесяцам($работающиеУчителя),
        'ссылкаНаИсходныйРезультат':$href,
        'текущийГод':year-from-date(current-date()),
        'текущаяДата':$текущаяДата,
        'количествоРаботающихППС':$количетсвоРаботающихУчителей
      }
};

declare
  %private
function teachers.list:учителяПоМесяцам($работающиеУчителя){
  let $месяцы :=
    ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь')
  for $i in $работающиеУчителя
  let $месяц := month-from-date($i/sch:birthDate/text())      
  order by $месяц
  group by $месяц    
  return
     <li>{$месяцы[$месяц]}<ul>{teachers.list:учителяПоМесяца($i)}</ul></li>
};

declare
  %private
function teachers.list:учителяПоМесяца($учителяПоМесяца){
  for $ii in $учителяПоМесяца
  let $день := day-from-date($ii/sch:birthDate/text())
  order by $день
  let $id := $ii/@id/data()
  return
    <li>{teachers.list:записьУчителя($ii)}</li>
};

declare
  %private
function teachers.list:записьУчителя($записьУчителя){
  let $деньРождения := 
    replace(
      $записьУчителя/sch:birthDate,
      '(\d{4})-(\d{2})-(\d{2})','$3.$2.$1'
    )
  let $фио :=
    $записьУчителя/sch:familyName||' '||$записьУчителя/sch:givenName||
    ' '||$записьУчителя/lip:отчество
  let $датаТрудоустройства := 
    replace(
      $записьУчителя/lip:трудоустройствоОО,
      '(\d{4})-(\d{2})-(\d{2})','$3.$2.$1'
    )
  let $возраст := 
    years-from-duration(
      dateTime:yearsMonthsDaysCount(
        xs:date(year-from-date(current-date()) || '-12-31'),
        $записьУчителя/sch:birthDate/text()
      )
    )
    return
      $деньРождения || ' - ' || $фио || ' - Работает: с ' ||
      $датаТрудоустройства || ' - Исполняется в этом году: ' || 
      $возраст || ' лет'
};

declare
  %private
function teachers.list:списокУчителей($params){
  $params?_getFileRDF(
     (: путь к файлу внутри хранилища :)
     'авторизация/lipersTeachers.xlsx',
     (: запрос на выборку записей :)
     '.',
     (: адрес (URL)схемы данных :)
     'http://81.177.136.43:9984/zapolnititul/api/v2/forms/24ebf0d0-bc64-4bfe-9c0c-f869a1db5473/fields',
     (: идентификатор хранилища :)
     $params?_config('store.yandex.personalData')
  )
};

(: чисто для интереса и для отладки:)
declare
  %private
function teachers.list:ссылкаНаИсходныеДанные($params){
  web:create-url(
     $params?_config( "api.method.getData" ) || 'stores/' ||  $params?_config('store.yandex.personalData') || '/rdf',
     map{
       'access_token' : session:get('access_token'),
       'path' : 'авторизация/lipersTeachers.xlsx',
       'xq' : '.',
       'schema' : 'http://81.177.136.43:9984/zapolnititul/api/v2/forms/24ebf0d0-bc64-4bfe-9c0c-f869a1db5473/fields'
     }
   )
};