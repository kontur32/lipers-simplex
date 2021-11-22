module namespace uchenik.list = 'content/reports/uchenik.list';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchenik.list:main( $params ){
    (: данные в формате похожем на RDF :)
    let $data :=
      $params?_getFileRDF(
         'tmp/kids.xlsx', (: путь к файлу в нутри хранилища :)
         '.', (: запрос на выборку записей :)
         $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
      )
    
    (: чисто для любопытсва :)
    let $href := uchenik.list:ссылкаНаИсходныеДанные( $params )

    let $список :=
      for $i in $data/table/row
      let $месяц := month-from-date( xs:date( $i/sch:birthDate ) )
      order by  $месяц
      group by $месяц
      return
        <li>Месяц { $месяц }<ul>{
          for $ii in $i
          let $день := day-from-date( xs:date( $ii/sch:birthDate ) )
          order by  $день
          let $id := $ii/@id/data()
          return
            <li>{$ii/sch:birthDate} - {$ii/sch:familyName || ' ' || $ii/sch:givenName || ' ' ||$ii/lip:отчество} (<a href = "{ $id }">идентификатор ученика</a>)</li>
        }</ul></li>
        
    return
      map{
        'списокУчеников' : <div><a href = "{ $href }">исходыне данные</a><ol>{$список}</ol></div>
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