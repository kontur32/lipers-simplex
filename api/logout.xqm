module namespace logout = "logout";

declare 
  %rest:GET
  %rest:path( "/lipers-simplex/api/v01/logout" )
function logout:main(){
  session:close(),
  web:redirect("https://portal.titul24.ru/logout.php")
};
