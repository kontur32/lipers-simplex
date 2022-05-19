module namespace teachers.botQRlist = 'content/reports/teachers.botQRlist';

import module namespace dateTime = 'dateTime'
  at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function teachers.botQRlist:main($params){
  let $всеУчителя := teachers.botQRlist:списокУчителей($params)
  let $работающиеУчителя := $всеУчителя/table/row[not(lip:увольнениеОО/text())]
  let $количетсвоРаботающихУчителей := count($работающиеУчителя)
  return
    map{
      'списокУчителей':teachers.botQRlist:учителяПоМесяцам($работающиеУчителя, $params),
      'количествоРаботающихППС':$количетсвоРаботающихУчителей
    }
};

declare
  %private
function teachers.botQRlist:учителяПоМесяцам($работающиеУчителя, $params){
  <table calss="table border">
    {teachers.botQRlist:учителяПоМесяцу($работающиеУчителя, $params)}
  </table>
};

declare
  %private
function teachers.botQRlist:учителяПоМесяцу($учителяПоМесяцу, $params){
  for $учитель in $учителяПоМесяцу
  order by $учитель/sch:familyName/text()  
  let $tokenUrl :=
    let $userLogin := $учитель/lip:логин/text()
    where $userLogin
    let $url :=
      fetch:xml(
        web:create-url(
          'http://81.177.136.43:9984/lipers-simplex/p/api/v01/token_',
          map{
            'string':
              replace('{"login":"%1","grants":"teacher"}', '%1', $userLogin)
          }
        )
      )//url/text()
    let $QRlink :=
      $params?_tpl('content/data-api/qrGernerate', map{'string': $url})//result
    return
      (
        <td>
        <a href="{$url}">ссылка</a>
        </td>,
        <td>
          <img src="{$QRlink}"/>
        </td>
      )
  return
    <tr>
      <td>{teachers.botQRlist:записьУчителя($учитель)}</td>
      {$tokenUrl}
    </tr>
};

declare
  %private
function teachers.botQRlist:записьУчителя($записьУчителя){
  let $фио :=
    $записьУчителя/sch:familyName||' '||$записьУчителя/sch:givenName||
    ' '||$записьУчителя/lip:отчество
  return
    $фио
};

declare
  %private
function teachers.botQRlist:списокУчителей($params){
  $params?_getFileRDF(
     (: путь к файлу внутри хранилища :)
     'авторизация/lipersTeachers.xlsx',
     (: запрос на выборку записей :)
     '.',
     (: адрес (URL)схемы данных :)
     'http://81.177.136.43:9984/zapolnititul/api/v2/forms/24ebf0d0-bc64-4bfe-9c0c-f869a1db5473/fields',
     (: идентификатор хранилища :)
     $params?_config('store.yandex.personalData')
  )
};