module namespace content = 'content/teacher';

declare function content:main( $params ){
  let $кодАвторизации := 
    substring(replace(session:id(), '[A-Za-z]', ''), 1, 5)
  return
    map{
      'кодАвторизации' : $кодАвторизации,
      'urlРеакцииБота' : 'https://t.me/ZavkafBot?start=231634'
    }
};