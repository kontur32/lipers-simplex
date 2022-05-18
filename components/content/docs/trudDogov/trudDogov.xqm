module namespace тк = 'content/docs/trudDogov';
 
declare function тк:main( $params ){
  map{
    'данные' : $params?_tpl( 'content/data-api/uchitel', $params )
  }
};
