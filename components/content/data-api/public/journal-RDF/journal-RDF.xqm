module namespace journal-RDF = 'content/data-api/public/journal-RDF';

import module namespace dateTime = 'dateTime'
  at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function journal-RDF:main($params){
  let $data := 
     $params?_tpl('content/data-api/public/journal-Raw', $params)
  let $rdf :=
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
      {$data//file/table/journal-RDF:оценкиПоПредмету(.)}
    </rdf:RDF>
  return
    map{'данные' : $rdf}
};

declare
  %private
function journal-RDF:оценкиПоПредмету($data as element(table))
  as element()*
{
  let $названиеПредмета := 
      normalize-space(tokenize($data/row[1]/cell[1]/@label/data(), ',')[1])
  let $класс := 
      normalize-space(tokenize($data/row[1]/cell[1]/@label/data(), ',')[2])
  let $ученики := $data/row[1]/cell
  let $оценкиВсе := $data/row[position()>6][cell[1]/text()]
  for $записьУченика in $оценкиВсе
  let $дата := $записьУченика/cell[1]/text()
  let $домашнееЗадание := $записьУченика/cell[2]/text()
  let $тема := $записьУченика/cell[3]/text()
  for $оценкаУченика in $записьУченика/cell[position()>3][text()]
  where $записьУченика
  let $идентификаторУченика :=
    $ученики[@label/data()=$оценкаУченика/@label/data()]/text()
  for $оценка in tokenize($оценкаУченика/text(), ",")
  return
      <rdf:Description xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:п="http://lipers.ru/схема/признаки/" xmlns:s="http://schema.org/" rdf:about="{'http://lipers.ru/схема/сущности/отметкаВЖурнале#' || random:uuid()}">
        <rdf:type rdf:resource="http://lipers.ru/схема/онтология/записьВЖурнале"/>
        <п:ученик rdf:resource="{'http://lipers.ru/схема/сущности/ученик#' || $идентификаторУченика}"/>
        <п:названиеПредмета>{$названиеПредмета}</п:названиеПредмета>
        <s:Date>{xs:string(dateTime:dateParse($дата))}</s:Date>
        <п:домашнееЗадание>{$домашнееЗадание}</п:домашнееЗадание>
        <п:темаУрока>{$тема}</п:темаУрока>
        <п:оценкаЗаУрок>{normalize-space($оценка)}</п:оценкаЗаУрок>
        <п:имяФайла>{$data/parent::*/@label/data()}</п:имяФайла>
        <п:класс>{$класс}</п:класс>
      </rdf:Description>
};
