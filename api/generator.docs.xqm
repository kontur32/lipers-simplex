module namespace docs = "lipers-simplex/student/docs";

import module namespace config = "app/config" at '../functions/config.xqm';
import module namespace funct="funct" at "../functions/functions.xqm";

declare 
  %rest:GET
  %rest:query-param( "id", "{ $id }", "" )
  %rest:path( "/lipers-simplex/api/v01/generator/docs/{ $документ }" )
  %private
function docs:main( $документ as xs:string, $id as xs:string ){
  let $поляДляВставки := 
      funct:tpl('content/docs/' || $документ, map{'id' : $id})/table
  let $шаблон := docs:шаблон($документ)
  let $имяВыходногоФайла := $документ || '.docx'
  let $заполненныйШаблон :=
     docs:заполнитьШаблон($поляДляВставки, $шаблон, $имяВыходногоФайла )
  return
    $заполненныйШаблон
};

declare
  %private
function docs:шаблон($документ as xs:string){
  let $URLшаблона := 
    fetch:xml(
      web:create-url(
        'http://iro37.ru/xqwiki/api.php',
        map{
          'action':'ask',
          'format':'xml',
          'query':
            replace(
              '[[Организация::Лицей "Перспектива"]][[Слэг шаблона::%1]]|?URL',
              '%1',
              $документ
            )
        }
      )
  )
  /api/query/results/subject/printouts/property[@label="URL"]/value[1]/text()
  return
    fetch:binary($URLшаблона)
   
};

declare
  %private
function docs:заполнитьШаблон(
  $поля as element(table),
  $шаблон as xs:base64Binary,
  $имяФайла as xs:string
){
  let $запрос :=
      <http:request method='POST'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="template";'/>
            <http:body media-type = "application/octet-stream" >
              { $шаблон }
            </http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="data";'/>
            <http:body media-type = "application/xml">
              { $поля }
            </http:body>
        </http:multipart> 
      </http:request>
    
  let $ContentDispositionValue := 
      "attachment; filename=" || iri-to-uri( $имяФайла  )
  let $ответ := 
     http:send-request (
        $запрос,
        'http://localhost:9984/api/v1/ooxml/docx/template/complete'
      )
  return
     (
        <rest:response>
          <http:response status="200">
            <http:header name="Content-Disposition" value="{ $ContentDispositionValue }" />
            <http:header name="Content-type" value="application/octet-stream"/>
          </http:response>
        </rest:response>,
        $ответ[2]
      )
};