module namespace uchenik.propuski = 'content/reports/uchenik.propuski';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm'; 

declare function uchenik.propuski:main( $params ){
  let $data := $params?_tpl('content/data-api/public/journal-Raw', $params)
  let $период := uchenik.propuski:период()
  return
    map{
       'началоПериода' : $период?началоПериода,
       'конецПериода' : $период?конецПериода,
       'пропуски' : <div>{ uchenik.propuski:пропуски($data, $период) }</div>
    }
};

declare function uchenik.propuski:пропуски($data, $период){  
  for $данные2 in stud:ученики($data//table[row[1]/cell/text()])
  let $номерЛичногоДела := $данные2?1  
  let $tables := $data//table[row[1]/cell/text()=$номерЛичногоДела]
  let $имяУченика := 
    $tables[1]/row[1]/cell[text()=$номерЛичногоДела][1]/@label/data()
     
  let $оценкиПромежуточнойАттестации := 
    stud:количествоПропусковПоПредметам(
      $tables, $номерЛичногоДела, $период?началоПериода, $период?конецПериода
    )
  let $класс := tokenize($tables[1]/@label)[1]
  let $result := 
   <div>   
     <h6>Оценки за текущий учебный год: {$имяУченика}, {$класс} класс</h6>     
     <table class = "table table-striped table-bordered">
       <tr>
         <th width="10%">Предмет</th>
         <th width="20%">Количество пропусков за выбранный период</th>
       </tr>
       {
        for $p in $оценкиПромежуточнойАттестации
        return 
           <tr> 
             <td>{$p?1}</td>
             <td>{$p?2}</td>
           </tr>
        }
      </table>
    </div>

  return
    $result
};

declare function uchenik.propuski:период(){
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