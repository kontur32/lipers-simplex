module namespace uchenik.list = 'content/reports/uchenik.list';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchenik.list:main( $params ){

    let $месяцы := ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь')
    
    (: данные в формате "похожем-на-RDF" :)
    let $data := uchenik.list:списокВсехУчеников( $params )
    let $ученикиТекущие := $data/row[ not(lip:выбытиеОО/text()) ]   
    
    let $списокУчеников :=   
      for $i in  $ученикиТекущие
      let $месяцРожденияУченика := month-from-date( xs:date( $i/sch:birthDate ))   
      order by $месяцРожденияУченика
      group by $месяцРожденияУченика     
      return
         <li>{ $месяцы[$месяцРожденияУченика] }
           <ul>{uchenik.list:записиОбУченикахОдногоМесяцаРождения($i)}</ul>
         </li>
    
    let $всегоУчеников := count($ученикиТекущие)
    let $ссылкаНаИсходныеДанные := uchenik.list:ссылкаНаИсходныеДанные( $params )
    let $текущаяДата := format-date(current-date(), "[D01].[M01].[Y0001]")    
    let $текущийГод := year-from-date(current-date())
    return
      map{
        'текущаяДата' : $текущаяДата,
        'ссылкаНаИсходныеДанные' : $ссылкаНаИсходныеДанные,
        'текущийГод' : $текущийГод,
        'всегоУчеников' : $всегоУчеников,
        'списокУчеников' : $списокУчеников
      }
};

declare
  %private
function
  uchenik.list:записиОбУченикахОдногоМесяцаРождения(
      $ученикиОдногМесяцаРождения as element(row)*
  ) as element(li)*
{
  for $ii in $ученикиОдногМесяцаРождения
  let $день := day-from-date( xs:date( $ii/sch:birthDate ) )
  order by $день
  let $деньРождения :=
    format-date(xs:date($ii/sch:birthDate), "[D01].[M01].[Y0001]")
  let $датаПоступления := 
    format-date(xs:date($ii/lip:поступлениеОО), "[D01].[M01].[Y0001]")
  let $фио := 
    $ii/sch:familyName || ' ' || $ii/sch:givenName || ' ' ||$ii/lip:отчество
  let $исполняетсяЛет := 
    years-from-duration(
      dateTime:yearsMonthsDaysCount(
        xs:date( year-from-date(current-date()) || '-12-31'), xs:date($ii/sch:birthDate)
      )
    )
  
  return
    <li>
      {$деньРождения} - 
      { $фио || ' - Поступил(а): с ' || $датаПоступления || ' - Исполняется в этом году: ' || $исполняетсяЛет || ' лет' }
    </li>
};

declare
  %private
function
  uchenik.list:списокВсехУчеников($params) as element(table)
{
  $params?_getFileRDF(
     'авторизация/lipersKids.xlsx', (: путь к файлу внутри хранилища :)
     '.', (: запрос на выборку записей :)
     'http://81.177.136.43:9984/zapolnititul/api/v2/forms/846524b3-febe-4418-86cc-c7d2f0b7839a/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
     $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
  )/table
};

declare function uchenik.list:ссылкаНаИсходныеДанные($params){
  web:create-url(
     $params?_config( "api.method.getData" ) || 'stores/' ||  $params?_config('store.yandex.personalData') || '/rdf',
     map{
       'access_token' : session:get('access_token'),
       'path' : 'tmp/kids.xlsx',
       'xq' : '.',
       'schema' : 'http://81.177.136.43:9984/zapolnititul/api/v2/forms/846524b3-febe-4418-86cc-c7d2f0b7839a/fields'
     }
   )
};