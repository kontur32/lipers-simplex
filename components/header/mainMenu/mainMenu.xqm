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
           [ $items, 't', 'Форма для преподавателя' ]
    case 'student'
      return
        let $items := 
          (
            [ 'Домашнее задание', 'journal' ]
          )
        return
          [ $items, 's', 'Форма для студента' ]
    default
      return
        [ ( [ '', '' ] ), '', '' ]

  let $меню :=
    map{
      'главная' : '/lipers-simplex/' || $пункты?2,
      'названиеРаздела' : $пункты?3,
      'пункты' : mainMenu:items( $пункты?1, $пункты?2, $пункты?3 )
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