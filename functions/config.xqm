module namespace config = "app/config";

declare  variable $config:param:= function( $param ) {
  doc ( "../config.xml" ) 
  /config/param[ @id = $param ]/text()
};

declare  function config:param( $param ) {
  doc ( "../config.xml" ) 
  /config/param[ @id = $param ]/text()
};