module namespace raspisanieRDF = 'content/data-api/public/raspisanieRDF';

import module namespace model = 'http://lipers.ru/modules/модельДанных'
  at 'https://raw.githubusercontent.com/kontur32/lipers-Zeitplan/master/modules/dataModel.xqm';

declare function raspisanieRDF:main($params){
  let $data := 
     $params?_tpl('content/data-api/public/raspisanieRaw', $params)
  let $путь := $data/file/@label/data()
  let $имяФайла := substring-before(tokenize($путь, "/")[last()], ".")
  let $номерУчебнойНедели := xs:integer(tokenize($имяФайла, "-")[2])
  let $номерКалендарнойНедели := $номерУчебнойНедели + 34
  let $год := xs:integer(tokenize($имяФайла, "-")[1])
  let $учебныйГод :=
    if(current-date()>=xs:date($год || '-09-01'))
    then($год || '/' || $год + 1)
    else($год - 1 || '/' || $год)
  
  let $расписаниеУчителей := 
    $data//table[@label = 'Расписание учителей']
  let $списокПолейЗаписиРасписания := 
    $data//table[@label='Признаки']/row/cell[@label='Признак']/text()
   
  let $расписаниеПоМодели :=
    model:расписание(
         $расписаниеУчителей,
         map{'признаки' : $списокПолейЗаписиРасписания}
       )
  let $rdf := 
    model:расписаниеRDF(
      $расписаниеПоМодели, 
      $год, 
      $номерКалендарнойНедели, 
      $учебныйГод, 
      $номерУчебнойНедели
    )
  return
    map{'данные' : $rdf}
};
