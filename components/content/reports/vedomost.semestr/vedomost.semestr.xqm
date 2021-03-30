module namespace vedomost.semestr = 'content/reports/vedomost.semestr';

declare function vedomost.semestr:main( $params ){
  let $dataRaw :=
    $params?_getFile(
      'Аттестация/ДО_набор.xlsx',
      $params?_config( "api.functions.path" ) || 'vedomost.semestr.xq'
    )
  
  let $всеГруппы := json:parse( $dataRaw )/json/группа
  let $списокГрупп := $всеГруппы/номерГруппы/text()
  let $текущаяГруппа := request:parameter( 'группа', $списокГрупп[ 1 ] )
  
  let $группа := $всеГруппы[ номерГруппы = $текущаяГруппа ]
  let $всеСеместры := $группа/семестры/семестр
  let $списокСеместров := $всеСеместры[ студенты ]/номерСеместра/text()
  
  let $текущийСеместр := request:parameter( 'семестр', $списокСеместров[ 1 ] )

  let $строкиТаблицы :=
    vedomost.semestr:успеваемостьЗаСеместр(
       $всеСеместры[ номерСеместра/text() = $текущийСеместр ]/студенты/студент,
       $всеСеместры[ номерСеместра/text() = $текущийСеместр ]/количествоПромежуточнойАттестации/number()
      )
  let $среднийБаллПоСеместрам := 
    vedomost.semestr:среднийБаллПоСеместрам(
      $всеСеместры
    )
  
  let $группыМеню := 
    for $i in $списокГрупп
    return
      if( $i = $текущаяГруппа )
      then( <span class="ml-2">{ $i }</span> )
      else( <a class="ml-2" href = "{'?группа=' || $i }"> { $i }</a> )
  
  let $семестрыМеню := 
    for $i in $списокСеместров
    return
      if( $i = $текущийСеместр )
      then( <span class="ml-2">{ $i }</span> )
      else(
        <a class="ml-2" href = "{'?семестр=' || $i || '&amp;группа=' || $текущаяГруппа}"> { $i }</a>
      )
      
  return
    map{
      'семестры' : $семестрыМеню,
      'группы' : $группыМеню,
      'семестр' : $текущийСеместр,
      'успеваемостьЗаСеместр' : $строкиТаблицы,
      'среднийБаллПоСеместрам' : $среднийБаллПоСеместрам
    }
};

declare function vedomost.semestr:успеваемостьЗаСеместр( $студенты as element( студент )*, $количествоЭкзаменовЗачетов ){
  <div>
    <table class = 'table-striped'>
        <thead>
          <tr class = "text-center">
            <th>Студент</th>
            <th>Оценок</th>
            <th>Долгов</th>
            <th>Средний балл</th>
          </tr>
        </thead>
        <tbody>
         {  
           for $i in $студенты
           let $всегоОценокСтудента :=
             $i/количествоОценок/number() + $i/количествоЗачетов/number()
           return
             <tr>
               <td>{ $i/фио/text() }</td>
               <td class = "text-center">{ $всегоОценокСтудента }</td>
               <td class = "text-center">{ $количествоЭкзаменовЗачетов - $всегоОценокСтудента }</td>
               <td class = "text-center">{ round( $i/средняяОценка/number(), 1 ) }</td>
             </tr>
         }
          <tr>
            <th colspan='2' >По группе</th>
            <th class = "text-center">
              {
                $количествоЭкзаменовЗачетов * count( $студенты ) -
                sum( $студенты/количествоОценок/number() ) -
                sum( $студенты/количествоЗачетов/number() ) 
              }
            </th>
            <th class = "text-center">{
              round( avg( $студенты[ средняяОценка/number() > 0 ]/средняяОценка ), 1 ) 
            }</th>
          </tr>
        </tbody>
      </table>
    </div>
};

declare function vedomost.semestr:среднийБаллПоСеместрам( $семестры as element( семестр )* ){
    <table class = 'table-striped'>
        <thead>
          <tr class = "text-center">
            <th>Семестр</th>
            <th>Оценок</th>
            <th>Средний балл</th>
          </tr>
        </thead>
        <tbody>
          {
            for $i in $семестры
            return
              <tr class = "text-center">
                <td >{ $i/номерСеместра/text() }</td>
                <td>{ $i/количествоПромежуточнойАттестации/text() }</td>
                <td>{ round( avg( $i/студенты/студент[ средняяОценка/number() > 0 ]/средняяОценка ), 1 ) }</td>
              </tr>
          }
          <tr>
            <th colspan='2' >Средний за весь период</th>
            <th class = "text-center">{
              round(
                avg( $семестры/студенты/студент[ средняяОценка/number() > 0 ]/средняяОценка ), 1
             )
            }</th>
          </tr>
        </tbody>
    </table>
};