module namespace logout = "logout";

declare 
  %rest:GET
  %rest:path( "/lipers-simplex/api/v01/logout" )
function logout:main(){
  session:close(),
  fetch:text('https://portal.titul24.ru/logout.php'),
  web:redirect( "/lipers-simplex" )
};
