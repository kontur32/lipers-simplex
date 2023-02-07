module namespace spisokClassovRDF = 'content/data-api/public/spisokClassovRDF';

declare function spisokClassovRDF:main($params){
  let $классы := $params?_queryRDF(spisokClassovRDF:sparql())//класс/value
  return
    map{'данные' :
    <result>
      {$классы}
    </result>}
};

declare
  %private
function
  spisokClassovRDF:sparql() as xs:string
{
  'PREFIX источник: <portal.titul24.ru:220/store/f6104dd1-b88b-4104-9528-b8a7d473b251/Spravochniki/Reestr-classov.xlsx>
PREFIX признак: <http://lipers.ru/схема/признаки/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT  ?класс  
WHERE { 
    GRAPH источник: {
        ?s признак:названиеКласса ?класс
    } 
}
ORDER BY xsd:integer(REPLACE(?класс, "\\D", ""))  REPLACE(?класс, "\\d", "")'
};


declare
  %private
function
  spisokClassovRDF:списокКлассов($params) as element(класс)*
{
  let $классы :=
    fetch:xml(
      web:create-url(
        'http://a.roz37.ru:9984/garpix/semantik/app/request/execute',
        map{
          'rp' : 'http://a.roz37.ru/lipers/запросы/реестр-классов'
        }
      )
    )/child::*/класс
  for $i in $классы
  order by xs:integer(replace($i/text(), "\D", ""))
  return
    $i
};