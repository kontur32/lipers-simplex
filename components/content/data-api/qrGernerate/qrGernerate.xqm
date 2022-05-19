module namespace qrGernerate = 'content/data-api/qrGernerate';

declare function qrGernerate:main( $params ){
  let $qrImageHref := qrGernerate:qrImageHref( $params?string )
  return
    map{'данные' : <result>{$qrImageHref}</result>}
};

declare
  %private
function
  qrGernerate:qrImageHref($string as xs:string) 
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