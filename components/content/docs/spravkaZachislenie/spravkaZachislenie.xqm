module namespace справкаЗачислениеОО = 'content/docs/spravkaZachislenie';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function справкаЗачислениеОО:main( $params ){
  let $всеУученики :=
    $params?_tpl( 'content/data-api/spisokUchenikov', $params )
  let $ученик := 
    $всеУученики
    /table/row[
      if($params?id)
      then(@id="http://lipers.ru/сущности/ученики#" || $params?id)
      else(1)
    ]
    
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
          </row>       
         </table>

  return
    map{'данные' : $данные}
};