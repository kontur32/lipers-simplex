module namespace uchenik.docs-print = 'content/reports/uchenik.docs-print';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';



declare function uchenik.docs-print:main( $params ){
    let $data := 
      $params?_tpl( 'content/data-api/spisokUchenikov', $params )/table 
    let $ученикиТекущие := $data/row[ not(lip:выбытиеОО/text()) ]   
    let $документы :=
      (
        ['Справка-зачисление','spravkaZachislenie'],
        ['Справка-выезд','spravkaVyezd'],
        ['Договор','dogovorLiceum'],
        ['Доп. соглашение','dopDogovor'],
        ['Взнос','vznos'],
        ['Справка-обучение','spravkaObuchOO']
      )
    

   
    let $списокУчеников :=   
      for $i in  $ученикиТекущие
      let $фио :=
        $i/sch:familyName || ' ' || $i/sch:givenName || ' ' ||$i/lip:отчество           
      let $класс := $i/lip:классБазаОО/text()   
      let $n :=
        if( request:parameter( 'список' ) )
        then( $фио )
        else( xs:integer($класс) )      
      order by $n    
      count $c
    return
         <tr>
           <td>{$c}</td>
           <td>{$фио}</td>
           <td>{$класс}</td>
           {uchenik.docs-print:кнопкиДокументов($документы, $i/@id/data())}
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

declare 
  %private
function uchenik.docs-print:кнопкиДокументов(
  $документы as item()*,
  $id as xs:string
){
  for $doc in $документы 
  let $href := uchenik.docs-print:href($doc?2, $id)
  return
    <td><a class="btn btn-primary" href="{$href}">{$doc?1}</a></td>
};

declare 
  %private
function uchenik.docs-print:href($слэг as xs:string, $id as xs:string){
   web:create-url(
    '/lipers-simplex/api/v01/generator/docs/' || $слэг,
    map{'id':$id}
  )
};