module namespace zameshen-26 = 'content/data-api/public/zameshen-26';

import module namespace dateTime = 'dateTime' 
  at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function zameshen-26:main($params){
  let $путь := '2020-2021/Табель/Журнал замещений 2021.xlsx'
  let $d := zameshen-26:расписание($params, $путь)
  let $text:= 
    (
      'На основании приказа № 246-к от 24.09.2020г. среднее количество учащихся в классе – 26 человек',
      'На основании приказа № 246-к от 24.09.2020г. средняя наполняемость группы – 13 человек'
    )
  let $dates :=
    map{
      'from':if($params?from)then($params?from)else('2020-09-01'),
      'to':if($params?to)then($params?to)else('2020-09-10')
    }
  let $fromDate:= 
      if($params?from)then($params?from)else('2020-09-01')
  let $toDate:= 
    if($params?to)then($params?to)else('2020-09-10')
  return
    map:merge((
      $dates,
      zameshen-26:table($d, $dates?from, $dates?to, $text)
    ))
};

declare
  %private
function
  zameshen-26:расписание($params, $путь) as element(file)
{
  $params?_getFileStore($путь, '.', $params?_config('store.yandex.school26'))
  /file
};

declare function zameshen-26:data($data){ 
  for $i in $data
  let $t := $i/cell[@label ='Учитель_замещение']/text()
  order by $t
  group by $t
  where $t
  return
    <i t='{$t}'>{
      for $ii in $i
      let $z := $ii/cell[@label='Учитель']/text()
      order by $z
      group by $z
      count $c1
      return 
        <ii z = '{$z}'>{
          for $iii in $ii
           let $p := $iii/cell[@label = 'Предмет_замещение']/text()
           order by $p
           group by $p
           count $c2
           return 
              <iii p = '{$p}'>{
                for $iiii in $iii
                let $cl := $iiii/cell[ @label = 'Класс' ]/text()
                 order by $cl
                 group by $cl
                 count $c3
                 let $классов := distinct-values($iii/cell[@label='Класс']/text())
                 return
                   <tr>
                     <td>{$cl}</td>
                     <td >{count($iiii)}</td>
                   </tr>
              }</iii>
        }</ii>
    }</i>
};

declare function zameshen-26:table($data, $params){
  <table border = '1px' style = "width : 50%" bgcolor="#FFFFFF" bordercolor="#000000" cellspacing="0" cellpadding="0">
    <tr style = "text-align: center; font-weight: bold;">
      <td>№ пп</td>
      <td>Ф.И.О. учителя, заменившего урок</td>
      <td>Ф.И.О. учителя, пропустившего урок</td>
      <td>Учебный предмет</td>
      <td>Класс</td>
      <td>Кол-во часов</td>
      <td style = "font-style: italic; font-weight: normal;" rowspan = '{ count( $data//tr ) + 2 + count( $data )}'> { $params?text }</td>
    </tr>
    {
     for $i in $data
     count $c1
     return
       for $ii in $i/ii
       count $c2
       return
         for $iii in $ii/iii
         count $c3
         return
           for $tr in $iii/tr
           count $c4
           return
             (
             <tr>
               {
                 if( $c2 = 1 and $c3 = 1 and $c4 = 1 )
                 then(
                   <td rowspan = '{count($i//tr) + 1}'>{$c1}</td>,
                   <td rowspan = '{count($i//tr) + 1}'>{$i/@t/data()}</td>
                 )
                 else()
               }
               {
                 if( $c3 = 1 and $c4 = 1 )
                 then(
                   <td rowspan = '{ count( $ii//tr ) }'>{ $ii/@z/data() }</td>
                 )
                 else()
               }
               {
                 if( $c4 = 1 )
                 then(
                   <td rowspan = '{ count( $iii//tr ) }'>{ $iii/@p/data() }</td>
                 )
                 else()
               }
               <td>{ $tr/td[ last() - 1 ]/text() }</td>
               <td style = "text-align: center;">{ $tr/td[ last() ]/text() }</td>
             </tr>,
              if( $c2 = count( $i/ii) and $c3 = count( $ii/iii ) and $c4 = count( $iii/tr ) )
               then(
                 <tr style = "font-style: italic;">
                   <td colspan = '3'>Итого: </td>
                   <td style = "text-align: center;">{sum($i//td[2]/text())}</td>
                 </tr>
               )
               else()
           ),
             <tr style = "text-align: center; font-weight: bold;">
               <td colspan = '5'>Всего: </td>
               <td>{ sum( $data//tr/td[ last() ]/number() )}</td>
             </tr>
    }
  </table>
};

declare function zameshen-26:table($d, $fromDate, $toDate, $text){
  let $data := 
    $d//table[1]/row
      [cell[@label='Дата']/dateTime:dateParse(./text()) >= xs:date($fromDate)]
      [cell[@label='Дата']/dateTime:dateParse(./text()) <= xs:date($toDate)]
  
  let $поКлассам := 
      $data[cell[@label='Предмет']/text() contains text ftnot {'технология', 'английский', 'информатика', 'основы компьютерной'}]
  let $поПодгруппам := 
    $data[cell[@label='Предмет']/text() contains text {'технология', 'английский', 'информатика', 'основы компьютерной'}] 
return
  map{
    'поКлассам': zameshen-26:table(zameshen-26:data($поКлассам), map{'text':$text[1]}),
    'поПодгруппам':zameshen-26:table(zameshen-26:data($поПодгруппам), map{'text':$text[2]})
  }
};