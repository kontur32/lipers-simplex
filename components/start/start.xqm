module namespace start = "start";

declare function start:main( $params as map(*) ){
  let $OAuthLoginURL :=
    web:create-url(
      $params?_config( 'authHost' ) || '/oauth/authorize',
      map{
        'client_id' : $params?_config( 'OAuthClienID' ),
        'response_type' : 'code',
        'state' : 'state'
      }
    )
  return  
    map{
      'OAuthLoginURL' : $OAuthLoginURL
    }
};