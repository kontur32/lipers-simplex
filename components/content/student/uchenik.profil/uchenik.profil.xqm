module namespace uchenik.profil = 'content/student/uchenik.profil';

declare function uchenik.profil:main( $params ){
  let $данные :=
      fetch:xml(
        web:create-url(
          'http://iro37.ru:9984/zapolnititul/api/v2.1/data/publication/0f93d1c5-613e-4c11-8542-0b96047ba427',
          map{
            'номерЛичногоДела' : session:get( 'номерЛичногоДела' )
          }
        )
    )
  return
   map{ 
      'фото' :  $данные/table/row/cell[ @label = "Фотография" ]/text(),
      'фамилия' : $данные/table/row/cell[ @label = "Фамилия" ]/text(),
      'имя' : $данные/table/row/cell[ @label = "Имя" ]/text(),
	  'отчество' : $данные/table/row/cell[ @label = "Отчество" ]/text(),
      'сан2' : $данные/table/row/cell[ @label = "Сан" ]/text(),
      'имя в хиротонии' : $данные/table/row/cell[ @label = "Имя в хиротонии" ]/text(),
	  'дата рождения' : $данные/table/row/cell[ @label = "дата рождения" ]/text(),
      'именины' : $данные/table/row/cell[ @label = "Именины" ]/text(),
	  'номер личного дела' : $данные/table/row/cell[ @label = "номер личного дела" ]/text(),
	  'номер зачетной книжки' : $данные/table/row/cell[ @label = "номер зачетной книжки" ]/text(),
	  'логин и пароль в прометее' : $данные/table/row/cell[ @label = "Логин и пароль в прометее"]/text(),
	  'форма обучения' : $данные/table/row/cell[ @label = "Форма обучения" ]/text(),
	  'образование' : $данные/table/row/cell[ @label = "Образование" ]/text(),
	  'дата поступления в ОО' : $данные/table/row/cell[ @label = "дата поступления в ОО" ]/text(),
	  'дата выбытия из ОО' : $данные/table/row/cell[ @label = "дата выбытия из ОО" ]/text(),
      
	  'телефон' : $данные/table/row/cell[ @label = "Контактный телефон" ]/text(),
      'телефон2' : $данные/table/row/cell[ @label = "Контактный телефон2" ]/text(),
      'телефон3' : $данные/table/row/cell[ @label = "Контактный телефон3" ]/text(),
	  'e-mail' : $данные/table/row/cell[ @label = "e-mail (личный)" ]/text(),
	  'skype' : $данные/table/row/cell[ @label = "Skype" ]/text(),
      'адрес2' : $данные/table/row/cell[ @label = "Место проживания" ]/text(),
	  'адрес' : $данные/table/row/cell[ @label = "Адрес регистрации" ]/text(),
	   
	  'портфолио' : $данные/table/row/cell[ @label = "Портфолио" ]/text(),
	  'важные документы' : $данные/table/row/cell[ @label = "Важные документы" ]/text()
	  

    }
};

