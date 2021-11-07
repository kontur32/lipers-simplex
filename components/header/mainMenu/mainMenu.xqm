module namespace mainMenu = "header/mainMenu";

declare function mainMenu:main( $params as map(*) ){
  let $пункты :=
    switch ( $params?area )
    case 'teacher'
      return
        let $items := 
          (
            [ 'Журнал пропусков', 'teachers.konduit' ],
            [ 'Возраст учащихся', 'uchenik.vozrast2' ]
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
            [ 'Журнал пропусков', 'teachers.konduit' ]
          )
        return
           [ $items2, 't', 'Кадры' ]
    default
      return
        [ ( [ '', '' ] ), '', '' ]
    
  let $меню :=
    map{
      'главная' : '/lipers-simplex/' || $пункты?2,
      'названиеРаздела' : $пункты?3,
	  'названиеРаздела2' : $пункты2?3,
      'пункты' : mainMenu:items( $пункты?1, $пункты?2, $пункты?3 ),
	  'пункты2' : mainMenu:items( $пункты2?1, $пункты2?2, $пункты2?3 )
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