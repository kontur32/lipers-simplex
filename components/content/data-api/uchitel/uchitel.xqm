module namespace uchitel = 'content/data-api/uchitel';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function uchitel:main( $params ){
  let $учитель :=
    $params?_tpl( 'content/data-api/spisokUchitel', $params )
    /table/row[@id=$params?id and not(lip:увольнениеОО/text())][last()]
 
  let $данные := 
        <table>
          <row id = 'fields'>
            <cell id='http://lipers.ru/схема/фамилияРодПад'>{
              $учитель/lip:фамилияРодПад/text()
            }</cell>
            <cell id='http://lipers.ru/схема/отчествоРодПад'>{
              $учитель/lip:отчествоРодПад/text()
            }</cell>
           <cell id='http://lipers.ru/схема/имяРодПад'>{
              $учитель/lip:имяРодПад/text()
            }</cell>
            <cell id='http://schema.org/birthDate'>{
              format-date(
                xs:date($учитель/sch:birthDate/text()),
                "[D01].[M01].[Y0001]"
              )
            }</cell>
            <cell id='http://lipers.ru/схема/имяЗП'>{
              $учитель/lip:имяЗП/text()
            }</cell>
            <cell id='http://lipers.ru/схема/отчествоЗП'>{
              $учитель/lip:отчествоЗП/text()
            }</cell>
            <cell id='http://lipers.ru/схема/фамилияЗП'>{
              $учитель/lip:фамилияЗП/text()
            }</cell>
            <cell id='http://lipers.ru/схема/инициалыЗП'>{
              $учитель/lip:инициалыЗП/text()
            }</cell>
           <cell id='http://lipers.ru/схема/классПоступленияОО'>{
              $учитель/lip:классПоступленияОО/text()
            }</cell>
            <cell id='http://lipers.ru/схема/инициалыУченика'>{
              $учитель/lip:инициалыУченика/text()
            }</cell>
           <cell id='http://schema.org/familyName'>{
              $учитель/sch:familyName/text()
            }</cell>
            <cell id='http://schema.org/givenName'>{
              $учитель/sch:givenName/text()
            }</cell>
            <cell id='http://lipers.ru/схема/отчество'>{
              $учитель/lip:отчество/text()
            }</cell>
            <cell id='http://lipers.ru/схема/телефонЗП'>{
              $учитель/lip:телефонЗП/text()
            }</cell>
            <cell id='http://lipers.ru/схема/паспортЗПподразделение'>{
              $учитель/lip:паспортЗПподразделение/text()
            }</cell>
            <cell id='http://lipers.ru/схема/паспортЗПвыдан'>{
              $учитель/lip:паспортЗПвыдан/text()
            }</cell>
            <cell id='http://lipers.ru/схема/паспортЗПномерСерия'>{
              $учитель/lip:паспортЗПномерСерия/text()
            }</cell>
            <cell id='http://lipers.ru/схема/пропискаЗП'>{
              $учитель/lip:пропискаЗП/text()
            }</cell>
            </row>       
         </table>
  return
    map{'данные' : $данные }
};
