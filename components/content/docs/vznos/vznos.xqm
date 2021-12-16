module namespace взнос = 'content/docs/vznos';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function взнос:main( $params ){
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
            <cell id='http://lipers.ru/схема/отчествоРодПад'>{
              $ученик/lip:отчествоРодПад/text()
            }</cell>
           <cell id='http://lipers.ru/схема/имяРодПад'>{
              $ученик/lip:имяРодПад/text()
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
           <cell id='http://lipers.ru/схема/классПоступленияОО'>{
              $ученик/lip:классПоступленияОО/text()
            }</cell>
            <cell id='http://lipers.ru/схема/инициалыУченика'>{
              $ученик/lip:инициалыУченика/text()
            }</cell>
           <cell id='http://schema.org/familyName'>{
              $ученик/sch:familyName/text()
            }</cell>
            <cell id='http://schema.org/givenName'>{
              $ученик/sch:givenName/text()
            }</cell>
            <cell id='http://lipers.ru/схема/отчество'>{
              $ученик/lip:отчество/text()
            }</cell>
            <cell id='http://lipers.ru/схема/телефонЗП'>{
              $ученик/lip:телефонЗП/text()
            }</cell>
            <cell id='http://lipers.ru/схема/паспортЗПподразделение'>{
              $ученик/lip:паспортЗПподразделение/text()
            }</cell>
            <cell id='http://lipers.ru/схема/паспортЗПвыдан'>{
              $ученик/lip:паспортЗПвыдан/text()
            }</cell>
            <cell id='http://lipers.ru/схема/паспортЗПномерСерия'>{
              $ученик/lip:паспортЗПномерСерия/text()
            }</cell>
            <cell id='http://lipers.ru/схема/пропискаЗП'>{
              $ученик/lip:пропискаЗП/text()
            }</cell>
            </row>       
         </table>

  return
    map{'данные' : $данные}
};