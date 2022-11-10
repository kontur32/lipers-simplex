module namespace ROZ_contacts = 'content/data-api/public/ROZ_contacts';

declare function ROZ_contacts:main($params){
  
  let $data :=
    csv:parse(
      fetch:text(
        'https://docs.google.com/spreadsheets/d/e/2PACX-1vSauisyqZbMm9BNiIpfLQ7fkeNuZNg5jlSDGqllUORvgiVXgha6pY_QJgadY2iSks-HlNvnDhGZh8zm/pub?output=csv'
      ),
      map{'header':'yes'}
    )//record
    let $user := $data[region/text()=request:parameter('region')]
      
    return
      map{'данные' :
        <result>
          <lastname>{$user/lastname/text()??string-join($user/lastname/text(), ', ')!!'нет'}</lastname>
          <firstname>{$user/firstname/text()??string-join($user/firstname/text(), ', ')!!'нет'}</firstname>
          <telegram_username>{$user/telegram_username/text()??string-join($user/telegram_username/text(), ', ')!!'контакт скрыт'}</telegram_username>
          <telegram_id>{$user[1]/telegram_id/text()}</telegram_id>
        </result>
      }
};
