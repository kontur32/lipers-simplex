module namespace uchenik.listTeachers = 'content/student/uchenik.listTeachers';

declare function uchenik.listTeachers:main( $params ){
  let $данные :=
      fetch:xml( 'http://iro37.ru:9984/zapolnititul/api/v2.1/data/publication/8d83183e-ce1f-4fa2-aba8-15cea705928a' )
  
  return
   map{ 
	  'список' : 
	  (
	  
          for $c in $данные/table/row

		  return

		  <div class="btn-group dropright">
		  
		  <table>
<tr>
<td>
  <button type="button" class="btn-8" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    { $c/cell[ @label = "Фамилия Имя Отчество" ] }
  </button>
  


  
  <div class="dropdown-menu">
       
     <table class="table table-striped">
        <tr>
          <td><center>
      <img src = "{ $c/cell[ @label = "Фотография" ] }" class="img-fluid" style = "max-width: 100%; height: auto;"></img>
      </center></td>
          <td><center><h6>{ $c/cell[ @label = "Фамилия Имя Отчество" ]} </h6></center></td>
        </tr>
		<tr>
          <td><h6>Кафедра</h6></td>
          <td>{ $c/cell[ @label = "Кафедра" ]}</td>
        </tr>
        <tr>
          <td><h6>Должность</h6></td>
          <td>{ $c/cell[ @label = "Должность" ]}</td>
        </tr>
        <tr>
          <td><h6>Ученая степень и звание</h6></td>
          <td>{ $c/cell[ @label = "Учёная степень" ]}, { $c/cell[ @label = "Учёное звание" ]}</td>
        </tr>
        <tr>
          <td><h6>Преподавание</h6></td>
          <td>{ $c/cell[ @label = "Преподаваемый предмет" ]}</td>
        </tr>
		<tr>
          <td><h6>e-mail</h6></td>
          <td>{ $c/cell[ @label = "e-mail (личный)" ]}</td>
        </tr>
		
      </table>
      
    </div>
	


</td>
</tr>

</table>


</div>
	  )
	  
    }
};

