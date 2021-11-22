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
        'списокУчеников' : <div><ol>{$список}</ol></div>
      }
};