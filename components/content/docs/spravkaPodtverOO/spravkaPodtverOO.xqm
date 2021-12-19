module namespace взнос = 'content/docs/spravkaPodtverOO';

declare function взнос:main( $params ){
  let $ученик := $params?_tpl( 'content/data-api/uchitel', $params )    
  return
    map{'данные' : $ученик}
};