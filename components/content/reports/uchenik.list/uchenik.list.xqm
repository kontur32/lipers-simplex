module namespace uchenik.list = 'content/reports/uchenik.list';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchenik.list:main( $params ){
    (: чисто для любопытсва :)
    let $href := uchenik.list:ссылкаНаИсходныеДанные( $params )
    
    (: данные в формате "похожем-на-RDF" :)
    let $data :=
      $params?_getFileRDF(
         'авторизация/lipersKids.xlsx', (: путь к файлу в нутри хранилища :)
         '.', (: запрос на выборку записей :)
         'http://81.177.136.43:9984/zapolnititul/api/v2/forms/846524b3-febe-4418-86cc-c7d2f0b7839a/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
         $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
      )
        
    let $всегоУчеников :=
    for $i in $data/table/row
    where not($i/lip:выбытиеОО/text())
    return $i

    let $список := 
           
      for $i in $data/table/row
      let $месяцы := month-from-date( xs:date( $i/sch:birthDate ))
      
      let $месяц := ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь') 
           
      order by $месяцы
      group by $месяцы     
      return
         <li>{ $месяц [$месяцы] }<ul>
         {
          for $ii in $i
          let $день := day-from-date( xs:date( $ii/sch:birthDate ) )
          order by $день
          let $id := $ii/@id/data()
          where not($ii/lip:выбытиеОО/text())
          return
            <li>
            {replace($ii/sch:birthDate,'(\d{4})-(\d{2})-(\d{2})','$3.$2.$1')} - 
            {$ii/sch:familyName || ' ' || $ii/sch:givenName || ' ' ||$ii/lip:отчество || ' - Поступил(а): с ' ||replace($ii/lip:поступлениеОО,'(\d{4})-(\d{2})-(\d{2})','$3.$2.$1') || ' - Исполняется в этом году: ' || years-from-duration(dateTime:yearsMonthsDaysCount( xs:date( year-from-date(current-date()) || '-12-31'), xs:date($ii/sch:birthDate) ) ) || ' лет' }
            </li>
        }</ul></li>
        
    return
      map{
        'списокУчеников' : <div><a href = "{ $href }">исходные данные</a>
        <h5><center>Календарь дней рождений Лицеистов на {year-from-date(current-date())} год</center></h5>
        <p>Всего в Лицее на {replace(substring-before (xs:normalizedString (current-dateTime()), 'T'),'(\d{4})-(\d{2})-(\d{2})','$3.$2.$1')} г. обучается {count($всегоУчеников/sch:familyName)} учеников.</p>
        <ol>{$список}</ol></div>
      }
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