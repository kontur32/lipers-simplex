module namespace vedomost.dynamics = 'content/reports/vedomost.dynamics';

declare function vedomost.dynamics:main( $params ){
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

  let $динамикаПоГруппе :=
    vedomost.dynamics:успеваемостьЗаСеместр(
       $всеСеместры,
       $списокСеместров
      )
  
  let $группыМеню := 
    for $i in $списокГрупп
    return
      if( $i = $текущаяГруппа )
      then( <span class="ml-2"><b>{ $i }</b></span> )
      else( <a class="ml-2" href = "{'?группа=' || $i }"> { $i }</a> )
      
  return
    map{
      'группы' : $группыМеню,
      'семестр' : $текущийСеместр,
      'успеваемостьЗаСеместр' : $динамикаПоГруппе
    }
};

declare function vedomost.dynamics:успеваемостьЗаСеместр(
  $семестры as element( семестр )*, $списокСеместров
)
{
  <div>
    <table class = 'table-striped' >
        <thead>
          <tr class = "text-center">
            <th>№ пп</th>
            <th>Студент</th>
            {
              for $i in $списокСеместров
              return
                <th>{ $i } сем</th>
            }
            <th>Средний балл</th>
          </tr>
        </thead>
        <tbody>
         {  
           for $i in $семестры[1]/студенты/студент/фио/text()
           count $c
           return
             <tr class = "text-center">
               <td>{ $c }.</td>
               <td class = "text-left">{ $i }</td>
               {
                 for $j in $списокСеместров
                 let $оценка := 
                   $семестры[ номерСеместра/text() = $j ]
                   /студенты/студент[ фио/text() = $i ]
                   /средняяОценка/number()
                 let $средняяОценка := 
                   $оценка > 0 ?? round( $оценка, 1 ) !! "-"
                 return
                   <td>{ $средняяОценка }</td>
               }
               <td class = "text-center">{
                  let $средниеОценки := 
                     $семестры
                     /студенты/студент[ фио/text() = $i ]
                     /средняяОценка/number()
                  return
                     round( avg( $средниеОценки ), 1 )
               }</td>
             </tr>
         }
          <tr id = 'avg-total-sem'>
            <th></th>
            <th>По группе</th>
            {
              for $j in $списокСеместров
                 let $оценка := 
                   $семестры[ номерСеместра/text() = $j ]
                   /студенты/студент
                   /средняяОценка/number()
                 let $средняяОценка := 
                   round( avg( $оценка ), 1 ) 
                 return
                   <th class = "text-center" >{ $средняяОценка }</th>
            }
            <th class = "text-center">{
              let $средниеОценки := 
                 $семестры
                 /студенты/студент
                 /средняяОценка[ number() > 0 ]/number()
              return
                 round( avg( $средниеОценки ), 1 )
            }</th>
          </tr>
        </tbody>
      </table>
    </div>
};