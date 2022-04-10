module namespace biblioteka.list = 'content/reports/biblioteka.list';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

import module namespace functx = "http://www.functx.com";

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function  biblioteka.list:main( $params ){
  let $классы :=
    for $i in (1 to 10)
    return
      <a href="{'?класс=' || $i}">{$i} класс</a>
  let $класс := request:parameter('класс') ?? request:parameter('класс') !! '4'
  let $url :=
    web:create-url(
      'http://a.roz37.ru:9984/garpix/semantik/app/request/execute',
      map{
        'rp' : 'http://a.roz37.ru/lipers/запросы/учебники-по-классам',
        'класс' : $класс,
        'файл' : 'Biblioteka/lipersBooks04.xlsx'
      }
    )
  let $книгиПоКлассу := fetch:xml($url)
  return
    map{
      'списокВсехКниг' : $книгиПоКлассу,
      'класс' : $класс,
      'классы' : $классы
    }
};

declare
  %private
function
 biblioteka.list:списокВсехКниг($params) as element(table)*
{
  $params?_getFileRDFparams(
     'Biblioteka/lipersBooks.xlsx' , (: путь к файлу внутри хранилища :)
     '.',
     'http://81.177.136.43:9984/zapolnititul/api/v2/forms/b3d871a0-bea6-4459-b7fb-9480fef40e6a/fields' (: адрес (URL) для доступа к схеме - по этому адресу можно пройти :),
     map{'page':'5;6'},
     $params?_config('store.yandex.personalData.local') (: идентификатор хранилища :)
  )//table
};

declare function  biblioteka.list:main1( $params ){
        
    let $data := biblioteka.list:списокВсехКниг ( $params )
        
    let $весьСписок := $data/row 
    
    let $списокКниг :=
    
      for $i in $весьСписок
        let $названиеКниги :=
          $i/lip:названиеКниги/text()
        
        let $класс := 
          $i/parent::*/@label/data()
        
        let $авторКниги :=
          $i/lip:автор/text()
          
        let $абонент :=
          $i/lip:абонентКниги/text()
        
        let $состоянеКнигиНаМоментВыдачи :=
          $i/lip:состоянеКнигиНаМоментВыдачи/text()
        
        let $состоянеКнигиНаМоментВозврата :=
          $i/lip:состоянеКнигиНаМоментВозврата/text()
        
        let $шифрВкаталогеЛицея :=
          $i/lip:номерВкаталоге/text()
          
        let $ценаКниги :=
          $i/lip:ценаКниги/text()
          
        order by $названиеКниги
        count $count
          
          return
          (                
          <tr>   
             <td>{$count}</td>           
             <td>{$класс}</td>
             <td>{$названиеКниги}</td>
             <td>{$авторКниги}</td>
             <td>{$абонент}</td>
             <td>{$состоянеКнигиНаМоментВыдачи}</td>
             <td>{$состоянеКнигиНаМоментВозврата}</td>
             <td>{$шифрВкаталогеЛицея}</td>
             <td>{$ценаКниги}</td>
          </tr>
           )
      
      
      let $текущаяДата := format-date(current-date(), "[D01].[M01].[Y0001]") 
      return

      map{
        'текущаяДата' : $текущаяДата,
        'списокВсехКниг' : (biblioteka.list:заголовок( $params ), $списокКниг)
      }
};


declare function  biblioteka.list:заголовок( $params ){

      let $заголовокТаблицы :=
          (<tr>
           <th>№ п/п</th>
           <th>Класс</th>
           <th>Название учебника</th>
           <th>Автор</th>
           <th>Кому выдано</th>
           <th>Состояние выдачи</th>
           <th>Состояние возврата</th>
           <th>Шифр в каталоге Лицея</th>
           <th>Цена книги</th>
        </tr>
        )        
        return $заголовокТаблицы
        
};