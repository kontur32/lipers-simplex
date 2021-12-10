module namespace mainMenu = "header/mainMenu";

declare function mainMenu:main( $params as map(*) ){
  let $пункты :=
    switch ( $params?area )
    case 'teacher'
      return
        let $items := 
          (
            [ 'Журнал пропусков', 'teachers.konduit' ],
            [ 'Возраст учащихся', 'uchenik.vozrast2' ],
		        [ 'Дни рождения лицеистов', 'uchenik.list'],
            [ 'Список учителей и предметов', 'uchenik.predmet']  
        )
        return
           [ $items, 't', 'Контингент' ]
    case 'student'
      return
        let $items := 
          (
            [ 'Оценки', 'uchenik.ocenki' ]
          )
        return
          [ $items, 's', 'Форма для ученика' ]
    default
      return
        [ ( [ '', '' ] ), '', '' ]

  let $пункты2 :=
    switch ( $params?area )
    case 'teacher'
      return
        let $items2 := 
          (            
            [ 'Дни рождения сотрудников', 'teachers.list' ]
          )
        return
           [ $items2, 't', 'Кадры' ]
    default
      return
        [ ( [ '', '' ] ), '', '' ]
        
        
   let $пункты3 :=
    switch ( $params?area )
    case 'teacher'
      return
        let $items3 := 
          (
            [ 'Журнал пропусков', 'ucheniki.propuski' ],
            [ 'Оценки за четверть', 'uchenik.konduit' ]

          )
        return
           [ $items3, 't', 'ОКО' ]
    default
      return
        [ ( [ '', '' ] ), '', '' ]
    
  let $меню :=
    map{
    'главная' : '/lipers-simplex/' || $пункты?2,
    'названиеРаздела'  : $пункты?3,
	  'названиеРаздела2' : $пункты2?3,
    'названиеРаздела3' : $пункты3?3,
    'пункты'  : mainMenu:items( $пункты?1, $пункты?2, $пункты?3 ),
	  'пункты2' : mainMenu:items( $пункты2?1, $пункты2?2, $пункты2?3 ),
    'пункты3' : mainMenu:items( $пункты3?1, $пункты3?2, $пункты3?3 )
    }
  return
     $меню
};

declare function mainMenu:items( $items, $area, $mainLabel ){
  for $i in $items
  where $i?1 != ''
  let $href := '/lipers-simplex/' || $area || '/reports/' || $i?2
  return
   <a class="dropdown-item" href="{ $href }">{ $i?1 }</a>       
};