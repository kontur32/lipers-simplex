module namespace journal-Raw = 'content/data-api/public/journal-Raw';

declare function journal-Raw:main($params){
  let $путь := 'raspisanie'
  let $учителя := 
    journal-Raw:списокУчителей($params)//cell[@label="Файл журнала"][text()]/text()
  let $data := journal-Raw:расписание($params, $путь, $учителя)
  return
    map{'данные' : <journal label="{$путь}">{$data}</journal>}
};

declare
  %private
function
  journal-Raw:расписание($params, $путь, $учителя) as element(file)*
{
   for $i in $учителя
   let $путь := string-join(($путь, $i),"/")
   return
     $params?_getFileStore(
       $путь, 
       '.', 
       $params?_config('store.yandex.jornal')
    )/child::* update insert node attribute {"label"}{$путь} into .
};

declare
  %private
function journal-Raw:списокУчителей($params){
    $params?_getFileStore(
        'авторизация/lipersTeachers.xlsx', 
         '.', 
         $params?_config('store.yandex.personalData')
      )
};