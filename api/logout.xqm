module namespace logout = "logout";

declare 
  %rest:GET
  %rest:path( "/lipers-simplex/api/v01/logout" )
function logout:main(){
  session:close(),
  let $logout :=
  fetch:text('https://portal.titul24.ru/logout.php')
  return
    web:redirect( "/lipers-simplex" )
};
