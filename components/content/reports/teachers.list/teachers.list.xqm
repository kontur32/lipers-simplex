module namespace teachers.list = 'content/reports/teachers.list';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function teachers.list:main( $params ){
    (: чисто для любопытсва :)
    let $href := teachers.list:ссылкаНаИсходныеДанные( $params )
    
    (: данные в формате "похожем-на-RDF" :)
    let $data :=
      $params?_getFileRDF(
         'авторизация/lipersTeachers.xlsx', (: путь к файлу внутри хранилища :)
         '.', (: запрос на выборку записей :)
         'http://81.177.136.43:9984/zapolnititul/api/v2/forms/24ebf0d0-bc64-4bfe-9c0c-f869a1db5473/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
         $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
      )
        
    let $всегоППС :=
    for $i in $data/table/row
    where not ($i/lip:увольнениеОО/text())
   
    return $i

    let $список := 
           
      for $i in $data/table/row
      where not ($i/lip:увольнениеОО/text())
      let $месяцы := month-from-date(  $i/sch:birthDate/text())
      
      let $месяц := ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь') 
           
      order by $месяцы
      group by $месяцы     
      return
         <li>{ $месяц [$месяцы] }<ul>
         {
          for $ii in $i
          let $день := day-from-date( $ii/sch:birthDate/text() )
          order by $день
          let $id := $ii/@id/data()
        
          return
            <li>
            {replace($ii/sch:birthDate,'(\d{4})-(\d{2})-(\d{2})','$3.$2.$1')} - 
            {$ii/sch:familyName || ' ' || $ii/sch:givenName || ' ' ||$ii/lip:отчество || ' - Работает: с ' || replace($ii/lip:трудоустройствоОО,'(\d{4})-(\d{2})-(\d{2})','$3.$2.$1') || '' || ' - Исполняется в этом году: ' || years-from-duration(dateTime:yearsMonthsDaysCount( xs:date( year-from-date(current-date()) || '-12-31'), ($ii/sch:birthDate/text()) ) ) || ' лет' }
            </li>
        }</ul></li>
        
    return
      map{
        'списокУчеников' : <div><a href = "{ $href }">исходные данные</a>
        <h5><center>Календарь дней рождений сотрудников Лицея на {year-from-date(current-date())} год</center></h5>
        <p>Всего в Лицее на {replace(substring-before (xs:normalizedString (current-dateTime()), 'T'),'(\d{4})-(\d{2})-(\d{2})','$3.$2.$1')} г. неустанно работает {count($всегоППС/sch:familyName)} человек.</p>
        <ol>{$список}</ol></div>
      }
};

declare function teachers.list:ссылкаНаИсходныеДанные($params){
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