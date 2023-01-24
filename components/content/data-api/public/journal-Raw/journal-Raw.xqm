module namespace journal-Raw = 'content/data-api/public/journal-Raw';

declare function journal-Raw:main($params){
  let $путь := 'raspisanie'
  let $учителя := 
    journal-Raw:списокУчителей($params)//cell[@label="Файл журнала"][text()]/text()
  let $path.cache := $params?_config('path.cache') || 'journal-Raw.xml'
  let $data := 
    if(request:parameter('update')='yes')
    then(
      let $journal := 
        <journal label="{$путь}" dateTime="{current-dateTime()}">{
          journal-Raw:расписание($params, $путь, $учителя)
        }</journal>      
      return
        ($journal, file:write($path.cache, $journal))
    )
    else(doc($path.cache))
  
  return
      map{'данные' : $data}
};

declare
  %private
function
  journal-Raw:расписание($params, $путь, $учителя) 
{
   for $i in $учителя
   let $path := string-join(($путь, $i),"/")
   return
   try{
    $params?_getFileStore(
       $path, 
       '.', 
       $params?_config('store.yandex.jornal')
    )/child::* update insert node attribute {"label"}{$path} into .
  }catch*{}
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