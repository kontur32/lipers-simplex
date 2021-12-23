module namespace teachers.docs-print = 'content/reports/teachers.docs-print';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function teachers.docs-print:main( $params ){
    let $data := 
      $params?_tpl( 'content/data-api/spisokUchitel', $params )/table
    let $сотрудникиТекущие := $data/row[ not(lip:увольнениеОО/text()) ]   
    
    let $списокСотрудников :=   
      for $i in $сотрудникиТекущие
      let $фио :=
        $i/sch:familyName || ' ' || $i/sch:givenName || ' ' ||$i/lip:отчество
      let $href :=
        web:create-url(
          '/lipers-simplex/api/v01/generator/docs/spravkaPodtverOO',
          map{'id':$i/@id}
        )
       
      order by $фио
      count $c
      
      let $yearLipers := 
        let $date := $i/lip:трудоустройствоОО
        return
          if( $date )
          then(
            let $max := current-date()
            let $min := ( $i/lip:трудоустройствоОО )
            return
              dateTime:yearsMonthsDaysCount( $max, $min )
          )
          else('н/д')
      
      return
         <tr>
           <td>{$c}</td>
           <td>{$фио}</td>
           <td>{$yearLipers}</td>
           <td><a class="btn btn-primary" href="{$href}">Справка-подтверждение</a></td>
         </tr>
    
    let $всегоСотрудников := count($сотрудникиТекущие)
    let $текущаяДата := format-date(current-date(), "[D01].[M01].[Y0001]")    
    let $текущийГод := year-from-date(current-date())
    return
      map{
        'текущаяДата' : $текущаяДата,
        'текущийГод' : $текущийГод,
        'всегоСотрудников' : $всегоСотрудников,
        'списокСотрудников' : $списокСотрудников
      }
};