module namespace uchenik.ocenki = 'content/reports/uchenik.ocenki';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm';

declare function uchenik.ocenki:main( $params ){
  let $период := uchenik.ocenki:период()
  let $началоПериода := $период?началоПериода
  let $конецПериода := $период?конецПериода
  let $data := $params?_tpl('content/data-api/public/journal-Raw', $params)
  return
    map{
      'началоПериода' : format-date(xs:date( $началоПериода ), "[Y]-[M01]-[D01]"),
      'конецПериода' : format-date(xs:date( $конецПериода ), "[Y]-[M01]-[D01]"),
      'оценки' : <div>{ uchenik.ocenki:main( $data, session:get( 'номерЛичногоДела' ), $началоПериода, $конецПериода ) }</div>
    }
};

declare function uchenik.ocenki:main( $data, $номерЛичногоДела, $началоПериода, $конецПериода ){  
  let $tables := $data//table[ row[ 1 ]/cell/text() = $номерЛичногоДела ]
  let $имяУченика := 
    ( $tables/row[ 1 ]/cell[ text() = $номерЛичногоДела ]/@label/data() )[ 1 ]
    
  let $оценкиПоПредметам := 
    stud:записиПоВсемПредметамЗаПериод(
      $tables,
      $номерЛичногоДела,
      xs:date( $началоПериода ),
      xs:date( $конецПериода )
    )  
  
  let $оценкиПромежуточнойАттестации := 
    stud:промежуточнаяАттестацияУченика( $tables, $номерЛичногоДела )
    
  let $result := 
    <div>
      <p>Журнал успеваемости ученика: { $имяУченика }</p>
      <p>Текущие оценки за четверть</p>
      <table  class = "table table-striped table-bordered">
        <tr class="text-center"> 
           <th>Предмет</th>
           <th>Текущие оценки</th>
           <th>Средний балл</th>
           <th>Средний балл за контрольные</th>
        </tr>
        {
          for $i in $оценкиПоПредметам
          let $оценки := $i?2?2[ number( . ) >0 ]
          let $количествоПропусков := count( $i?2[ ?2 = 'н' ] )
          
          let $оценкиЗаКонтрольные := 
              for $n in $i?2?2
              where ($n = ('1к', '2к', "3к", "4к", '5к'))
              return xs:integer(substring-before ($n, 'к'))     
          
          let $всеОценки :=        
               for $всеОценки in $i?2  
               return (
                      if (matches ($всеОценки?2, 'к'))      
                      then (<b title="{format-date(xs:date($всеОценки?1), "[D01].[M01].[Y0001]")} Контрольная">{translate($всеОценки?2, 'к', ',  ')}</b>)
                      else (
                           if(matches ($всеОценки?2, 'д'))
                           then <font size="3" title="{format-date(xs:date($всеОценки?1), "[D01].[M01].[Y0001]")} Дом.работа" color="red" face="Arial">{translate($всеОценки?2, 'д', ', ')}</font>
                           else 
                               (
                               if(matches ($всеОценки?2, 'ч'))
                               then <font title="{format-date(xs:date($всеОценки?1), "[D01].[M01].[Y0001]")} Техника чтения | {substring-after($всеОценки?2, 'ч') } слов в минуту" size="3" color="blue" face="Arial">{substring-before($всеОценки?2, 'ч'), ','}</font>
                               else (<font title="{format-date(xs:date($всеОценки?1), "[D01].[M01].[Y0001]")}">{$всеОценки?2, ','}</font>)
                               )
                           )
                        )
           
           let $оценкиЗаДомашние := 
              for $n in $i?2?2
              where ($n = ('1д', '2д', '3д', '4д', '5д'))
              return xs:integer(substring-before ($n, 'д'))
              
           let $оценкиДвойныеПерваяОценка := 
              for $n in $i?2?2
              where ($n = ('1/5к','2/5к','3/5к','4/5к','5/5к', 
                           '1/4к','2/4к','3/4к','4/4к','5/4к',
                           '1/3к','2/3к','3/3к','4/3к','5/3к',
                           '1/2к','2/2к','3/2к','4/2к','5/2к',
                           '1/1к','2/1к','3/1к','4/1к','5/1к'                 
                        ))
              return xs:integer(substring-before ($n, '/'))
           
           let $оценкиДвойныеВтораяОценка := 
              for $n in $i?2?2
              where ($n = ('1/5к','2/5к','3/5к','4/5к','5/5к', 
                           '1/4к','2/4к','3/4к','4/4к','5/4к',
                           '1/3к','2/3к','3/3к','4/3к','5/3к',
                           '1/2к','2/2к','3/2к','4/2к','5/2к',
                           '1/1к','2/1к','3/1к','4/1к','5/1к'                 
                          ))
              return xs:integer(substring-before (substring-after ($n, '/'),  'к'))
            
          let $техникаЧтения :=        
               for $всеОценки in $i?2  
               return (
                         if(matches ($всеОценки?2, 'ч'))
                         then <font title="{format-date(xs:date($всеОценки?1), "[D01].[M01].[Y0001]")} Техника чтения | {substring-after($всеОценки?2, 'ч') } слов в минуту" size="3" color="blue" face="Arial">{substring-before($всеОценки?2, 'ч'), ','}</font>
                        else (<font title="{format-date(xs:date($всеОценки?1), "[D01].[M01].[Y0001]")}">{$всеОценки?2, ','}</font>)
                               )
                           
                        
          
          let $оценкиДляСредней := ($оценки, $оценкиЗаКонтрольные, $оценкиЗаДомашние, $оценкиДвойныеПерваяОценка, $оценкиДвойныеВтораяОценка)
                    
           return
            
            <tr>
              <td>{ $i?1 }</td>
              <td class="text-center">{ $всеОценки } { if( $количествоПропусков )then( ' (пропусков: ' || $количествоПропусков || ')' ) }</td>
              <td class="text-center">{ round( avg( $оценкиДляСредней ), 1 )}</td>
              <td class="text-center">{ round( avg( $оценкиЗаКонтрольные ), 1 ) }</td>
            </tr>
        }
      </table>
      
   <p><center>Оценки за четверть и год</center></p>
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
           <td> { $p?1 } </td>
           <td> { $p?2[ 1 ] } </td>
           <td> { $p?2[ 2 ] } </td>
           <td> { $p?2[ 3 ] } </td>
           <td> { $p?2[ 4 ] } </td>
           <td> { $p?2[ 5 ] } </td>
         </tr>
      }
    </table>
   
   <p><center>Техника чтения</center></p>
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
           <td> { $p?1 } </td>
           <td> { $p?2[ 1 ] } </td>
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