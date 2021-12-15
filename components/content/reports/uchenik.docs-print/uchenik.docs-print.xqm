module namespace uchenik.docs-print = 'content/reports/uchenik.docs-print';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchenik.docs-print:main( $params ){
    let $data := 
      $params?_tpl( 'content/data-api/spisokUchenikov', $params )/table
      
    let $ученикиТекущие := $data/row[ not(lip:выбытиеОО/text()) ]   
    
    let $списокУчеников :=   
      for $i in  $ученикиТекущие
      let $фио :=
        $i/sch:familyName || ' ' || $i/sch:givenName || ' ' ||$i/lip:отчество
      let $href :=
        '/lipers-simplex/api/v01/generator/docs/spravkaZachislenie?id=' ||
        substring-after($i/@id, '#')
      let $href2 :=
        '/lipers-simplex/api/v01/generator/docs/spravkaVyezd?id=' ||
        substring-after($i/@id, '#')
      let $href3 :=
        '/lipers-simplex/api/v01/generator/docs/dogovorLiceum?id=' ||
        substring-after($i/@id, '#')
      order by $фио
      count $c
      return
         <tr>
           <td>{$c}</td>
           <td>{$фио}</td>
           <td><a class="btn btn-primary" href="{$href}">Справка-зачисление</a></td>
           <td><a class="btn btn-primary" href="{$href2}">Справка-выезд</a></td>
           <td><a class="btn btn-primary" href="{$href3}">Договор</a></td>
         </tr>
    
    let $всегоУчеников := count($ученикиТекущие)
    let $текущаяДата := format-date(current-date(), "[D01].[M01].[Y0001]")    
    let $текущийГод := year-from-date(current-date())
    return
      map{
        'текущаяДата' : $текущаяДата,
        'текущийГод' : $текущийГод,
        'всегоУчеников' : $всегоУчеников,
        'списокУчеников' : $списокУчеников
      }
};