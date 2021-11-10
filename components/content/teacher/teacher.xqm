module namespace content = 'content/teacher';

declare function content:main( $params ){
    let $профильУчителя := 
      $params?_tpl( 'content/teacher/teacher.profil', map{} )
    return
      map{
        'содержание' : <div>Профиль учителя</div>
      }
};