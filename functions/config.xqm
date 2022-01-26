module namespace config = "app/config";

declare  variable $config:param:= function( $param ) {
  doc ( "../config.xml" ) 
  /config/param[ @id = $param ][ 1 ]/text()
};

declare  function config:param( $param ) {
  doc ( "../config.xml" ) 
  /config/param[ @id = $param ][ 1 ]/text()
};