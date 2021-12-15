module namespace справкаВыездОО = 'content/docs/spravkaVyezd';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function справкаВыездОО:main( $params ){
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
            <cell id='http://lipers.ru/схема/фамилияРодПад'>{
              $ученик/lip:фамилияРодПад/text()
            }</cell>
            <cell id='http://lipers.ru/схема/имяРодПад'>{
              $ученик/lip:имяРодПад/text()
            }</cell>
            <cell id='http://lipers.ru/схема/отчествоРодПад'>{
              $ученик/lip:отчествоРодПад/text()
            }</cell>
           <cell id='http://schema.org/givenName'>{
              $ученик/sch:givenName/text()
            }</cell>
            <cell id='http://schema.org/birthDate'>{
              format-date(
                xs:date($ученик/sch:birthDate/text()),
                "[D01].[M01].[Y0001]"
              )
            }</cell>
            <cell id='http://lipers.ru/схема/имяЗП'>{
              $ученик/lip:имяЗП/text()
            }</cell>
            <cell id='http://lipers.ru/схема/отчествоЗП'>{
              $ученик/lip:отчествоЗП/text()
            }</cell>
            <cell id='http://lipers.ru/схема/фамилияЗП'>{
              $ученик/lip:фамилияЗП/text()
            }</cell>
            <cell id='http://lipers.ru/схема/инициалыЗП'>{
              $ученик/lip:инициалыЗП/text()
            }</cell>
           <cell id='http://lipers.ru/схема/классБазаОО'>{
              $ученик/lip:классБазаОО/text()
            }</cell>
           </row>       
         </table>

  return
    map{'данные' : $данные}
};