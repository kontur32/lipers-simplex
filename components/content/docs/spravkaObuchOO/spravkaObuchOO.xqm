module namespace справкаОбучениеОО = 'content/docs/spravkaObuchOO';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function справкаОбучениеОО:main( $params ){
  let $всеУученики :=
    $params?_tpl( 'content/data-api/spisokUchenikov', $params )
  let $ученик := $всеУученики/table/row[@id=$params?id and not(lip:выбытиеОО/text())][last()]
    
  let $данные := 
        <table>
          <row id = 'fields'>
            <cell id='http://schema.org/givenName'>{
              $ученик/sch:givenName/text()
            }</cell>
            <cell id='http://lipers.ru/схема/отчество'>{
              $ученик/lip:отчество/text()
            }</cell>
            <cell id='http://schema.org/familyName'>{
              $ученик/sch:familyName/text()
            }</cell>
            <cell id='http://schema.org/birthDate'>{
              format-date(
                xs:date($ученик/sch:birthDate/text()),
                "[D01].[M01].[Y0001]"
              )
            }</cell>
            <cell id='http://lipers.ru/схема/классБазаОО'>{
              $ученик/lip:классБазаОО/text()
            }</cell>            
          </row>       
         </table>

  return
    map{'данные' : $данные}
};