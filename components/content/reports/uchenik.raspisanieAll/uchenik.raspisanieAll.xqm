module namespace uchenik.raspisanie = 'content/reports/uchenik.raspisanieAll';

declare function  uchenik.raspisanie:main($params){
  let $реестрКлассов := 
    $params?_tpl('content/data-api/public/spisokClassov', $params)
    //класс/text()
  let $класс := 
    request:parameter('класс') ?? request:parameter('класс') !! $реестрКлассов[1]
  let $меню := for $i in $реестрКлассов return <a href="?класс={$i}">{$i}</a> 
  
  let $расписание11 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":11
        }
      )
    )//table[1]
    
    let $расписание10 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":10
        }
      )
    )//table[1]
    
     let $расписание90 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс": ('9а')
        }
      )
    )//table[1]
    
    let $расписание91 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":('9б')          
        }
      )
    )//table[1]
  
  let $расписание8 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":8
        }
      )
    )//table[1]
  
  let $расписание7 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":7
        }
      )
    )//table[1]
  
  let $расписание6 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":6
        }
      )
    )//table[1]
  
  let $расписание50 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":('5а')
        }
      )
    )//table[1]
  
  let $расписание51 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":('5б')
        }
      )
    )//table[1]
  
  let $расписание4 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":4
        }
      )
    )//table[1]
  
  let $расписание3 :=  
     fetch:xml(
      web:create-url(
        "http://a.roz37.ru:9984/garpix/semantik/app/request/execute",
        map{
          "rp":"http://a.roz37.ru/lipers/запросы/расписание-классов",
          "класс":3
        }
      )
    )//table[1]
  
  return
    map{
      'меню':$меню,
      'класс': 11,
      'расписание11' : $расписание11,
      'расписание10' : $расписание10,
      'расписание90' : $расписание90,
      'расписание91' : $расписание91,
      'расписание8' : $расписание8,
      'расписание7' : $расписание7,
      'расписание6' : $расписание6,
      'расписание50' : $расписание50,
      'расписание51' : $расписание51,
      'расписание4' : $расписание4,
      'расписание3' : $расписание3  
    }
};