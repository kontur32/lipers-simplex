module namespace uchenik.list = 'content/reports/uchenik.list';

declare function uchenik.list:main( $params ){
  
  let $data := $params?_getFile( 'students.xlsx', '.' )
    
  let $строкиТаблицы :=
    uchenik.list:строкиТаблицы( $data//table[@label = "ОЗО 2016"]/row )
    
  return
    map{
      'строкиТаблицы' : $строкиТаблицы
    }
};

declare function uchenik.list:строкиТаблицы( $data ){
  <tbody>
    {
      for $i in $data
      count $c
      let $фамилия := $i/cell[ @label = 'Фамилия' ]/text()
      order by $фамилия
      let $href1 :=
        web:create-url(
          '/saivpds/api/v01/print.diploma.1',
          map{
            'id' : $i/cell[ @label = 'номер личного дела' ]/text(),
            'group' : 'ОЗО 2016'
          }
        )
      let $href2 :=
        web:create-url(
          '/saivpds/api/v01/print.diploma.2',
          map{
            'id' : $i/cell[ @label = 'номер личного дела' ]/text(),
            'group' : 'ОЗО 2016'
          }
        )
      return
        <tr>
          <td class = "text-center">{ $c }.</td>
          <td>{ $фамилия }</td>
          <td>{
            $i/cell[ @label = 'Имя' ]/text()
          }</td>
          <td>{
            $i/cell[ @label = 'Отчество' ]/text()
          }</td>
          <td align='center'><a href = "{ $href1 }">лист 1</a></td>
          <td align='center'><a href = "{ $href2 }">лист 2</a></td>
        </tr>
    }
  </tbody>
};