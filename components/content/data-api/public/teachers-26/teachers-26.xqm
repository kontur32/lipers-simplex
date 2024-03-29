module namespace teachers-26 = 'content/data-api/public/teachers-26';

import module namespace dateTime = 'dateTime' 
  at 'http://iro37.ru/res/repo/dateTime.xqm';

declare function teachers-26:main($params){
  let $путь := '/Учителя.xlsx'
  let $data := teachers-26:расписание($params, $путь)
  return
    map{'данные' : teachers-26:таблица($data)}
};

declare function teachers-26:таблица($data) as element(tr)*{
  let $категории :=
    (['В','высшая'], ['1','первая'],['С','сответствие занимаемой должности'],['МС','молодой специалист'], ['Н','нет'])
  for $i in $data/table[@label="Учителя"]/row
  order by $i/cell[@label="ФИО"]/text()
  order by $i/cell[@label="Сортировка"]/xs:integer(text())
  count $c
  let $категория :=
    $категории[?1=$i/cell[@label="Категория"]/text()]?2
  return
   <tr>
     <td>{$c}</td>
     <td>{$i/cell[@label="ФИО"]/text()}</td>
     <td>{$i/cell[@label="Должность"]/text()}</td>
     <td>{$i/cell[@label="Образование"]/text()}</td>
     <td>{string-join($i/cell[@label="Название образовательного учреждения"]/text(), ', ')}</td>
     <td>{string-join($i/cell[@label="Специальность по диплому"]/text(), ', ')}</td>
     <td>{$i/cell[@label="Ученая степень"]/text()}</td>
     <td>{$i/cell[@label="Ученое звание"]/text()}</td>
     <td>{format-date(dateTime:dateParse($i/cell[@label="Дата КПК"]/text()), "[Y0001]")}</td>
     <td>{$i/cell[@label="Общий стаж"]/text()}</td>
     <td>{$i/cell[@label="Стаж в должности"]/text()}</td>    
     <td>{$категория}</td>
     <td>{$i/cell[@label="Предметы"]/text()}</td>
 </tr> 
};

declare
  %private
function
  teachers-26:расписание($params, $путь) as element(file)
{
  $params?_getFileStore(
     $путь, 
     '.', 
     $params?_config('store.yandex.school26')
  )/file
};