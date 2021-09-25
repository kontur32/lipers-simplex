module namespace check = "check";


declare 
  %perm:check( "/lipers-simplex/t" )
function check:userArea(){
  let $grants := session:get( "grants" )
  where  not( $grants = 'teacher' )
  return
    web:redirect("/lipers-simplex")
};