module namespace check = "check";


declare 
  %perm:check( "/lipers-simplex/s" )
function check:userArea(){
 let $grants := session:get( "grants" )
  where  not( $grants = 'student' )
  return
    web:redirect("/lipers-simplex")
};