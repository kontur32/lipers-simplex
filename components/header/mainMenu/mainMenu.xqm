module namespace mainMenu = "header/mainMenu";

declare function mainMenu:main( $params as map(*) ){
  let $пункты :=
    switch ( $params?area )
    case 'teacher'
      return
        let $items := 
          (            
            [ 'Адреса и контакты', 'uchenik.adress' ],
            [ 'Возраст учащихся', 'uchenik.vozrast2' ],
            [ 'Дни рождения лицеистов', 'uchenik.list'],
            [ 'Список учителей и предметов', 'uchenik.predmet'],
            [ 'Справки на печать', 'uchenik.docs-print']
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
          [ $items, 's', 'Оценки' ]
    default
      return
        [ ( [ '', '' ] ), '', '' ]

  let $пункты2 :=
    switch ( $params?area )
    case 'teacher'
      return
       let $items2 := 
          (            
            [ 'Список сотрудников', 'teachers.spisok' ],
            [ 'Возраст и стажи', 'teachers.kadr'],
            [ 'Дни рождения сотрудников', 'teachers.list' ],
            [ 'Справки на печать', 'teachers.docs-print']
            
          )
        return
           [ $items2, 't', 'Кадры' ]           
    case 'student'
      return
        let $items := 
          (
            [ 'Техника чтения', 'uchenik.tehChten' ]
          )
        return
          [ $items, 's', 'Техника чтения' ]     
           
    default
      return
        [ ( [ '', '' ] ), '', '' ]
        
        
   let $пункты3 :=
    switch ( $params?area )
    case 'teacher'
      return
        let $items3 := 
          (            
            [ 'Текущие оценки', 'uchenik.journal' ],
            [ 'Журнал пропусков', 'ucheniki.propuski' ],
            [ 'Оценки за четверть', 'uchenik.konduit' ],
            [ 'Литкоины', 'uchenik.litkoinAll' ]

          )
        return
           [ $items3, 't', 'ОКО' ]
    case 'student'
      return
        let $items := 
          (
            [ 'Литкоины', 'uchenik.litkoin' ]
          )
        return
          [ $items, 's', 'Литкоины' ]
    default
      return
        [ ( [ '', '' ] ), '', '' ]
    
    let $пункты4 :=
    switch ( $params?area )
    case 'teacher'
      return
       let $items4 := 
          (            
            [ 'Каталог учебников', 'biblioteka.list' ],
            [ 'Статистика', 'teachers.docs-print']
          )
        return
           [ $items4, 't', 'Библиотека' ]
    default
      return
        [ ( [ '', '' ] ), '', '' ]
    
  let $меню :=
    map{
    'главная' : '/lipers-simplex/' || $пункты?2,
    'названиеРаздела'  : $пункты?3,
	  'названиеРаздела2' : $пункты2?3,
    'названиеРаздела3' : $пункты3?3,
    'названиеРаздела4' : $пункты4?3,
    'пункты'  : mainMenu:items( $пункты?1, $пункты?2, $пункты?3 ),
	  'пункты2' : mainMenu:items( $пункты2?1, $пункты2?2, $пункты2?3 ),
    'пункты3' : mainMenu:items( $пункты3?1, $пункты3?2, $пункты3?3 ),
    'пункты4' : mainMenu:items( $пункты4?1, $пункты4?2, $пункты4?3 )
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