module namespace uchenik.journal = 'content/reports/uchenik.journal';

import module namespace stud = 'lipers/modules/student' 
  at 'https://raw.githubusercontent.com/kontur32/lipers-zt/master/modules/stud.xqm'; 
import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchenik.journal:main( $params ){  
  
  let $началоПериода :=
    if( request:parameter( 'началоПериода' ) )
    then( xs:date( request:parameter( 'началоПериода' ) ) )
    else(      
        if (fn:month-from-date(current-date() ) = (06, 07, 08, 09, 10, 11, 12))
        then (fn:year-from-date(current-date()) || '-09-01')
        else fn:year-from-date(current-date() ) - 1 || '-09-01'
        )
  
  let $конецПериода :=
    if( request:parameter( 'конецПериода' ) )
    then( xs:date( request:parameter( 'конецПериода' ) ) )
    else( current-date() ) 
  
  let $data:=
    fetch:xml(
      'http://81.177.136.43:9984/zapolnititul/api/v2.1/data/publication/70ac0ae7-0f03-48cc-9962-860ef2832349'
    )
  let $ученики := uchenik.journal:списокВсехУчеников($params)
  let $текущий := (request:parameter(xs:string('класс')))
  return
    map{
       'оценкиТекущие' : <div>{ uchenik.journal:main2($data, $текущий, $ученики) }</div>,
       'классы' : for $i in (1 to 11) return <a href="{'?класс=' || $i}">{$i}</a>,
       'класс' : $текущий
    }
};
declare
  %private
function
  uchenik.journal:списокВсехУчеников($params) as element(row)*
{
    $params?_getFileRDF(
       'авторизация/lipersKids.xlsx', (: путь к файлу внутри хранилища :)
       '.', (: запрос на выборку записей :)
       'http://81.177.136.43:9984/zapolnititul/api/v2/forms/846524b3-febe-4418-86cc-c7d2f0b7839a/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
       $params?_config('store.yandex.personalData') (: идентификатор хранилища :)
    )/table/row[not(*:выбытиеОО/text())]
};
declare function uchenik.journal:main2($data, $текущийКласс, $ученики ){   
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
      xs:date( '2021-09-01' ),
      xs:date( current-date() )
    )    
  
  let $result := 
   <div>   

   <h6>Оценки за текущий учебный год: { $фиоУченика }, { $номерКлассаУченика  } класс</h6>     
   <div>
      <table  class = "table table-striped table-bordered">
        <tr class="text-center"> 
           <th>Предмет</th>
           <th>Текущие оценки</th>
           <th>Средний балл</th>
           <th>Средний балл за контрольные</th>
        </tr>
        {
          for $i in $оценкиПоПредметам[ position() >= 2 ]
          let $оценки := $i?2?2[ number( . ) > 0 ]
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
    </div>
    </div>
  return
    $result
};
  
 