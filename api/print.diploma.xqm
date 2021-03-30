module namespace diploma = "/saivpds/api/v01/print.diploma";

import module namespace config = "app/config" at '../functions/config.xqm';
import module namespace funct = "funct" at '../functions/functions.xqm';
import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare 
  %rest:GET
  %rest:query-param( "id", "{ $id }" )
  %rest:query-param( "group", "{ $group }" )
  %rest:path( "/saivpds/api/v01/print.diploma.1" )
function diploma:main( $id, $group ){
  let $fields := diploma:getDipolma.1( $id, $group )
  let $fileName := 'diplom.docx'
  let $templatePath := 
    'http://dbx.iro37.ru/zapolnititul/api/v2/forms/f734020a-8355-4903-aaaa-f5ddb1a97042/template'
  return
     diploma:fillTemplate( $fields, $templatePath, $fileName )
};

declare 
  %rest:GET
  %rest:query-param( "id", "{ $id }" )
  %rest:query-param( "group", "{ $group }" )
  %rest:path( "/saivpds/api/v01/print.diploma.2" )
function diploma:main2( $id, $group ){
  let $fields := diploma:getDipolma.2( $id, $group )
  let $fileName := 'diplom.docx'
  let $templatePath := 
    'http://dbx.iro37.ru/zapolnititul/api/v2/forms/4d902444-d4d0-4b89-86d1-da9548d3e765/template'
  return
     diploma:fillTemplate( $fields, $templatePath, $fileName )
};

declare function diploma:getDipolma.2( $id, $group ){
  let $формыОтчетности := ( 'экзамен', 'диф.зачет', 'зачет' )
  let $notes := 
    funct:getFileWithParams( 
        'Аттестация/ДО_набор.xlsx',
        'http://localhost:8984/static/saivpds/funct/ocenki.student.xq',
        map{
          'id' : $id,
          'group' : $group
        }
      )
      /json/оценки/дисциплина
  
let $оценкиПоПредметам := 
      <table>
        {
          for $i in $notes
          where $i[ формаОтчетности/text() = ( 'экзамен', 'диф.зачет', 'зачет' ) ]
          order by $i/семестр/text()
          let $название := $i/название/text()
          group by $название
          return
            <row>
              <cell>{ $название }</cell>
              <cell>{ $i[ last() ]/ЗЕТ/text() }</cell>
              <cell>{ $i[ last() ]/оценкаПрописью/text() }</cell>
            </row>
        }
      </table>

let $ВКР :=
  $notes[ формаОтчетности/text() = "выпускная квалификационная работа"]
return
  <table>
    <row  id = 'fields'>
      <cell id = "названиеВКР" contentType = 'field'>{ $ВКР/название/text()}</cell>
      <cell id = "оцВКР" contentType = 'field'>{ $ВКР/оценкаПрописью/text() }</cell>
    </row>
    <row id = 'tables'>
      <cell id = 'оценки'>
        { $оценкиПоПредметам }
      </cell>
    </row>
  </table>
};

declare function diploma:getDipolma.1( $id, $group ){
  let $data :=
    funct:getFile( 'students.xlsx', '.'
    )/file/table[ @label = $group ]/row[cell[@label="номер личного дела"] = $id ]
  
  let $курсовые := 
    funct:getFileWithParams( 
        'Аттестация/ДО_набор.xlsx',
        'http://localhost:8984/static/saivpds/funct/ocenki.student.xq',
        map{
          'id' : $id,
          'group' : $group
        }
      )
      /json/оценки/дисциплина[ формаОтчетности/text() = "курсовая работа" ]

return
    <table>
      <row  id = 'fields'>
        <cell id = 'ФамилияСтудента' contentType = 'field'>{ $data/cell[@label = 'Фамилия']/text() }</cell>
        <cell id = 'ИмяСтудента' contentType = 'field'>{ $data/cell[@label = 'Имя']/text() }</cell>
        <cell id = 'ОтчествоСтудента' contentType = 'field'>{ $data/cell[@label = 'Отчество']/text() }</cell>
        <cell id = 'сан' contentType = 'field'>{ $data/cell[@label = 'Сан']/text() }</cell>
        <cell id = 'имяХиротонии' contentType = 'field'>{ $data/cell[@label = 'Имя в монашестве']/text() }</cell>
        <cell id = 'ДатаРождения' contentType = 'field'>{
          replace(
              xs:string(
                dateTime:dateParse(
                  $data/cell[ @label = 'дата рождения' ]/text()
                )
              ),
             '(\d{4})-(\d{2})-(\d{2})',
             '$3.$2.$1'
           )
         
        }</cell>
        <cell id = 'РегистрационныйНомерДиплом' contentType = 'field'>{ $data/cell[@label = 'Номер диплома']/text() }</cell>
        <cell id = 'ДатаВыдачиДиплом' contentType = 'field'>{
          replace(
             $data/cell[ @label = 'Дата диплома' ]/text(),
             '(\d{4})-(\d{2})-(\d{2})',
             '$3.$2.$1'
           )
        }</cell>
        <cell id = 'предыдущий документ об образовании' contentType = 'field'>{ $data/cell[@label = 'Предыдущий документ об образовании' ]/text() }</cell>
      </row>
      <row id="tables">
        <cell id="курсовые">
          <table>
            {
              for $i in $курсовые
              return
                <row>
                  <cell>{ $i/название/text() }</cell>
                  <cell>{ $i/оценкаПрописью/text() }</cell>
                </row>
            }            
          </table>
        </cell>
      </row>
    </table>
};

declare function diploma:fillTemplate( $fields, $templatePath, $fileName ){
  let $template :=
    fetch:binary(
      $templatePath
    )
  let $request :=
      <http:request method='post'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="template";'/>
            <http:body media-type = "application/octet-stream" >
              { $template }
            </http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="data";'/>
            <http:body media-type = "application/xml">
              { $fields }
            </http:body>
        </http:multipart> 
      </http:request>
    
  let $ContentDispositionValue := 
      "attachment; filename=" || iri-to-uri( $fileName  )
  let $response := 
     http:send-request (
        $request,
        'http://localhost:8984/api/v1/ooxml/docx/template/complete'
      )
  return
     (
        <rest:response>
          <http:response status="200">
            <http:header name="Content-Disposition" value="{ $ContentDispositionValue }" />
            <http:header name="Content-type" value="application/octet-stream"/>
          </http:response>
        </rest:response>,
        $response[2]
      )
};