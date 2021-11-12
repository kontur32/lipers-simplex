module namespace logout = "logout";

declare 
  %rest:GET
  %rest:path( "/lipers-simplex/api/v01/logout" )
function logout:main(){
  session:close(),
  <meta http-equiv="refresh" content="0;url=https://portal.titul24.ru/logout.php"/>
};
