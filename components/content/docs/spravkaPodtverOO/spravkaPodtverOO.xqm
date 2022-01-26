module namespace взнос = 'content/docs/spravkaPodtverOO';

declare function взнос:main( $params ){
  map{
    'данные' : $params?_tpl( 'content/data-api/uchitel', $params )
  }
};
