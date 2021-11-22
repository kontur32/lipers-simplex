module namespace uchenik.list = 'content/reports/uchenik.list';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchenik.list:main( $params ){
 
    let $профильУчителя := 
      $params?_tpl( 'content/teacher/teacher.profil', map{} )
    let $data :=
      $params?_getFileRDF( 'tmp/kids.xlsx', '.', 'f6104dd1-b88b-4104-9528-b8a7d473b251' )
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
          return
            <li>{$ii/sch:birthDate} - { $ii/sch:familyName || ' ' || $ii/sch:givenName}</li>
        }</ul></li>
        
    return
      map{
        'списокУчеников' : <div><ol>{$список}</ol></div>
      }
};