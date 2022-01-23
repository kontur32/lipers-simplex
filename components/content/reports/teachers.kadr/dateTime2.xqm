(:~
 : Функции для TRaC.
 :
 : @author Александр Калинин и Сергей Мишуров, Artel 2019-2020, BSD License
 :)

module namespace dateTime2 = 'dateTime2';

import module namespace functx = "http://www.functx.com";


(:~
 : Расчитывает интервал ремени между двумя датами.
 : @param  $max  конечная дата
 : @param  $min  начальная дата
 : @return xs:duration
 :)
declare 
  %public
function 
dateTime2:yearsMonthsDaysCount2( $max as xs:date , $min as xs:date )
  as xs:duration
{
   let $year-diff := year-from-date($max) - year-from-date($min)
  let $day-diff := day-from-date($max) - day-from-date($min)
  let $day-diff2 := 
    if( $day-diff < 0 )
    then( functx:days-in-month( $min ) + $day-diff  )
    else( $day-diff )
  
  let $month-diff := 
    if( ($day-diff < -1) or ($day-diff = 0 ) )
    then (month-from-date( $max ) - month-from-date( $min ) - 1 )
    else( month-from-date( $max ) - month-from-date( $min )  ) 
  
  let $yearMonth :=  ( ( $year-diff * 12 ) + $month-diff ) || "M" 
  
  let $dayTime := 
    if ($day-diff = 0)
    then (functx:days-in-month( $min ) || "D")
    else ($day-diff2 || "D")
  return
     xs:duration( "P" || $yearMonth || $dayTime )
};

(:~
 : Переводит интервал в ремени в формат 1 год / 1 месяц / 1 день.
 : @param  $duration  интервал времени
 : @return xs:string
 :)
declare 
  %public
function 
dateTime2:transform-PYMD-1( $duration as xs:duration )
  as xs:string
{
  functx:replace-multi(
      xs:string( $duration ),
      ( 'P', 'Y', 'M', 'D' ),
      ( '', ' год (года/лет) ', ' месяцев (месяц/месяца) ', ' дней (день/дня)' )
   )
};

(:~
 : Переводит дату в формат ISO '2020-01-01' из формата '01.01.2020'
 : или из формата даты Экселя
 : @param  $data  
 : @return xs:date или пустую строку
 :)
declare function dateTime2:dateParse( $date as xs:string* ){
  if( matches( $date, '^\d{2,2}.\d{2}.\d{4}$') )
  then(
    dateTime2:dateParseComaSeparate( $date )
  )
  else(
    if( try{ xs:integer( $date ) }catch*{ false() } )
    then(
      dateTime2:dateParseExcel( xs:integer( $date ) )
    )
    else()
  )
};

declare function dateTime2:dateParseComaSeparate( $date as xs:string* )  as xs:date {
  xs:date( replace( $date, '(\d{2}).(\d{2}).(\d{4})', '$3-$2-$1') )
};

declare function dateTime2:dateParseExcel( $date as xs:integer )  as xs:date {
  xs:date( "1900-01-01" ) + xs:dayTimeDuration("P" || $date - 2 || "D")
};