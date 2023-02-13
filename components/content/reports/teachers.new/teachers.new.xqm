module namespace teachers.new = 'content/reports/teachers.new';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function teachers.new:ссылкаНаИсходныеДанные($params){
  web:create-url(
     $params?_config( "api.method.getData" ) || 'stores/' ||  $params?_config('store.yandex.personalData') || '/rdf',
     map{
       'access_token' : session:get('access_token'),
       'path' : 'Utils/admin.xlsx',
       'xq' : '.',
       'schema' : 'http://81.177.136.43:9984/zapolnititul/api/v2/forms/21616c29-2427-4d1d-9cd7-8b83092c92c0/fields'
     }
   )
};

declare function teachers.new:main( $params ){
    (: чисто для любопытсва :)
    let $href := teachers.new:ссылкаНаИсходныеДанные( $params )
    
    (: данные в формате "похожем-на-RDF" :)
    let $data :=
      $params?_getFileRDF(
         'Utils/admin.xlsx', (: путь к файлу внутри хранилища :)
         '.', (: запрос на выборку записей :)
         'http://81.177.136.43:9984/zapolnititul/api/v2/forms/21616c29-2427-4d1d-9cd7-8b83092c92c0/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
         $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
      )
        
    let $список := 
           
      for $i in $data/table/row   
        let $button := $i/lip:button/text()
        let $links := $i/lip:links/text()   
      return     
          <tr>
             <td><a class="btn btn-primary" href="{$links}">{$button}</a></td>
          </tr>
    return
      map{
        'обновления' : <div><h5><center>Обновление данных</center></h5>
            <center>{$список}</center>
         </div>
      }   
};