module namespace teacher.profil = 'content/teacher/teacher.profil';

declare function teacher.profil:main( $params ){
  let $данные :=
      fetch:xml(
        web:create-url(
          'http://iro37.ru:9984/zapolnititul/api/v2.1/data/publication/269e77a0-bf1c-4564-a910-9e4d23ce6af1',
          map{
            'номерЛичногоДела' : session:get( 'номерЛичногоДела' )
			
          }
        )
    )/table/row
  return
    map{ 
      'фото' :  $данные/cell[ @label = "Фотография" ]/text(),
      'фамилия' : $данные/cell[ @label = "Фамилия" ]/text(),
      'имя' : $данные/cell[ @label = "Имя" ]/text(),
	  'отчество' : $данные/cell[ @label = "Отчество" ]/text(),
      'сан2' : $данные/cell[ @label = "Cан(название)" ]/text(),
      'имя в хиротонии' : $данные/cell[ @label = "Имя в хиротонии" ]/text(),
	  'кафедра' : $данные/cell[ @label = "Кафедра" ]/text(),
      'телефон' : $данные/cell[ @label = "Контактный телефон" ]/text(),
      'телефон2' : $данные/cell[ @label = "Контактный телефон2" ]/text(),
      'телефон3' : $данные/cell[ @label = "Контактный телефон3" ]/text(),
	  'skype' : $данные/cell[ @label = "Skype" ]/text(),
	  'прометей' : $данные/cell[ @label = "Логин и пароль в Прометее" ]/text(),
	  'e-mail' : $данные/cell[ @label = "e-mail (личный)" ]/text(),
      'адрес' : $данные/cell[ @label = "Место проживания" ]/text(),
	  'адрес2' : $данные/cell[ @label = "Адрес регистрации" ]/text(),
	  'дата рождения' : $данные/cell[ @label = "Дата рождения (чч.мм.гггг)" ]/text(),
      'именины' : $данные/cell[ @label = "Именины" ]/text(),
      'должность' : $данные/cell[ @label = "Должность" ]/text(),
	  'преподаваемый предмет' : $данные/cell[ @label = "Преподаваемый предмет" ]/text(),
	  'дата трудоустройства в САИВПДС' : $данные/cell[ @label = "Дата трудоустройства в САИВПДС " ]/text(),
      'ученая степень' : $данные/cell[ @label = "Учёная степень" ]/text(),
      'ученое звание' : $данные/cell[ @label = "Учёное звание" ]/text(),
      'образование' : $данные/cell[ @label = "Образование" ]/text(),
      'специальность 1' : $данные/cell[ @label = "Специальность по диплому               (первое высшее)" ]/text(),
	  'ВО1' : $данные/cell[ @label = "Название образовательного учреждения                        (первое высшее)" ]/text(),
	  'ВО1год' : $данные/cell[ @label = "Год окончания      (первое высшее)" ]/text(),
	  'ВО2' : $данные/cell[ @label = "Название образовательного учреждения (второе высшее)" ]/text(),
	  'специальность 2' : $данные/cell[ @label = "Специальность по диплому (второе высшее)" ]/text(),
	  'ВО2год' : $данные/cell[ @label = "Год окончания (второе высшее)" ]/text(),
	  'портфолио' : $данные/cell[ @label = "Портфолио" ]/text(),
	  'важные документы' : $данные/cell[ @label = "Важные документы" ]/text()

    }
};