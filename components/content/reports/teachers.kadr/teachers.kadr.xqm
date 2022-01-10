module namespace teachers.kadr = 'content/reports/teachers.kadr';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

import module namespace functx = "http://www.functx.com";

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function teachers.kadr:main( $params ){
    
    let $текущаяДата := teachers.kadr:текущаяДата( $params )
    
    let $сегодня := substring-before(xs:string(current-date()), '+')
    
    let $data := teachers.kadr:данные( $params )           
      
    let $сотрудникиТекущие := $data/row
    [ (((lip:трудоустройствоОО/text() <= $текущаяДата)))
      and
      ( (lip:увольнениеОО/text()) >= $текущаяДата
      or
      not(lip:увольнениеОО/text() ) )
    
    ]   
    
    let $списокСотрудников :=   
      for $i in $сотрудникиТекущие
      let $фио :=
        $i/sch:familyName || ' ' || $i/sch:givenName || ' ' ||$i/lip:отчество
       
      order by $фио
      count $c
           
      (: Начало кода подсчета стажа работы в Лицее :)
      let $yearLipers := 
        let $date := $i/lip:трудоустройствоОО
        return
          if( $date )
          then(
            let $max := $текущаяДата

            let $min := ( $i/lip:трудоустройствоОО )
            return
              dateTime:yearsMonthsDaysCount( $max, $min )
          )
          else('н/д')
        
            (: Конец кода подсчета стажа Работы в Лицее:)    
     
      (: Начало кода подсчета общего стажа работы с учетом стажа работы в Лицее :)
      let $стажОбщийТрудовойВформатеЛицея := fn:tokenize($i/lip:общийстажТрудоустройство/text())
        
      let $стажОбщийТрудовойВправильномФормате := substring-before(xs:string('P' || functx:replace-multi(
      xs:string( $стажОбщийТрудовойВформатеЛицея ),
      ( 'г', 'м', 'д' ),
      (  'Y', 'M', 'D' ) 
   )), 'M') || 'M' 
          
       let $ОтображениеГодаИмесяцаСтажаРаботыВЛицее := 
            if (xs:integer(substring-after(substring-before(xs:string($yearLipers), 'Y'), 'P') >= '1' ) )
            
            then
            ( 
            
            if (xs:integer(string-length(substring-before(xs:string($yearLipers), 'M' ) || 'M'
          ) = 1)
            
          )
            then
            (
               substring-before(xs:string($yearLipers), 'Y' ) || 'Y0M'
          ) 
            else 
              substring-before(xs:string($yearLipers), 'M' ) || 'M'
          ) 
              else 
              (('P0Y' || substring-before(substring-after(xs:string($yearLipers), 'P'), 'M') || 'M'))
            
        
        let $ОтображениеГодаИмесяцаСтажаРаботыВЛицее5 := 
            if (xs:integer(string-length(xs:string($ОтображениеГодаИмесяцаСтажаРаботыВЛицее)) = 1)
            
          )
            then
            (
               $yearLipers
          ) 
            else 
              $ОтображениеГодаИмесяцаСтажаРаботыВЛицее || 'M'
            
       let $стажВлицее :=
         functx:insert-string(xs:string($yearLipers),'0M',3)
       
       
       let $ОтображениеГодаИмесяцаСтажаРаботыВЛицее2 := 
            if (functx:contains-word(xs:string($yearLipers), 'M')
            )   
            then
            (( substring-before(xs:string($yearLipers), 'Y') || 'Y0M' ))
            else ('P0Y' || substring-before(substring-after(xs:string($yearLipers), 'P'), 'M') || 'M')
            
       let $ОтображениеГодаИмесяцаСтажаРаботыВЛицее3 := 
            if (functx:contains-word(xs:string($ОтображениеГодаИмесяцаСтажаРаботыВЛицее), 'P')
            )
            then
            ($ОтображениеГодаИмесяцаСтажаРаботыВЛицее)
            else
            ($yearLipers)   
        
       let $ОтображениеГодаИмесяцаОбщегоТрудовогоСтажа := 
           if (xs:integer(substring-after(substring-before(xs:string($стажОбщийТрудовойВправильномФормате), 'Y'), 'P') >= '1' ))
            then
            ( substring-before(xs:string($стажОбщийТрудовойВправильномФормате), 'M') || 'M' )
            else ('P' || substring-before(substring-after(xs:string($стажОбщийТрудовойВправильномФормате), 'P'), 'M') || 'M')
            
       let $ОбщийТрудовойСтажБезУчетаДней :=
           xs:yearMonthDuration($ОтображениеГодаИмесяцаСтажаРаботыВЛицее) + xs:yearMonthDuration($ОтображениеГодаИмесяцаОбщегоТрудовогоСтажа)

           
      
      (: Конец кода подсчета общего стажа работы с учетом стажа работы в Лицее :)
      

      
      return
         <tr>
           <td>{$c}</td>
           <td>{$фио}</td>
           <td>{$стажОбщийТрудовойВформатеЛицея}</td>
           <td>{$стажОбщийТрудовойВправильномФормате}</td>
           <td>{$yearLipers} </td>
           <td>Все ячейки <br/>{$ОтображениеГодаИмесяцаСтажаРаботыВЛицее3}</td>
           <td>Общий стаж {$ОтображениеГодаИмесяцаСтажаРаботыВЛицее2}</td>
           <td>!!!!!!! ОтображениеГодаИмесяцаСтажаРаботыВЛицее<br/>{ $ОтображениеГодаИмесяцаСтажаРаботыВЛицее }</td>
           <td>ОтображениеГодаИмесяцаОбщегоТрудовогоСтажа<br/>{ $ОтображениеГодаИмесяцаОбщегоТрудовогоСтажа }</td>
           <td>ОбщийТрудовойСтажБезУчетаДней<br/>{ $ОбщийТрудовойСтажБезУчетаДней }</td>
           <td>Стаж в Лицее {dateTime:transform-PYMD-1(xs:duration($yearLipers)) }</td>
         </tr>
  
    let $всегоСотрудников := count($сотрудникиТекущие)
    let $текущаяДата2 := format-date(current-date(), "[D01].[M01].[Y0001]")    
    let $текущийГод := year-from-date(current-date())
    return
      map{
        'дата' : xs:string($текущаяДата),
        'текущаяДата' : $текущаяДата2,
        'текущийГод' : $текущийГод,
        'всегоСотрудников' : $всегоСотрудников,
        'списокСотрудников' : $списокСотрудников,
        'сег' : $сегодня
      }
};

declare function teachers.kadr:текущаяДата( $params ){
    
    let $сегодня := substring-before(xs:string(current-date()), '+')
    
    let $текущаяДата :=
    if( request:parameter( 'дата' ) )
    then ( xs:date( request:parameter( 'дата' ) ) )
    else ( xs:date($сегодня)
         )
    return $текущаяДата
    
};

declare function teachers.kadr:данные( $params ){
      
    let $data := 
      $params?_tpl( 'content/data-api/spisokUchitel', $params )/table
    return
    $data
};