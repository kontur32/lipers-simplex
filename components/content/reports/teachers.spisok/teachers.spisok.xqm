module namespace teachers.spisok = 'content/reports/teachers.spisok';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function teachers.spisok:main( $params ){
    (: чисто для любопытсва :)
    let $href := teachers.spisok:ссылкаНаИсходныеДанные( $params )
    
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
       
       let $name := $i/sch:familyName
       order by $name
       count $count
     
      return
         <tr>
         {
          for $ii in $i
                 
          
          let $id := $ii/@id/data()
        
          return
            (
            <td> { $count } </td>,
            <td> { $name } </td>,
            <td> { $ii/sch:givenName }</td>,
            <td> { $ii/lip:отчество/text() } </td>,
            <td> { replace($ii/sch:birthDate,'(\d{4})-(\d{2})-(\d{2})','$3.$2.$1') } </td>,
            <td> { $ii/lip:должностьТК/text() } </td> 
            )
          }
          </tr>
        
    return
      map{
        'списокУчеников' : <div><a href = "{ $href }">исходные данные</a>
        <h5><center>Список сотрудников на {year-from-date(current-date())} год</center></h5>
        <p>Всего в Лицее на {replace(substring-before (xs:normalizedString (current-dateTime()), 'T'),'(\d{4})-(\d{2})-(\d{2})','$3.$2.$1')} г. работает {count($всегоППС/sch:familyName)} человек.</p>
        <table border = '1'>
        <tr>
            <th>№ п/п</th>
            <th>Фамилия</th>
            <th>Имя</th>
            <th>Отчество</th>
            <th>Дата рождения</th>
            <th>Должность</th>
         </tr>
            <center>
            {$список}
            </center>
         </table></div>
      }
};

declare function teachers.spisok:ссылкаНаИсходныеДанные($params){
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