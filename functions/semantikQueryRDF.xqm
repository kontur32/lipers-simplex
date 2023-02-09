(:
  модуль реализует метод извлечения данных из RDF-хранилища на основе 
  комплексного семантического запроса
:)

module namespace semantikQueryRDF = "semantikQueryRDF";

import module namespace config = "app/config" at "config.xqm";  
import module namespace queryRDF = "queryRDF" at "queryRDF.xqm";

declare variable $semantikQueryRDF:semantikURL := 
  'http://a.roz37.ru:9984/garpix/semantik/app/request';

(: возвращает результат комплексного семантического запроса :)
declare 
  %public
function semantikQueryRDF:get(
  $идентификаторЗапроса as xs:string,
  $праметры as map(*)
) as element(){
  let $запрос := semantikQueryRDF:запросSPARQL($идентификаторЗапроса, $праметры)
  let $sparql := $запрос/данные
  let $output := $запрос/данные/@output/data()
  let $xquery := $запрос/рендеринг
  let $шаблон := parse-xml($запрос/шаблон/text())/child::*
  let $RDFData := semantikQueryRDF:RDFData($sparql, $output)
  let $data :=
    switch($output)
    case 'xml' return $RDFData//Q{http://www.w3.org/2005/sparql-results#}result
    case 'json' return $RDFData//_
    default return $RDFData//_
  return
    semantikQueryRDF:output($data, $xquery, $шаблон)
};


(: получает данные из RDF-хранилища :)
declare 
  %private
function semantikQueryRDF:RDFData(
  $sparql as xs:string,
  $output as xs:string
) as element(){
  queryRDF:get($sparql, $output)/child::* 
};


(: получает комплексный семантический запрос из "семантического контракта" :)
declare 
  %private
function semantikQueryRDF:запросSPARQL(
  $идентификаторЗапроса as xs:string,
  $праметры as map(*)
) as element(запрос){
  let $URIзапроса := xs:anyURI($идентификаторЗапроса)
  let $url :=
    web:create-url(
        $semantikQueryRDF:semantikURL,
        map:merge((map{'_path':$URIзапроса}, $праметры))
      )
  return
    fetch:xml($url)/запрос
};

(: формирует строку GET-запроса к RDF-базе :)
declare 
  %private
function semantikQueryRDF:urlЗапросаSPARQL(
  $sparql,
  $output
) as xs:anyURI{
  let $url := 
    web:create-url(
      config:param('api.method.RDF') || "query/",
      map{"output":$output,"query": $sparql}
    )
  return
    xs:anyURI($url)
};


(: рендиерит результат запроса RDF-данных :)
declare
  %private
function semantikQueryRDF:output(
  $данные as element()*,
  $запросРендеринга as xs:string,
  $шаблон as element()
) as element(){
  let $результат :=
    xquery:eval(
      $запросРендеринга, 
      map{'results':$данные, '':$данные},
      map{'permission':'none'}
    )
  return
    $шаблон update insert node $результат into .
};