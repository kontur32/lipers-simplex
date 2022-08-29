module namespace teachers.botQRlist = 'content/reports/teachers.botQRlist';

import module namespace dateTime = 'dateTime'
  at 'http://iro37.ru/res/repo/dateTime.xqm';

declare namespace sch = 'http://schema.org';
declare namespace lip = 'http://lipers.ru/схема';

declare function teachers.botQRlist:main($params){
  let $всеУчителя :=
    $params?_tpl('content/data-api/spisokUchitel', $params)
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
  let $userLogin := $учитель/lip:логин/text()
  where $userLogin
  let $фио := teachers.botQRlist:записьУчителя($учитель)
  order by $фио  
  let $userString :=
    replace('{"login":"%1","grants":"teacher"}', '%1', $userLogin)
  let $url :=
    $params?_tpl('content/data-api/public/token_', map{'string': $userString})//url/text()
  let $QRlink :=
    $params?_tpl('content/data-api/qrGernerate', map{'string': $url})//result/text()
  let $QRlink := teachers.botQRlist:qrImageHref($url)
  return
    <tr>
      <td>{$фио}</td>
      <td><a href="{$url}">ссылка</a></td>
      <td><img src="{$QRlink}"/></td>
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
function
  teachers.botQRlist:qrImageHref($string as xs:string) 
{
  let $shortLink := fetch:text('https://clck.ru/--?url=' || web:encode-url( $string ))
  return  
    web:create-url(
      'https://chart.googleapis.com/chart',
      map{
        'cht': 'qr',
        'chs' : '200x200',
        'choe' : 'UTF-8',
        'chld' : 'H',
        'chl' : $shortLink            
      }
    )
};