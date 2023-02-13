module namespace reports = 'content/reports';

declare function reports:main( $params ){
  let $адресЗапросаСтраницы := 
    switch ( $params?страница )
    case "teachers.konduit"
      return
        let $url := 
          web:create-url(
            'http://iro37.ru:9984/zapolnititul/api/v2.1/data/publication/3a61d3a6-1984-4891-afd3-4c1f9750633a',
            map{
              'page' : 'teachers.konduit',
              'mode' : 'iframe'
            }
          )
        return
          reports:getData( $url )
 
  case "teachers.tabel"
      return
        $params?_tpl( 'content/teacher/teachers.tabel', map{} )  
      
  case "uchenik.jour.ail-new"
      return
        let $url := 
         web:create-url(
            'http://iro37.ru:9984/zapolnititul/api/v2.1/data/publication/a2aa28dc-7a83-4a6e-aff6-679f1c9a9ab7',
            map{
              'page' : 'uchenik.jour.ail-new',
              'номерЛичногоДела' :  session:get( "номерЛичногоДела" ),
              'mode' : 'iframe'
            }
          )
        return
          reports:getData( $url )
    
    case "uchenik.profil"
      return
        $params?_tpl( 'content/student/uchenik.profil', map{} )
    
    
	case "uchenik.listTeachers"
      return
        $params?_tpl( 'content/student/uchenik.listTeachers', map{} )
	
	case "journal"
      return
        let $url := 
          web:create-url(
            'http://iro37.ru:9984/zapolnititul/api/v2.1/data/publication/065edfb3-7f4c-4f67-8ff3-640070b36290',
            map{
              'date' : '2020-11-23',
              'mode' : 'iframe'
            }
          )
        return
          reports:getData( $url )
    
  case "teachers.list"
      return
        $params?_tpl( 'content/reports/teachers.list', map{} )

  case "uchenik.list"
      return
        $params?_tpl( 'content/reports/uchenik.list', map{} )

  case "teachers.botQRlist"
      return
        $params?_tpl( 'content/reports/teachers.botQRlist', map{} )
  
  case "uchenik.predmet"
      return
        $params?_tpl( 'content/reports/uchenik.predmet', map{} )
    
  case "vedomost.semestr"
       return
         $params?_tpl( 'content/reports/vedomost.semestr', map{} )
    
  case "vedomost.dynamics"
       return
         $params?_tpl( 'content/reports/vedomost.dynamics', map{} )
    
    case "uchenik.vozrast"
       return
         $params?_tpl( 'content/reports/uchenik.vozrast', map{} )
         
    case "uchenik.vozrast2"
       return
         $params?_tpl( 'content/reports/uchenik.vozrast2', map{} )
    
    case "uchenik.ocenki"
       return
         $params?_tpl( 'content/reports/uchenik.ocenki', map{} )
                  
   case "uchenik.konduit"
       return
         $params?_tpl( 'content/reports/uchenik.konduit', map{} )
    
   case "uchenik.quality"
       return
         $params?_tpl( 'content/reports/uchenik.quality', map{} )
    
   case "uchenik.propuski"
       return
         $params?_tpl( 'content/reports/uchenik.propuski', map{} )
   
   case "uchenik.docs-print"
       return
         $params?_tpl( 'content/reports/uchenik.docs-print', map{} )
   case "teachers.docs-print"
       return
         $params?_tpl( 'content/reports/teachers.docs-print', map{} )       
   case "uchenik.adress"
       return
         $params?_tpl( 'content/reports/uchenik.adress', map{} )  
   case "teachers.kadr"
       return
         $params?_tpl( 'content/reports/teachers.kadr', map{} )
 
   case "biblioteka.list"
       return
         $params?_tpl( 'content/reports/biblioteka.list', map{} )
   
   case "uchenik.litkoinAll"
       return
         $params?_tpl( 'content/reports/uchenik.litkoinAll', map{} )
   
   case "uchenik.litkoin"
       return
         $params?_tpl( 'content/reports/uchenik.litkoin', map{} )
   
   case "teachers.spisok"
      return
        $params?_tpl( 'content/reports/teachers.spisok', map{} )
   
   case "uchenik.tehChten"
      return
        $params?_tpl( 'content/reports/uchenik.tehChten', map{} )
   
   case "uchenik.journal"
      return
        $params?_tpl( 'content/reports/uchenik.journal', map{} )
   
   case "uchenik.raspisanie"
      return
        $params?_tpl( 'content/reports/uchenik.raspisanie', map{} )
        
   case "uchenik.class22"
      return
        $params?_tpl( 'content/reports/uchenik.class22', map{} )
     
   case "uchenik.personal"
      return
        $params?_tpl( 'content/reports/uchenik.personal', map{} )
   
    case "uchenik.raspisanieAll"
      return
        $params?_tpl( 'content/reports/uchenik.raspisanieAll', map{} )
    
    case "teachers.new"
      return
        $params?_tpl( 'content/reports/teachers.new', map{} )

    case "teachers.error"
      return
        $params?_tpl( 'content/reports/teachers.error', map{} )
        
    default
      return
        $params?_tpl( 'content/reports/uchenik.propuski', map{} )

   return
    map{
      'отчет' : $адресЗапросаСтраницы
    }
};

declare function reports:getData( $адресЗапросаСтраницы ){
  <iframe width = '100%' height = "600px" src = '{ $адресЗапросаСтраницы }' ></iframe>
};