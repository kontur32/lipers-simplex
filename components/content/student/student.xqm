module namespace content = 'content/student';

declare function content:main( $params ){
  
  let $текущиеОценки := 
    $params?_tpl( 'content/reports/uchenik.ocenki', map{} )
  
  
  let $result := 
    <div>
      <div>{ $текущиеОценки }</div>
    </div>
  
  return
    map{
      'содержание' : $result
    }
};