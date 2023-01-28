module namespace uchenik.ocenki = 'content/reports/uchenik.ocenki';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm';

declare function uchenik.ocenki:main($params){
  let $номерЛичногоДела := session:get('номерЛичногоДела')
  let $период := uchenik.ocenki:период()

  let $журналыУченика := 
    $params?_tpl('content/data-api/public/journal-Raw', $params)
    //table[row[1]/cell/text()=$номерЛичногоДела]
  
  let $имяУченика := 
    ($журналыУченика/row[1]/cell[text()=$номерЛичногоДела]/@label/data())[1]

  return
    map{
      'началоПериода' : $период?началоПериода,
      'конецПериода' : $период?конецПериода,
      'имяУченика' : $имяУченика,
      
      (: оценки из RDF :)
      'текущиеОценкиУченика' :
        uchenik.ocenki:текущиеОценкиУченика($params, $номерЛичногоДела),
      
      (: оценки из TRCI :)
      'промежуточнаяАттестация' : 
        uchenik.ocenki:промежуточнаяАттестация($журналыУченика, $номерЛичногоДела),
      'техникаЧтения' : 
        uchenik.ocenki:техникаЧтения($журналыУченика, $номерЛичногоДела)
    }
};

declare
  %private
function uchenik.ocenki:текущиеОценкиУченика($params, $номерЛичногоДела){
  $params?_tpl(
    'content/data-api/public/ocenkiUchenikaTable',
    map{"номерЛичногоДелаУченика": $номерЛичногоДела}
  )/table
};

declare 
  %private
function uchenik.ocenki:промежуточнаяАттестация($журналыУченика, $номерЛичногоДела){
  let $оценкиПромежуточнойАттестации := 
    stud:промежуточнаяАттестацияУченика($журналыУченика, $номерЛичногоДела)    
  return
   <table class = "table table-striped table-bordered">
     <tr>
       <th width="20%">Предмет</th>
       <th width="10%">Четверть I</th>
       <th width="10%">Четверть II</th>
       <th width="10%">Четверть III</th>
       <th width="10%">Четверть IV</th>
       <th width="10%">Год</th>
    </tr>
     {
      for $p in $оценкиПромежуточнойАттестации
      return 
         <tr> 
           <td>{$p?1}</td>
           <td>{$p?2[1]}</td>
           <td>{$p?2[2]}</td>
           <td>{$p?2[3]}</td>
           <td>{$p?2[4]}</td>
           <td>{$p?2[5]}</td>
         </tr>
      }
    </table>
};

declare 
  %private
function uchenik.ocenki:техникаЧтения($журналыУченика, $номерЛичногоДела){
  let $оценкиПромежуточнойАттестации := 
    stud:промежуточнаяАттестацияУченика($журналыУченика, $номерЛичногоДела)   
  return
   <table class = "table table-striped table-bordered">
     <tr>
       <th width="20%">Предмет</th>
       <th width="10%">Четверть I</th>
       <th width="10%">Четверть II</th>
       <th width="10%">Четверть III</th>
       <th width="10%">Четверть IV</th>
       <th width="10%">Год</th>
    </tr>
     {
      for $p in $оценкиПромежуточнойАттестации
      return 
         <tr> 
           <td>{$p?1}</td>
           <td>{$p?2[1]}</td>
           <td>{$p?2[2]}</td>
           <td>{$p?2[3]}</td>
           <td>{$p?2[4]}</td>
           <td>{$p?2[5]}</td>
         </tr>
      }
    </table>
};


declare function uchenik.ocenki:период(){
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