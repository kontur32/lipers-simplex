module namespace uchenik.konduit = 'content/reports/uchenik.konduit';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm';

declare function uchenik.konduit:main($params){  
  let $data := $params?_tpl('content/data-api/public/journal-Raw', $params)
  
  let $ученики := uchenik.konduit:списокВсехУчеников($params)
  let $текущий := (request:parameter(xs:string('класс')))
  return
    map{
       'оценкиЧетверть' : <div>{uchenik.konduit:main2($data, $текущий, $ученики)}</div>,
       'классы' : for $i in (1 to 11) return <a href="{'?класс=' || $i}">{$i}</a>,
       'класс' : $текущий
    }
};
declare
  %private
function
  uchenik.konduit:списокВсехУчеников($params) as element(row)*
{
    $params?_getFileRDF(
       'авторизация/lipersKids.xlsx', (: путь к файлу внутри хранилища :)
       '.', (: запрос на выборку записей :)
       'http://81.177.136.43:9984/zapolnititul/api/v2/forms/846524b3-febe-4418-86cc-c7d2f0b7839a/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
       $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
    )/table/row[not(*:выбытиеОО/text())]
};
declare function uchenik.konduit:main2($data, $текущийКласс, $ученики ){   
  for $ученик in $ученики
  let $номерЛичногоДелаУченика := 
    substring-after($ученик/@id/data(), 'реестрУчеников')  
  let $фиоУченика :=
    $ученик/*:familyName || ' ' ||  $ученик/*:givenName    
  order by $фиоУченика
  let $номерКлассаУченика := xs:string($ученик/*:классБазаОО/text()) 
  where $номерКлассаУченика = $текущийКласс
  
  let $оценкиУченика := $data//table[ row[ 1 ]/cell/text() = $номерЛичногоДелаУченика  ]
  
  let $оценкиПромежуточнойАттестации := 
    stud:промежуточнаяАттестацияУченика( $оценкиУченика, $номерЛичногоДелаУченика )
  
  let $оценкиПоПредметам := 
    stud:записиПоВсемПредметамЗаПериод(
      $оценкиУченика,
      $номерЛичногоДелаУченика,
      xs:date('2021-09-01'),
      xs:date(current-date())
    )    
    
  let $result :=   
   <div>   
     <h6>Оценки за текущий учебный год: {$фиоУченика}, {$номерКлассаУченика} класс</h6>
     <table class = "table table-striped table-bordered">
       <tr>
         <th width="20%">Предмет</th>
         <th width="10%">I триместр</th>
         <th width="10%">II триместр</th>
         <th width="10%">III триместр</th>
         <th width="10%">Годовая оценка</th>
        </tr>
       {
        for $p in $оценкиПромежуточнойАттестации
        return 
           <tr> 
             <td> { $p?1 } </td>
             <td> { $p?2[ 2 ] } </td>
             <td> { $p?2[ 3 ] } </td>
             <td> { $p?2[ 4 ] } </td>
             <td> { $p?2[ 5 ] } </td>
           </tr>
        }
      </table>
    </div>
  return
    $result
};

