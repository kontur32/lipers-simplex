module namespace uchenik.journal = 'content/reports/uchenik.journal';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm'; 

declare function uchenik.journal:main($params){  
  let $период := uchenik.journal:период()
  let $началоПериода := $период?началоПериода
  let $конецПериода := $период?конецПериода 
  let $ученики := uchenik.journal:списокВсехУчеников($params)
  let $текущийКласс := request:parameter(xs:string('класс'))
  let $классыДляМеню := 
     for-each(1 to 11, function($i){<a href="{'?класс=' || $i}">{$i}</a>})
  let $оценкиВсехУчениковКласса :=
    <div>{
      uchenik.journal:оценкиВсехУчениковКласса($params, $текущийКласс, $ученики)
    }</div>
  return
    map{
       'оценкиТекущие' : $оценкиВсехУчениковКласса,
       'классы' : $классыДляМеню,
       'класс' : $текущийКласс
    }
};
declare
  %private
function
  uchenik.journal:списокВсехУчеников($params) as element(row)*
{
    $params?_getFileRDF(
       'авторизация/lipersKids.xlsx',
       '.', (: запрос на выборку записей :)
       'http://81.177.136.43:9984/zapolnititul/api/v2/forms/846524b3-febe-4418-86cc-c7d2f0b7839a/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
       $params?_config('store.yandex.personalData')
    )/table/row[not(*:выбытиеОО/text())]
};

declare

function
  uchenik.journal:оценкиВсехУчениковКласса(
    $params,
    $текущийКласс as xs:string,
    $ученики as element(row)*
  ) as element(div)*
{   
  for $ученик in $ученики  
  let $номерКлассаУченика := xs:string($ученик/*:классБазаОО/text()) 
  where $номерКлассаУченика = $текущийКласс
  let $номерЛичногоДелаУченика := substring-after($ученик/@id/data(), 'реестрУчеников')  
  let $фиоУченика := $ученик/*:familyName || ' ' ||  $ученик/*:givenName    
  order by $фиоУченика   
  let $result := 
   <div>   
     <h6>Оценки за текущий учебный год: {$фиоУченика}, {$номерКлассаУченика} класс</h6>  
      {
        $params?_tpl(
          'content/data-api/public/ocenkiUchenikaTable',
          map{"номерЛичногоДелаУченика": $номерЛичногоДелаУченика}
        )/table
      }
    </div>
  return
    $result
};

declare function uchenik.journal:период(){
  let $началоПериода := 
    if(request:parameter('началоПериода'))
    then(request:parameter('началоПериода'))
    else(       
        if (fn:month-from-date(current-date() ) = (06, 07, 08, 09, 10, 11, 12))
        then (fn:year-from-date(current-date()) || '-09-01')
        else fn:year-from-date(current-date() ) - 1 || '-09-01'
        )
  let $конецПериода := 
    if(request:parameter('конецПериода'))
    then(request:parameter('конецПериода'))
    else(format-date(current-date(), "[Y0001]-[M01]-[D01]"))
  return
    map{
      'началоПериода':$началоПериода,
      'конецПериода':$конецПериода
    }
};
 