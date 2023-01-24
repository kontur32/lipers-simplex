module namespace uchenik.tehChten = 'content/reports/uchenik.tehChten';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm';

declare function uchenik.tehChten:main($params){
  let $период := uchenik.tehChten:период()
  let $началоПериода := $период?началоПериода
  let $конецПериода := $период?конецПериода
  let $data := $params?_tpl('content/data-api/public/journal-Raw', $params)
  return
    map{
      'началоПериода':format-date(xs:date($началоПериода), "[Y]-[M01]-[D01]"),
      'конецПериода':format-date(xs:date($конецПериода), "[Y]-[M01]-[D01]"),
      'оценки':
        <div>{
          uchenik.tehChten:main($data, session:get('номерЛичногоДела'), $началоПериода, $конецПериода)
        }</div>
    }
};

declare function uchenik.tehChten:main($data, $номерЛичногоДела, $началоПериода, $конецПериода){  
  let $tables := $data//table[row[1]/cell/text() = $номерЛичногоДела]
  let $имяУченика := 
    ($tables/row[1]/cell[text()=$номерЛичногоДела]/@label/data())[1]
  let $оценкиПоПредметам := 
    stud:записиПоВсемПредметамЗаПериод(
      $tables,
      $номерЛичногоДела,
      xs:date($началоПериода),
      xs:date($конецПериода)
    )    
  let $result := 
    <div>
      <p>Журнал успеваемости ученика: {$имяУченика}</p>
      <table  class = "table table-striped table-bordered">
         <tr class="text-center"> 
           <th>Дата</th>
           <th>Оценка</th>
           <th>Количество слов в минуту</th>
         </tr>
        {
          for $i in $оценкиПоПредметам[position() >= 2] 
          for $всеОценки in $i?2
          where matches ($всеОценки?2, 'ч')                     
          return
           <tr>
             <td class="text-center">{format-date(xs:date($всеОценки?1), "[D01].[M01].[Y0001]")}</td>
             <td class="text-center">{substring-before($всеОценки?2, 'ч')}</td>
             <td class="text-center">{substring-after($всеОценки?2, 'ч')}</td>
           </tr>
        }
      </table>
    </div>
  return
    $result
};

declare function uchenik.tehChten:период(){
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